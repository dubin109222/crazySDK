//
//  CS_SwapCoinAmountView.swift
//  CrazySnake
//
//  Created by Lee on 16/03/2023.
//

import UIKit

class CS_SwapCoinAmountView: UIView {
    
    typealias StringBlock = (String?) -> Void
    var inputChange: StringBlock?
    var changeTypeAction: CS_NoParasBlock?
    
    var token = TokenName.Snake
    var ratio = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func otherAmountChange(_ amount: String?){
        
        let text = "\((Double(ratio) ?? 0) * (Double(amount ?? "0") ?? 0))"
        amountInputView.textField.text = Utils.formatAmount(text)
    }
    
    func setToken(_ data: TokenName) {
        token = data
        typeIcon.image = token.icon()
        typeButton.setTitle(token.rawValue, for: .normal)
        amountLabel.text = "\(data.balance()) \(data.rawValue)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var topBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#2C2A31")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.text = "crazy_str_pay_pay".ls_localized
        return label
    }()
    
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.text = "crazy_str_from".ls_localized
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .right
        label.text = "\(token.balance()) \(token.rawValue)"
        return label
    }()
    
    lazy var amountInputView: CS_SwapCoinInputView = {
        let view = CS_SwapCoinInputView()
        view.backgroundColor = .ls_color("#2C2A31")
        view.ls_cornerRadius(10)
        weak var weakSelf = self
        view.inputChange = { text in
            weakSelf?.inputChange?(text)
        }
        return view
    }()
    
    lazy var typeIcon: UIImageView = {
        let view = UIImageView()
        view.image = token.icon()
        return view
    }()
    
    lazy var typeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 20))
        button.addTarget(self, action: #selector(clickCoinTypeButton(_:)), for: .touchUpInside)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle(token.rawValue, for: .normal)
        button.setImage(UIImage.ls_bundle("swap_icon_down_white@2x"), for: .normal)
        button.ls_layout(.imageRight,padding: 12)
        return button
    }()
    
    lazy var chainLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "(\(Config.chain.name))"
        return label
    }()

}

//MARK: action
extension CS_SwapCoinAmountView {
    @objc private func clickCoinTypeButton(_ sender: UIButton) {
        changeTypeAction?()
    }
}


//MARK: UI
extension CS_SwapCoinAmountView {
    
    private func setupView() {
        addSubview(topBackView)
        addSubview(titleLabel)
        addSubview(sourceLabel)
        addSubview(amountLabel)
        addSubview(amountInputView)
        addSubview(typeIcon)
        addSubview(typeButton)
        addSubview(chainLabel)
        
        topBackView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(topBackView)
            make.left.equalTo(16)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(topBackView.snp.bottom).offset(12)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sourceLabel)
            make.left.equalTo(topBackView).offset(54)
        }
        
        amountInputView.snp.makeConstraints { make in
            make.bottom.equalTo(-20)
            make.left.equalTo(titleLabel)
            make.width.equalTo(144)
            make.height.equalTo(30)
        }
        
        typeButton.snp.makeConstraints { make in
            make.centerY.equalTo(amountInputView)
            make.right.equalTo(-20)
            make.width.equalTo(72)
            make.height.equalTo(20)
        }
        
        typeIcon.snp.makeConstraints { make in
            make.centerX.equalTo(typeButton)
            make.bottom.equalTo(typeButton.snp.top).offset(-2)
        }
        
        chainLabel.snp.makeConstraints { make in
            make.centerX.equalTo(typeButton)
            make.top.equalTo(typeButton.snp.bottom)
        }
    }
}


class CS_SwapCoinInputView: UIView {
    
    typealias StringBlock = (String?) -> Void
    var inputChange: StringBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("swap_icon_input_amount@2x")
        return view
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.placeholder = "0"
        view.keyboardType = .decimalPad
        view.textAlignment = .right
        view.textColor = .ls_white()
        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return view
    }()
}

//MARK: action
extension CS_SwapCoinInputView {
    @objc private func textFieldDidChange(_ field: UITextField) {
        inputChange?(field.text)
    }
}

//MARK: UI
extension CS_SwapCoinInputView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(textField)
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.height.equalTo(12)
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.left.equalToSuperview().offset(28)
            make.height.equalToSuperview()
        }
    }
}


class CS_SwapCoinContentItemView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        label.textAlignment = .right
        return label
    }()
}

//MARK: UI
extension CS_SwapCoinContentItemView {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(0)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(0)
        }
    }
}
