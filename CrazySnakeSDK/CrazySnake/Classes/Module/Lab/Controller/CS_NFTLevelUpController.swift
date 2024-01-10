//
//  CS_NFTLevelUpController.swift
//  CrazySnake
//
//  Created by Lee on 28/02/2023.
//

import UIKit
import JXSegmentedView
import SwiftyAttributes
import HandyJSON

class CS_NFTLevelUpController: CS_BaseEmptyController {
    
    typealias NFTFeedBlock = (CS_NFTPropModel?,CS_NFTPropModel?,CS_NFTPropModel?) -> Void
    var propChangeAction: NFTFeedBlock?
    
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var primaryFeed: CS_NFTPropModel?
    private var intermadiateFeed: CS_NFTPropModel?
    private var seniorFeed: CS_NFTPropModel?
    private var currentFeed: CS_NFTPropModel?{
        didSet{
            guard let model = currentFeed else { return }
            feedAmountView.resetData(max: model.num, current: 0)
            levelView.updateExperience(0)
        }
    }
    private var page = 1
    private var quality = 0
    private var dataSource = [CS_NFTDataModel]()
    lazy var mockData: [CS_NFTDataModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTDataModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "lab.upgrade") as? [CS_NFTDataModel] {
                return model
            }
        }
        return []
    }()

    private var selectedModel: CS_NFTDataModel?{
        didSet{
            guard let model = selectedModel else { return }
            let url = URL.init(string: model.image ?? "")
            iconView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
            levelView.setData(model)
            if let _ = model.upgrade?.next_bonus {
                confirmButton.isEnabled = true
                levelHashLabel.isHidden = false
                levelHashLabel.attributedText = "UP to ".attributedString + "Lv\(model.upgrade?.next_bonus?.level ?? 5)".withTextColor(.ls_color("#7A56E1")).withFont(.ls_JostRomanFont(16)) + " Can get extra Hash: ".attributedString + "\(model.upgrade?.next_bonus?.power ?? 0)".withTextColor(.ls_color("#7A56E1")).withFont(.ls_JostRomanFont(16))
            } else {
                confirmButton.isEnabled = false
                levelHashLabel.isHidden = true
            }
            
            
            
        }
    }

    var isMock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        registerNotication()

        // Do any additional setup after loading the view.
        GuideMaskManager.checkGuideState(.nft_level_up) { isFinish in
            self.isMock = !isFinish
            self.requestMyNFTList()
            self.requestMyFeedsList()
            self.emptyStyle = .loading
            
            if self.isMock {
                self.collectionView.reloadData()
                self.updateLayout()
                self.guideStepOne()
            }
        }

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        CS_NewFeatureAlert.showPage(.labUpgrade)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CS_NFTLabNftCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.cornerRadius = 15
        view.contentInset = UIEdgeInsets(top: 14, left: 14, bottom: 0, right: 14)
        view.register(CS_NFTLabNftCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self))
        view.backgroundColor = .ls_dark_3()
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requestMyNFTList()
            weakSelf?.requestMyFeedsList()
        }
        view.ls_addFooter {
            weakSelf?.page += 1
            weakSelf?.requestMyNFTList()
        }
        view.mj_footer.isHidden = true
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 142, height: 159))
        view.ls_cornerRadius(10)
        view.ls_addCorner(.topLeft, cornerRadius: 20)
        view.ls_addCorner(.bottomRight, cornerRadius: 35)
//        view.backgroundColor = .ls_dark_4()
//        view.image = UIImage.ls_bundle( "icon_nft_demo@2x")
        return view
    }()
    
    lazy var feedView: CS_NFTLevelUpFeedView = {
        let view = CS_NFTLevelUpFeedView()
        weak var weakSelf = self
        view.chooseAction = { model in
            weakSelf?.currentFeed = model
        }
        return view
    }()
    
    lazy var feedAmountView: CS_AmountInputView = {
        let view = CS_AmountInputView()
        weak var weakSelf = self
        view.amountChange = { amount in
            let totle = amount*(weakSelf?.currentFeed?.extend_params?.value ?? 0)
            weakSelf?.levelView.updateExperience(totle)
        }
        return view
    }()
    
    lazy var levelView: CS_NFTLevelUpLevelView = {
        let view = CS_NFTLevelUpLevelView()
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 234, height: 40))
        button.addTarget(self, action: #selector(clickConfirmAction(_:)), for: .touchUpInside)
        button.ls_cornerRadius(7)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_speed_up".ls_localized, for: .normal)
        button.setImage(UIImage.ls_bundle( "icon_nft_lab_level_up@2x"), for: .normal)
        button.setBackgroundImage(UIImage.ls_bundle("common_bg_button_purpose@2x"), for: .normal)
        button.setBackgroundImage(UIImage.ls_image(.ls_text_gray(),viewSize: CGSize(width: 234, height: 40)), for: .disabled)
        button.ls_layout(.imageLeft,padding: 7)
        return button
    }()
    
    lazy var levelHashLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#666666"), .ls_font(12))
        label.textAlignment = .center
        return label
    }()

}


