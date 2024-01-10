//
//  CS_MarketNFTController.swift
//  CrazySnake
//
//  Created by Lee on 23/04/2023.
//

import UIKit
import JXSegmentedView
import HandyJSON

class CS_MarketNFTController: CS_BaseEmptyController {

    private var page = 1
    private var dataSource = [CS_MarketModel]()
    lazy var mockData: [CS_MarketModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_MarketModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "market.shelve_list") as? [CS_MarketModel] {
                var list = model
                if list.count >= 2 {
                    list[1].item_type = 1
                    list[1].nftDetail?.user?.wallet_address = (CS_AccountManager.shared.userInfo?.wallet_address ?? "")
                }
                return list
            }
            
        }
        return []
    }()
    
    private var quality = 0
    
    public var isMock = false
    
    public var mockToInventoryHandle: (() -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        setupView()
        collectionView.isHidden = true
        GuideMaskManager.checkGuideState(.market_nft) { isFinish in
            self.isMock = !isFinish
            self.collectionView.reloadData()
            self.collectionView.isHidden = false
            self.requestList()
            self.emptyStyle = .loading
            
            if self.isMock {
                self.collectionView.reloadData()
                self.guideStepOne()
            }
        }

        registerNotication()
        
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 28
        layout.itemSize = CS_MarketCollectionCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(CS_MarketCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_MarketCollectionCell.self))
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requestList()
        }
        view.ls_addFooter {
            weakSelf?.page += 1
            weakSelf?.requestList()
        }
        view.mj_footer.isHidden = true
        return view
    }()
}


//MARK: Notification
extension CS_MarketNFTController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyRemoveOffer(_:)), name: NotificationName.CS_MarketRemoveOffer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyPlaceOffer(_:)), name: NotificationName.CS_MarketPlaceOffer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyBuyItem(_:)), name: NotificationName.CS_MarketBuyItem, object: nil)
    }
    
    @objc private func notifyRemoveOffer(_ notify: Notification) {
        guard let model = notify.object as? CS_MarketModel else { return }
        dataSource.removeAll(where: { $0.sku_id == model.sku_id })
        collectionView.reloadData()
    }
    
    @objc private func notifyPlaceOffer(_ notify: Notification) {
        guard let model = notify.object as? CS_MarketModel else { return }
        if model.item_type == 1 {
            page = 1
            requestList()
        }
    }
    
    @objc private func notifyBuyItem(_ notify: Notification) {
        guard let model = notify.object as? CS_MarketModel else { return }
        dataSource.removeAll(where: { $0.sku_id == model.sku_id })
        collectionView.reloadData()
    }
}

extension CS_MarketNFTController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_MarketCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_MarketCollectionCell.self), for: indexPath) as! CS_MarketCollectionCell
        var model : CS_MarketModel
        if isMock {
            model = mockData[indexPath.row]
        } else {
            model = dataSource[indexPath.row]
        }
        cell.setData(model)
        cell.buyButton.isUserInteractionEnabled = false
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
        let vc = CS_MarketNFTDetailController()
        vc.model = model
        present(vc, animated: false)
    }
    
}

extension CS_MarketNFTController {
    func guideStepOne() {
        if self.isMock == true {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 0, section: 0)) as? CS_MarketCollectionCell {
                    let maskRect = cell.buyButton.convert(cell.buyButton.bounds, to: nil)
                    
                    GuideMaskView.show (tipsText: "Select the NFT you want to purchase.",
                                        currentStep: "1",
                                        totalStep: "5",
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
    
    func guideStepTwo() {
        weak var weakSelf = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 1, section: 0)) as? CS_MarketCollectionCell {
                let maskRect = cell.buyButton.convert(cell.buyButton.bounds, to: nil)
                
                GuideMaskView.show (tipsText: "NFTs already sold are also cancelled.",
                                    currentStep: "2",
                                    totalStep: "5",
                                    maskRect: maskRect,
                                    textWidthDefault: 223,
                                    direction: .up){
                    weakSelf?.guideStepThree()
                    
                } skipHandle: {
                    weakSelf?.guideStepEnd()
                }
            }
        }

    }
    
    func guideStepThree() {
        weak var weakSelf = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 0, section: 0)) {
                let maskRect = cell.convert(cell.bounds, to: nil)
                
                GuideMaskView.show (tipsText: "NFT details can be viewed.",
                                    currentStep: "3",
                                    totalStep: "5",
                                    maskRect: maskRect,
                                    textWidthDefault: 223,
                                    direction: .left){
                    weakSelf?.guideStepFour()
                    
                } skipHandle: {
                    weakSelf?.guideStepEnd()
                }
            }
        }
    }
    
    func guideStepFour() {
        let model = mockData[0]
        let vc = CS_MarketNFTDetailController()
        vc.isMock = true
        vc.model = model
        weak var weakSelf = self
        vc.mockNextHandle = { isSkip in
            if isSkip {
                weakSelf?.guideStepEnd()
            } else {
                weakSelf?.guideStepFive()
            }
        }
        present(vc, animated: false)
    }
    
    func guideStepFive() {
        mockToInventoryHandle?()
    }
    
    func guideStepEnd( isSkip: Bool = true) {
        GuideMaskManager.saveGuideState(.market_nft)
        self.isMock = false
        self.collectionView.reloadData()
    }

}


//MARK: action
extension CS_MarketNFTController {
    func requestList() {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            if !isMock {
                collectionView.reloadData()
            }
            return
        }
        weak var weakSelf = self
        // filter {"quality":3,"sex":1,"class":100001}
        // item_type 类型，1nft，2道具
        
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["item_type"] = "\(1)"
        para["page"] = "\(page)"
        para["page_size"] = "20"
        para["filter"] = self.filterStr
        CSNetworkManager.shared.getMarketList(para) { resp in
            weakSelf?.collectionView.ls_compeletLoading(false)
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
            }
        }
    }
}

extension CS_MarketNFTController {
    func setupView(){
        navigationView.isHidden = true
        backView.image = nil
        backView.backgroundColor = .clear
        view.backgroundColor = .clear
        emptyDescription = "crazy_str_empty_nft_backpack_hint".ls_localized
        titleColor = .ls_white()
        view.addSubview(collectionView)

        
        collectionView.snp.makeConstraints { make in
            make.left.bottom.equalTo(CS_ms(20))
            make.right.bottom.equalTo(-CS_ms(20))
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
}

extension CS_MarketNFTController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}
