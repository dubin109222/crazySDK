//
//  CS_NFTBackpackController.swift
//  CrazySnake
//
//  Created by Lee on 06/03/2023.
//

import UIKit
import JXSegmentedView

class CS_NFTBackpackController: CS_BaseEmptyController {

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var sub_type = 0
    private var page = 1
    private var quality = 0
    private var dataSource = [CS_NFTPropModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        walletAddress = "0xa2d0648f9c66bdaf9372eeadbe64d8694d87f402"
        setupView()
        // Do any additional setup after loading the view.
        emptyStyle = .loading
        requestList()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = ProfileBoxCollectionCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(ProfileBoxCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(ProfileBoxCollectionCell.self))
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 10, left: 18, bottom: 0, right: 0)
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requestList()
        }
//        view.ls_addFooter {
//            weakSelf?.page += 1
//            weakSelf?.requestList()
//        }
//        view.mj_footer.isHidden = true
        return view
    }()
}

extension CS_NFTBackpackController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProfileBoxCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ProfileBoxCollectionCell.self), for: indexPath) as! ProfileBoxCollectionCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let vc = CS_NFTPropDetailController()
        vc.prop = model
        present(vc, animated: false)
        weak var weakSelf = self
        vc.openBoxSuccess = {
            weakSelf?.requestList()
        }
        
    }
    
}

//MARK: action
extension CS_NFTBackpackController {
    func requestList() {
        
        guard let address = walletAddress else {
            emptyStyle = .empty
            collectionView.reloadData()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sub_type"] = "\(sub_type)"
//        para["page"] = "\(page)"
//        para["page_size"] = "20"
        CSNetworkManager.shared.getMybackpackList(para) { resp in
            weakSelf?.collectionView.ls_compeletLoading(false)
            var hasMore = false
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
//                    if list.count > 0 {
//                        hasMore = true
//                    }
                }
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            weakSelf?.collectionView.ls_compeletLoading(weakSelf?.page == 1, hasMore: hasMore)
//            weakSelf?.collectionView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 < 5
            weakSelf?.collectionView.reloadData()
        }
    }
}

extension CS_NFTBackpackController {
    func setupView(){
        navigationView.isHidden = true
        backView.image = UIImage.ls_bundleImageJpg(named: "bg_image_no_title")
        emptyTitle = ""
        emptyDescription = "crazy_str_empty_nft_backpack_hint".ls_localized
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.left.bottom.equalTo(CS_ms(20))
            make.right.bottom.equalTo(-CS_ms(20))
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
}

extension CS_NFTBackpackController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}