//MARK: Notification
extension CS_NFTLevelUpController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyNFTInfoChange(_:)), name: NotificationName.CS_NFTInfoChange, object: nil)
    }
    
    @objc private func notifyNFTInfoChange(_ notify: Notification) {
        page = 1
        requestMyNFTList()
    }
}

extension CS_NFTLevelUpController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTLabNftCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self), for: indexPath) as! CS_NFTLabNftCell
        var model : CS_NFTDataModel
        if isMock {
            model = mockData[indexPath.row]
        } else {
            model = dataSource[indexPath.row]
        }
        cell.setData(model,selectedItem: selectedModel)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMock {
            return mockData.count
        }
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectedModel = dataSource[indexPath.row]
        self.collectionView.reloadData()
    }
    
}

extension CS_NFTLevelUpController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

//MARK: action
extension CS_NFTLevelUpController {
    @objc func clickConfirmAction(_ sender: UIButton) {
        let amount = feedAmountView.currentNum
        guard amount > 0 else { return }
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["token_id"] = selectedModel?.token_id
        para["num"] = amount
        para["item_id"] = currentFeed?.item_id
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.nftLevelUp(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.handleUpgradeData(resp.data)
                weakSelf?.requestMyFeedsList()
            }
        }
    }
    
    func handleUpgradeData(_ nft: CS_NFTDataModel?) {
        if nft?.level ?? 0 > selectedModel?.level ?? 0 {
            let alert = CS_NFTLabLevelUpAlert()
            alert.setLevelUpData(selectedModel, nft: nft)
            alert.show()
        }
        if let nft = nft {
            selectedModel = nft
            var index = -1
            for item in dataSource.enumerated() {
                if item.element.token_id == nft.token_id {
                    index = item.offset
                    break
                }
            }
            if index >= 0, let range = Range(NSRange(location: index, length: 1)) {
                dataSource.replaceSubrange(range,with: [nft])
                collectionView.reloadData()
            }
        }
//        weak var weakSelf = self
//        alert.didDismissBlock = {
//        }
    }
    
    func updateNFT(_ nft: CS_NFTDataModel?){
        
    }
}

