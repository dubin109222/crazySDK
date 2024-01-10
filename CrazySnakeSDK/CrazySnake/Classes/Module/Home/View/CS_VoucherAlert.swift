//
//  CS_VoucherAlert.swift
//  CrazySnake
//
//  Created by BigB on 2023/11/13.
//

import UIKit
import SnapKit
import HandyJSON

class CS_VoucherAlert: CS_BaseAlert {
    
    let confirmBtn = UIButton(type: .custom)
    
    var list: [ListRewardItem] = [] {
        didSet {
            let alert = CS_VoucherGetAlert()

            if list.count == 1 {
                alert.model = list.first
            } else {
                alert.list = list
            }
            alert.updateData()
            alert.show()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backView.isUserInteractionEnabled = false
        backView.backgroundColor = .ls_color("#11111A", alpha: 0.7)
        
        
        contentView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(213)
        }

        self.initSubViews()
        closeButton.isHidden = false

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func dismissSelf() {
        super.dismissSelf()
    }
    
    
    @objc func clickConfirmBtn(_ sender : UIButton) {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["gift_cdk"] = inputText.text


        CSNetworkManager.shared.giftCkdExchange(para) { (list : [ListRewardItem]) in
            
            self.dismissSelf()
            self.list = list
        }
    }

    // 移除通知的观察者
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 键盘弹出时调用
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // 计算键盘与textView底部的距离
            let keyboardBottomSpace = keyboardSize.height

            // 计算textView底部相对于父视图的位置
            let textViewBottomRelativeToParent = self.convert(inputText.frame.origin, from: inputText).y + inputText.frame.height

            // 计算需要调整的距离
            let adjustment = textViewBottomRelativeToParent - (self.frame.height - keyboardBottomSpace)

            // 如果需要调整
            if adjustment > 0 {
                // 调整父视图的位置
                self.frame.origin.y -= adjustment

                // 使用动画使调整生效
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            }
        }
    }

    // 键盘收起时调用
    @objc func keyboardWillHide(_ notification: Notification) {
        // 恢复父视图的位置
        self.frame.origin.y = 0

        // 使用动画使调整生效
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    let titleLb = UILabel()

    let subTitleLb = UILabel()

    let inputText = UITextField()

    func initSubViews()  {
        
        
        titleLb.text = "Gift code redemption"
        titleLb.textColor = .white
        titleLb.font = .ls_JostRomanFont(16)
        titleLb.textAlignment = .center
        titleLb.numberOfLines = 0
        
        self.contentView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(18)
        }
        
        subTitleLb.text = "Please enter the gift pack redemption code to receivethe exclusive gift pack"
        subTitleLb.textAlignment = .center
        subTitleLb.textColor = .ls_color("#7E7EA7")
        subTitleLb.font = .ls_JostRomanFont(11)
        subTitleLb.numberOfLines = 0
        self.contentView.addSubview(subTitleLb)
        subTitleLb.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(10)
        }
        
        let inputTextBg = UIView()
        inputTextBg.backgroundColor = .ls_color("#262638")
        inputTextBg.layer.masksToBounds = true
        inputTextBg.layer.cornerRadius = 15
        self.contentView.addSubview(inputTextBg)
        inputTextBg.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(subTitleLb.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ls_color("#7E7EA7"),
            // 可以添加其他属性，比如字体大小等
        ]
        let attributedPlaceholder = NSAttributedString(string: "Enter redemption code", attributes: attributes)
        inputText.attributedPlaceholder = attributedPlaceholder
        inputText.textColor = .white
        inputText.font = .ls_JostRomanFont(12)
        inputTextBg.addSubview(inputText)
        inputText.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        
        // 注册通知，监听键盘弹出和收起事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        

        
        confirmBtn.addTarget(self, action: #selector(clickConfirmBtn(_:)), for: .touchUpInside)
        confirmBtn.setTitle("Confirm", for: .normal)
        confirmBtn.titleLabel?.font = .ls_JostRomanFont(16)
   
        confirmBtn.layer.masksToBounds = true
        confirmBtn.layer.borderWidth = 1
        confirmBtn.layer.cornerRadius = 7
        confirmBtn.layer.borderColor = UIColor.white.cgColor
        self.contentView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputTextBg.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 156, height: 34))
        }

        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.92, green: 0.49, blue: 1, alpha: 1).cgColor, UIColor(red: 0.3, green: 0.43, blue: 1, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = CGRectMake(0, 0, 156, 34)
        confirmBtn.layer.insertSublayer(gradient1, at: 0)
    }
}

