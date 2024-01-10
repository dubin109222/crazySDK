//
//  CS_MarketProtStopSellingController.swift
//  CrazySnake
//
//  Created by Lee on 02/05/2023.
//

import UIKit

class CS_MarketProtStopSellingController: CS_BaseAlertController {

    var model: CS_MarketModel?
    let account = CS_AccountManager.shared.accountInfo

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        setData()
    }
    
    func setData() {
        guard let prop = model?.propDetail else { return }
        titleLabel.text = prop.props_type.disPlayName()
        addressLabel.text = prop.user?.wallet_address
        imageView.image = prop.props_type.iconImage()
        let amount = model?.balance ?? 1
        amountLabel.text = "\(amount)"
        if model?.status == 1 {
            priceView.priceLabel.text = "\(model?.price ?? "0")"
        }
    }
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.lineBreakMode = .byTruncatingMiddle
        label.text = CS_AccountManager.shared.accountInfo?.wallet_address
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var imageShadowView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("common_icon_item_shadow@2x")
        return view
    }()
    
    lazy var saleBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.ls_cornerRadius(12)
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_icon_prop_amount@2x")
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#FFE063"), .ls_JostRomanFont(19))
        return label
    }()
    
    lazy var saleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "Items left"
        return label
    }()
    
    lazy var infoBackView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
        view.backgroundColor = .ls_color("#34294C",alpha: 0.8)
//        view.ls_addCorner([.topRight,.bottomRight], cornerRadius: 15)
        return view
    }()
    
    lazy var priceView: CS_MarketNFTPriceViewLeft = {
        let view = CS_MarketNFTPriceViewLeft()
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 180, height: 40))
        button.setBackgroundImage(nil, for: .normal)
        button.backgroundColor = .ls_color("#E16A56")
        button.setTitle("crazy_str_sell_remove_offer".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        return button
    }()
}

//MARK: action
extension CS_MarketProtStopSellingController {
    @objc private func clickConfirmButton(_ sender: UIButton) {
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
}


//MARK: UI
extension CS_MarketProtStopSellingController {
    
    private func setupView() {
        contentView.addSubview(addressLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(imageShadowView)
        contentView.addSubview(saleBackView)
        contentView.addSubview(iconView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(saleLabel)
        contentView.insertSubview(infoBackView, at: 0)
        contentView.addSubview(priceView)
        contentView.addSubview(confirmButton)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(480)
            make.height.equalTo(240)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(contentView).offset(24)
            make.top.equalTo(contentView).offset(16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.width.equalTo(160)
        }
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(17*CS_kRate)
            make.width.equalTo(97)
            make.height.equalTo(83)
        }
        
        imageShadowView.snp.makeConstraints { make in
            make.centerX.equalTo(imageView).offset(0)
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.width.equalTo(86)
            make.height.equalTo(9)
        }
        
        saleBackView.snp.makeConstraints { make in
            make.left.equalTo(21*CS_kRate)
            make.bottom.equalTo(contentView).offset(-10)
            make.width.equalTo(114)
            make.height.equalTo(56)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(saleBackView).offset(18)
            make.top.equalTo(saleBackView).offset(10)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(saleBackView).offset(54)
            make.centerY.equalTo(iconView)
        }
        
        saleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(saleBackView)
            make.bottom.equalTo(saleBackView).offset(-8)
        }
        
        infoBackView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.right.equalTo(contentView)
            make.left.equalTo(contentView.snp.centerX).offset(0)
            make.bottom.equalTo(contentView)
        }
        
        priceView.snp.makeConstraints { make in
            make.left.equalTo(infoBackView).offset(42)
            make.bottom.equalTo(confirmButton.snp.top).offset(-12)
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(-60)
            make.centerX.equalTo(infoBackView)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
    }
}

