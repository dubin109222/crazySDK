//
//  CS_StakeAmountInputView.swift
//  CrazySnake
//
//  Created by Lee on 17/03/2023.
//

import UIKit

class CS_StakeAmountInputView: UIView {

    typealias CS_InputChangeBlock = (String?) -> Void
    var inputContentChange: CS_InputChangeBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = TokenName.Snake.icon()
        return view
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.textAlignment = .right
        view.textColor = .ls_white()
        view.font = .ls_JostRomanFont(16)
        view.keyboardType = .numberPad
        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ls_text_gray()])
        return view
    }()

}

//MARK: action
extension CS_StakeAmountInputView {
    @objc private func textFieldDidChange(_ field: UITextField) {
        inputContentChange?(field.text)
    }
}


//MARK: UI
extension CS_StakeAmountInputView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(textField)
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(3)
            make.width.height.equalTo(24)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.left.equalToSuperview().offset(30)
            make.height.equalToSuperview()
        }
    }
}

