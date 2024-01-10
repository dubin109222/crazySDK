//
//  CS_SharePlay2earnLeftView.swift
//  CrazySnake
//
//  Created by Lee on 08/05/2023.
//

import UIKit
import SwiftyAttributes

class CS_SharePlay2earnLeftView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#333333")
        view.ls_cornerRadius(5)
        return view
    }()

    lazy var infoView: CS_ShareReworadsView = {
        let view = CS_ShareReworadsView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_color("#F8F8F8")
        view.typeButton.setTitle("crazy_str_my_rewards".ls_localized, for: .normal)
        view.typeButton.setImage(.ls_named("share_icon_rewards@2x"), for: .normal)
        return view
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_boldFont(12))
        label.text = "crazy_str_balance".ls_localized
        return label
    }()
    
    lazy var balanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#3A3A3A")
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var cashLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#CCCCCC"), .ls_mediumFont(12))
        label.text = "crazy_str_cash_value".ls_localized
        return label
    }()
    
    lazy var cytLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#CCCCCC"), .ls_mediumFont(12))
        label.text = "crazy_str_cyt".ls_localized
        return label
    }()
    
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_boldFont(12))
        label.text = "crazy_str_total_withdrawn".ls_localized
        return label
    }()
    
    lazy var totalView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#3A3A3A")
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var totalCashLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#CCCCCC"), .ls_mediumFont(12))
        label.text = "crazy_str_cash_value".ls_localized
        return label
    }()
}

//MARK: data
extension CS_SharePlay2earnLeftView {
    func setData(_ data: CS_ShareDataModel) {
        infoView.cashLabel.attributedText = "+\(data.reward?.daily_cash ?? "") ".withTextColor(.ls_color("#46F490"))+"crazy_str_cash_value".ls_localized.attributedString
        infoView.cytLabel.attributedText = "+\(data.reward?.daily_cyt ?? "") ".withTextColor(.ls_color("#46F490"))+"crazy_str_cyt".ls_localized.attributedString
        cashLabel.attributedText = "crazy_str_cash_value".ls_localized.attributedString +  "  \(data.balance?.cash ?? "")  =  \((Double(data.balance?.cash ?? "0") ?? 0) / 10000)  USDT".withTextColor(.ls_white())
        cytLabel.attributedText =  "crazy_str_cyt".ls_localized.attributedString + "  ".attributedString + "\(data.balance?.cyt ?? "")".withTextColor(.ls_white())
        
        totalCashLabel.attributedText = "crazy_str_cash_value".ls_localized.attributedString +  "  \(data.reward?.total?.cash ?? "")".withTextColor(.ls_color("#AC7CFF")) + "  =  \(data.reward?.total?.cash2usdt ?? "")  USDT".attributedString
        totalCashLabel.attributedText = "crazy_str_cash_value".ls_localized.attributedString + " \(data.withdraw?.total ?? "")".withTextColor(.ls_color("#46F490")) + " = \(data.withdraw?.cash2usdt ?? "") USDT".attributedString
    }
}


//MARK: UI
extension CS_SharePlay2earnLeftView {
    
    private func setupView() {
        addSubview(backView)
        backView.addSubview(infoView)
        backView.addSubview(balanceLabel)
        backView.addSubview(balanceView)
        balanceView.addSubview(cashLabel)
        balanceView.addSubview(cytLabel)
        backView.addSubview(totalLabel)
        backView.addSubview(totalView)
        totalView.addSubview(totalCashLabel)
        
        backView.snp.makeConstraints { make in
            make.left.top.equalTo(5)
            make.right.bottom.equalTo(-5)
        }
        
        infoView.snp.makeConstraints { make in
            make.left.top.right.equalTo(backView)
            make.height.equalTo(55)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(infoView.snp.bottom).offset(10)
        }
        
        balanceView.snp.makeConstraints { make in
            make.left.equalTo(9)
            make.top.equalTo(balanceLabel.snp.bottom).offset(9)
            make.right.equalTo(-9)
            make.height.equalTo(50)
        }
        
        cashLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(8)
        }
        
        cytLabel.snp.makeConstraints { make in
            make.left.equalTo(cashLabel)
            make.bottom.equalTo(-8)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(balanceView.snp.bottom).offset(10)
        }
        
        totalView.snp.makeConstraints { make in
            make.left.equalTo(9)
            make.top.equalTo(totalLabel.snp.bottom).offset(9)
            make.right.equalTo(-9)
            make.height.equalTo(50)
        }
        
        totalCashLabel.snp.makeConstraints { make in
            make.left.equalTo(cashLabel)
            make.centerY.equalToSuperview()
        }
    }
}

class CS_ShareReworadsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    lazy var dayView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    lazy var typeButton: UIButton = {
        let button = UIButton(frame: CGRectMake(0, 0, 114, 55))
        button.isUserInteractionEnabled = false
        button.setImage(UIImage.ls_bundle("share_icon_quest_ad@2x"), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitle("crazy_str_watch_ads".ls_localized, for: .normal)
        button.setTitleColor(.ls_dark_3(), for: .normal)
        button.ls_layout(.imageTop, padding: 3)
        return button
    }()
    
    lazy var dayButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.backgroundColor = .ls_color("#3A3A3A")
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitle("crazy_str_today".ls_localized, for: .normal)
        button.setTitleColor(.ls_white(), for: .normal)
        return button
    }()
    
    lazy var cashLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        label.attributedText = "+43213".withTextColor(.ls_color("#46F490"))+" Cash value".ls_localized.attributedString
        return label
    }()
    
    lazy var cytLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        label.attributedText = "+43213".withTextColor(.ls_color("#46F490"))+" CYT".ls_localized.attributedString
        return label
    }()
    
}

//MARK: UI
extension CS_ShareReworadsView {
    
    private func setupView() {
        
        addSubview(typeButton)
        addSubview(dayView)
        dayView.addSubview(dayButton)
        dayView.addSubview(cashLabel)
        dayView.addSubview(cytLabel)
                
        typeButton.snp.makeConstraints { make in
            make.left.centerY.equalTo(self)
            make.width.equalTo(114)
            make.height.equalTo(55)
        }
        
        dayView.snp.makeConstraints { make in
            make.left.equalTo(typeButton.snp.right)
            make.top.equalTo(self).offset(2.5)
            make.right.bottom.equalTo(self).offset(-2.5)
        }
        
        dayButton.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(dayView)
            make.width.equalTo(34)
        }
        
        cashLabel.snp.makeConstraints { make in
            make.left.equalTo(47)
            make.top.equalTo(2)
        }
        
        cytLabel.snp.makeConstraints { make in
            make.left.equalTo(cashLabel)
            make.bottom.equalTo(-2)
        }
    }
}
