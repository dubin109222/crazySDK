//
//  CS_NFTNFTDetailController.swift
//  CrazySnake
//
//  Created by Lee on 12/03/2023.
//

import UIKit
import SwiftyAttributes

class CS_NFTNFTDetailController: CS_BaseAlertController {

    var isMock = false
    var model: CS_NFTDataModel?
    var sendSuccess: CS_NoParasBlock?
    var transferOutSuccess: CS_NoParasBlock?
    var loadDetailSuccess: CS_NoParasBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setData()
        requedtDetail()
    }
    
    func setData() {
        guard let model = model else { return }
        iconView.image = model.quality.icon()
        qualityLabel.textColor = model.quality.color()
        qualityLabel.text = model.quality.name()
        titleLabel.attributedText = "NFT  ".attributedString + "#\(model.token_id)".withFont(.ls_JostRomanFont(12))
        initPowerLabel.attributedText = "crazy_str_initial_hash_power".ls_localized.attributedString + "      ".attributedString + "\(model.power_origin)".withFont(.ls_JostRomanFont(16)).withTextColor(.ls_white())
        let url = URL.init(string: model.image)
        imageView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        statusButton.setTitle(model.status.dispalyName(), for: .normal)
        statusButton.isHidden = model.status == .freedom
        
//        sendButton.isHidden = model.status != .freedom
        
        listNftButton.isHidden = model.status != .freedom
        tipsLabel.isHidden = model.status != .freedom
        
        if model.status == .freedom {
            contentView.snp.remakeConstraints { make in
                make.left.equalTo(45)
                make.right.equalTo(-CS_ms(18))
                make.top.equalTo(44)
                make.height.equalTo(253)
            }
        } else {
            contentView.snp.remakeConstraints { make in
                make.left.equalTo(45)
                make.right.equalTo(-CS_ms(18))
                make.centerY.equalToSuperview()
                make.height.equalTo(253)
            }
        }
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var qualityLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()

    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.lineBreakMode = .byTruncatingMiddle
        label.text = CS_AccountManager.shared.accountInfo?.wallet_address
        return label
    }()
    
    lazy var initPowerLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#EEEEEE"), .ls_font(11))
        label.textAlignment = .center
        label.backgroundColor = .ls_color("#322E3D",alpha: 0.6)
        label.ls_cornerRadius(3)
        label.ls_border(color: .ls_color("#7E56E1"))
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var statusButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 124, height: 28))
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_color("#FFFCD6"), for: .normal)
        button.setBackgroundImage(UIImage.ls_bundle("nft_bg_selected_nft@2x"), for: .normal)
//        button.ls_addColorLayer(begin: .ls_color("#231531",alpha: 0), middle: .ls_color("#231531",alpha: 0.98), end: .ls_color("#231531",alpha: 0),cornerRadius: 2)
        return button
    }()
    
    lazy var infoBackView: CS_NFTDetailInfoView = {
        let view = CS_NFTDetailInfoView()
        view.backgroundColor = .ls_color("#252033")
        view.ls_cornerRadius(15)
        view.setData(model)
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickSendButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("nft_icon_send@2x"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var listNftButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 139, height: 43))
        button.addTarget(self, action: #selector(clickListNftButton(_:)), for: .touchUpInside)
        button.setBackgroundImage(UIImage.ls_bundle("nft_icon_bg_list_nft@2x"), for: .normal)
        button.setTitle("crazy_str_list_nft".ls_localized, for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(10))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = "crazy_str_after_listing_your_nft".ls_localized_color([])
        label.isHidden = true
        return label
    }()
    
    var guideNextHandle: (() -> ())? = nil
}

//MARK: request
extension CS_NFTNFTDetailController {
    func requedtDetail(){
        guard let model = model else { return }
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["token_id"] = model.token_id
        CSNetworkManager.shared.getNFTDetail(para) { resp in
            if resp.status == .success {
                weakSelf?.loadDetailSuccess?()
            }
        }
        guideStepOne()
    }
}

extension CS_NFTNFTDetailController {
    func guideStepOne() {
        if isMock {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let cell = self.listNftButton
                let maskRect = cell.convert(cell.bounds, to: nil)
                
                GuideMaskView.show (tipsText: "NFT uploaded to the chain.",
                                    currentStep: "2",
                                    totalStep: "3",
                                    maskRect: maskRect,
                                    textWidthDefault: 223,
                                    direction: .down){
                    weakSelf?.guideStepTwo()
                    
                } skipHandle: {
                    weakSelf?.guideStepEnd()
                }
            }
        }
    }
    
    func guideStepTwo() {
    
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.nft.first?.contract_address else {
            return
        }
        guard let tokenId = Int(model?.token_id ?? "") else { return }
        let para = CS_ContractNFT.withdrawPara(token: contract, ids: [tokenId])
        
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "Transfer".ls_localized
                vc.showGwei = false
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.present(vc, animated: false)
                weakSelf?.guideStepThree(vc)
                
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func guideStepThree(_ maskView: CS_EstimateGasAlertController) {
        weak var weakSelf = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let cell = maskView.contentView
            let maskRect = cell.convert(cell.bounds, to: nil)
            
            GuideMaskView.show (tipsText: "Gas Coin needs to be consumed, click on Confirm to complete.",
                                currentStep: "3",
                                totalStep: "3",
                                maskRect: maskRect,
                                textWidthDefault: 223,
                                direction: .left){
                maskView.dismiss(animated: false)
                weakSelf?.guideStepEnd()
                
            } skipHandle: {
                maskView.dismiss(animated: false)
                weakSelf?.guideStepEnd()
            }
        }

    }
    
    func guideStepEnd() {
        self.dismiss(animated: true)
        self.guideNextHandle?()
    }
}


