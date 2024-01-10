//
//  CS_AmountInputView.swift
//  CrazySnake
//
//  Created by Lee on 06/03/2023.
//

import UIKit

class CS_AmountInputView: UIView {
    
    var maxNum = 0
    var currentNum = 0
    
    var amountChange: CS_IntBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetData(max: Int, current: Int) {
        maxNum = max
        currentNum = current
        if current > 0 {
            textField.text = "\(currentNum)"
        } else {
            textField.text = nil
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(8)
        view.ls_border(color: .ls_white(),width: 3)
        return view
    }()
    
    lazy var reduceButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickReduceButton(_:)), for: .touchUpInside)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.ls_white(), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(36)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickAddButton(_:)), for: .touchUpInside)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.ls_white(), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(36)
        return button
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.font = .ls_JostRomanFont(19)
        field.textColor = .ls_color("#46F490")
        field.textAlignment = .center
        field.backgroundColor = .ls_color("#494949")
        field.ls_cornerRadius(5)
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        field.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ls_text_gray()])
        field.placeholder = "0"
        return field
    }()
    
    lazy var maxButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickMaxButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_max".ls_localized, for: .normal)
        button.setTitleColor(.ls_white(), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(14)
        button.backgroundColor = .ls_purpose()
        button.ls_cornerRadius(5)
        return button
    }()

}

//MARK: action
extension CS_AmountInputView {
    
    @objc private func clickReduceButton(_ sender: UIButton) {
        guard currentNum > 0 else {
            return
        }
        currentNum -= 1
        textField.text = "\(currentNum)"
        amountChange?(currentNum)
    }
    
    @objc private func clickAddButton(_ sender: UIButton) {
        guard currentNum < maxNum else {
            return
        }
        currentNum += 1
        textField.text = "\(currentNum)"
        amountChange?(currentNum)
    }
    
    @objc private func clickMaxButton(_ sender: UIButton) {
        currentNum = maxNum
        textField.text = "\(currentNum)"
        amountChange?(currentNum)
    }
    
    @objc private func textFieldDidChange(_ field: UITextField) {
        if let amount = textField.text, let amountNum = Int(amount) {
            if amountNum > maxNum{
                currentNum = maxNum
                textField.text = "\(currentNum)"
            } else {
                currentNum = amountNum
            }
            amountChange?(currentNum)
        } else {
            amountChange?(0)
        }
    }
    
}


//MARK: UI
extension CS_AmountInputView {
    
    private func setupView() {
        addSubview(backView)
        addSubview(reduceButton)
        addSubview(textField)
        addSubview(addButton)
        addSubview(maxButton)
        
        maxButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(49)
        }
        
        backView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(maxButton.snp.left).offset(-8)
        }
        
        reduceButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(backView)
            make.left.equalTo(backView).offset(3)
            make.width.equalTo(40)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(backView)
            make.right.equalTo(backView).offset(-3)
            make.width.equalTo(40)
        }
        
        textField.snp.makeConstraints { make in
            make.center.equalTo(backView)
            make.width.equalTo(62)
            make.height.equalTo(26)
        }
    }
}
