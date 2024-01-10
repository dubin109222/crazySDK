//
//  CS_ConfirmAlert.swift
//  Platform
//
//  Created by Lee on 04/12/2021.
//  Copyright © 2021 ELFBOX. All rights reserved.
//

import UIKit

class CS_ConfirmAlert: CS_BaseAlert {
    
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
        label.ls_set(UIColor.ls_dark(), UIFont.ls_font(16))
        label.numberOfLines = 0
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 180, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_ok".ls_localized, for: .normal)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickCloseButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_cancel".ls_localized, for: .normal)
        button.backgroundColor = .ls_gray(0.8)
        button.ls_cornerRadius(7)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        return button
    }()
}

//MARK: action
extension CS_ConfirmAlert {
    
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
extension CS_ConfirmAlert {
    private func setupView() {
        tapDismissEnable = false
        closeButton.isHidden = false
        backView.backgroundColor = .ls_black(0.8)
        contentView.layer.shadowColor = UIColor.clear.cgColor
        contentView.ls_border(color: .ls_gray(0.6),width: 2)
        contentView.addSubview(contentLabel)
        contentView.addSubview(cancelButton)
        contentView.addSubview(confirmButton)
        
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(420)
            make.height.equalTo(220)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView).offset(-20)
//            make.top.equalTo(40)
//            make.bottom.equalTo(-60)
            make.left.equalTo(titleLabel)
            make.right.equalTo(-32)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalTo(-64)
            make.bottom.equalTo(-16)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.right.equalTo(confirmButton.snp.left).offset(-32)
            make.top.height.equalTo(confirmButton)
            make.width.equalTo(80)
        }
        
    }
}