//MARK: request
extension CS_NFTLevelUpController {
    func requestMyNFTList() {
        
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["status"] = "\(0)"
        para["quality"] = "\(quality)"
        para["page"] = "\(page)"
        para["page_size"] = "20"
        CSNetworkManager.shared.getMyNFTList(para) { resp in
            
            var hasMore = false
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
                    if weakSelf?.selectedModel == nil {
                        if weakSelf?.isMock == true {
                            weakSelf?.selectedModel = weakSelf?.mockData.first
                        } else {
                            weakSelf?.selectedModel = weakSelf?.dataSource.first
                        }
                    }
                    if list.count > 0 {
                        hasMore = true
                    }
                } else {
                    if weakSelf?.isMock == true {
                        weakSelf?.selectedModel = weakSelf?.mockData.first
                    }
                }
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            weakSelf?.collectionView.ls_compeletLoading(weakSelf?.page == 1, hasMore: hasMore)
            weakSelf?.collectionView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 < 5
            if weakSelf?.isMock == false {
                weakSelf?.collectionView.reloadData()
                weakSelf?.updateLayout()
            }
            
        }
    }
    
    // 第一步
    private func guideStepOne() {
        if self.isMock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let cell = self.collectionView.cellForItem(at: .init(row: 0, section: 0)) {
                    
                    let mockItem = cell
                    let maskRect = mockItem.convert(mockItem.bounds, to: nil)
                    
                    weak var weakSelf = self
                    GuideMaskView.show (tipsText: "Select the NFT to be upgraded.",
                                        currentStep: "1",
                                        totalStep: "3",
                                        maskRect: maskRect,
                                        textWidthDefault: 223,
                                        direction: .left){
                        weakSelf?.guideStepTwo()
                    } skipHandle: {
                        weakSelf?.guideStepEnd()
                    }
                }
            }
        }
    }
    // 第二步
    private func guideStepTwo() {
        
        let mockItem = feedView
        let maskRect = mockItem.convert(mockItem.bounds, to: nil)

        weak var weakSelf = self
        GuideMaskView.show (tipsText: "Select props and enter quantity.",
                            currentStep: "2",
                            totalStep: "3",
                            maskRect: maskRect,
                            textWidthDefault: 223,
                            direction: .right){
            weakSelf?.guideStepThree()
        } skipHandle: {
            weakSelf?.guideStepEnd()
        }

    }
    // 第三步
    private func guideStepThree() {
        
        let mockItem = confirmButton
        let maskRect = mockItem.convert(mockItem.bounds, to: nil)

        weak var weakSelf = self
        GuideMaskView.show (tipsText: "Click the button to upgrade.",
                            currentStep: "3",
                            totalStep: "3",
                            maskRect: maskRect,
                            textWidthDefault: 223,
                            direction: .right){
            weakSelf?.guideStepEnd()

        } skipHandle: {
            weakSelf?.guideStepEnd()
        }
    }
    
    func guideStepEnd() {
        GuideMaskManager.saveGuideState(.nft_level_up)
        self.isMock = false
        if self.dataSource.count > 0 {
            self.selectedModel = self.dataSource.first
        } else {
            self.selectedModel = nil
        }
        self.collectionView.reloadData()
        self.updateLayout()
        
    }
    
    func requestMyFeedsList() {
        
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sub_type"] = "\(5)"
        CSNetworkManager.shared.getMybackpackList(para) { resp in
            if resp.status == .success {
                if let list = resp.data?.list {
                    weakSelf?.handleFeedsData(list)
                }
            }
        }
    }
    
    func handleFeedsData(_ list: [CS_NFTPropModel]) {
        for item in list {
            switch item.props_type {
            case .feedSimple:
                primaryFeed = item
                if currentFeed?.props_type == .feedSimple {
                    currentFeed = item
                }
            case .feedHighGrade:
                intermadiateFeed = item
                if currentFeed?.props_type == .feedHighGrade {
                    currentFeed = item
                }
            case .feedSuper:
                seniorFeed = item
                if currentFeed?.props_type == .feedSuper {
                    currentFeed = item
                }
            default: break
            }
        }
        
        if currentFeed == nil {
            currentFeed = primaryFeed
        }
        feedView.item0.setData(primaryFeed)
        feedView.item1.setData(intermadiateFeed)
        feedView.item2.setData(seniorFeed)
        propChangeAction?(primaryFeed,intermadiateFeed,seniorFeed)
    }
}

extension CS_NFTLevelUpController {
    func setupView(){
        navigationView.isHidden = true
        titleColor = .ls_white()
        emptyDescription = "crazy_str_empty_nfg_hint".ls_localized
        view.addSubview(iconView)
        view.addSubview(feedView)
        view.addSubview(feedAmountView)
        view.addSubview(levelView)
        view.addSubview(confirmButton)
        view.addSubview(levelHashLabel)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(28))
            make.top.equalTo(10)
            make.width.equalTo(255)
            make.bottom.equalTo(-10)
        }
        
        feedView.snp.makeConstraints { make in
            make.right.equalTo(-CS_ms(28))
            make.top.equalTo(24)
            make.width.equalTo(200)
            make.height.equalTo(62)
        }
        
        feedAmountView.snp.makeConstraints { make in
            make.left.right.equalTo(feedView)
            make.top.equalTo(feedView.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
        
        levelView.snp.makeConstraints { make in
            make.left.right.equalTo(feedView)
            make.top.equalTo(feedView.snp.bottom).offset(80)
            make.height.equalTo(40)
        }
        
        iconView.snp.makeConstraints { make in
            make.right.equalTo(feedView.snp.left).offset(-14)
            make.top.equalTo(feedView).offset(10)
            make.width.equalTo(142)
            make.height.equalTo(159)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalTo(feedView).offset(-55)
            make.bottom.equalTo(-35)
            make.width.equalTo(234)
            make.height.equalTo(40)
        }
        
        levelHashLabel.snp.makeConstraints { make in
            make.centerX.equalTo(confirmButton)
            make.bottom.equalTo(-12)
        }
    }
    
    func updateLayout() {
        if !isMock && dataSource.count == 0 {
            collectionView.snp.updateConstraints { make in
                make.width.equalTo(CS_kScreenW-2*CS_ms(28))
            }
        } else {
            collectionView.snp.updateConstraints { make in
                make.width.equalTo(255)
            }
        }
    }
}


