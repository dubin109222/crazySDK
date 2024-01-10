//
//  CS_FieldInputView.swift
//  Platform
//
//  Created by Lee on 23/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit

class CS_FieldInputView: UIView {
    
    var clickRightButtonAction: CS_NoParasBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAddressInput(){
        arrowButton.isHidden = true
        textField.snp.remakeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.font = UIFont.ls_JostRomanFont(12)
        field.textColor = UIColor.ls_white()
        field.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ls_text_gray()])

        return field
    }()
    
    lazy var iconButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 22))
        button.setImage(UIImage(named: "icon_eyes_closed"), for: .normal)
        button.setImage(UIImage(named: "icon_eyes_open"), for: .selected)
        button.setTitleColor(.ls_dark_2(), for: .normal)
        button.titleLabel?.font = .ls_font(16)
        button.isHidden = true
        button.addTarget(self, action: #selector(clickIconButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickIconButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("wallet_icon_arrow_down@2x"), for: .normal)
        button.ls_layout(.imageLeft,padding: 6)
        return button
    }()
}


//MARK: action
extension CS_FieldInputView {
    
    @objc fileprivate func clickIconButton(_ sender: UIButton) {
        if let block = clickRightButtonAction {
            block()
        } else {        
            sender.isSelected = !sender.isSelected
            textField.isSecureTextEntry = !sender.isSelected
        }
    }
}


//MARK: UI
extension CS_FieldInputView {
    
    fileprivate func setupView() {
        backgroundColor = UIColor.ls_dark_4()
        layer.cornerRadius = 5
        layer.masksToBounds = true
        addSubview(textField)
        addSubview(iconButton)
        addSubview(arrowButton)
        
        arrowButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-6)
            make.centerY.equalToSuperview()
        }
        
        iconButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-26)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(24)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-116)
            make.centerY.equalToSuperview()
        }
    }
}
