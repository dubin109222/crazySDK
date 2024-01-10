//
//  CS_NFTSendNFTController.swift
//  CrazySnake
//
//  Created by Lee on 29/05/2023.
//

import UIKit

class CS_NFTSendNFTController: CS_BaseAlertController {

    var model: CS_NFTDataModel?
    var sendSuccess: CS_NoParasBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setData()
    }
    
    func setData() {
        guard let model = model else { return }
        let url = URL.init(string: model.image)
        imageView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
    }
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_5()
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = .ls_bundle("nft_icon_send_nft@2x")
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var myTitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.text = "crazy_str_my_wallet_address".ls_localized
        return label
    }()

    lazy var myAddressLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#999999"), .ls_JostRomanFont(12))
        label.lineBreakMode = .byTruncatingMiddle
        label.text = CS_AccountManager.shared.accountInfo?.wallet_address
        return label
    }()
    
    lazy var receveAddress: UILabel = {
        let lab = UILabel()
        lab.text = "Gifted wallet address".ls_localized
        lab.textColor = .ls_white()
        lab.font = .ls_JostRomanFont(12)
        return lab
    }()
    
    lazy var addressInput: CS_FieldInputView = {
        let view = CS_FieldInputView()
        view.textField.placeholder = "Input wallet address"
        view.iconButton.isHidden = true
        view.updateAddressInput()
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 139, height: 43))
        button.addTarget(self, action: #selector(clickSendButton(_:)), for: .touchUpInside)
        button.setBackgroundImage(UIImage.ls_bundle("nft_icon_bg_list_nft@2x"), for: .normal)
        button.setTitle("Send now".ls_localized, for: .normal)
        return button
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(10))
        label.numberOfLines = 0
        label.text = "The receiver wallet address must be a wallet from inside the ecosystem.".ls_localized
        return label
    }()
}

//MARK: action
extension CS_NFTSendNFTController {
    @objc private func clickSendButton(_ sender: UIButton) {
        send()
    }
}

//MARK: contract
extension CS_NFTSendNFTController {
    
    func send(){
        let toAddress = addressInput.textField.text ?? ""
        guard toAddress.count > 0 else {
            CS_ToastView.showError("Receiving address is requested".ls_localized)
            return
        }
        let account = CS_AccountManager.shared.accountInfo
        guard let address = account?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: account?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["to"] = toAddress
        para["token_ids"] = model?.token_id
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.sendNft(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                NotificationCenter.default.post(name: NotificationName.CS_MarketBuyItem, object: weakSelf?.model)
                weakSelf?.dismiss(animated: false)
                weakSelf?.sendSuccess?()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
}

//MARK: UI
extension CS_NFTSendNFTController {
    
    private func setupView() {
        titleLabel.textColor = .ls_white()
        titleLabel.text = "Gift confirmation".ls_localized
        contentView.addSubview(infoView)
        contentView.addSubview(iconView)
        contentView.addSubview(imageView)
        contentView.addSubview(myTitleLabel)
        contentView.addSubview(myAddressLabel)
        contentView.addSubview(receveAddress)
        contentView.addSubview(addressInput)
        contentView.addSubview(sendButton)
        contentView.addSubview(tipsLabel)
        
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(450)
            make.height.equalTo(236)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(18)
            make.top.equalTo(contentView).offset(6)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(48)
        }
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(13)
            make.top.equalTo(iconView.snp.bottom).offset(20)
            make.width.equalTo(167)
            make.height.equalTo(176)
        }
        
        myTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(20)
            make.top.equalTo(imageView)
        }
        
        myAddressLabel.snp.makeConstraints { make in
            make.left.equalTo(myTitleLabel)
            make.top.equalTo(myTitleLabel.snp.bottom).offset(4)
            make.right.equalTo(-30)
        }
        
        receveAddress.snp.makeConstraints { make in
            make.left.equalTo(myTitleLabel)
            make.top.equalTo(myAddressLabel.snp.bottom).offset(12)
        }
        
        addressInput.snp.makeConstraints { make in
            make.left.equalTo(receveAddress)
            make.top.equalTo(receveAddress.snp.bottom).offset(6)
            make.right.equalTo(myAddressLabel)
            make.height.equalTo(24)
        }
        
        
        sendButton.snp.makeConstraints { make in
            make.left.equalTo(myTitleLabel)
            make.top.equalTo(addressInput.snp.bottom).offset(12)
            make.width.equalTo(139)
            make.height.equalTo(42)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.right.equalTo(myAddressLabel)
            make.top.equalTo(sendButton.snp.bottom).offset(2)
        }
    }
}
