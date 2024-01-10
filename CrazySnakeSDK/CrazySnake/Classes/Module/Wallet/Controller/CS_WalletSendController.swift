//
//  CS_WalletSendController.swift
//  Platform
//
//  Created by Lee on 29/04/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit
import SwiftyAttributes

class CS_WalletSendController: CS_WalletBaseController {

    var accountInfo = CS_AccountManager.shared.accountInfo
    var token: TokenName = .Snake
    var tokenModel = CS_AccountManager.shared.coinTokenList.first(where: {$0.token == .Snake})
    var gasPrice: CS_EstimateGasPriceModel? {
        didSet {
            gasLabel.text = "Gas fee:\(gasPrice?.gas ?? "--") \(TokenName.GasCoin.rawValue)"
        }
    }
    
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tokenModel = CS_AccountManager.shared.coinTokenList.first(where: {$0.token == token})
        setupView()
        requestGasPrice()
    }
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = token.icon()
        return view
    }()
    
    lazy var tokenNameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#EEEEEE"), .ls_boldFont(14))
        label.text = token.name()
        return label
    }()
    
    lazy var chainLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_font(12))
        label.textAlignment = .left
        label.attributedText = "Network ".withFont(.ls_font(10)).withTextColor(.ls_color("#999999")) + Config.chain.name.attributedString
        return label
    }()
    
    lazy var receveAddress: UILabel = {
        let lab = UILabel()
        lab.text = "crazy_str_receiving_wallet_address".ls_localized
        lab.textColor = .ls_white()
        lab.textAlignment = .center
        lab.font = .ls_boldFont(16)
        return lab
    }()
    
    lazy var addressInput: CS_WalletFieldInputView = {
        let view = CS_WalletFieldInputView()
        view.textField.placeholder = "crazy_str_input_receiving_wallet_address".ls_localized
        view.actionButton.isHidden = true
        view.textField.addTarget(self, action: #selector(addressInputDidchange), for: .editingChanged)
        view.updateAddressInput()
        return view
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "crazy_str_balance".ls_localized
        label.textColor = .ls_white()
        label.font = .ls_boldFont(16)
        return label
    }()
    
    lazy var amountTitle: UILabel = {
        let label = UILabel()
        label.textColor = .ls_white()
        label.font = .ls_font(12)
        label.textAlignment = .right
        label.text = "\(tokenModel?.balance ?? "--")"
        return label
    }()
    
    lazy var amountNameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#999999"), .ls_font(10))
        label.text = token.name()
        label.textAlignment = .right
        return label
    }()
    
    lazy var amountView: CS_WalletFieldInputView = {
        let view = CS_WalletFieldInputView()
        view.textField.placeholder = "0"
        view.textField.delegate = self
        view.textField.keyboardType = .decimalPad
        view.clickRightButtonAction = {
            self.clickAllAction()
        }
        view.textField.addTarget(self, action: #selector(amountInputDidchange), for: .editingChanged)
        return view
    }()
    
    lazy var gasLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .ls_color("#999999")
        lab.font = .ls_font(12)
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 310, height: 50))
        button.setTitle("crazy_str_confirm_and_send".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickNext), for: .touchUpInside)
        return button
    }()

}

extension CS_WalletSendController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == amountView.textField {
            return Utils.digitalTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
        }
        return true
    }
    
    @objc func addressInputDidchange(){
        
    }
    
    @objc func amountInputDidchange(){
        
    }
    
    @objc fileprivate func clickAllAction() {
        amountView.textField.text = tokenModel?.balance
    }
}

//MARK: action
extension CS_WalletSendController {
    
