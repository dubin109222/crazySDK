//
//  CS_MarketNFTDetailController.swift
//  CrazySnake
//
//  Created by Lee on 25/04/2023.
//

import UIKit
import SwiftyAttributes

class CS_MarketNFTDetailController: CS_BaseAlertController {

    var model: CS_MarketModel?
    var mockNextHandle : ((Bool) -> ())?
    /// 0: 自己-上架；1:自己-取消上架；2:他人-购买
    var actionStatus = 0
    
    let account = CS_AccountManager.shared.accountInfo
    
    var isMock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setData()
        guideOneStep()
    }
    
    func setData() {
        guard let model = model,let nft = model.nftDetail else { return }
        
        if model.isSelf() {
            if model.status == 1 {
                actionStatus = 1
                priceView.isHidden = false
                priceView.priceLabel.text = "\(model.price)"
                confirmButton.setBackgroundImage(nil, for: .normal)
                confirmButton.backgroundColor = .ls_color("#E16A56")
                confirmButton.setTitle("crazy_str_sell_remove_offer".ls_localized, for: .normal)
            } else {
                actionStatus = 0
                priceInputView.isHidden = false
            }
        } else {
            actionStatus = 2
            priceView.isHidden = false
            priceView.priceLabel.text = "\(model.price)"
            confirmButton.setTitle("crazy_str_buy".ls_localized, for: .normal)
        }
        
        iconView.image = nft.quality.icon()
        qualityLabel.textColor = nft.quality.color()
        qualityLabel.text = nft.quality.name()
        titleLabel.attributedText = "NFT  ".attributedString + "#\(nft.token_id)".withFont(.ls_JostRomanFont(12))
        initPowerLabel.attributedText = "crazy_str_initial_hash_power".ls_localized.attributedString + "      ".attributedString + "\(nft.power_origin)".withFont(.ls_JostRomanFont(16)).withTextColor(.ls_white())
        let url = URL.init(string: nft.image)
        imageView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        statusButton.setTitle(nft.status.dispalyName(), for: .normal)
        statusButton.isHidden = nft.status == .freedom
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
        return button
    }()
    
    lazy var infoBackView: CS_NFTDetailInfoView = {
        let view = CS_NFTDetailInfoView()
        view.backgroundColor = .ls_color("#252033")
        view.ls_cornerRadius(15)
        view.setData(model?.nftDetail)
        return view
    }()
    
    lazy var priceInputView: CS_MarketNFTPriceInputView = {
        let view = CS_MarketNFTPriceInputView()
        view.isHidden = true
        return view
    }()
    
    lazy var priceView: CS_MarketNFTPriceView = {
        let view = CS_MarketNFTPriceView()
        view.isHidden = true
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 233, height: 40))
        button.setTitle("crazy_str_place_offer".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        return button
    }()
    
    
}

extension CS_MarketNFTDetailController {
    func guideOneStep() {
        if isMock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
            {
                weak var weakSelf = self
                let cell = self.infoBackView
                let maskRect = cell.convert(cell.bounds, to: nil)
                GuideMaskView.show (tipsText: "View NFT details.",
                                    currentStep: "4",
                                    totalStep: "5",
                                    maskRect: maskRect,
                                    textWidthDefault: 223,
                                    direction: .down){
                    weakSelf?.mockNextHandle?(false)
                    weakSelf?.dismiss(animated: false)
                } skipHandle: {
                    weakSelf?.guideStepEnd()
                }
            }
        }
    }
    
    func guideStepEnd(_ isSkip : Bool = true) {
        self.mockNextHandle?(true)
        self.dismiss(animated: false)
    }
}

//MARK: action
extension CS_MarketNFTDetailController {
    
    @objc private func clickConfirmButton(_ sender: UIButton) {
        switch actionStatus {
        case 0:
            guard let price = priceInputView.inputField.text, Int(price) ?? 0 > 0 else {
                return
            }
            weak var weakSelf = self
            CS_AccountManager.shared.verifyPassword {
                weakSelf?.placeOffer()
            }
        case 1:
            removeOffer()
        case 2:
            requestBuyGasPrice()
        default:
            break
        }
    }
    
