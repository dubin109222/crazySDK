//
//  CS_MarketMineCell.swift
//  CrazySnake
//
//  Created by Lee on 24/04/2023.
//

import UIKit

class CS_MarketMineCell: UICollectionViewCell {
    
    var clickPlaceOffer: CS_NoParasBlock?
    var clickRemovePlaceOffer: CS_NoParasBlock?
    
    var model: CS_MarketModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSelling(_ model: CS_MarketModel?) {
        setData(model)
        guard let model = model else { return }
        setsView.powerView.isHidden = false
        if model.item_type == 2 {
            amountLabel.text = "x \(model.total)"
        } else {
            amountLabel.text = ""
        }
        
        priceLabel.text = model.price
        tokenIcon.isHidden = false
        priceLabel.isHidden = false
        buyButton.setBackgroundImage(nil, for: .normal)
        buyButton.backgroundColor = .ls_color("#E16A56")
        buyButton.setTitle("crazy_str_sell_remove_offer".ls_localized, for: .normal)
    }
    
    func setDataInventory(_ model: CS_MarketModel?) {
        guard let model = model else { return }
        setData(model)
        if model.item_type == 2 {
            if let nft = model.propDetail {
                amountLabel.text = "x \(nft.num)"
            }
        } else {
            amountLabel.text = ""
        }
        
        tokenIcon.isHidden = true
        priceLabel.isHidden = true
    }
    
    func setDataInventorySets(_ model: CS_NFTSetInfoModel?) {
        guard let model = model else { return }
        shadowView.isHidden = true
        coverView.isHidden = true
        titleLabel.text = model.set_class.cs_configName()
        setsView.isHidden = false
        setsView.setDataInventorySets(model)
        amountLabel.text = ""
        tokenIcon.isHidden = true
        priceLabel.isHidden = true
    }
    
    func setData(_ model: CS_MarketModel?) {
        guard let model = model else { return }
        self.model = model
        setsView.isHidden = true
        shadowView.isHidden = model.item_type != 2
        coverView.isHidden = false
        if model.item_type == 1 {
            if let nft = model.nftDetail {
                let url = URL.init(string: nft.image)
                coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
                titleLabel.text = "#\(nft.token_id)"
            }
        } else if model.item_type == 3 {
            setsView.isHidden = false
            coverView.isHidden = true
            setsView.setData(model)
            if let nft = model.nftSetsDetail.first {
                titleLabel.text = nft.nft_class.cs_configName()
            }
        } else {
            if let nft = model.propDetail {

                coverView.image = nft.props_type.iconImage()
                titleLabel.text = nft.props_type.disPlayName()
            }
        }
        
    }
    
    lazy var backView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("market_bg_mine_nft@2x")
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        return view
    }()

    lazy var coverView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 95, height: 106))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var setsView: CS_NFTSetsView = {
        let view = CS_NFTSetsView()
        view.isHidden = true
        view.powerView.isHidden = true
        return view
    }()
    
    lazy var shadowView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("common_icon_item_shadow@2x")
        return view
    }()
    
    lazy var searchIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("market_icon_mine_search@2x")
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
        view.isHidden = true
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.isHidden = true
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .right
        return label
    }()
    
    lazy var buyButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 120, height: 32))
        button.setTitle("crazy_str_place_offer".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickBuyButton(_:)), for: .touchUpInside)
        return button
    }()
}

//MARK: open
extension CS_MarketMineCell {
    
    public class func itemSize() -> CGSize {
        let width = (CS_kScreenW-2*(CS_ms(12))-3*20)/4.0
        return CGSize(width: width, height: 242)
    }
}

//MARK: action
extension CS_MarketMineCell {
    @objc private func clickBuyButton(_ sender: UIButton) {
        clickPlaceOffer?()
        clickRemovePlaceOffer?()
    }
}


//MARK: UI
extension CS_MarketMineCell {
    
    fileprivate func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(setsView)
        backView.addSubview(coverView)
        backView.addSubview(shadowView)
        backView.addSubview(searchIcon)
        backView.addSubview(titleLabel)
        backView.addSubview(tokenIcon)
        backView.addSubview(priceLabel)
        backView.addSubview(amountLabel)
        backView.addSubview(buyButton)
        
        backView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(20)
        }
        
        coverView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
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
        
        searchIcon.snp.makeConstraints { make in
            make.bottom.equalTo(coverView).offset(24)
            make.left.equalTo(0)
            make.width.equalTo(34)
            make.height.equalTo(27)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.left.equalTo(coverView).offset(24)
            make.bottom.equalTo(searchIcon)
            make.width.height.equalTo(26)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(tokenIcon.snp.right).offset(8)
            make.centerY.equalTo(tokenIcon)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(10)
            make.width.equalTo(118)
            make.height.equalTo(23)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.bottom.equalTo(searchIcon).offset(0)
        }
        
        buyButton.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.bottom.equalTo(-10)
            make.width.equalTo(120)
            make.height.equalTo(32)
        }
    }
}

