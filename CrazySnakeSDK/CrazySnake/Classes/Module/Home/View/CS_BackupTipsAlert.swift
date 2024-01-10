//
//  CS_BackupTipsAlert.swift
//  CrazySnake
//
//  Created by Lee on 28/03/2023.
//

import UIKit

class CS_BackupTipsAlert: CS_BaseAlert {

    var clickSkipAction: CS_NoParasBlock?
    var clickConfrimAction: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_backup_tips@2x")
        return view
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickSkipButton(_:)), for: .touchUpInside)
        button.backgroundColor = .ls_color("#555555")
        button.ls_cornerRadius(7)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_text_gray(), for: .normal)
        button.setTitle("crazy_str_skip".ls_localized, for: .normal)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 174, height: 44))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_backup".ls_localized, for: .normal)
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
extension CS_BackupTipsAlert {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        clickConfrimAction?()
        dismissSelf()
    }
    
    @objc private func clickSkipButton(_ sender: UIButton) {
        clickSkipAction?()
        dismissSelf()
    }
}

extension CS_BackupTipsAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_dark_3()
        closeButton.isHidden = false
        titleLabel.text = "crazy_str_backup_reminder".ls_localized
        textView.text = "crazy_str_dialog_backup_reminder_desc".ls_localized
        
        contentView.addSubview(iconView)
        contentView.addSubview(textView)
        contentView.addSubview(skipButton)
        contentView.addSubview(confirmButton)
        
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(420)
            make.height.equalTo(220)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.centerY.equalTo(closeButton)
            make.width.height.equalTo(18)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(contentView).offset(60)
            make.centerY.equalTo(iconView)
        }

        textView.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.top.equalTo(44)
            make.right.equalTo(-50)
            make.bottom.equalTo(-68)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).offset(40)
            make.bottom.equalTo(-10)
            make.width.equalTo(174)
            make.height.equalTo(44)
        }
        
        skipButton.snp.makeConstraints { make in
            make.right.equalTo(confirmButton.snp.left).offset(-30)
            make.centerY.equalTo(confirmButton)
            make.width.equalTo(63)
            make.height.equalTo(44)
        }
    }
    
}



