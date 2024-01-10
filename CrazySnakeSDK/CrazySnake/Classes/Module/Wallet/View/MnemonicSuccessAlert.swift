//
//  MnemonicSuccessAlert.swift
//  Platform
//
//  Created by Lee on 24/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit

class MnemonicSuccessAlert: CS_BaseAlert {

   
    var clickConfirmBlock: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_color("#2B728C"), UIFont.ls_font(12))
        label.numberOfLines = 0
        label.text = "Crazysnake \nStart your CrazySnake journey"
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_alert_ok"), for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        return button
    }()
    
}

//MARK: action
extension MnemonicSuccessAlert {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        dismissSelf()
        if let block = clickConfirmBlock {
            block()
        }
    }
}


//MARK: UI
extension MnemonicSuccessAlert {
    
    private func setupView() {
        titleLabel.text = "Success"
        titleLabel.textColor = UIColor.ls_color("#53BCDB")
        closeButton.isHidden = true
        tapDismissEnable = false
        
        contentView.addSubview(tipsLabel)
        contentView.addSubview(confirmButton)
        contentView.bringSubviewToFront(closeButton)
                
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.top.equalTo(42)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView.snp.bottom).offset(-8)
        }
    }
}
