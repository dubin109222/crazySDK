//
//  CS_SwapOrderHistroyController.swift
//  CrazyWallet
//
//  Created by BigB on 2023/7/3.
//

import Foundation
import UIKit
import SnapKit
import MJRefresh

class CS_SwapOrderHistroyController : CS_BaseEmptyController {
    private var page = 1
    private var dataSource = [CS_SwapHistoryModel]()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backView.image = nil
        self.backView.backgroundColor = .ls_color("#171718")
        
        navigationView.titleLabel.text = "crazy_str_orders_history".ls_localized
        navigationView.backView.image = nil
        
        if self.isLandscape() {
            let line = UIView()
            line.backgroundColor = .white.withAlphaComponent(0.1)
            self.view.addSubview(line)
            line.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
                make.top.equalTo(navigationView.snp.bottom)
            }

        }
        
        self.collectionView.ls_compeletLoading(true, hasMore: false)
   

        emptyStyle = .loading
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
//        emptyDescription = "No NFTs available in your inventory"

        self.view.addSubview(self.collectionView)
        if self.isLandscape() {
            
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(navigationView.snp.bottom).offset(38)
                make.right.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(CS_ms(30))
            }

        } else {
            
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(navigationView.snp.bottom).offset(38)
                make.right.bottom.equalToSuperview()
                make.left.equalToSuperview()
            }
            
        }
        
        self.requstList()
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        if self.isLandscape() {
            layout.itemSize = CGSize(width: CS_kScreenW - CS_ms(30) - 35, height: 140)
        } else {
            layout.itemSize = CGSize(width: 335, height: 202.5)
        }
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CS_SwapOrderHistoryCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_SwapOrderHistoryCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.ls_addHeader(false) {
            self.page = 1
            self.requstList()
        }
        collectionView.ls_addFooter {
            self.page += 1
            self.requstList()
        }
        collectionView.mj_footer.isHidden = true

        return collectionView
    }()
}

extension CS_SwapOrderHistroyController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_SwapOrderHistoryCell.self), for: indexPath) as! CS_SwapOrderHistoryCell
        
        cell.fromNameDesLb.text = Config.chain.name
        cell.toNameDesLb.text = Config.chain.name
        
        let model = self.dataSource[indexPath.row]
        cell.data = model
        
        weak var weakSelf = self
        cell.clickWithdrawAction = {
            weakSelf?.estimateGasWithdraw(model)
        }

        
        return cell
    }
    
}

// 领取u币逻辑
extension CS_SwapOrderHistroyController {
    func estimateGasWithdraw(_ history: CS_SwapHistoryModel){
        
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        guard let encodeData = CS_ContractSwap.shared.encodeDataWithdraw(sid: history.sid)  else { return }
        let para = CS_ContractSwap.getEstimateSwapWithdrawPara(sid: history.sid, id: history.id)
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "crazy_str_withdraw".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract.contract_address
                vc.para = para
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.withdraw(history, funcHash: encodeData)
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func withdraw(_ history: CS_SwapHistoryModel, funcHash: String){
        weak var weakSelf = self
        LSHUD.showLoading()
        CS_ContractSwap.shared.swapWithdraw(id: history.id, amount: history.amount_out, funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
//                var model = weakSelf?.dataSource.first(where: {$0.id == history.id})
//                model?.status = 1
//                weakSelf?.tableView.reloadData()
                weakSelf?.page = 1
                LSHUD.showLoading()
                weakSelf?.requstList()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }

}

extension CS_SwapOrderHistroyController {
    func requstList(){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            self.collectionView.ls_compeletLoading(true, hasMore: false)
            self.collectionView.reloadData()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["status"] = "\(-1)"
        para["page"] = "\(page)"
        para["page_size"] = "20"
        CSNetworkManager.shared.getSwapHistoryList(para) { resp in
            LSHUD.hide()
            var hasMore = false
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
                }
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            if weakSelf?.dataSource.count ?? 0 < resp.data?.total ?? 0 {
                hasMore = true
            }
            self.collectionView.ls_compeletLoading(true, hasMore: hasMore)
            self.collectionView.reloadData()
        }
    }
}