//MARK: action
extension CS_NFTNFTDetailController {
    @objc private func clickSendButton(_ sender: UIButton) {
        let vc = CS_NFTSendNFTController()
        vc.model = model
        present(vc, animated: false)
        weak var weakSelf = self
        vc.sendSuccess = {
            weakSelf?.dismiss(animated: false)
            weakSelf?.sendSuccess?()
        }
    }
    
    @objc private func clickListNftButton(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.nft_transfer.first?.contract_address else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        
        LSHUD.showLoading()
        weak var weakSelf = self
        CS_ContractApprove.nftIsApproved(to: contract, response: { isApproved in
            LSHUD.hide()
            if isApproved {
                weakSelf?.estimateGas()
            } else {
                weakSelf?.approveEstimateGas(address, contract: contract)
            }
        })
    }
}

//MARK: contract
extension CS_NFTNFTDetailController {
    func approveEstimateGas(_ address: String, contract: String){
        let para = CS_ContractNFT.estimateApprovePara(to: contract)
        
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "Approve".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.approve(address, contract: contract)
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func approve(_ address: String, contract: String){
//        let para = CS_ContractNFT.approvePara(to: contract)
//        weak var weakSelf = self
//        CSNetworkManager.shared.postFreeGasByName(para) { resp in
//            LSHUD.hide()
//            if resp.status == .success {
//                weakSelf?.estimateGas()
//            } else {
//                LSHUD.showError(resp.message)
//            }
//        }
//        return
        weak var weakSelf = self
        let funcHash = CS_ContractApprove.encodeDataNFTApprove(to: contract) ?? ""
        LSHUD.showLoading()
        CS_ContractApprove.approveNFT(to: contract, funcHash: funcHash, response: { resp in
            LSHUD.hide()
            if resp.code == 0 {
                weakSelf?.estimateGas()
            } else {
                LSHUD.showError(resp.message)
            }
        })
    }
    
    func estimateGas(){
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.nft.first?.contract_address else {
            return
        }
        guard let tokenId = Int(model?.token_id ?? "") else { return }
        let para = CS_ContractNFT.withdrawPara(token: contract, ids: [tokenId])
        
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
                    weakSelf?.transferOut()
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func transferOut(){
        guard let tokenId = Int(model?.token_id ?? "") else { return }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["token_ids"] = "\(tokenId)"
        para["contract_name"] = model?.contract_name ?? ""
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.nftTransferOut(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                LSHUD.showInfo(resp.message)
                weakSelf?.transferOutSuccess?()
                weakSelf?.dismiss(animated: false)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}



//MARK: UI
extension CS_NFTNFTDetailController {
    
    private func setupView() {
        titleLabel.textColor = .ls_white()
        contentView.addSubview(iconView)
        contentView.addSubview(qualityLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(initPowerLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(statusButton)
        contentView.addSubview(infoBackView)
        view.addSubview(sendButton)
        view.addSubview(listNftButton)
        view.addSubview(tipsLabel)
        
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(10)
            make.width.equalTo(44)
            make.height.equalTo(40)
        }
        
        qualityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.bottom.equalTo(iconView.snp.bottom).offset(4)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(contentView).offset(80)
            make.top.equalTo(iconView)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        
        initPowerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.right.equalTo(-80)
            make.width.equalTo(143)
            make.height.equalTo(26)
        }
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.width.equalTo(167)
            make.height.equalTo(176)
        }
        
        statusButton.snp.makeConstraints { make in
            make.center.equalTo(imageView)
            make.width.equalTo(94)
            make.height.equalTo(28)
        }
        
        infoBackView.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.top.equalTo(imageView)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(169)
        }
        
        listNftButton.snp.makeConstraints { make in
//            make.left.equalTo(contentView.snp.centerX)
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.bottom).offset(6)
            make.width.equalTo(139)
            make.height.equalTo(43)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.height.equalTo(listNftButton)
            make.width.equalTo(59)
            make.right.equalTo(listNftButton.snp.left).offset(-10)
        }
        
        tipsLabel.snp.makeConstraints { make in
//            make.left.right.equalTo(contentView)
            make.left.right.equalToSuperview()
            make.top.equalTo(listNftButton.snp.bottom).offset(2)
        }
    }
}
