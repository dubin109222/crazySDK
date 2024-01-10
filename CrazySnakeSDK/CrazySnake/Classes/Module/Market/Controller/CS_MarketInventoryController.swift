//
//  CS_MarketInventoryController.swift
//  CrazySnake
//
//  Created by Lee on 23/04/2023.
//

import UIKit
import JXSegmentedView
import HandyJSON



class CS_MarketInventoryController: CS_BaseEmptyController {

    private var page = 1
    private var dataSource = [CS_MarketModel]()
    lazy var mockData: [CS_MarketModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_MarketModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "market.inventories_list") as? [CS_MarketModel]  {
                return model
            }
            
        }
        return []
    }()

    private var quality = 0
    var isMock = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // FIXME: 刷新mock，根据本地化获取
        setupView()

        GuideMaskManager.checkGuideState(.market_nft) { isFinish in
            self.isMock = !isFinish
            self.requestList()
            self.emptyStyle = .loading
            
            if self.isMock {
                self.collectionView.reloadData()
                self.guideStepOne()
            }
        }

        // Do any additional setup after loading the view.
        registerNotication()

    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 19.5
        layout.itemSize = CS_MarketMineCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(CS_MarketMineCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_MarketMineCell.self))
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
    
    var mockNextHandle: ((Bool) -> ())? = nil
}


//MARK: Notification
extension CS_MarketInventoryController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyRemoveOffer(_:)), name: NotificationName.CS_MarketRemoveOffer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyPlaceOffer(_:)), name: NotificationName.CS_MarketPlaceOffer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyBuyItem(_:)), name: NotificationName.CS_MarketBuyItem, object: nil)
    }
    
    @objc private func notifyRemoveOffer(_ notify: Notification) {
        guard let model = notify.object as? CS_MarketModel else { return }
        page = 1
                requestList()
    }
    
    @objc private func notifyPlaceOffer(_ notify: Notification) {
        guard let model = notify.object as? CS_MarketModel else { return }
        if model.item_type == 1 {
            dataSource.removeAll(where: { $0.item_id == model.item_id })
            collectionView.reloadData()
        } else {
            page = 1
                    requestList()
        }
    }
    
    @objc private func notifyBuyItem(_ notify: Notification) {
        guard let model = notify.object as? CS_MarketModel else { return }
        page = 1
                requestList()
    }
}

extension CS_MarketInventoryController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_MarketMineCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_MarketMineCell.self), for: indexPath) as! CS_MarketMineCell
        let model = isMock ? mockData[indexPath.row] : dataSource[indexPath.row]
        cell.setDataInventory(model)
        weak var weakSelf = self
        cell.clickPlaceOffer = {
            if model.item_type == 2 {
                let vc = CS_MarketPropStartSellingController()
                vc.model = model
                weakSelf?.present(vc, animated: false)
            } else {
                let vc = CS_MarketNFTDetailController()
                vc.model = model
                weakSelf?.present(vc, animated: false)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isMock ? mockData.count : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if model.item_type == 1 {
            let vc = CS_MarketNFTDetailController()
            vc.model = model
            present(vc, animated: false)
        } else {
            let vc = CS_MarketPropDetailController()
            vc.model = model
            present(vc, animated: false)
        }
    }
}

extension CS_MarketInventoryController {
    func guideStepOne() {
        if self.isMock == true {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 0, section: 0)) as? CS_MarketMineCell {
                    let maskRect = cell.buyButton.convert(cell.buyButton.bounds, to: nil)
                    
                    GuideMaskView.show (tipsText: "NFTs in backpacks can also be sold on shelves.",
                                        currentStep: "5",
                                        totalStep: "5",
                                        maskRect: maskRect,
                                        textWidthDefault: 223,
                                        direction: .left){
                        weakSelf?.guideStepEnd()
                    } skipHandle: {
                        weakSelf?.guideStepEnd()
                    }
                }
            }
        }
    }
    
    func guideStepEnd() {
        GuideMaskManager.saveGuideState(.market_nft)
        mockNextHandle?(true)

    }
}


//MARK: action
extension CS_MarketInventoryController {
    func         requestList() {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            if isMock == false {
                collectionView.reloadData()
            }
            
            return
        }
        weak var weakSelf = self
        
        // type 类型0全部，1nft，2箱子，3孵化器，4坑位卡
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["type"] = "\(0)"
        para["page"] = "\(page)"
        para["page_size"] = "20"
        para["filter"] = self.filterStr
        CSNetworkManager.shared.getMarketSellableList(para) { resp in
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

extension CS_MarketInventoryController {
    func setupView(){
        navigationView.isHidden = true
        backView.image = nil
        backView.backgroundColor = .clear
        view.backgroundColor = .clear
        emptyDescription = "crazy_str_empty_nft_backpack_hint".ls_localized
        titleColor = .ls_white()
        view.addSubview(collectionView)

        
        collectionView.snp.makeConstraints { make in
            make.left.bottom.equalTo(CS_ms(12))
            make.right.bottom.equalTo(-CS_ms(12))
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
}
extension CS_MarketInventoryController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}
