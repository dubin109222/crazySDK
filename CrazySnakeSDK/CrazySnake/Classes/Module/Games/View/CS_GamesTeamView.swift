//
//  CS_GamesTeamView.swift
//  CrazySnake
//
//  Created by Lee on 17/05/2023.
//

import UIKit
import SwiftyAttributes

class CS_GamesTeamView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func updateUserRound(_ model: CS_SessionUserRoundModel) {
        userRountView.isHidden = false
        userRountView.amountLabel.attributedText = amountLabel.attributedText
        userRountView.balanceLabel.attributedText = balanceLabel.attributedText
        userRountView.statusLabel.isHidden = model.status != -1
        userRountView.betAmountLabel.attributedText = "\(model.amount) ".withTextColor(.ls_color("#00FFB5")).withFont(.ls_font(16)) + TokenName.Diamond.name().attributedString
    }
    
    lazy var backView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("games_bg_red_team@2x")
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("games_icon_red_team@2x")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(19))
        label.attributedText = "Red".withTextColor(.ls_color("#E94F73")) + " Team".attributedString
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_gray(), .ls_JostRomanFont(12))
        label.attributedText = "Red Supporters".attributedString + " -".withTextColor(.ls_white())
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_gray(), .ls_JostRomanFont(16))
        label.attributedText = "-".withTextColor(.ls_color("#C7A6F9")) + TokenName.Diamond.name().withFont(.ls_JostRomanFont(12))
        return label
    }()
    
    lazy var supportButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 180, height: 34))
//        button.addTarget(self, action: #selector(clickSupportButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_support".ls_localized, for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var userRountView: CS_GamesUserRountView = {
        let view = CS_GamesUserRountView()
        view.isHidden = true
        return view
    }()
}

//MARK: action
extension CS_GamesTeamView {
    @objc private func clickSupportButton(_ sender: UIButton) {
        
    }
}


//MARK: UI
extension CS_GamesTeamView {
    
    private func setupView() {
        addSubview(backView)
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(amountLabel)
        addSubview(balanceLabel)
        addSubview(supportButton)
        addSubview(userRountView)
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.top.equalTo(10)
            make.width.height.equalTo(17)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(5)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(amountLabel.snp.bottom).offset(24)
        }
        
        supportButton.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.bottom.equalTo(-10)
            make.width.equalTo(180)
            make.height.equalTo(34)
        }
        
        userRountView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(34)
        }
    }
}


class CS_GamesUserRountView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2()
        view.ls_cornerRadius(15)
        view.ls_border(color: .ls_color("#AC7CFF"))
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_gray(), .ls_JostRomanFont(12))
        label.attributedText = "Red Supporters".attributedString + " -".withTextColor(.ls_white())
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_gray(), .ls_JostRomanFont(16))
        label.attributedText = "-".withTextColor(.ls_color("#C7A6F9")) + TokenName.Diamond.name().withFont(.ls_JostRomanFont(12))
        return label
    }()
    
    lazy var selectedLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .center
        label.text = "Selected".ls_localized
        label.backgroundColor = .ls_dark_3()
        label.ls_cornerRadius(7)
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#E18456"), .ls_font(10))
        label.textAlignment = .center
        label.ls_border(color: .ls_color("#E18456"))
        label.text = "crazy_str_confirming".ls_localized
        label.ls_cornerRadius(10)
        label.isHidden = true
        return label
    }()
    
    lazy var betAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        return label
    }()
}


//MARK: UI
extension CS_GamesUserRountView {
    
    private func setupView() {
        addSubview(backView)
        addSubview(amountLabel)
        addSubview(balanceLabel)
        addSubview(selectedLabel)
        addSubview(statusLabel)
        addSubview(betAmountLabel)
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(19)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.left.equalTo(amountLabel)
            make.top.equalTo(amountLabel.snp.bottom).offset(4)
        }
        
        selectedLabel.snp.makeConstraints { make in
            make.left.equalTo(amountLabel)
            make.bottom.equalTo(betAmountLabel.snp.top).offset(-2)
            make.width.equalTo(74)
            make.height.equalTo(24)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(selectedLabel)
            make.left.equalTo(selectedLabel.snp.right).offset(24)
            make.width.equalTo(74)
            make.height.equalTo(20)
        }
        
        betAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(amountLabel)
            make.bottom.equalTo(-12)
        }
    }
}
