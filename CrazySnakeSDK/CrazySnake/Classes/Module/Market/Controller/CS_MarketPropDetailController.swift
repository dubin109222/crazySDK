//
//  CS_MarketPropDetailController.swift
//  CrazySnake
//
//  Created by Lee on 25/04/2023.
//

import UIKit

class CS_MarketPropDetailController: CS_BaseAlertController {
    
    var model: CS_MarketModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        setData()
    }
    
    func setData() {
        guard let prop = model?.propDetail else { return }
        titleLabel.text = prop.props_type.disPlayName()
        imageView.image = prop.props_type.iconImage()
        infotitleLabel.text = prop.props_type.disPlayName()
        infoLabel.text = prop.props_type.displayDesc()
        amountLabel.text = "\(model?.balance ?? 1)"
        
        if model?.status == 1 {
            priceView.isHidden = false
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
    
    lazy var infoBackView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 402*CS_kRate, height: 108))
        view.backgroundColor = .ls_color("#D3BDFF",alpha: 0.2)
        view.ls_addCorner([.topLeft,.bottomLeft], cornerRadius: 15)
        return view
    }()
    
    lazy var infotitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.text = "Title"
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    lazy var saleBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#D3BDFF",alpha: 0.2)
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
        label.text = "crazy_str_quantity_for_sale".ls_localized
        return label
    }()
    
    lazy var priceView: CS_MarketNFTPriceView = {
        let view = CS_MarketNFTPriceView()
        view.isHidden = true
        return view
    }()
}

//MARK: action
extension CS_MarketPropDetailController {
    
}


//MARK: UI
extension CS_MarketPropDetailController {
    
    private func setupView() {
        contentView.addSubview(addressLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(imageShadowView)
        contentView.addSubview(infoBackView)
        contentView.addSubview(infotitleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(saleBackView)
        contentView.addSubview(iconView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(saleLabel)
        contentView.addSubview(priceView)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(640)
            make.height.equalTo(CS_kScreenH-100)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(contentView).offset(33*CS_kRate)
            make.top.equalTo(contentView).offset(16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
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
        
        infoBackView.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.right.equalTo(contentView)
            make.left.equalTo(imageView.snp.right).offset(42)
            make.height.equalTo(108)
        }
        
        infotitleLabel.snp.makeConstraints { make in
            make.left.equalTo(infoBackView).offset(24)
            make.top.equalTo(infoBackView).offset(13)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(infotitleLabel)
            make.top.equalTo(infotitleLabel.snp.bottom).offset(6)
            make.right.equalTo(infoBackView).offset(-24)
        }
        
        saleBackView.snp.makeConstraints { make in
            make.left.equalTo(21*CS_kRate)
            make.bottom.equalTo(contentView).offset(-27)
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
        
        priceView.snp.makeConstraints { make in
            make.centerX.equalTo(infoBackView)
            make.centerY.equalTo(saleBackView)
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
    }
}

