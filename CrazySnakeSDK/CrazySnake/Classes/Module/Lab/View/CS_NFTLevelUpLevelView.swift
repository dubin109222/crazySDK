//
//  CS_NFTLevelUpLevelView.swift
//  CrazySnake
//
//  Created by Lee on 01/03/2023.
//

import UIKit

class CS_NFTLevelUpLevelView: UIView {
    
    var nftModel: CS_NFTDataModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateExperience(_ amount: Int) {
        let cureent: Double = Double(nftModel?.current_experience ?? 0)
        let need: Double = Double(nftModel?.experience ?? 0)
        let totel = need
        if totel <= 0 {
            return
        }
        
        let cureentMulti = cureent/totel
        var willMulti = (cureent+Double(amount))/totel
        if willMulti > 1 {
            willMulti = 1
        }
        experienceLabel.text = "\(Int(cureent)+amount)/\(Int(totel))"
        levelWillView.snp.remakeConstraints { make in
            make.left.top.bottom.equalTo(levelBackView)
            make.width.equalTo(levelBackView.snp.width).multipliedBy(willMulti)
        }
        
        levelNowView.snp.remakeConstraints { make in
            make.left.top.bottom.equalTo(levelBackView)
            make.width.equalTo(levelBackView.snp.width).multipliedBy(cureentMulti)
        }
    }
    
    func setData(_ model: CS_NFTDataModel) {
        nftModel = model
        levelNowLabel.text = "Lv.\(model.level)"
        if model.upgrade?.next_bonus == nil {
            levelWillLabel.text = "crazy_str_max".ls_localized
        } else {
            levelWillLabel.text = "Lv.\(model.level + 1)"
        }
        
        hashNowLabel.text = "Hash \(model.total_power)"
        hashWillLabel.isHidden = model.upgrade?.next_bonus == nil
        hashWillLabel.text = "\(model.upgrade?.next_level?.power ?? 0)"
        updateExperience(0)
    }
    
    lazy var levelBackView: UIImageView = {
        let view = UIImageView()
        view.ls_cornerRadius(10)
        view.ls_border(color: .ls_color("#BABABA"),width: 2)
        view.backgroundColor = .ls_white()
        return view
    }()
    
    lazy var levelWillView: UIImageView = {
        let view = UIImageView()
        view.ls_cornerRadius(10)
        view.backgroundColor = .ls_color("#BABBBB")
        return view
    }()
    
    lazy var levelNowView: UIImageView = {
        let view = UIImageView()
        view.ls_cornerRadius(10)
        view.backgroundColor = .ls_dark_4()
        return view
    }()
    
    lazy var experienceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_purpose_01(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()
    
    lazy var levelNowLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_font(14))
        label.text = "Lv."
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var levelWillLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_font(14))
        label.textAlignment = .right
        label.text = "Lv."
        return label
    }()
    
    lazy var hashNowLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_JostRomanFont(14))
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var hashIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("lab_icon_levelup_hash@2x")
        return view
    }()
    
    lazy var hashWillLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#7A56E1"), .ls_JostRomanFont(14))
        return label
    }()
}

//MARK: UI
extension CS_NFTLevelUpLevelView {
    
    private func setupView() {
        addSubview(levelBackView)
        addSubview(levelWillView)
        addSubview(levelNowView)
        addSubview(levelNowLabel)
        addSubview(levelWillLabel)
        addSubview(experienceLabel)
        addSubview(hashNowLabel)
        addSubview(hashIcon)
        addSubview(hashWillLabel)
        
        levelBackView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        levelWillView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(levelBackView)
            make.width.equalTo(levelBackView.snp.width).multipliedBy(0)
        }
        
        levelNowView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(levelBackView)
            make.width.equalTo(levelBackView.snp.width).multipliedBy(0)
        }
        
        experienceLabel.snp.makeConstraints { make in
            make.center.equalTo(levelBackView)
        }
        
        levelNowLabel.snp.makeConstraints { make in
            make.left.equalTo(levelBackView)
            make.bottom.equalTo(levelBackView.snp.top).offset(-6)
        }
        
        levelWillLabel.snp.makeConstraints { make in
            make.right.equalTo(levelBackView)
            make.centerY.equalTo(levelNowLabel)
        }
        
        hashIcon.snp.makeConstraints { make in
            make.centerX.equalTo(levelBackView).offset(16)
            make.centerY.equalTo(levelNowLabel)
        }
        
        hashNowLabel.snp.makeConstraints { make in
            make.right.equalTo(hashIcon.snp.left).offset(-10)
            make.left.greaterThanOrEqualTo(levelNowLabel.snp.right)
            make.centerY.equalTo(levelNowLabel)
        }
        
        hashWillLabel.snp.makeConstraints { make in
            make.left.equalTo(hashIcon.snp.right).offset(10)
            make.centerY.equalTo(levelNowLabel)
        }
    }
}
