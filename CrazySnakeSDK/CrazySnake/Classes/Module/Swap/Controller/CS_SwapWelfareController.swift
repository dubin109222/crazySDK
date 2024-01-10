//
//  CS_SwapWelfareController.swift
//  CrazySnake
//
//  Created by Lee on 15/05/2023.
//

import UIKit
import JXSegmentedView
import SwiftyAttributes

class CS_SwapWelfareController: CS_BaseEmptyController {

    var welfareInfo: CS_SwapWelfareModel?
    var amount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        LSHUD.showLoading()
        requestWelfareInfo()
    }
    

    lazy var leftView: CS_NormalInfoView = {
        let view = CS_NormalInfoView()
        view.titleLabel.text = "crazy_str_welfare_swap".ls_localized
        return view
    }()
    
    lazy var leftToken: CS_SwapWelfareTokenInfoView = {
        let view = CS_SwapWelfareTokenInfoView()
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("swap_icon_to@2x")
        return view
    }()
    
    lazy var rightToken: CS_SwapWelfareTokenInfoView = {
        let view = CS_SwapWelfareTokenInfoView()
        view.amountLabel.textColor = .ls_color("#46F490")
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 180, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_confirm_swap".ls_localized, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var timesLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_font(10))
        label.textAlignment = .center
        label.text = "crazy_str_exchange_time_content".ls_localized
        return label
    }()

    lazy var rightView: CS_NormalInfoView = {
        let view = CS_NormalInfoView()
        view.titleLabel.text = "crazy_str_welfare_swap".ls_localized
        return view
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickRefreshButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("swap_icon_refresh@2x"), for: .normal)
        return button
    }()
    
    lazy var directionLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#CCCCCC"), .ls_JostRomanFont(12))
        label.numberOfLines = 0
        label.text = "crazy_str_swap_welfare_content".ls_localized
        return label
    }()
    
    lazy var rightBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#3A3A3A")
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var priceView: CS_SwapCoinContentItemView = {
        let view = CS_SwapCoinContentItemView()
        view.titleLabel.text = "crazy_str_price".ls_localized
        view.contentLabel.text = "--"
        return view
    }()
    
    lazy var slippageView: CS_SwapCoinContentItemView = {
        let view = CS_SwapCoinContentItemView()
        view.titleLabel.text = "crazy_str_slippage".ls_localized
        view.contentLabel.text = "0.5%"
        view.contentLabel.textColor = .ls_color("#46F490")
        return view
    }()
    
    lazy var feesView: CS_SwapCoinContentItemView = {
        let view = CS_SwapCoinContentItemView()
        view.titleLabel.text = "crazy_str_fees".ls_localized
        view.contentLabel.text = "0.2%"
        return view
    }()
}

//MARK: action
extension CS_SwapWelfareController {
    
    @objc private func clickRefreshButton(_ sender: UIButton) {
        LSHUD.showLoading()
        requestPrice()
    }
    
    @objc private func clickConfirmButton(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let model = welfareInfo,let tokenFrom = model.from?.token else {
            LSHUD.hide()
            return
        }
        
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper?.contract_address else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        var swapType = CS_SwapType.SnakeToUSDT
        if tokenFrom == .USDT {
            swapType = .USDTToSnake
            
            let balance = TokenName.USDT.balance()
            guard Double(balance) ?? 0 >= Double(amount) else {
                LSHUD.showError("Insufficient balance".ls_localized)
                return
            }
            
//            guard Double(amount) ?? 0 >= 1 else {
//                LSHUD.showError("USDT need more than 1U".ls_localized)
//                return
//            }
            
        } else {
            let balance = TokenName.Snake.balance()
            guard Double(balance) ?? 0 >= Double(amount) else {
                LSHUD.showError("Insufficient balance".ls_localized)
                return
            }
        }
        
        LSHUD.showLoading()
        weak var weakSelf = self
        CS_ContractSwap.swapIsApproved(swapType: swapType) { isApproved in
            if isApproved {
                weakSelf?.swapEstimateGas(address, contract: contract, swapType: swapType)
            } else {
                weakSelf?.approveEstimateGas(address, contract: contract,swapType: swapType)
            }
        }
    }
    
    func requestWelfareInfo() {
        
        weak var weakSelf = self
        var para :[String:Any] = [:]
        let wallet_address = CS_AccountManager.shared.accountInfo?.wallet_address
        para["wallet_address"] = wallet_address
        CSNetworkManager.shared.getWelfareSwap(para) { resp in
            if resp.status == .success, let model = resp.data?.first {
                weakSelf?.welfareInfo = model
                weakSelf?.leftToken.setData(model.from)
                weakSelf?.rightToken.setData(model.to)
                weakSelf?.amount = model.amount
                weakSelf?.timesLabel.attributedText = "crazy_str_exchange_time_content".ls_localized_color([" \(model.left_times)"])                
                weakSelf?.requestPrice()
                weakSelf?.confirmButton.isEnabled = resp.data?.first?.is_confirming == 0
            }
        }
    }
    
