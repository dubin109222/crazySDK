//
//  CS_SwapCoinController.swift
//  CrazySnake
//
//  Created by Lee on 16/03/2023.
//

import UIKit
import JXSegmentedView

class CS_SwapCoinController: CS_BaseController {

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        requestRatio()
    }

    lazy var leftAmountView: CS_SwapCoinAmountView = {
        let view = CS_SwapCoinAmountView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(10)
        weak var weakSelf = self
        view.changeTypeAction = {
            weakSelf?.showChangeAlert(true)
        }
        view.inputChange = { text in
            weakSelf?.rightAmountView.otherAmountChange(text)
        }
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("swap_icon_to@2x")
        return view
    }()
    
    lazy var rightAmountView: CS_SwapCoinAmountView = {
        let view = CS_SwapCoinAmountView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(10)
        view.setToken(.USDT)
        view.titleLabel.text = "crazy_str_get".ls_localized
        view.sourceLabel.text = "crazy_str_to".ls_localized
        weak var weakSelf = self
        view.changeTypeAction = {
            weakSelf?.showChangeAlert(false)
        }
        view.inputChange = { text in
            weakSelf?.leftAmountView.otherAmountChange(text)
        }
        return view
    }()
    
    func showChangeAlert(_ isLeft: Bool) {
//        let alert = CS_SwapSelectTokenAlert()
//        alert.show(isLeft: isLeft)
//        weak var weakSelf = self
//        alert.selecedToken = { token in
//            weakSelf?.tokenChange(token, isLeft: isLeft)
//        }
    }
    
    func tokenChange(_ token: TokenName, isLeft: Bool) {
        if isLeft {
            let radio = leftAmountView.ratio
            if token == rightAmountView.token {
                leftAmountView.ratio = rightAmountView.ratio
                rightAmountView.ratio = radio
                rightAmountView.setToken(leftAmountView.token)
            }
            leftAmountView.setToken(token)
        } else {
            let radio = leftAmountView.ratio
            if token == leftAmountView.token {
                leftAmountView.ratio = rightAmountView.ratio
                rightAmountView.ratio = radio
                leftAmountView.setToken(rightAmountView.token)
            }
            rightAmountView.setToken(token)
        }
        rightAmountView.otherAmountChange(leftAmountView.amountInputView.textField.text)
        requestRatio()
    }
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var priceView: CS_SwapCoinContentItemView = {
        let view = CS_SwapCoinContentItemView()
        view.titleLabel.text = "crazy_str_price".ls_localized
        view.contentLabel.text = "--"
        return view
    }()
    
    lazy var conversionView: CS_SwapCoinContentItemView = {
        let view = CS_SwapCoinContentItemView()
        view.titleLabel.text = "crazy_str_conversion".ls_localized
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
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickRefreshButton(_:)), for: .touchUpInside)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_refresh_price".ls_localized, for: .normal)
        button.ls_cornerRadius(7)
        button.borderColor = .ls_white()
        button.borderWidth = 1
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 180, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_confirm_swap".ls_localized, for: .normal)
        return button
    }()
}

