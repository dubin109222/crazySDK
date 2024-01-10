//
//  CS_GameAmountInputAlert.swift
//  CrazySnake
//
//  Created by Lee on 22/05/2023.
//

import UIKit
import SwiftyAttributes

class CS_GameAmountInputAlert: CS_BaseAlert {

    typealias CS_AmountBlock = (String) -> Void
    var clickConfrimAction: CS_AmountBlock?
    
    var sessionConfig: CS_SessionConfigModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        tapDismissEnable = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        let amount = Utils.formatAmount(TokenName.Diamond.balance()) + " " + TokenName.Diamond.name()
        // FIXME: 这里需要修改的
        label.attributedText = "Balance".ls_localized.attributedString + ": ".attributedString + amount.withTextColor(.ls_white())
//        weakSelf?.timesLabel.attributedText = "crazy_str_exchange_time_content".ls_localized_color([" \(model.left_times)"])

        return label
    }()
    
    lazy var inputLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.text = "Input Support Amount".ls_localized
        return label
    }()
    
    lazy var amountInputView: CS_StakeAmountInputView = {
        let view = CS_StakeAmountInputView()
        view.backgroundColor = .ls_color("#2F293F")
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 180, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_confirm".ls_localized, for: .normal)
        return button
    }()
    
}

//MARK: function
extension CS_GameAmountInputAlert {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        guard let amount = amountInputView.textField.text, amount.count > 0 else { return }
        
        let balance = TokenName.Diamond.balance()
        guard Double(balance) ?? 0 >= Double(amount) ?? 0 else {
            LSHUD.showError("Insufficient balance".ls_localized)
            return
        }
        
        if let config = sessionConfig {
            guard Double(config.bet_min) ?? 0 <= Double(amount) ?? 0 else {
                LSHUD.showError("Bet min is: \(config.bet_min)")
                return
            }
            
            guard Double(config.bet_max) ?? 0 >= Double(amount) ?? 0 else {
                LSHUD.showError("Bet max is: \(config.bet_max)")
                return
            }
        }
        
        clickConfrimAction?(amount)
        dismissSelf()
    }
}

extension CS_GameAmountInputAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_dark_3()
        closeButton.isHidden = false
        titleLabel.text = "Bidding Area".ls_localized
        
        contentView.addSubview(balanceLabel)
        contentView.addSubview(inputLabel)
        contentView.addSubview(amountInputView)
        contentView.addSubview(confirmButton)
        
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(223)
            make.height.equalTo(227)
        }
        
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.centerY.equalTo(closeButton)
        }

        balanceLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(46)
            make.right.equalTo(-20)
        }
        
        inputLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(88)
            make.right.equalTo(-20)
        }
        
        amountInputView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(-24)
            make.top.equalTo(inputLabel.snp.bottom).offset(4)
            make.height.equalTo(30)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(-10)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
    }
    
}
