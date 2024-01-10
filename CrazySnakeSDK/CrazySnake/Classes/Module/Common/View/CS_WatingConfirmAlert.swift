//
//  CS_PasswordTipsAlert.swift
//  CrazySnake
//
//  Created by Lee on 28/03/2023.
//

import UIKit

class CS_WatingConfirmAlert: CS_BaseAlert {

    var clickConfrimAction: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 180, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("查看订单".ls_localized, for: .normal)
        return button
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .clear
        view.font = .ls_JostRomanFont(12)
        view.textColor = .ls_text_gray()
        view.isEditable = false
//        view.textContainerInset = UIEdgeInsets.init(top: 24, left: 16, bottom: 16, right: 16)
        return view
    }()

}

//MARK: function
extension CS_WatingConfirmAlert {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        clickConfrimAction?()
        dismissSelf()
    }
}

extension CS_WatingConfirmAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_dark_3()
        closeButton.isHidden = false
        titleLabel.text = "Tips".ls_localized
        textView.text = "有一笔订单正在确认交易中详情请查看订单列表".ls_localized
        
        contentView.addSubview(textView)
        contentView.addSubview(confirmButton)
        
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(420)
            make.height.equalTo(220)
        }

        textView.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.top.equalTo(44)
            make.right.equalTo(-50)
            make.bottom.equalTo(-60)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(-10)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
    }
    
}


