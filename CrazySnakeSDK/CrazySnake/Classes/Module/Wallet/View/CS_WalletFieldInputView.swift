//
//  CS_WalletFieldInputView.swift
//  CrazySnake
//
//  Created by Lee on 12/07/2023.
//

import UIKit

class CS_WalletFieldInputView: UIView {

    var clickRightButtonAction: CS_NoParasBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAddressInput(){
        lineView.isHidden = true
        actionButton.isHidden = true
        textField.snp.remakeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.font = UIFont.ls_mediumFont(12)
        field.textColor = UIColor.ls_white()
        field.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ls_text_gray()])

        return field
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_white(0.1)
        return view
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 58))
        button.setTitleColor(.ls_color("#A676FF"), for: .normal)
        button.titleLabel?.font = .ls_mediumFont(14)
        button.setTitle("All", for: .normal)
        button.addTarget(self, action: #selector(clickIconButton(_:)), for: .touchUpInside)
        return button
    }()
}


//MARK: action
extension CS_WalletFieldInputView {
    
    @objc fileprivate func clickIconButton(_ sender: UIButton) {
        clickRightButtonAction?()
    }
}


//MARK: UI
extension CS_WalletFieldInputView {
    
    fileprivate func setupView() {
        backgroundColor = .ls_color("#1E1E20")
        ls_cornerRadius(10)
        addSubview(textField)
        addSubview(lineView)
        addSubview(actionButton)
        
        actionButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(55)
        }
        
        lineView.snp.makeConstraints { make in
            make.right.equalTo(actionButton.snp.left).offset(0)
            make.top.equalTo(16)
            make.width.equalTo(1)
            make.bottom.equalTo(-16)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(lineView.snp.left).offset(-12)
            make.centerY.equalToSuperview()
        }
    }
}
