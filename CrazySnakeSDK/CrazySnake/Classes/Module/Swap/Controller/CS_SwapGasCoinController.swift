//
//  CS_GasCoinController.swift
//  CrazySnake
//
//  Created by Lee on 16/03/2023.
//

import UIKit
import JXSegmentedView

class CS_SwapGasCoinController: CS_BaseEmptyController {

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var dataSource = [CS_SwapGasCoinModel]()
    private var selectedModel: CS_SwapGasCoinModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        requestList()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
//        layout.minimumInteritemSpacing = 10
        layout.itemSize = CS_SwapGasCoinCell.itemSize()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(CS_SwapGasCoinCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_SwapGasCoinCell.self))
        view.backgroundColor = .clear
//        view.contentInset = UIEdgeInsets(top: 6, left: 12, bottom: 0, right: 12)
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.requestList()
        }

        return view
    }()

}

extension CS_SwapGasCoinController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_SwapGasCoinCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_SwapGasCoinCell.self), for: indexPath) as! CS_SwapGasCoinCell
        let model = dataSource[indexPath.row]
        cell.setData(model,index: indexPath.row)
        cell.clickConfirmAction = {
            self.selectedModel = model
            self.clickConfirm()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK: contract
extension CS_SwapGasCoinController {
    func clickConfirm() {
        
        let snake = TokenName.Snake.balance()
        guard Double(snake) ?? 0 > Double(selectedModel?.need_snake ?? "0") ?? 0 else {
            LSHUD.showError("Insufficient balance".ls_localized)
            return
        }
        
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper?.contract_address else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        swapEstimateGas(address, contract: contract)
        return
        LSHUD.showLoading()
        weak var weakSelf = self
        CS_ContractApprove.snakeTokenIsApproved(to: contract) { isApproved in
            if isApproved {
                weakSelf?.swapEstimateGas(address, contract: contract)
            } else {
                weakSelf?.approveEstimateGas(address, contract: contract)
            }
        }
    }
    
    func approveEstimateGas(_ address: String, contract: String){
        let encodeData = CS_ContractApprove.encodeDataTokenApprove(to: contract) ?? ""
        let para = CS_ContractApprove.estimateTokenApprovePara(to: contract)
        weak var weakSelf = self
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "Approve"
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                vc.showGasCoinInsufficientAlert = false
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.approve(address, contract: contract, funcHash: encodeData)
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func approve(_ address: String, contract: String, funcHash: String){
        weak var weakSelf = self
        LSHUD.showLoading()
        CS_ContractApprove.approveSnake(to: contract, funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
                weakSelf?.swapEstimateGas(address, contract: contract)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func swapEstimateGas(_ address: String, contract: String){
        guard let amount = selectedModel?.need_snake else {
            return
        }
        guard let to = CS_AccountManager.shared.basicConfig?.contract?.cash_box?.contract_address else {
            return
        }
        let funcHash = CS_ContractTransfer.encodeDataTransferTokenSnake(to: to, amount: amount) ?? ""
        let para = CS_ContractSwap.getEstimateSwapGasCoinPara(to: to, amount: amount, gasCoin: selectedModel?.gas_coin ?? "")
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "crazy_str_swap".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                vc.showGasCoinInsufficientAlert = false
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.swap(address, contract: to,amount: amount, funcHash: funcHash)
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func swap(_ address: String, contract: String,amount: String, funcHash: String){
        LSHUD.showLoading()
        CS_ContractSwap.swapGasCoin(amount: amount, gasCoin: selectedModel?.gas_coin ?? "", funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
                CS_AccountManager.shared.loadTokenBlance()
            }
            LSHUD.showInfo(resp.message)
        }
    }
    
}


//MARK: request
extension CS_SwapGasCoinController {
    func requestList() {
        
//        /// getSwapGasCoinList
//        func getSwapGasCoinList(_ response: @escaping((CS_SwapGasCoinResp) -> ()) ){
//            
//            LSNetwork.shared.httpGetRequest(path: "/v2/api/token/gas_coins", para: nil) { (json) in
//                let resp = CS_SwapGasCoinResp(json)
//                response(resp)
//            }
//        }

//        weak var weakSelf = self
//        CSNetworkManager.shared.getSwapGasCoinList { resp in
//            
//            if resp.status == .success {
//                weakSelf?.dataSource.removeAll()
//                weakSelf?.dataSource.append(contentsOf: resp.data)
//                weakSelf?.emptyStyle = .empty
//            } else {
//                weakSelf?.emptyStyle = .error
//            }
//            weakSelf?.collectionView.ls_compeletLoading(true, hasMore: false)
//            weakSelf?.collectionView.reloadData()
//        }
    }
}

extension CS_SwapGasCoinController {
    func setupView(){
        navigationView.isHidden = true
        backView.image = UIImage.ls_bundleImageJpg(named: "bg_image_no_title")
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(185*3+20*2)
            make.height.equalTo(272)
        }
    }
}

extension CS_SwapGasCoinController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

