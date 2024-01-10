//
//  CS_MarketNFTPriceView.swift
//  CrazySnake
//
//  Created by Lee on 25/04/2023.
//

import UIKit

class CS_MarketNFTPriceView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(12))
        label.text = "crazy_str_selling_price".ls_localized
        label.textAlignment = .center
        return label
    }()
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_token_diamond@2x")
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        return label
    }()
}

//MARK: UI
extension CS_MarketNFTPriceView {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(tokenIcon)
        addSubview(priceLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.right.equalTo(self.snp.centerX).offset(-4)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.width.height.equalTo(26)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(tokenIcon.snp.right).offset(8)
            make.centerY.equalTo(tokenIcon)
        }
        
    }
}

class CS_MarketNFTPriceViewLeft: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(12))
        label.text = "Total requird"
        return label
    }()
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_token_diamond@2x")
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        return label
    }()
}

//MARK: UI
extension CS_MarketNFTPriceViewLeft {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(tokenIcon)
        addSubview(priceLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(0)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.width.height.equalTo(26)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(tokenIcon.snp.right).offset(8)
            make.centerY.equalTo(tokenIcon)
        }
        
    }
}





