//
//  CS_GasCoinInsufficientAlert.swift
//  CrazySnake
//
//  Created by Lee on 10/04/2023.
//

import UIKit

class CS_GasCoinInsufficientAlert: CS_BaseAlert {

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
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.numberOfLines = 0
        label.text = "1.You can swap Gas Coin in “Swap”\n2.You can swap Gas Coin in games"
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 160, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("Swap now!".ls_localized, for: .normal)
        return button
    }()
}

//MARK: action
extension CS_GasCoinInsufficientAlert {
    
    @objc private func clickConfirmButton(_ sender: UIButton) {
//        clickConfirmAction?()
        self.dismissSelf()
        let vc = CS_SwapController()
        vc.selectedIndex = 1
//        UIViewController.current()?.navigationController?.pushViewController(vc, animated: true)
        CrazyPlatform.pushTo(vc)
    }
}


//MARK: UI
extension CS_GasCoinInsufficientAlert {
    private func setupView() {
        tapDismissEnable = false
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_color("#201D27")
        contentView.addSubview(contentLabel)
        contentView.addSubview(confirmButton)
        titleLabel.text = "Gas Coin Insufficient"
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(-12)
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        
        contentView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self).offset(-20)
            make.width.equalTo(420)
            make.height.equalTo(200)
        }
    }
}
