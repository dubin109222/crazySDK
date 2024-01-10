//
//  CS_NFTStakeChooseAlert.swift
//  CrazySnake
//
//  Created by Lee on 14/03/2023.
//

import UIKit

class CS_NFTStakeChooseAlert: CS_BaseAlert {
    
    var isMock = false
    
    var clickSingleAction: CS_NoParasBlock?
    var clickSetAction: CS_NoParasBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var singleView: CS_NFTStakeChooseItemView = {
        let view = CS_NFTStakeChooseItemView(frame: CGRect(x: 0, y: 0, width: 215, height: 110))
        view.addTarget(self, action: #selector(clickSingleButton(_:)), for: .touchUpInside)
        view.titleLabel2.backgroundColor = .ls_color("#FFCEA3")
        view.titleLabel2.text = "crazy_str_nft_stake_single_nft".ls_localized
        view.labelIcon.image = UIImage.ls_bundle("nft_icon_stake_nft_single@2x")
        view.iconView.image = UIImage.ls_bundle("nft_icon_stake_nft_single_icon@2x")
        view.layer.shadowColor = UIColor(red: 1, green: 0.81, blue: 0.64, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 15
        view.backgroundColor = .ls_color("#201D27")
        view.layer.cornerRadius = 15
        return view
    }()
    
    public lazy var setView: CS_NFTStakeChooseItemView = {
        let view = CS_NFTStakeChooseItemView(frame: CGRect(x: 0, y: 0, width: 215, height: 110))
        view.addTarget(self, action: #selector(clickSetButton(_:)), for: .touchUpInside)
        view.titleLabel2.backgroundColor = .ls_color("#C1A3FF")
        view.titleLabel2.text = "crazy_str_nft_stake_nft_set".ls_localized
        view.labelIcon.image = UIImage.ls_bundle("nft_icon_stake_nft_set@2x")
        view.iconView.image = UIImage.ls_bundle("nft_icon_stake_nft_set_icon@2x")
        view.layer.shadowColor = UIColor(red: 0.83, green: 0.74, blue: 1, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 15
        view.backgroundColor = .ls_color("#201D27")
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .center
        label.text = "Click on an empty area to close"
        return label
    }()
    
}

//MARK: action
extension CS_NFTStakeChooseAlert {
    @objc private func clickSingleButton(_ sender: UIButton) {
        dismissSelf()
        clickSingleAction?()
    }
    
    @objc private func clickSetButton(_ sender: UIButton) {
        dismissSelf()
        clickSetAction?()
    }
}

//MARK: UI
extension CS_NFTStakeChooseAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.8)
        
        addSubview(singleView)
        addSubview(setView)
        addSubview(tipsLabel)
        
        singleView.snp.makeConstraints { make in
            make.right.equalTo(backView.snp.centerX).offset(-22)
            make.centerY.equalToSuperview()
            make.width.equalTo(215)
            make.height.equalTo(110)
        }
        
        setView.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(singleView)
            make.left.equalTo(singleView.snp.right).offset(44)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}


class CS_NFTStakeChooseItemView: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLabel2: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_JostRomanFont(16))
        label.textAlignment = .center
        label.ls_cornerRadius(4)
        return label
    }()
    
    lazy var stakingLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(24))
        label.textAlignment = .center
        label.text = "crazy_str_staking".ls_localized
        return label
    }()
    
    lazy var labelIcon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
}

//MARK: UI
extension CS_NFTStakeChooseItemView {
    
    private func setupView() {
        
        addSubview(titleLabel2)
        addSubview(labelIcon)
        addSubview(stakingLabel)
        addSubview(iconView)
        
        titleLabel2.snp.makeConstraints { make in
            make.left.equalTo(17)
            make.top.equalTo(27)
            make.width.equalTo(94)
            make.height.equalTo(20)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-4)
            make.width.height.equalTo(95)
        }
        
        labelIcon.snp.makeConstraints { make in
            make.right.equalTo(iconView.snp.left).offset(-12)
            make.bottom.equalTo(iconView.snp.bottom).offset(-13)
            make.width.equalTo(40)
            make.height.equalTo(17)
        }
        
        stakingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel2)
            make.top.equalTo(titleLabel2.snp.bottom).offset(12)
        }
        
    }
}
