//
//  CS_CodeTextField.swift
//  CrazySnake
//
//  Created by Lee on 03/04/2023.
//

import UIKit

class CS_CodeTextField: UIView {
    var code: String?
    var codeDidChange: CS_StringBlock?
    var codeWillBeginEditing: CS_NoParasBlock?
    var codeDidEndEditing: CS_NoParasBlock?
    
    var itemCount = 6
    var itemMargin = 19
    var labels = [CS_CodeInputLabel]()
    var currentLabel: CS_CodeInputLabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        field.delegate = self
        field.textColor = .clear
        return field
    }()
    
    lazy var coverView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickMaskButton), for: .touchUpInside)
        button.backgroundColor = .ls_dark_3()
        return button
    }()
}

//MARK: function
extension CS_CodeTextField {
    func pasteCode(_ code: String?){
        self.textField.text = code
        handleInputText()
    }
}


//MARK: action
extension CS_CodeTextField {
    @objc private func textFieldDidChange(_ field: UITextField) {
        handleInputText()
    }
    
    func handleInputText(){
        var inputText = textField.text?.ls_trimmed
        if inputText?.count ?? 0 > itemCount {
            inputText = inputText?[0...itemCount-1]
        }
        
        for item in labels.enumerated() {
            let label = item.element
            if item.offset < inputText?.count ?? 0 {
//                label.text = inputText?[item.offset...item.offset]
                label.text = "*"
            } else {
                label.text = nil
            }
        }
        code = inputText
        codeDidChange?(inputText)
        cursor()
        if inputText?.count ?? 0 >= itemCount {
            currentLabel?.stopAnimating()
            textField.resignFirstResponder()
        }
    }
    
    @objc private func clickMaskButton() {
        textField.becomeFirstResponder()
        cursor()
    }
    
    override func endEditing(_ force: Bool) -> Bool {
        textField.endEditing(force)
        currentLabel?.stopAnimating()
        return super.endEditing(force)
    }
    
    func cursor(){
        currentLabel?.stopAnimating()
        var index = self.code?.count ?? 0
        if index >= labels.count {
            index = labels.count - 1
        }
        let label = labels[index]
        label.startAnimating()
        currentLabel = label
    }
}

//MARK: UITextFieldDelegate
extension CS_CodeTextField: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.codeDidEndEditing?()
        currentLabel?.stopAnimating()
        return true
    }
}



//MARK: UI
extension CS_CodeTextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        if labels.count != itemCount {
//            return
//        }
//        let w = 41
//        var x = 0
//        for item in labels.enumerated() {
//            x = item.offset * (w + itemMargin)
//            let label = item.element
//            label.frame = CGRect(x: x, y: 0, width: w, height: w)
//        }
//        textField.frame = bounds
//        coverView.frame = bounds
    }
    
    func configTextField(){
        
    }
    
    private func setupView() {
        addSubview(self.textField)
        addSubview(self.coverView)
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let itemWidth = 41
        for index in (0..<itemCount) {
            
            let label = CS_CodeInputLabel(frame: CGRect(x: index*(itemWidth+itemMargin), y: 0, width: itemWidth, height: itemWidth))
            label.textAlignment = .center
            label.textColor = .ls_white()
            label.font = .ls_JostRomanFont(19)
            label.ls_cornerRadius(5)
            label.ls_border(color: .ls_color("#666666"))
            addSubview(label)
            labels.append(label)
        }
    }
}

class CS_CodeInputLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let h = 30
//        let w = 2
//        let x = width*0.5
//        let y = height*0.5
//        lineView.frame = CGRect(x: 0, y: 0, width: w, height: h)
//        lineView.center = CGPoint(x: x, y: y)
    }
    
    func startAnimating(){
//        return
//        guard text?.count == 0 else {
//            return
//        }
//        let oa = CABasicAnimation(keyPath: "opacity")
//        oa.fromValue = 0
//        oa.toValue = 1
//        oa.duration = 1
//        oa.repeatCount = MAXFLOAT
//        oa.isRemovedOnCompletion = false
//        oa.fillMode = .forwards
//        oa.timingFunction = CAMediaTimingFunction(name: .easeIn)
//        lineView.layer.add(oa, forKey: "opacity")
    }
    
    func stopAnimating(){
//        return
//        lineView.layer.removeAnimation(forKey: "opacity")
    }
    
//    lazy var backView: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage.ls_bundle("wallet_bg_code_input@2x")
//        return view
//    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.alpha = 0
        view.isHidden = true
        return view
    }()
}

//MARK: UI
extension CS_CodeInputLabel {
    
    private func setupView() {
        addSubview(lineView)
        
//        lineView.snp.makeConstraints { make in
//            make.left.equalTo(20)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(2)
//            make.height.equalTo(30)
//        }
    }
}
