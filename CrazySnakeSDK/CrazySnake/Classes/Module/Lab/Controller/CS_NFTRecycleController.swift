//
//  CS_NFTRecycleController.swift
//  CrazySnake
//
//  Created by Lee on 02/03/2023.
//

import UIKit
import JXSegmentedView
import HandyJSON

class CS_NFTRecycleController: CS_BaseEmptyController {

    var propChangeAction: NFTPropBlock?
    
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var feedModel: CS_NFTPropModel?
    private var page = 1
    private var quality = 0
    private var dataSource = [CS_NFTDataModel]()
    lazy var mockData: [CS_NFTDataModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTDataModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "lab.convertion") as? [CS_NFTDataModel] {
                return model
            }
        }
        return []
    }()
    private var selectedList = [CS_NFTDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        setupView()
        // Do any additional setup after loading the view.
        registerNotication()

        GuideMaskManager.checkGuideState(.nft_recycle) { isFinish in
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
//        CS_NewFeatureAlert.showPage(.labRecycle)
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
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_icon_recycle@2x")
        return view
    }()
    
    lazy var amountIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("nft_icon_essence_advance@2x")
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_JostRomanFont(16))
        label.text = "0"
        return label
    }()
    
    lazy var tipsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickTipsButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("icon_tips_black@2x"), for: .normal)
        return button
    }()
        
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 209, height: 40))
        button.addTarget(self, action: #selector(clickConfirmAction(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_nft_upgrade_orb".ls_localized, for: .normal)
        button.setImage(UIImage.ls_bundle( "icon_nft_lab_recycle@2x"), for: .normal)
        button.ls_layout(.imageLeft,padding: 7)
        return button
    }()

    var isMock = false
}


extension CS_NFTRecycleController {
    // 第一步
    private func guideStepOne() {
        if self.isMock {
//            feedModel = mockData.first
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let cell = self.collectionView.cellForItem(at: .init(row: 0, section: 0)) {
                    
                    let mockItem = cell
                    let maskRect = mockItem.convert(mockItem.bounds, to: nil)
                    
                    weak var weakSelf = self
                    GuideMaskView.show (tipsText: "You can single or multiple select NFT.",
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
                
        let mockItem = amountLabel
        let maskRect = mockItem.convert(mockItem.bounds, to: nil)

        weak var weakSelf = self
        GuideMaskView.show (tipsText: "Evolutionary Essence can be obtained after conversion.",
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
        GuideMaskManager.saveGuideState(.nft_recycle)
        isMock = false
        selectedList = []
        collectionView.reloadData()
    }
}

//MARK: Notification
extension CS_NFTRecycleController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyNFTInfoChange(_:)), name: NotificationName.CS_NFTInfoChange, object: nil)
    }
    
    @objc private func notifyNFTInfoChange(_ notify: Notification) {
        page = 1
        requestMyNFTList()
    }
}

extension CS_NFTRecycleController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTLabNftCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self), for: indexPath) as! CS_NFTLabNftCell
        var model : CS_NFTDataModel
        if isMock {
            model = mockData[indexPath.row]
        } else {
            model = dataSource[indexPath.row]
        }
        cell.setData(model,selectedList: selectedList)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMock {
            return mockData.count
        }
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        
        var isExsit = false
        var index = 0
        var amount = 0
        for item in selectedList.enumerated() {
            amount += item.element.essences
            if model.id == item.element.id {
                isExsit = true
                index = item.offset
            }
        }
        if isExsit {
            amount -= model.essences
            selectedList.remove(at: index)
        } else {
            amount += model.essences
            selectedList.append(model)
        }
        amountLabel.text = "\(amount)"
        self.collectionView.reloadData()
    }
    
}

extension CS_NFTRecycleController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

//MARK: action
extension CS_NFTRecycleController {
    @objc private func clickTipsButton(_ sender: UIButton) {
        CS_HelpCenterAlert.showNFTRecycle()
    }
    
    @objc func clickConfirmAction(_ sender: UIButton) {
        guard selectedList.count > 0 else {
            LSHUD.showInfo("Please select nft")
            return
        }
        let alert = CS_ConfirmAlert()
        alert.show("crazy_str_nft_recycle".ls_localized, content: "crazy_str_sure_to_proceed_with_the_conversion".ls_localized)
        alert.clickConfirmAction = {
            self.recycleAction()
        }
    }
    func recycleAction() {
        
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        
        var ids = ""
        var amount = 0
        for item in selectedList {
            if ids.count == 0 {
                ids = "\(item.token_id)"
            } else {
                ids = "\(ids)|\(item.token_id)"
            }
            amount += item.essences
        }
        
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["nonce"] = nonce
        para["sign"] = sign
        para["token_ids"] = ids
        
        weak var weakSelf = self
        CSNetworkManager.shared.nftRecycle(para) { resp in
            if resp.status == .success {
                weakSelf?.selectedList.removeAll()
                weakSelf?.amountLabel.text = "0"
                weakSelf?.collectionView.reloadData()
                weakSelf?.collectionView.mj_header.beginRefreshing()
                let alert = CS_LabUpgradeAlert()
                alert.showWith(amount)
            }
        }
    }
}

//MARK: request
extension CS_NFTRecycleController {
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
                feedModel = item
                propChangeAction?(feedModel)
            default: break
            }
        }
    }
}

extension CS_NFTRecycleController {
    func setupView(){
        navigationView.isHidden = true
        titleColor = .ls_white()
        emptyDescription = "crazy_str_empty_nfg_hint".ls_localized
        view.addSubview(iconView)
        view.addSubview(amountIcon)
        view.addSubview(amountLabel)
        view.addSubview(confirmButton)
        view.addSubview(collectionView)
        view.addSubview(tipsButton)
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalTo(-CS_ms(23))
            make.bottom.equalTo(-28)
            make.width.equalTo(209)
            make.height.equalTo(40)
        }
        
        amountIcon.snp.makeConstraints { make in
            make.left.equalTo(confirmButton).offset(71)
            make.bottom.equalTo(confirmButton.snp.top).offset(-11)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountIcon)
            make.left.equalTo(amountIcon.snp.right).offset(6)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(confirmButton).offset(0)
            make.bottom.equalTo(confirmButton.snp.top).offset(-66)
            make.width.equalTo(109)
            make.height.equalTo(134)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(28))
            make.top.equalTo(10)
            make.right.equalTo(confirmButton.snp.left).offset(-20)
            make.bottom.equalTo(-10)
        }
        
        tipsButton.snp.makeConstraints { make in
            make.right.equalTo(confirmButton)
            make.top.equalTo(collectionView).offset(16)
        }
    }
    
    func updateLayout() {
        
        if !isMock && dataSource.count == 0 {
            collectionView.snp.remakeConstraints { make in
                make.left.equalTo(CS_ms(28))
                make.top.equalTo(10)
                make.right.equalTo(confirmButton).offset(0)
                make.bottom.equalTo(-10)
            }
        } else {
            collectionView.snp.remakeConstraints { make in
                make.left.equalTo(CS_ms(28))
                make.top.equalTo(10)
                make.right.equalTo(confirmButton.snp.left).offset(-20)
                make.bottom.equalTo(-10)
            }
        }
    }
}