    @objc private func clickNext(){
        if isLoading == true {
            return
        }
        
        guard let toAddress = addressInput.textField.text?.ls_trimmed, toAddress.count > 0 else {
            LSHUD.showError("crazy_str_input_receiving_wallet_address".ls_localized)
            return
        }
        
        guard Utils.isEthAddress(toAddress) == true else {
            LSHUD.showError("crazy_str_input_receiving_wallet_address".ls_localized)
            return
        }
        
        guard let amount = amountView.textField.text,(Double(amount) ?? 0) > 0 else {
            LSHUD.showError("crazy_str_amount_hint".ls_localized)
            return
        }
        
        guard let mainToken = tokenModel else {
            LSHUD.showError("crazy_str_balance_not_enough".ls_localized)
            return
        }
        
        let tokenAmount = Double(mainToken.balance) ?? 0

        if (Double(amount) ?? 0) > tokenAmount {
            LSHUD.showError("crazy_str_balance_not_enough".ls_localized)
            return
        }
        
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        
        self.view.endEditing(true)
        isLoading = true
        LSHUD.showLoading()
        
        var funcHash = CS_ContractTransfer.encodeDataTransferTokenSnake(to: toAddress, amount: amount)
        if token == .USDT {
            funcHash = CS_ContractTransfer.encodeDataTransferTokenUSDT(to: toAddress, amount: amount)
        }
        let para = CS_ContractTransfer.getEstimateTokenTransferPara(to: toAddress, amount: amount)
        weak var weakSelf = self
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            weakSelf?.isLoading = false
            if resp.status == .success {
                weakSelf?.gasPrice = resp.data
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "crazy_str_transfer".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    LSHUD.showLoading()
                    weakSelf?.isLoading = true
                    if weakSelf?.token == .USDT {
                        weakSelf?.transferUSDT(toAddress: toAddress, amount: amount, funcHash: funcHash ?? "")
                    } else {
                        weakSelf?.transferSnake(toAddress: toAddress, amount: amount,funcHash: funcHash ?? "")
                    }
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func transferSnake(toAddress: String, amount: String,funcHash: String){
        
        weak var weakSelf = self
        CS_ContractTransfer.transferSnakeToken(to: toAddress, amount: amount, funcHash: funcHash) { resp in
            weakSelf?.handleTransferResult(resp: resp)
        }
    }
    
    func transferUSDT(toAddress: String, amount: String, funcHash: String){
        
        weak var weakSelf = self
        CS_ContractTransfer.transferUSDTToken(to: toAddress, amount: amount, funcHash: funcHash) { resp in
            weakSelf?.handleTransferResult(resp: resp)
        }
    }
    
    func handleTransferResult(resp: CSResultRespon){
        LSHUD.hide()
        isLoading = false
        if resp.code == 0 {
            LSHUD.showSuccess("ok")
//            LSHUD.showSuccess(resp.message)
            popTo(CS_WalletController.self)
        } else {
            LSHUD.showError(resp.message)
        }
    }
}


//MARK: request
extension CS_WalletSendController {
    func requestGasPrice() {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        let para = CS_ContractTransfer.getEstimateTokenTransferPara(to: address, amount: "10")
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            if resp.status == .success {
                weakSelf?.gasPrice = resp.data
            }
        }
    }
}

extension CS_WalletSendController {
    
    private func initDefaultData() {
       
    }
 
    private func setupView() {
//        titleImage = UIImage(named: "title_send")
        navigationView.backView.backgroundColor = .ls_color("#171718")
        navigationView.titleLabel.text = "crazy_str_my_wallet".ls_localized

        view.addSubview(tokenIcon)
        view.addSubview(tokenNameLabel)
        view.addSubview(chainLabel)
        view.addSubview(receveAddress)
        view.addSubview(addressInput)
        view.addSubview(balanceLabel)
        view.addSubview(amountTitle)
        view.addSubview(amountNameLabel)
        view.addSubview(amountView)
        view.addSubview(gasLabel)
        view.addSubview(nextBtn)
        
        tokenIcon.snp.makeConstraints { make in
            make.right.equalTo(view.snp.centerX).offset(12)
            make.top.equalTo(navigationView.snp.bottom).offset(0)
            make.width.equalTo(31)
            make.height.equalTo(31)
        }
        
        tokenNameLabel.snp.makeConstraints { make in
            make.left.equalTo(tokenIcon.snp.right).offset(10)
            make.top.equalTo(tokenIcon).offset(-2)
        }
        
        chainLabel.snp.makeConstraints { make in
            make.left.equalTo(tokenNameLabel)
            make.bottom.equalTo(tokenIcon).offset(4)
        }
        
        receveAddress.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(tokenIcon.snp.bottom).offset(23)
        }
        
        addressInput.snp.makeConstraints { make in
            make.centerX.equalTo(receveAddress)
            make.top.equalTo(receveAddress.snp.bottom).offset(10)
            make.width.equalTo(337)
            make.height.equalTo(58)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.centerX.equalTo(receveAddress)
            make.top.equalTo(addressInput.snp.bottom).offset(12)
        }
        
        amountTitle.snp.makeConstraints { make in
            make.right.equalTo(addressInput)
            make.centerY.equalTo(balanceLabel)
        }
        
        amountNameLabel.snp.makeConstraints { make in
            make.right.equalTo(amountTitle.snp.left).offset(-9)
            make.centerY.equalTo(balanceLabel)
        }
        
        amountView.snp.makeConstraints { make in
            make.left.right.equalTo(addressInput)
            make.top.equalTo(amountTitle.snp.bottom).offset(12)
            make.height.equalTo(50)
        }
        
        gasLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(amountView.snp.bottom).offset(9)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(310)
            make.bottom.equalTo(-14)
            make.height.equalTo(50)
        }
    }
}
