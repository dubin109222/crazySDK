//
//  CS_StakeTokenController.swift
//  CrazySnake
//
//  Created by Lee on 17/03/2023.
//

import UIKit
import JXSegmentedView
import SwiftyAttributes

class CS_StakeTokenController: CS_BaseController {

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var contractAddress = CS_AccountManager.shared.basicConfig?.contract?.token_stake?.contract_address
    private var dataModel: CS_StakeTimeDataModel?
    private var stakeAmount: Double = 0
    private var selectedTime: CS_StakeTimeModel?
    
    var isMock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        requestTimeList()

        GuideMaskManager.checkGuideState(.stake_token) { isFinish in
            self.isMock = !isFinish
            
            if self.isMock {
                self.guideStepOne()
            }
        }

        
        

    }
    
    lazy var amountContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(10)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(19))
        label.text = "crazy_str_input_staking_amount".ls_localized
        return label
    }()
    
    lazy var amountInputView: CS_StakeAmountInputView = {
        let view = CS_StakeAmountInputView()
        view.backgroundColor = .ls_color("#2C2A32")
        view.ls_cornerRadius(10)
        weak var weakSelf = self
        view.inputContentChange = { text in
            weakSelf?.stakeAmount = Double(text ?? "0") ?? 0
            weakSelf?.updateCytAmount()
        }
        return view
    }()
    
    lazy var timeSelectView: CS_StakeSelectTimeView = {
        let view = CS_StakeSelectTimeView()
        weak var weakSelf = self
        view.selectTimeChange = { model in
            weakSelf?.selectedTime = model
            weakSelf?.updateCytAmount()
        }
        return view
    }()
    
    lazy var infoContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(10)
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 180, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_confirm_and_stake".ls_localized, for: .normal)
        return button
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = TokenName.Snake.icon()
        return view
    }()
    
    lazy var aprLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        label.text = "APR:--"
        return label
    }()
    
    lazy var cyttitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.text = "crazy_str_cyt_quantity".ls_localized
        return label
    }()
    
    lazy var tipsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickTipsButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("icon_nav_tips@2x"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var cytAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#CDA4FF"), .ls_JostRomanFont(16))
        label.text = "--"
        return label
    }()
}

extension CS_StakeTokenController {
    func guideStepOne() {
        if self.isMock {
            DispatchQueue.main.async {
                let maskRect = self.amountInputView.convert(self.amountInputView.bounds, to: nil)

                GuideMaskView.show (tipsText: "Enter the number of TOKEN to be stake.",
                                    currentStep: "1",
                                    totalStep: "3",
                                    maskRect: maskRect,
                                    textWidthDefault: 223,
                                    direction: .up){
                    self.guideStepTwo()
                    
                } skipHandle: {
                    self.guideStepEnd()
                }
            }
        }
    }
    
    func guideStepTwo() {
        let maskRect = self.timeSelectView.convert(self.timeSelectView.bounds, to: nil)

        GuideMaskView.show (tipsText: "Select the time of stake.",
                            currentStep: "2",
                            totalStep: "3",
                            maskRect: maskRect,
                            textWidthDefault: 223,
                            direction: .down){
            self.guideStepThree()
            
        } skipHandle: {
            self.guideStepEnd()
        }
    }
    
    func guideStepThree() {
        let maskRect = self.confirmButton.convert(self.confirmButton.bounds, to: nil)

        GuideMaskView.show (tipsText: "Click the button to confrim and stake.",
                            currentStep: "3",
                            totalStep: "3",
                            maskRect: maskRect,
                            textWidthDefault: 223,
                            direction: .down){
            self.guideStepEnd()
        } skipHandle: {
            self.guideStepEnd()
        }
    }
    
    func guideStepEnd() {
        self.isMock = false
        GuideMaskManager.saveGuideState(.stake_token)
    }
}


//MARK: fuction
extension CS_StakeTokenController {
    func updateCytAmount() {
        guard let model = selectedTime else { return }
        let cytNum = String(format: "%.6f", stakeAmount*model.cytAmount())
        cytAmountLabel.text = "\(cytNum)"
        let apr = String(format: "%.2f%%", (Double(model.apr_token) ?? 0)*100)
        aprLabel.attributedText = "APR: ".attributedString + "\(apr)".withTextColor(.ls_color("#10D499"))
    }
}

//MARK: action
extension CS_StakeTokenController {
    
    @objc private func clickTipsButton(_ sender: UIButton) {
        CS_HelpCenterAlert.showStakeCytTips()
    }
    
