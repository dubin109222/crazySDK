//
//  CS_MarketNFTPriceInputView.swift
//  CrazySnake
//
//  Created by Lee on 25/04/2023.
//

import UIKit

class CS_MarketNFTPriceInputView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("market_icon_input_icon@2x")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_token_diamond@2x")
        return view
    }()
    
    lazy var inputField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.placeholder = "0"
        field.keyboardType = .numberPad
        field.textColor = .ls_white()
        field.font = UIFont.ls_JostRomanFont(12)
        field.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ls_text_gray()])
        field.backgroundColor = .ls_color("#2F294C",alpha: 0.8)
        field.ls_cornerRadius(6)
        return field
    }()
    
}

//MARK: UI
extension CS_MarketNFTPriceInputView {
    
    private func setupView() {
        backgroundColor = .ls_color("#2F294C",alpha: 0.2)
        ls_cornerRadius(6)
        addSubview(iconView)
        addSubview(tokenIcon)
        addSubview(inputField)
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(26)
        }
        
        inputField.snp.makeConstraints { make in
            make.left.equalTo(tokenIcon.snp.right).offset(6)
            make.centerY.equalToSuperview()
            make.right.equalTo(-8)
            make.height.equalTo(32)
        }
        
    }
}
