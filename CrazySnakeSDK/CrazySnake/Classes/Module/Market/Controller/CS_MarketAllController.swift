//
//  CS_MarketAllController.swift
//  CrazySnake
//
//  Created by Lee on 23/04/2023.
//

import UIKit
import JXSegmentedView

class CS_MarketAllController: CS_BaseEmptyController {

    private var page = 1
    private var dataSource = [CS_MarketModel]()
    private var quality = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        emptyStyle = .loading
        requestMyNFTList()
        registerNotication()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = ProfileNFTCollectionCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(ProfileNFTCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(ProfileNFTCollectionCell.self))
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 10, left: 18, bottom: 0, right: 0)
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requestMyNFTList()
        }
        view.ls_addFooter {
            weakSelf?.page += 1
            weakSelf?.requestMyNFTList()
        }
        view.mj_footer.isHidden = true
        return view
    }()
}


//MARK: Notification
extension CS_MarketAllController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyOpenBoxSuccess(_:)), name: NotificationName.CS_OpenBoxSuccess, object: nil)
    }
    
    @objc private func notifyOpenBoxSuccess(_ notify: Notification) {
        page = 1
        requestMyNFTList()
    }
}

extension CS_MarketAllController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProfileNFTCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ProfileNFTCollectionCell.self), for: indexPath) as! ProfileNFTCollectionCell
        let model = dataSource[indexPath.row]
//        cell.setData(model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
//        let vc = CS_NFTNFTDetailController()
//        vc.model = model
//        present(vc, animated: false)
    }
    
}

//MARK: action
extension CS_MarketAllController {
    func requestMyNFTList() {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            collectionView.reloadData()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["status"] = "\(-1)"
        para["quality"] = "\(quality)"
        para["page"] = "\(page)"
        para["page_size"] = "20"
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
            weakSelf?.collectionView.reloadData()
        }
    }
}

extension CS_MarketAllController {
    func setupView(){
        navigationView.isHidden = true
        backView.image = UIImage.ls_bundleImageJpg(named: "bg_image_no_title")
        emptyDescription = "crazy_str_empty_nfg_hint".ls_localized
        view.addSubview(collectionView)

        
        collectionView.snp.makeConstraints { make in
            make.left.bottom.equalTo(CS_ms(20))
            make.right.bottom.equalTo(-CS_ms(20))
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
}

extension CS_MarketAllController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}
