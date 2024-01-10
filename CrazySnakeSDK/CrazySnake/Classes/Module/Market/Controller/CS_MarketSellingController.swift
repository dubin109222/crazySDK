//
//  CS_MarketSellingController.swift
//  CrazySnake
//
//  Created by Lee on 23/04/2023.
//

import UIKit
import JXSegmentedView

class CS_MarketSellingController: CS_BaseEmptyController {

    private var page = 1
    private var dataSource = [CS_MarketModel]()
    private var quality = 0

    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        emptyStyle = .loading
        requestList()
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
}

//MARK: Notification
extension CS_MarketSellingController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyRemoveOffer(_:)), name: NotificationName.CS_MarketRemoveOffer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyPlaceOffer(_:)), name: NotificationName.CS_MarketPlaceOffer, object: nil)
    }
    
    @objc private func notifyRemoveOffer(_ notify: Notification) {
        guard let model = notify.object as? CS_MarketModel else { return }
        dataSource.removeAll(where: { $0.sku_id == model.sku_id })
        collectionView.reloadData()
    }
    
    @objc private func notifyPlaceOffer(_ notify: Notification) {
//        guard let model = notify.object as? CS_MarketModel else { return }
//        if model.item_type == 1 {
//        }
        page = 1
                requestList()
    }
}

extension CS_MarketSellingController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_MarketMineCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_MarketMineCell.self), for: indexPath) as! CS_MarketMineCell
        let model = dataSource[indexPath.row]
        cell.setDataSelling(model)
        weak var weakSelf = self
        cell.clickRemovePlaceOffer = {
            if model.item_type == 2 {
                let vc = CS_MarketProtStopSellingController()
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
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if model.item_type == 1 {
            let vc = CS_MarketNFTDetailController()
            vc.model = model
            present(vc, animated: false)
        } else if model.item_type == 3 {
            let vc = CS_MarketNFTSetDetailController()
            vc.model = model
            pushTo(vc)
        } else {
            let vc = CS_MarketPropDetailController()
            vc.model = model
            present(vc, animated: false)
        }
    }
    
}

//MARK: action
extension CS_MarketSellingController {
    func         requestList() {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            collectionView.reloadData()
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

        CSNetworkManager.shared.getMarketSellingList(para) { resp in
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
            weakSelf?.collectionView.reloadData()
        }
    }
}

extension CS_MarketSellingController {
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

extension CS_MarketSellingController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

