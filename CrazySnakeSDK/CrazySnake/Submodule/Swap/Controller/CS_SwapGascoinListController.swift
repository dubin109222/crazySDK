//
//  CS_SwapGascoinListController.swift
//  CrazyWallet
//
//  Created by BigB on 2023/7/3.
//

import UIKit
import SnapKit
import JXSegmentedView
import HandyJSON

class CS_SwapGascoinListController : CS_BaseEmptyController {
    
    enum Style {
        case gasCoin
        case gameTokens
    }
    
    var style : Style = .gasCoin
    
    var isMock = false
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: (CS_kScreenW - 21.5 * 2 - 10) / 2, height: 203)
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CS_SwapGascoinItem.self, forCellWithReuseIdentifier: "CS_SwapGascoinItem")
        weak var weakSelf = self
        collectionView.ls_addHeader(false) {
            weakSelf?.requestList()
        }
        
        return collectionView
    }()
    
    private var dataSource = [CS_SwapTokenItem]()
    
    lazy var mockData: [CS_SwapTokenItem] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_SwapTokenItem>.deserializeModelArrayFrom(json: jsonStr,designatedPath: self.style == .gasCoin ? "swap.gascoin" : "swap.diamond") as? [CS_SwapTokenItem] {
                return model
            }
            
        }
        return []
    }()
    
    private var selectedModel: CS_SwapTokenItem?

    
    func requestList() {
        
        if self.style == .gasCoin {
            CSNetworkManager.shared.getSwapGasCoinList() { (resp: [CS_SwapTokenItem]) in
                
                self.dataSource = resp
                self.emptyStyle = .empty
                self.collectionView.ls_compeletLoading(true, hasMore: false)
                if self.isMock == false {
                    self.collectionView.reloadData()
                }
            }
        } else if self.style == .gameTokens {
            guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
                emptyStyle = .empty
                if self.isMock == false {
                    collectionView.reloadData()
                }
                
                return
            }
            var para :[String:Any] = [:]
            para["wallet_address"] = address
//            para["page"] = "\(page)"
//            para["page_size"] = "20"

            CSNetworkManager.shared.getGameTokens(para) { (resp : [CS_SwapTokenItem]) in
                self.dataSource = resp
                self.emptyStyle = .empty
                self.collectionView.ls_compeletLoading(true, hasMore: false)
                if self.isMock == false {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    
    override func viewDidLoad() {
        self.initSubView()
        
        GuideMaskManager.checkGuideState(style == .gasCoin ? .gas_coin_list : .game_token_list) { isFinish in
            self.isMock = !isFinish
            self.requestList()
            self.emptyStyle = .loading
            
            if self.isMock {
                self.collectionView.reloadData()
                self.guideStepOne()
            }
        }
    }
    
    private func initSubView() {
        self.collectionView.backgroundColor = .clear
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.right.bottom.equalToSuperview().offset(-20)
        }
        
        collectionView.reloadData()
    }
}


extension CS_SwapGascoinListController {
    func guideStepOne() {
        if self.isMock == true {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 0, section: 0))  {
                    let maskRect = cell.convert(cell.bounds, to: nil)
                    
                    GuideMaskView.show (tipsText: "Select the amount of \(weakSelf?.style == .gasCoin ? "Gas Coin" : "Diamond") to be exchanged.",
                                        currentStep: "1",
                                        totalStep: "2",
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
            if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 0, section: 0)) as? CS_SwapGascoinItem {
                let maskRect = cell.tokenContentView.convert(cell.tokenContentView.bounds, to: nil)
                
                GuideMaskView.show (tipsText: "Click the button below to redeem.",
                                    currentStep: "2",
                                    totalStep: "2",
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
    
    func guideStepEnd() {
        GuideMaskManager.saveGuideState(self.style == .gameTokens ? .game_token_list : .gas_coin_list)
        self.isMock = false
        self.collectionView.reloadData()
    }
}

extension CS_SwapGascoinListController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        
        let isPortrait = (UIApplication.shared.statusBarOrientation == .portrait)
        if isPortrait {
            return CGSize(width: (collectionView.bounds.size.width - 10) / 2, height: 203)
        } else {
            return CGSize(width: (collectionView.bounds.size.width - 12.5 * 2 - 30) / 4, height: 197)
        }
        
    }
}

extension CS_SwapGascoinListController : UICollectionViewDelegate {
    
}

extension CS_SwapGascoinListController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isMock ? mockData.count : self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CS_SwapGascoinItem", for: indexPath) as! CS_SwapGascoinItem
        cell.style = self.style
        cell.data = isMock ? mockData[indexPath.row] : self.dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        weak var weakSelf = self
        if dataSource[indexPath.row].is_confirming == 2 {
            let alert = CS_WatingConfirmAlert()
            alert.clickConfrimAction = {
                let historyOrderVc = CS_SwapOrderHistroyController()
                weakSelf?.pushTo(historyOrderVc)
            }
            alert.show()
            return
        }
        weakSelf?.selectedModel = weakSelf?.dataSource[indexPath.row]
        weakSelf?.clickConfirm()
    }
    
    
}

