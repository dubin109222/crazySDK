//
//  CS_AirDropDetails.swift
//  CrazySnake
//
//  Created by BigB on 2023/7/11.
//
//  空投说明

import UIKit
import SnapKit

class CS_AirDropDetailsAlert: CS_BaseAlert {
    
    var data : CS_NFTStakeInfoAirDropModel? {
        didSet {
            currentLevel.tokenLb.text = "\(data?.cur?.airdrop ?? 0)"
            currentLevel.currentLevelLb.text = "\(data?.cur?.pow_left ?? 0) - \(data?.cur?.pow_right ?? 0)"
            if data?.next == nil {
                nextLevel.isHidden = true
                nextIcon.image = nil
                nextIcon.backgroundColor = .ls_color(0x000000, alpha: 0.1)
                nextIcon.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(13.5)
                    make.right.equalToSuperview().offset(-13.5)
                    make.height.equalTo(1)
                    make.top.equalTo(currentLevel.snp.bottom).offset(10)
                }
            } else {
                nextLevel.tokenLb.text = "\(data?.next?.airdrop ?? 0)"
                nextLevel.currentLevelLb.text = "\(data?.next?.pow_left ?? 0) - \(data?.next?.pow_right ?? 0)"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.snp.remakeConstraints { make in
            make.left.equalTo(197)
            make.right.equalTo(-104)
            make.bottom.equalTo(-75.5)
            make.top.equalTo(80.5)
        }

        self.initSubViews()
        closeButton.isHidden = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let currentLevel : LevelView = LevelView()
    let nextLevel : LevelView = LevelView()
    let nextIcon = UIImageView()

    func initSubViews()  {
        self.contentView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 366, height: 219))
        }
        
        let titleLb = UILabel()
        titleLb.text = "Airdrop Details"
        titleLb.textColor = .white
        titleLb.font = .ls_JostRomanFont(16)
        
        self.contentView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(18)
        }
        
        let desLb = UILabel()
        desLb.textColor = .ls_color("#999999")
        desLb.font = .ls_JostRomanFont(11)
        desLb.numberOfLines = 0
        desLb.text = """
When the total staking power reaches the value shown,
the amount of tokens bellow will be airdropped
"""
        self.contentView.addSubview(desLb)
        desLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(titleLb.snp.bottom).offset(4.5)
        }
        currentLevel.titleLb.text = "Actual Hash power"
        currentLevel.layer.masksToBounds = true
        currentLevel.layer.cornerRadius = 15
        self.contentView.addSubview(currentLevel)
        currentLevel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(9.5)
            make.right.equalToSuperview().offset(-9.5)
            make.top.equalTo(desLb.snp.bottom).offset(12)
            make.height.equalTo(55)
        }
        
        nextIcon.image = .ls_bundle("level_next_icon@2x")
        self.contentView.addSubview(nextIcon)
        nextIcon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 14, height: 12.5))
            make.top.equalTo(currentLevel.snp.bottom).offset(6.5)
            make.centerX.equalToSuperview()
        }
        
        // 无下一等级Label，遮在最底部
        let maxTipsLb = UILabel()
        maxTipsLb.text = "No next hash power level available"
        maxTipsLb.textColor = UIColor.ls_color("#999999")
        maxTipsLb.font = .ls_JostRomanFont(11)
        self.contentView.addSubview(maxTipsLb)
        maxTipsLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-35.5)
        }
        
        nextLevel.titleLb.text = "Next Hash level"
        nextLevel.layer.masksToBounds = true
        nextLevel.layer.cornerRadius = 15
        nextLevel.layer.borderColor = UIColor.ls_color("#F3E5FF",alpha: 0.1).cgColor
        nextLevel.layer.borderWidth = 2
        self.contentView.addSubview(nextLevel)
        nextLevel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(9.5)
            make.right.equalToSuperview().offset(-9.5)
            make.bottom.equalToSuperview().offset(-10.5)
            make.height.equalTo(55)
        }
        nextLevel.currentLevelLb.textColor = UIColor.ls_color("#C163FD")
                
    }
}

class LevelView : UIView {
    
    let currentLevelLb = UILabel()
    let tokenLb = UILabel()
    let titleLb = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.ls_color("#2B2B2B")
        
        let rightBgView = UIImageView()
        rightBgView.image = .ls_named("level_right_bg@2x")
        self.addSubview(rightBgView)
        rightBgView.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(162)
        }
        
        titleLb.font = .ls_JostRomanFont(14)
        titleLb.textColor = .white
        titleLb.text = "Actual Hash power"
        self.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.5)
            make.left.equalToSuperview().offset(13.5)
        }
        
        let icon = UIImageView()
        icon.image = .ls_bundle("level_view_icon@2x")
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 17))
            make.bottom.equalToSuperview().offset(-7.5)
            make.left.equalTo(titleLb)
        }
        
        let hashTitle = UILabel()
        hashTitle.text = "Hash"
        hashTitle.font = .ls_JostRomanFont(11)
        hashTitle.textColor = .ls_color("#999999")
        self.addSubview(hashTitle)
        hashTitle.snp.makeConstraints { make in
            make.top.equalTo(icon).offset(5)
            make.left.equalTo(icon.snp.right).offset(6.5)
        }
        
        currentLevelLb.font = .ls_JostRomanFont(14)
        currentLevelLb.textColor = .white
        self.addSubview(currentLevelLb)
        currentLevelLb.snp.makeConstraints { make in
            make.left.equalTo(hashTitle.snp.right).offset(14)
            make.centerY.equalTo(hashTitle)
        }
        
        let snakeLb = UILabel()
        snakeLb.textColor = .white
        snakeLb.text = "Snake Airdrop"
        self.addSubview(snakeLb)
        snakeLb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-26)
            make.top.equalToSuperview().offset(8.5)
        }
        
        let tokenView = UIView()
        self.addSubview(tokenView)
        
        let tokenIcon = UIImageView()
        tokenIcon.image = TokenName.Snake.icon()
        tokenView.addSubview(tokenIcon)
        tokenIcon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.size.equalTo(14)
        }
        
        tokenLb.font = .ls_JostRomanFont(14)
        tokenLb.textColor = .ls_color("#FFE405")
        tokenView.addSubview(tokenLb)
        tokenLb.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(tokenIcon.snp.right).offset(5.5)
            make.centerY.equalTo(tokenIcon)
        }
        
        tokenView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-9.5)
            make.centerX.equalTo(snakeLb)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