    func requestPrice() {
        guard let model = welfareInfo,let tokenFrom = model.from?.token ,let tokenTo = model.to?.token else {
            LSHUD.hide()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        let from = tokenFrom.rawValue
        let to = tokenTo.rawValue
        para["from"] = from
        para["to"] = to
        para["amount"] = EthUnitUtils.getWei(amount: "1", token: tokenFrom)
        CSNetworkManager.shared.getSwapRatio(para) { resp in
            LSHUD.hide()
            if resp.status == .success,let model = resp.data {
                let ratio = EthUnitUtils.getAmount(wei: model.ratio, token: tokenTo)
                let text = "\((Double(ratio ?? "0") ?? 0) * Double(weakSelf?.amount ?? 1))"
                weakSelf?.leftToken.amountLabel.text = "\(weakSelf?.amount ?? 1)"
                weakSelf?.rightToken.amountLabel.text = Utils.formatAmount(text)
                weakSelf?.priceView.contentLabel.text = "1 \(from) = \(Utils.formatAmount(ratio)) \(to)"
            }
        }
    }
    
}

//MARK: contract
extension CS_SwapWelfareController {
    func approveEstimateGas(_ address: String, contract: String, swapType: CS_SwapType){
        let encodeData = CS_ContractApprove.encodeDataTokenApprove(to: contract) ?? ""
        let para = CS_ContractApprove.estimateTokenApprovePara(to: contract)
        weak var weakSelf = self
        CSNetworkManager.shared.getEstimateGas(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "Approve"
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.approve(address, contract: contract, swapType: swapType, funcHash: encodeData)
                }
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func approve(_ address: String, contract: String, swapType: CS_SwapType, funcHash: String){
        weak var weakSelf = self
        LSHUD.showLoading()
        CS_ContractSwap.approve(swapType: swapType, funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
                weakSelf?.swapEstimateGas(address, contract: contract, swapType: swapType)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func swapEstimateGas(_ address: String, contract: String,swapType: CS_SwapType){
//        let amountOut = "\((Double(rightToken.amountLabel.text ?? "0") ?? 0) * 0.95)"
        let amountOut = "\((Double(rightToken.amountLabel.text ?? "0") ?? 0))"
        let para = CS_ContractSwap.shared.swapTokenPara(swapType: swapType, amount: "\(amount)", amountOutMin: amountOut)
        
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
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.swap(address, contract: contract,gasPrice: resp.data?.gas, swapType: swapType,funcHash: "")
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func swap(_ address: String, contract: String,gasPrice: String?,swapType: CS_SwapType, funcHash: String){
        guard let model = welfareInfo,let tokenFrom = model.from?.token ,let tokenTo = model.to?.token else {
            LSHUD.hide()
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
//        let amountOut = "\((Double(rightToken.amountLabel.text ?? "0") ?? 0) * 0.95)"
        let amountOut = "\((Double(rightToken.amountLabel.text ?? "0") ?? 0))"
        let amountWei = EthUnitUtils.getWei(amount: "\(amount)", token: tokenFrom)
        let amountOutWei = EthUnitUtils.getWei(amount: amountOut, token: tokenTo)
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["amount"] = amountWei
        para["get_amount"] = amountOutWei
        para["pool_fee"] = "3000"
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.welfareSwap(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                LSHUD.showInfo(resp.message)
                weakSelf?.requestWelfareInfo()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}


//MARK: UI
extension CS_SwapWelfareController {
    func setupView(){
        navigationView.isHidden = true
        titleColor = .ls_white()
        
        view.addSubview(leftView)
        leftView.addSubview(leftToken)
        leftView.addSubview(iconView)
        leftView.addSubview(rightToken)
        leftView.addSubview(timesLabel)
        leftView.addSubview(confirmButton)
        view.addSubview(rightView)
        rightView.addSubview(refreshButton)
        rightView.addSubview(directionLabel)
        rightView.addSubview(rightBottomView)
        rightBottomView.addSubview(priceView)
        rightBottomView.addSubview(feesView)
        rightBottomView.addSubview(slippageView)
        
        leftView.snp.makeConstraints { make in
            make.right.equalTo(view.snp.centerX).multipliedBy(0.9)
            make.top.equalTo(CS_RH(10))
            make.width.equalTo(260)
            make.height.equalTo(260)
        }
        
        leftToken.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(42)
            make.width.equalTo(86)
            make.height.equalTo(105)
        }
        
        rightToken.snp.makeConstraints { make in
            make.top.width.height.equalTo(leftToken)
            make.right.equalTo(-15)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(leftView)
            make.centerY.equalTo(leftToken)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(leftView)
            make.bottom.equalTo(-15)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
        timesLabel.snp.makeConstraints { make in
            make.centerX.equalTo(confirmButton)
            make.bottom.equalTo(confirmButton.snp.top).offset(-8)
        }
        
        rightView.snp.makeConstraints { make in
            make.left.equalTo(leftView.snp.right).offset(6)
            make.top.bottom.equalTo(leftView)
            make.width.equalTo(340)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.top.right.equalTo(rightView.backView)
            make.width.height.equalTo(24)
        }
        
        directionLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(42)
        }
        
        rightBottomView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
            make.height.equalTo(72)
        }
        
        priceView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(rightBottomView)
            make.height.equalTo(rightBottomView).multipliedBy(0.33)
        }
        
        feesView.snp.makeConstraints { make in
            make.left.right.height.equalTo(priceView)
            make.top.equalTo(priceView.snp.bottom)
        }
        
        slippageView.snp.makeConstraints { make in
            make.left.right.height.equalTo(priceView)
            make.top.equalTo(feesView.snp.bottom)
        }
    }
}

extension CS_SwapWelfareController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

