//
//  CS_NFTStakeInfoItemView.swift
//  CrazySnake
//
//  Created by Lee on 13/03/2023.
//

import UIKit

class CS_NFTStakeInfoItemView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#999999"), .ls_JostRomanFont(11))
        label.textAlignment = .center
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        return label
    }()
    
    lazy var helpIcon: UIImageView = {
        let helpIcon = UIImageView()
        helpIcon.image = .ls_bundle("airDrop_help_icon@2x")
        helpIcon.isHidden = true
        return helpIcon
    }()
}

//MARK: UI
extension CS_NFTStakeInfoItemView {
    
    private func setupView() {
        backgroundColor = .ls_dark_2()
//        ls_cornerRadius(5)
        
        addSubview(titleLabel)
        addSubview(amountLabel)
        addSubview(helpIcon)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(4)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(22)
        }
        helpIcon.snp.makeConstraints { make in
            make.centerY.equalTo(amountLabel)
            make.left.equalTo(amountLabel.snp.right).offset(2)
            make.size.equalTo(24)
        }
        
    }
}

class CS_NFTStakeInfoRewardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_token_land@2x")
        view.isHidden = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(11))
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        return label
    }()
}

//MARK: UI
extension CS_NFTStakeInfoRewardView {
    
    private func setupView() {
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(amountLabel)
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.left.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(22)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4.5)

        }
        
    }
}



class CS_NFTStakeInfoRewardView2: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_token_snake@2x")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#999999"), .ls_JostRomanFont(11))
        return label
    }()
    
    lazy var amountView: UIView = {
        let amountView = UIView()
        amountView.backgroundColor = .ls_color("#2B2B2B")
        amountView.layer.cornerRadius = 11
        amountView.layer.masksToBounds = true

        return amountView
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        return label
    }()
}

//MARK: UI
extension CS_NFTStakeInfoRewardView2 {
    
    private func setupView() {
        
        addSubview(amountView)
        addSubview(amountLabel)
        addSubview(iconView)
        addSubview(titleLabel)
        
        
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(11)
            make.top.equalToSuperview()
        }
        
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4.5)
            make.left.equalToSuperview()
            make.width.height.equalTo(22)
        }
        
        amountView.snp.makeConstraints { make in
            make.left.equalTo(iconView).offset(11)
            make.top.bottom.equalTo(iconView)
            make.right.equalToSuperview()
        }
        amountLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(iconView)
            make.right.equalTo(amountView)
            make.left.equalTo(iconView.snp.right).offset(2)
        }
        
    }
}
