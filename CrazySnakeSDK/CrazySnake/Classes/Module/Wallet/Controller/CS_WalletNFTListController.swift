//
//  CS_WalletNFTListController.swift
//  CrazySnake
//
//  Created by Lee on 30/05/2023.
//

import UIKit
import JXSegmentedView

class CS_WalletNFTListController: CS_BaseEmptyController {

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var page = 1
    private var quality = 0
    private var dataSource = [CS_NFTDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        walletAddress = "0xa2d0648f9c66bdaf9372eeadbe64d8694d87f402"
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
        layout.itemSize = CS_WalletNftCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(CS_WalletNftCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_WalletNftCell.self))
        view.backgroundColor = .ls_color("#171718")
        view.contentInset = UIEdgeInsets(top: 10, left: CS_ms(24), bottom: 0, right: CS_ms(24))
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
extension CS_WalletNFTListController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyOpenBoxSuccess(_:)), name: NotificationName.CS_OpenBoxSuccess, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletChange(_:)), name: NotificationName.walletChanged, object: nil)
    }
    
    @objc private func notifyOpenBoxSuccess(_ notify: Notification) {
        page = 1
        requestMyNFTList()
    }
    
    @objc private func notifyWalletChange(_ notify: Notification) {
        page = 1
        requestMyNFTList()
    }
}

extension CS_WalletNFTListController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_WalletNftCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_WalletNftCell.self), for: indexPath) as! CS_WalletNftCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        weak var weakSelf = self
        cell.clickDepositAction = {
            weakSelf?.estimateGas(model: model)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK: action
extension CS_WalletNFTListController {
    func requestMyNFTList(_ scrollToTop: Bool = false) {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            collectionView.reloadData()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
//        para["quality"] = "\(quality)"
        para["page"] = "\(page)"
        para["page_size"] = "20"
        CSNetworkManager.shared.getMyChainNFTList(para) { resp in
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
            if scrollToTop {
                weakSelf?.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
}

//MARK: contract
extension CS_WalletNFTListController {
    func estimateGas(model: CS_NFTDataModel){
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.nft.first?.contract_address else {
            return
        }
        guard let tokenId = Int(model.token_id) else { return }
        let para = CS_ContractNFT.depositPara(token: contract, ids: [tokenId])
        
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "Transfer".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.transfer(model: model)
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func transfer(model: CS_NFTDataModel){
        guard let tokenId = Int(model.token_id) else { return }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["token_ids"] = "\(tokenId)"
        para["contract_name"] = model.contract_name
        
        LSHUD.showLoading()
        CSNetworkManager.shared.nftTransferIn(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                LSHUD.showInfo(resp.message)
                weakSelf?.page = 1
                weakSelf?.requestMyNFTList(true)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}


extension CS_WalletNFTListController {
    func setupView(){
        navigationView.isHidden = true
        emptyDescription = "crazy_str_empty_nfg_hint".ls_localized
        view.addSubview(collectionView)

        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
    }
}
extension CS_WalletNFTListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