    func placeOffer(){
        guard let price = priceInputView.inputField.text, Int(price) ?? 0 > 0 else {
            return
        }
        guard let address = account?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: account?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["item_type"] = model?.item_type
        para["item_id"] = model?.item_id
        para["price"] = price
        para["amount"] = "1"
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.marketStartSell(para) { resp in
            LSHUD.hide()
            if resp.status == .success, resp.data?.success == 1 {
                NotificationCenter.default.post(name: NotificationName.CS_MarketPlaceOffer, object: weakSelf?.model)
                weakSelf?.dismiss(animated: false)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func removeOffer(){
        guard let address = account?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: account?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sku_id"] = model?.sku_id
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.marketStopSell(para) { resp in
            LSHUD.hide()
            if resp.status == .success, resp.data?.success == 1 {
                NotificationCenter.default.post(name: NotificationName.CS_MarketRemoveOffer, object: weakSelf?.model)
                weakSelf?.dismiss(animated: false)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func requestBuyGasPrice() {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        let para = CS_ContractTransfer.getEstimateMarketBuyPara(to: address, amount: "10",notSnake: true)
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "crazy_str_buy".ls_localized
                vc.gasPrice = resp.data
                vc.para = para
                vc.showGasCoinInsufficientAlert = false
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    CS_AccountManager.shared.accountInfo?.verifyPassword { password in
                        self.buy(password ?? "")
                    }
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func buy(_ pay_password: String){
        guard Double(CS_MarketManager.shared.diamondBalance) ?? 0 > Double(model?.price ?? "0") ?? 0 else {
            LSHUD.showError("Insufficient balance".ls_localized)
            return
        }
        
        // 预估弹窗
        
        guard let address = account?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: account?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sku_id"] = model?.sku_id
        para["num"] = "1"
        para["pay_password"] = pay_password
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.marketBuy(para) { resp in
            LSHUD.hide()
            if resp.status == .success  {
                if resp.data?.success == 1 {
                    NotificationCenter.default.post(name: NotificationName.CS_MarketBuyItem, object: weakSelf?.model)
                    weakSelf?.dismiss(animated: false)
                    
                    LSHUD.showSuccess("ok")
                } else {
                    LSHUD.showError("buy faild")
                }
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}

//MARK: contract
extension CS_MarketNFTDetailController {
    func estimateGasApprove(_ password: String){
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address else {
            return
        }
        let para = CS_ContractNFT.estimateApprovePara(to: contract)
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "crazy_str_buy".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                vc.showGasCoinInsufficientAlert = false
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.buy(password)
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
}



//MARK: UI
extension CS_MarketNFTDetailController {
    
    private func setupView() {
        titleLabel.textColor = .ls_white()
        contentView.addSubview(iconView)
        contentView.addSubview(qualityLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(initPowerLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(statusButton)
        contentView.addSubview(infoBackView)
        contentView.addSubview(priceInputView)
        contentView.addSubview(priceView)
        contentView.addSubview(confirmButton)
        
        contentView.snp.makeConstraints { make in
            make.left.equalTo(78)
            make.right.equalTo(-42)
            make.top.equalTo(28)
            make.bottom.equalTo(-28)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(10)
            make.width.height.equalTo(44)
        }
        
        qualityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(-6)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(contentView).offset(80)
            make.top.equalTo(iconView)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        initPowerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.right.equalTo(-80)
            make.width.equalTo(143)
            make.height.equalTo(26)
        }
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(10)
            make.top.equalTo(iconView.snp.bottom).offset(CS_ms(10))
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
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(-10)
            make.right.equalTo(-20)
            make.width.equalTo(233)
            make.height.equalTo(40)
        }
        
        priceInputView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(confirmButton)
            make.right.equalTo(contentView.snp.centerX)
            make.height.equalTo(40)
        }
        
        priceView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(confirmButton)
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
    }
}
