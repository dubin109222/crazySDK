//
//  CS_NFTEvolutionController.swift
//  CrazySnake
//
//  Created by Lee on 02/03/2023.
//

import UIKit
import JXSegmentedView
import HandyJSON

class CS_NFTEvolutionController: CS_BaseEmptyController {

    var propChangeAction: NFTPropBlock?
    
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var essenceEvolution: CS_NFTPropModel?
    private var page = 1
    private var quality = 0
    
    private var dataSource = [CS_NFTDataModel]()
    var isMock = false
    lazy var mockData: [CS_NFTDataModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTDataModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "lab.evolution") as? [CS_NFTDataModel] {
                return model
            }
        }
        return []
    }()
    private var selectedModel: CS_NFTDataModel?{
        didSet{
            guard let model = selectedModel else { return }
            let url = URL.init(string: model.image)
            iconView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
            infoView.setData(model)
            infoView.bottomAmountLabel.text = "\(model.evolve?.need_essences ?? 0)"
            confirmButton.isEnabled = model.evolve?.next_level?.type ?? 0 < 13
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        // Do any additional setup after loading the view.
        registerNotication()
        GuideMaskManager.checkGuideState(.nft_evolution) { isFinish in
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
//        CS_NewFeatureAlert.showPage(.labEvolution)
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
    
    lazy var infoView: CS_NFTUpgradeInfoView = {
        let view = CS_NFTUpgradeInfoView()
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 234, height: 40))
        button.addTarget(self, action: #selector(clickConfirmAction(_:)), for: .touchUpInside)
        button.ls_cornerRadius(7)
//        button.ls_addColorLayerPurpose()
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_nft_upgrade".ls_localized, for: .normal)
        button.setImage(UIImage.ls_bundle( "icon_nft_lab_level_up@2x"), for: .normal)
        button.setBackgroundImage(UIImage.ls_bundle("common_bg_button_purpose@2x"), for: .normal)
        button.setBackgroundImage(UIImage.ls_image(.ls_text_gray(),viewSize: CGSize(width: 234, height: 40)), for: .disabled)
        button.ls_layout(.imageLeft,padding: 7)
        return button
    }()
}


//MARK: Notification
extension CS_NFTEvolutionController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyNFTInfoChange(_:)), name: NotificationName.CS_NFTInfoChange, object: nil)
    }
    
    @objc private func notifyNFTInfoChange(_ notify: Notification) {
        page = 1
        requestMyNFTList()
    }
}

extension CS_NFTEvolutionController: UICollectionViewDelegate,UICollectionViewDataSource{
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
        return isMock ? mockData.count : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedModel = dataSource[indexPath.row]
        self.collectionView.reloadData()
    }
    
}

extension CS_NFTEvolutionController {
    // 第一步
    private func guideStepOne() {
        if self.isMock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let cell = self.collectionView.cellForItem(at: .init(row: 0, section: 0)) {
                    
                    let mockItem = cell
                    let maskRect = mockItem.convert(mockItem.bounds, to: nil)
                    
                    weak var weakSelf = self
                    GuideMaskView.show (tipsText: "Select the NFT to be evolution.",
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
                
        let mockItem = infoView
        let maskRect = mockItem.convert(mockItem.bounds, to: nil)

        weak var weakSelf = self
        GuideMaskView.show (tipsText: "View evolution rewards and essences to be consumed.",
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
        GuideMaskView.show (tipsText: "Click the button to evolution.",
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
        GuideMaskManager.saveGuideState(.nft_evolution)
        self.isMock = false
        if self.dataSource.count > 0 {
            self.selectedModel = self.dataSource.first
        } else {
            self.selectedModel = nil
        }
        self.collectionView.reloadData()
        self.updateLayout()
        
    }

}

extension CS_NFTEvolutionController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

//MARK: action
extension CS_NFTEvolutionController {
    @objc func clickConfirmAction(_ sender: UIButton) {
        guard selectedModel?.evolve?.next_level?.type ?? 0 < 13 else {
            return
        }
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["token_id"] = selectedModel?.token_id
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.nftEvolve(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.handleUpgradeData(resp.data)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func handleUpgradeData(_ nft: CS_NFTDataModel?) {
        
        essenceEvolution?.num -= selectedModel?.evolve?.need_essences ?? 0
        propChangeAction?(essenceEvolution)
        
        let alert = CS_NFTLabEvolutionAlert()
        alert.setLevelUpData(selectedModel, nft: nft)
        alert.show()
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
    }
}

//MARK: request
extension CS_NFTEvolutionController {
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
    
    func requestMyFeedsList() {
        
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sub_type"] = "\(3)"
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
            case .essenceEvolution:
                essenceEvolution = item
                propChangeAction?(essenceEvolution)
            default: break
            }
        }
    }
}

extension CS_NFTEvolutionController {
    func setupView(){
        navigationView.isHidden = true
        titleColor = .ls_white()
        emptyDescription = "crazy_str_empty_nfg_hint".ls_localized
        view.addSubview(infoView)
        view.addSubview(iconView)
        view.addSubview(confirmButton)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(28))
            make.top.equalTo(10)
            make.width.equalTo(255)
            make.bottom.equalTo(-10)
        }
        
        infoView.snp.makeConstraints { make in
            make.right.equalTo(-CS_ms(28))
            make.top.equalTo(collectionView).offset(37)
            make.width.equalTo(241)
            make.height.equalTo(140)
        }
        
        iconView.snp.makeConstraints { make in
            make.right.equalTo(infoView.snp.left).offset(20)
            make.top.equalTo(infoView).offset(-7)
            make.width.equalTo(142)
            make.height.equalTo(159)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalTo(infoView).offset(-62)
            make.bottom.equalTo(-32)
            make.width.equalTo(234)
            make.height.equalTo(40)
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