//MARK: action
extension CS_SwapCoinController {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        view.endEditing(true)
        guard let amount = leftAmountView.amountInputView.textField.text, Double(amount) ?? 0 > 0 else {
            return
        }
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper?.contract_address else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        let token = leftAmountView.token
        var swapType = CS_SwapType.SnakeToUSDT
        if token == .USDT {
            swapType = .USDTToSnake
            
            let balance = TokenName.USDT.balance()
            guard Double(balance) ?? 0 >= Double(amount) ?? 0 else {
                LSHUD.showError("Insufficient balance".ls_localized)
                return
            }
            
            guard Double(amount) ?? 0 >= 1 else {
                LSHUD.showError("USDT need more than 1U".ls_localized)
                return
            }
            
        } else {
            let balance = TokenName.Snake.balance()
            guard Double(balance) ?? 0 >= Double(amount) ?? 0 else {
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
    
    func approveEstimateGas(_ address: String, contract: String, swapType: CS_SwapType){
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
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.approve(address, contract: contract, swapType: swapType, funcHash: encodeData)
                }
            } else if resp.status != .gas_limit {
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
        let amount = leftAmountView.amountInputView.textField.text ?? "0"
        let amountOut = "\((Double(rightAmountView.amountInputView.textField.text ?? "0") ?? 0) * 0.95)"
        let encodeData = CS_ContractSwap.shared.encodeDataSwapToken(swapType: swapType, amount: amount, amountOutMin: amountOut) ?? ""
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
                    if swapType == .SnakeToUSDT {
                        weakSelf?.swapTokenToUSDT(address, contract: contract)
                    } else {
                        weakSelf?.swap(address, contract: contract,gasPrice: resp.data?.gas, swapType: swapType, funcHash: encodeData)
                    }
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func swap(_ address: String, contract: String,gasPrice: String?,swapType: CS_SwapType, funcHash: String){
        LSHUD.showLoading()
        let amount = leftAmountView.amountInputView.textField.text ?? "0"
        var amountOut = "\((Double(rightAmountView.amountInputView.textField.text ?? "0") ?? 0) * 0.95)"
        amountOut = Utils.formatAmount(amountOut)
        CS_ContractSwap.shared.swapToken(gasPrice:gasPrice,swapType: swapType, amount: amount, amountOutMin: amountOut, funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
                LSHUD.showInfo(resp.message)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func swapTokenToUSDT(_ address: String, contract: String){
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        let amount = leftAmountView.amountInputView.textField.text ?? "0"
        var amountOut = "\((Double(rightAmountView.amountInputView.textField.text ?? "0") ?? 0) * 0.95)"
        amountOut = Utils.formatAmount(amountOut)
        let amountInWei = EthUnitUtils.getWei(amount: "\(amount)", token: .Snake)
        let amountOutWei = EthUnitUtils.getWei(amount: amountOut, token: .USDT)
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["contract_name"] = "SnakeToken"
        para["amount_in"] = amountInWei
        para["amount_out"] = amountOutWei
        para["pool_fee"] = "3000"
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.swapTokenToUSDT(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                LSHUD.showInfo(resp.message)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    @objc private func clickRefreshButton(_ sender: UIButton) {
        LSHUD.showLoading()
        requestRatio()
    }
}

//MARK: request
extension CS_SwapCoinController {
    func requestRatio() {
        
//        let from = leftAmountView.token.rawValue
//        let to = rightAmountView.token.rawValue
//        if leftAmountView.token == .Snake {
//            priceView.contentLabel.text = "1 \(from) = \("0.002633") \(to)"
//            conversionView.contentLabel.text = "1 \(to) = \("363.160162") \(from)"
//        } else {
//            priceView.contentLabel.text = "1 \(from) = \("363.160162") \(to)"
//            conversionView.contentLabel.text = "1 \(to) = \("0.002633") \(from)"
//        }
        
        requestPrice()
        requestConversion()
    }
    
    func requestPrice() {
        
        weak var weakSelf = self
        var para :[String:Any] = [:]
        let from = leftAmountView.token.rawValue
        let to = rightAmountView.token.rawValue
        let tokenTo = rightAmountView.token
        para["from"] = from
        para["to"] = to
        para["amount"] = EthUnitUtils.getWei(amount: "1", token: leftAmountView.token)
        CSNetworkManager.shared.getSwapRatio(para) { resp in
            if resp.status == .success,let model = resp.data {
                let ratio = EthUnitUtils.getAmount(wei: model.ratio, token: tokenTo)
                weakSelf?.rightAmountView.ratio = ratio ?? "0"
                weakSelf?.priceView.contentLabel.text = "1 \(from) = \(Utils.formatAmount(ratio)) \(to)"
            }
        }
    }
    
    func requestConversion() {
        
        weak var weakSelf = self
        var para :[String:Any] = [:]
        let from = rightAmountView.token.rawValue
        let to = leftAmountView.token.rawValue
        let tokenTo = leftAmountView.token
        para["from"] = from
        para["to"] = to
        para["amount"] = EthUnitUtils.getWei(amount: "1", token: rightAmountView.token)
        CSNetworkManager.shared.getSwapRatio(para) { resp in
            LSHUD.hide()
            if resp.status == .success,let model = resp.data {
                let ratio = EthUnitUtils.getAmount(wei: model.ratio, token: tokenTo)
                weakSelf?.leftAmountView.ratio = ratio ?? "0"
                weakSelf?.conversionView.contentLabel.text = "1 \(from) = \(Utils.formatAmount(ratio)) \(to)"
            }
        }
    }
}


//MARK: UI
extension CS_SwapCoinController {
    func setupView(){
        navigationView.isHidden = true
        backView.image = UIImage.ls_bundleImageJpg(named: "bg_image_no_title")
        
        view.addSubview(leftAmountView)
        view.addSubview(rightAmountView)
        view.addSubview(iconView)
        view.addSubview(contentView)
        contentView.addSubview(priceView)
        contentView.addSubview(conversionView)
        contentView.addSubview(slippageView)
        contentView.addSubview(feesView)
        contentView.addSubview(refreshButton)
        contentView.addSubview(confirmButton)
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(56)
            make.width.height.equalTo(44)
        }
        
        leftAmountView.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.right.equalTo(iconView.snp.left).offset(-20)
            make.width.equalTo(265)
            make.height.equalTo(117)
        }
        
        rightAmountView.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(20)
            make.width.equalTo(265)
            make.height.equalTo(117)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.equalTo(leftAmountView)
            make.right.equalTo(rightAmountView)
            make.top.equalTo(leftAmountView.snp.bottom).offset(10)
            make.height.equalTo(138)
        }
        
        priceView.snp.makeConstraints { make in
            make.width.equalTo(contentView).multipliedBy(0.45)
            make.centerX.equalTo(contentView).multipliedBy(0.5)
            make.top.equalTo(contentView).offset(18)
            make.height.equalTo(16)
        }
        
        conversionView.snp.makeConstraints { make in
            make.centerX.width.height.equalTo(priceView)
            make.top.equalTo(contentView).offset(50)
        }
        
        slippageView.snp.makeConstraints { make in
            make.width.height.centerY.equalTo(priceView)
            make.centerX.equalTo(contentView).multipliedBy(1.5)
        }
        
        feesView.snp.makeConstraints { make in
            make.width.height.centerY.equalTo(conversionView)
            make.centerX.equalTo(slippageView)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.centerX).offset(-15)
            make.bottom.equalTo(-13)
            make.width.equalTo(121)
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(15)
            make.centerY.equalTo(refreshButton)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
    }
}

extension CS_SwapCoinController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

