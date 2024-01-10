//
//  CS_EventAmountInputView.swift
//  CrazySnake
//
//  Created by Lee on 06/04/2023.
//

import UIKit

class CS_EventAmountInputView: UIView {

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

    lazy var reduceButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickReduceButton(_:)), for: .touchUpInside)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.ls_white(), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(26)
        button.ls_cornerRadius(5)
        button.ls_border(color: .ls_white(0.3))
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickAddButton(_:)), for: .touchUpInside)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.ls_white(), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(26)
        button.backgroundColor = .ls_color("#7A56E1")
        button.ls_cornerRadius(5)
        return button
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.font = .ls_JostRomanFont(19)
        field.textColor = .ls_white()
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        field.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ls_text_gray()])
        field.placeholder = "0"
        return field
    }()
}

//MARK: action
extension CS_EventAmountInputView {
    
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
extension CS_EventAmountInputView {
    
    private func setupView() {
        
        addSubview(reduceButton)
        addSubview(textField)
        addSubview(addButton)

        reduceButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(0)
            make.left.equalTo(0).offset(3)
            make.width.equalTo(26)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(0)
            make.right.equalTo(0)
            make.width.equalTo(26)
        }
        
        textField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(62)
            make.height.equalTo(26)
        }
    }
}