extension CS_SwapGascoinListController : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}

extension CS_SwapGascoinListController {
    func clickConfirm() {
        
//        
//        // FIXME: 这里全是snake支付，以后可能换成别的
//        let snake = TokenName.Snake.balance()
//        guard Double(snake) ?? 0 > Double(selectedModel?.need_snake ?? "0") ?? 0 else {
//            LSHUD.showError("Insufficient balance".ls_localized)
//            return
//        }
//        
//        // FIXME: - 合约地址接口失效，重写预估接口
//        
//        let vc = CS_EstimateGasAlertController()
//        vc.showTitle = "crazy_str_swap"
////        vc.gasPrice = resp.data
////        vc.para = para
////        vc.showGasCoinInsufficientAlert = false
////        weak var weakSelf = self
//        self.present(vc, animated: false)
//        vc.clickConfirmAction = {
////            weakSelf?.swap(address, contract: to,amount: amount, funcHash: funcHash)
//        }
//
//        return
        
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        if style == .gameTokens {
            swapEstimateGasDiamond(address, contract: contract.contract_address)
        } else {
            swapEstimateGas(address, contract: contract.contract_address)
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
                    CS_AccountManager.shared.verifyPassword {
                        weakSelf?.swap(address, contract: to,amount: amount, funcHash: funcHash)
                    }
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
                LSHUD.showSuccess("ok")
//                LSHUD.showSuccess(resp.message)
            } else {
                LSHUD.showInfo(resp.message)
            }
        }
    }
    
    func swapEstimateGasDiamond(_ address: String, contract: String){
        guard let amount = selectedModel?.token_amount else {
            return
        }
        
        guard let contractName = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_name else {
            return
        }

        guard let to = CS_AccountManager.shared.basicConfig?.contract?.cash_box?.contract_address else {
            return
        }
        let funcHash = CS_ContractTransfer.encodeDataTransferTokenSnake(to: to, amount: amount) ?? ""
        let para = CS_ContractSwap.getEstimateSwapDiamondPara(contract: contractName, to: to, amount: amount)
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
                    CS_AccountManager.shared.verifyPassword {
                        weakSelf?.swapDiamond(address, contract: to,amount: amount, funcHash: funcHash)
                    }
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func swapDiamond(_ address: String, contract: String,amount: String, funcHash: String){
        guard let model = selectedModel else {
            return
        }
        
        LSHUD.showLoading()
        CS_ContractSwap.swapDiamond(id: model.id, game_id: model.game_id, funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
                CS_AccountManager.shared.loadTokenBlance()
//                LSHUD.showSuccess(resp.message)
                LSHUD.showSuccess("ok")
            } else {
                LSHUD.showInfo(resp.message)
            }
        }
    }
    
}