    @objc private func clickConfirmButton(_ sender: UIButton) {
                
        let balance = TokenName.Snake.balance()
        guard Double(balance) ?? 0 >= Double(stakeAmount) else {
            LSHUD.showError("Insufficient balance".ls_localized)
            return
        }
        
        guard stakeAmount >= 1 else {
            LSHUD.showError("Minimum of 1 snake to continue the operation".ls_localized)
            return
        }
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.token_stake?.contract_address else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        LSHUD.showLoading()
        CS_ContractApprove.snakeTokenIsApproved(to: contract) { isApproved in
            if isApproved {
                weakSelf?.estimateGasStake(address, contract: contract)
            } else {
                weakSelf?.estimateGasApprove(address,contract: contract)
            }
        }
    }
    
    func estimateGasApprove(_ address: String, contract: String){
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
            if resp.code == 0 {
                weakSelf?.estimateGasStake(address, contract: contract)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func estimateGasStake(_ address: String, contract: String){
        
        let encodeData = CS_ContractTokenStake.shared.encodeDataStake(amount: "\(stakeAmount)", period: selectedTime?.duration ?? 0)
        let para = CS_ContractTokenStake.estimateGasStakeToken(amount: "\(stakeAmount)",duraion: selectedTime?.duration ?? 0)
        weak var weakSelf = self
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "crazy_str_staking".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.stakeToken(contract: contract,funcHash: encodeData ?? "")
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func stakeToken(contract: String, funcHash: String){
        LSHUD.showLoading()
        CS_ContractTokenStake.shared.tokenStake(amount: "\(stakeAmount)", period: selectedTime?.duration ?? 0,funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
                LSHUD.showSuccess("ok")
//                LSHUD.showSuccess(resp.message)
                CS_AccountManager.shared.loadTokenBlance()
            } else {
                LSHUD.showInfo(resp.message)
            }
        }
    }

}

//MARK: request
extension CS_StakeTokenController {
    
    func requestTimeList() {
        guard let address = walletAddress else { return }
        guard let token = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address else { return }
        weak var weakSelf = self
        CSNetworkManager.shared.getStakeTimeList(address, token: token) { resp in
            
            if resp.status == .success {
                weakSelf?.dataModel = resp.data
                if let list = resp.data?.detail {
                    weakSelf?.timeSelectView.updateSource(list)
                }
            }
        }
    }
    
    func tokenStake(){
        
    }
}


//MARK: UI
extension CS_StakeTokenController {
    func setupView(){
        navigationView.isHidden = true
        backView.image = UIImage.ls_bundleImageJpg(named: "bg_image_no_title")
        
        view.addSubview(amountContentView)
        amountContentView.addSubview(titleLabel)
        amountContentView.addSubview(amountInputView)
        amountContentView.addSubview(timeSelectView)
        view.addSubview(infoContentView)
        infoContentView.addSubview(iconView)
        infoContentView.addSubview(aprLabel)
        infoContentView.addSubview(cyttitleLabel)
        infoContentView.addSubview(tipsButton)
        infoContentView.addSubview(cytAmountLabel)
        infoContentView.addSubview(confirmButton)
        
        infoContentView.snp.makeConstraints { make in
            make.right.equalTo(-CS_ms(45))
            make.top.equalTo(14)
            make.bottom.equalTo(-22)
            make.width.equalTo(200)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(infoContentView)
            make.top.equalTo(16)
            make.width.height.equalTo(52)
        }
        
        aprLabel.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.top.equalTo(98)
        }
        
        cyttitleLabel.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.top.equalTo(138)
        }
        
        tipsButton.snp.makeConstraints { make in
            make.centerY.equalTo(cyttitleLabel)
            make.right.equalTo(-12)
        }
        
        cytAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(cyttitleLabel)
            make.top.equalTo(cyttitleLabel.snp.bottom).offset(6)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(infoContentView)
            make.bottom.equalTo(infoContentView).offset(-12)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
        amountContentView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(45))
            make.right.equalTo(infoContentView.snp.left).offset(-10)
            make.top.bottom.equalTo(infoContentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(amountContentView).offset(22)
            make.top.equalTo(12)
        }
        
        amountInputView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(-28)
            make.top.equalTo(44)
            make.height.equalTo(30)
        }
        
        timeSelectView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(-16)
            make.top.equalTo(88)
            make.bottom.equalTo(0)
        }
    }
}

extension CS_StakeTokenController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}
