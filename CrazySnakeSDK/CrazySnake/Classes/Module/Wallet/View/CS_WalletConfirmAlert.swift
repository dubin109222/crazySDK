//
//  CS_WalletConfirmAlert.swift
//  CrazySnake
//
//  Created by Lee on 12/07/2023.
//

import UIKit

class CS_WalletConfirmAlert: CS_BaseAlert {
    
    var clickConfirmAction: CS_NoParasBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_text_gray(), UIFont.ls_font(12))
        label.numberOfLines = 0
        return label
    }()
    
    lazy var lineHori: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_white(0.05)
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_ok".ls_localized, for: .normal)
        button.titleLabel?.font = .ls_mediumFont(14)
        button.setTitleColor(.ls_white(), for: .normal)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickCloseButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_cancel".ls_localized, for: .normal)
        button.titleLabel?.font = .ls_mediumFont(14)
        button.setTitleColor(.ls_white(), for: .normal)
        return button
    }()
    
    lazy var lineVer: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_white(0.05)
        return view
    }()
}

//MARK: action
extension CS_WalletConfirmAlert {
    
    func show(_ title: String?, content: String?, showCancel: Bool = true) {
        self.titleLabel.text = title
        self.contentLabel.text = content
        
        if showCancel == false {
            cancelButton.isHidden = true
            confirmButton.snp.remakeConstraints { make in
                make.centerX.equalTo(contentView)
                make.bottom.equalTo(-10)
                make.width.equalTo(180)
                make.height.equalTo(40)
            }
        }
        
        self.show()
    }
    
    @objc private func clickConfirmButton(_ sender: UIButton) {
        clickConfirmAction?()
        self.dismissSelf()
    }
}


//MARK: UI
extension CS_WalletConfirmAlert {
    private func setupView() {
        tapDismissEnable = false
        closeButton.isHidden = true
        backView.backgroundColor = .ls_black(0.7)
        contentView.backgroundColor = .ls_color("#1E1E20")
        contentView.layer.shadowColor = UIColor.clear.cgColor
        contentView.addSubview(contentLabel)
        contentView.addSubview(lineHori)
        contentView.addSubview(cancelButton)
        contentView.addSubview(lineVer)
        contentView.addSubview(confirmButton)
        
//        contentView.snp.remakeConstraints { make in
//            make.centerX.equalTo(self)
//            make.top.equalTo(self.snp.centerY).offset(-120)
//            make.width.equalTo(294)
//            make.height.equalTo(154)
//        }
        
        titleLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(52)
            make.left.equalTo(35)
            make.right.equalTo(-35)
        }
        
        lineHori.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(contentLabel.snp.bottom).offset(21)
            make.height.equalTo(1)
        }
        
        lineVer.snp.makeConstraints { make in
            make.top.equalTo(lineHori.snp.bottom)
            make.centerX.equalTo(lineHori)
            make.height.equalTo(45)
            make.width.equalTo(1)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.height.equalTo(45)
            make.left.equalTo(lineVer.snp.right)
            make.top.equalTo(lineHori.snp.bottom)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.height.equalTo(confirmButton)
            make.right.equalTo(lineVer.snp.left)
            make.top.equalTo(confirmButton)
        }
        
        contentView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(294)
            make.centerY.equalTo(self.snp.centerY).offset(-24)
            make.bottom.equalTo(confirmButton)
        }
        
    }
}

