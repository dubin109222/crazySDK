//
//  CS_EventBuyController.swift
//  CrazySnake
//
//  Created by Lee on 06/04/2023.
//

import UIKit

class CS_EventBuyController: CS_BaseAlertController {
    
    var buySuccess: CS_NoParasBlock?
    var eventId = ""
    var model: CS_EventDetailModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setData()
    }
    
    func setData(){
        iconView.image = model.props_type.iconImage()
        titleLabel.text = model.props_type.disPlayName()
        textView.text = model.props_type.displayDesc()
        amountInputView.resetData(max: model.can_buy_num, current: 0)
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var amountInputView: CS_EventAmountInputView = {
        let view = CS_EventAmountInputView()
        return view
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.font = .ls_JostRomanFont(12)
        view.textColor = .ls_text_gray()
        view.isEditable = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 233, height: 34))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_buy".ls_localized, for: .normal)
        return button
    }()

}

//MARK: action
extension CS_EventBuyController {
    
    @objc private func clickConfirmButton(_ sender: UIButton) {
        guard amountInputView.currentNum > 0 else {
            return
        }
        
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper?.contract_address else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        CS_AccountManager.shared.verifyPassword {
            weakSelf?.swapEstimateGas(address, contract: contract)
        }
        
    }
    
    func swapEstimateGas(_ address: String, contract: String){
        let amount = "\(model.price)"
        guard let to = CS_AccountManager.shared.basicConfig?.contract?.cash_box?.contract_address else {
            return
        }
        let funcHash = CS_ContractTransfer.encodeDataTransferTokenSnake(to: to, amount: amount) ?? ""
        let para = CS_ContractTransfer.getEstimateTokenTransferPara(to: to, amount: amount)
        weak var weakSelf = self
        LSHUD.showLoading()
        
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "Transfer"
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
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
        weak var weakSelf = self
        LSHUD.showLoading()
        CS_ContractSwap.eventBuy(amount: amount,id: eventId,item_id: model.item_id, num: "\(amountInputView.currentNum)", funcHash: funcHash) { resp in
            LSHUD.hide()
            LSHUD.showInfo(resp.message)
            if resp.code == 0 {
                CS_AccountManager.shared.loadTokenBlance()
                weakSelf?.buySuccess?()
                weakSelf?.dismiss(animated: false)
            }
        }
    }
}

//MARK: UI
extension CS_EventBuyController {
    
    private func setupView() {
        
        contentView.addSubview(iconView)
        contentView.addSubview(amountInputView)
        contentView.addSubview(textView)
        contentView.addSubview(confirmButton)
        
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(403)
            make.height.equalTo(185)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.top.equalTo(32)
            make.width.equalTo(82)
            make.height.equalTo(73)
        }
        
        amountInputView.snp.makeConstraints { make in
            make.bottom.equalTo(-24)
            make.left.equalTo(14)
            make.height.equalTo(26)
            make.width.equalTo(112)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(145)
            make.top.equalTo(12)
            make.right.equalTo(-44)
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(-21)
            make.top.equalTo(46)
            make.height.equalTo(68)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(textView)
            make.bottom.equalTo(-20)
            make.width.equalTo(233)
            make.height.equalTo(34)
        }
    }
}
