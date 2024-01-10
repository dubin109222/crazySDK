//
//  CS_NFTUpgradeInfoView.swift
//  CrazySnake
//
//  Created by Lee on 02/03/2023.
//

import UIKit

class CS_NFTUpgradeInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTDataModel) {
        
        guard let current = model.evolve?.current_level,let next = model.evolve?.next_level else { return }
        
        topItemView.oldStar.showRightStar(current.num, color: model.qualityColor(),image: current.iconImage())
        topItemView.willStar.showStar(next.num, color: model.qualityColor(),image: next.iconImage())
        sencondItemView.oldLabel.text = "\(model.evolve?.current_level?.power ?? 0)"
        sencondItemView.willLabel.text = "\(model.evolve?.next_level?.power ?? 0)"
    }
    
    lazy var topItemView: CS_NFTUpgradeInfoStarView = {
        let view = CS_NFTUpgradeInfoStarView()
        view.titleLabel.text = "crazy_str_nft_upgrade_stage".ls_localized
        return view
    }()
    
    lazy var sencondItemView: CS_NFTUpgradeInfoItemView = {
        let view = CS_NFTUpgradeInfoItemView()
        view.titleLabel.text = "crazy_str_nft_hash_bonus".ls_localized
        return view
    }()
    
    lazy var bottomBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2()
        return view
    }()
    
    lazy var bottomTitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.text = "crazy_str_upgrade_orb".ls_localized
        return label
    }()
    
    lazy var bottomIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_icon_essence_advance@2x")
        return view
    }()
    
    lazy var bottomAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#EE7E3B"), .ls_JostRomanFont(16))
//        label.text = "100"
        return label
    }()

}

//MARK: UI
extension CS_NFTUpgradeInfoView {
    
    private func setupView() {
        
        backgroundColor = .ls_dark_2(0.8)
        ls_cornerRadius(15)
        
        addSubview(topItemView)
        addSubview(sencondItemView)
        addSubview(bottomBackView)
        addSubview(bottomTitleLabel)
        addSubview(bottomIcon)
        addSubview(bottomAmountLabel)
        
        topItemView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(6)
            make.height.equalTo(45)
        }
        
        sencondItemView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topItemView.snp.bottom)
            make.height.equalTo(45)
        }
        
        bottomBackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(38)
        }
        
        bottomTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackView)
            make.left.equalTo(45)
        }
                
        bottomIcon.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackView)
            make.left.equalTo(bottomBackView).offset(133)
            make.width.height.equalTo(32)
        }
        
        bottomAmountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackView)
            make.left.equalTo(bottomIcon.snp.right).offset(6)
        }
    }
}

class CS_NFTUpgradeInfoItemView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var oldLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .center
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "icon_NFTLab_alert_arrow@2x")
        return view
    }()
    
    lazy var willLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#46F490"), .ls_JostRomanFont(16))
        label.textAlignment = .center
        return label
    }()

}

//MARK: UI
extension CS_NFTUpgradeInfoItemView {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(oldLabel)
        addSubview(iconView)
        addSubview(willLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(45)
            make.top.equalTo(0)
        }
        
        oldLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalTo(oldLabel)
            make.left.equalTo(126)
            make.width.height.equalTo(14)
        }
        
        willLabel.snp.makeConstraints { make in
            make.centerY.equalTo(oldLabel)
            make.left.equalTo(iconView.snp.right).offset(8)
            make.right.equalTo(-8)
        }
    }
}

class CS_NFTUpgradeInfoStarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var oldStar: CS_NFTStarView = {
        let label = CS_NFTStarView()
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "icon_NFTLab_alert_arrow@2x")
        return view
    }()
    
    lazy var willStar: CS_NFTStarView = {
        let label = CS_NFTStarView()
        return label
    }()

}

//MARK: UI
extension CS_NFTUpgradeInfoStarView {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(oldStar)
        addSubview(iconView)
        addSubview(willStar)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(45)
            make.top.equalTo(0)
        }
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalTo(126)
            make.width.height.equalTo(14)
        }
        
        oldStar.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.right.equalTo(iconView.snp.left).offset(-10)
            make.width.equalTo(94)
            make.height.equalTo(12)
        }
        
        willStar.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(10)
            make.width.equalTo(94)
            make.height.equalTo(12)
        }
    }
}

