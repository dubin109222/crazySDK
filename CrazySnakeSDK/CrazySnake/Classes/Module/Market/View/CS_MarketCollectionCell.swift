//
//  CS_MarketCollectionCell.swift
//  CrazySnake
//
//  Created by Lee on 23/04/2023.
//

import UIKit

class CS_MarketCollectionCell: UICollectionViewCell {
    
    var clickBuyAction: CS_NoParasBlock?
    var clickRemoveAction: CS_NoParasBlock?
    
    var model: CS_MarketModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_MarketModel?) {
        self.model = model
        guard let model = model else { return }
        setsView.isHidden = model.item_type != 3
        coverView.isHidden = model.item_type == 3
        shadowView.isHidden = model.item_type != 2
        if model.item_type == 2 {
            amountLabel.isHidden = false
            amountLabel.text = "x \(model.total)"
            setUserInfo(model.propDetail?.user)
            if let nft = model.propDetail {
                addressLabel.text = nft.user?.wallet_address
                let url = URL.init(string: nft.icon)
                coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
                
                titleLabel.text = "\(nft.disPlayName())"
            }
        } else if model.item_type == 3 {
            amountLabel.isHidden = true
            setsView.setData(model)
            if let nft = model.nftSetsDetail.first {
                setUserInfo(nft.user)
                addressLabel.text = nft.user?.wallet_address
//                titleLabel.text = nft.nft_class.cs_configName()
                titleLabel.text = "\(nft.disPlayName())"

            }
        } else {
            amountLabel.isHidden = true
            setUserInfo(model.nftDetail?.user)
            if let nft = model.nftDetail {
                addressLabel.text = nft.user?.wallet_address
                let url = URL.init(string: nft.image)
                coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
                titleLabel.text = "#\(nft.token_id)"
            }
        }
        
        priceLabel.text = model.price
        if model.isSelf() {
            buyButton.setBackgroundImage(nil, for: .normal)
            buyButton.backgroundColor = .ls_color("#E16A56")
            buyButton.setTitle("crazy_str_sell_remove_offer".ls_localized, for: .normal)
        } else {
            buyButton.setBackgroundImage(UIImage.ls_bundle("common_bg_button_purpose@2x"), for: .normal)
            buyButton.setTitle("crazy_str_buy".ls_localized, for: .normal)
        }
    }
    
    func setUserInfo(_ user: CS_NFTUserModel?) {
        if let avatar = user?.avatar_image {
            let url = URL.init(string: avatar)
            userIcon.kf.setImage(with: url , placeholder: UIImage.ls_placeHeader(), options: nil , completionHandler: nil)
        } else {
            userIcon.image = UIImage.ls_placeHeader()
        }
    }
    
    lazy var backView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("market_bg@2x")
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var userIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("common_default_head_icon@2x")
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(10))
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()

    lazy var coverView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 95, height: 106))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var setsView: CS_NFTSetsView = {
        let view = CS_NFTSetsView()
        return view
    }()
    
    lazy var shadowView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("common_icon_item_shadow@2x")
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    lazy var searchIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("market_icon_search@2x")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .center
        label.backgroundColor = .ls_color("#909090",alpha: 0.1)
        label.ls_cornerRadius(11)
        return label
    }()
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_token_diamond@2x")
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()
    
    lazy var buyButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 118, height: 32))
        button.setTitle("crazy_str_buy".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickBuyButton(_:)), for: .touchUpInside)
        return button
    }()
}

//MARK: open
extension CS_MarketCollectionCell {
    
    public class func itemSize() -> CGSize {
        let width = (CS_kScreenW-2*(CS_ms(38))-30)/2.0
        return CGSize(width: width, height: 185)
    }
}

//MARK: action
extension CS_MarketCollectionCell {
    @objc private func clickBuyButton(_ sender: UIButton) {
        if self.model?.isSelf() == true {
            self.clickRemoveAction?()
        } else {
            self.clickBuyAction?()
        }
    }
}


//MARK: UI
extension CS_MarketCollectionCell {
    
    fileprivate func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(userIcon)
        backView.addSubview(addressLabel)
        backView.addSubview(coverView)
        backView.addSubview(setsView)
        backView.addSubview(shadowView)
        backView.addSubview(amountLabel)
        backView.addSubview(searchIcon)
        backView.addSubview(titleLabel)
        backView.addSubview(tokenIcon)
        backView.addSubview(priceLabel)
        backView.addSubview(buyButton)
        
        backView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(20)
        }
        
        userIcon.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(10)
            make.width.height.equalTo(22)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(userIcon.snp.right).offset(8)
            make.centerY.equalTo(userIcon)
            make.width.equalTo(74)
        }
        
        coverView.snp.makeConstraints { make in
            make.left.equalTo(addressLabel)
            make.top.equalTo(42)
            make.width.equalTo(95)
            make.height.equalTo(106)
        }
        
        setsView.snp.makeConstraints { make in
            make.edges.equalTo(coverView)
        }
        
        shadowView.snp.makeConstraints { make in
            make.centerX.equalTo(coverView)
            make.bottom.equalTo(coverView)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(shadowView.snp.right)
            make.centerY.equalTo(shadowView).offset(0)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.left.bottom.equalTo(0)
            make.width.equalTo(34)
            make.height.equalTo(27)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(1.5)
            make.centerY.equalTo(userIcon)
            make.width.equalTo(118)
            make.height.equalTo(23)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(58)
            make.width.height.equalTo(26)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(tokenIcon.snp.bottom).offset(10)
        }
        
        buyButton.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.bottom.equalTo(-10)
            make.width.equalTo(118)
            make.height.equalTo(32)
        }
    }
}

