//
//  CS_ShareTableHeaderView.swift
//  CrazySnake
//
//  Created by Lee on 08/05/2023.
//

import UIKit
import SwiftyAttributes

class CS_ShareTableHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#9455E9")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_JostRomanFont(16))
        return label
    }()

    lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(5)
        view.isHidden = true
        return view
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
        label.textAlignment = .center
        return label
    }()
    
    lazy var cytLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        label.textAlignment = .right
        return label
    }()
    
}

//MARK: data
extension CS_ShareTableHeaderView {
    func setData(_ data: CS_ShareRewardModel?) {
        guard let data = data else { return }
        cashLabel.attributedText = "+\(data.daily_cash) ".withTextColor(.ls_color("#46F490"))+"crazy_str_cash_value".ls_localized.attributedString
        cytLabel.attributedText = "+\(data.daily_cyt) ".withTextColor(.ls_color("#46F490"))+"crazy_str_cyt".ls_localized.attributedString
    }
}


//MARK: UI
extension CS_ShareTableHeaderView {
    
    private func setupView() {
        addSubview(lineView)
        addSubview(titleLabel)
        addSubview(infoView)
        infoView.addSubview(dayButton)
        infoView.addSubview(cashLabel)
        infoView.addSubview(cytLabel)
        
        lineView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
            make.width.equalTo(3)
            make.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.centerY.equalTo(lineView)
        }
        
        infoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(0)
            make.width.equalTo(306)
            make.height.equalTo(25)
        }
        
        dayButton.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(infoView)
            make.width.equalTo(40)
        }
        
        cashLabel.snp.makeConstraints { make in
            make.centerY.equalTo(infoView)
            make.centerX.equalTo(infoView).multipliedBy(0.9)
        }
        
        cytLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cashLabel)
            make.right.equalTo(-11)
        }
    }
}
