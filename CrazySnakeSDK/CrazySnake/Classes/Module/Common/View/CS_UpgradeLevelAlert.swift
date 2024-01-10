//
//  CS_UpgradeLevelAlert.swift
//  CrazySnake
//
//  Created by BigB on 2023/9/27.
//

import UIKit
import SnapKit
import HandyJSON

struct BlankContent: HandyJSON {
    
}

struct DispatchLevelModel: HandyJSON {
    var max_nft: String = "0"
    var level: String = "0"
    var adventure_scale: String = "0"
    var need_adventure: String = "0"
}

struct UpgradeLevelModel: HandyJSON {
    var next: DispatchLevelModel?
    var current: DispatchLevelModel?
}

class CS_UpgradeLevelAlert: CS_BaseAlert {
    
    var data : NFT_DisPatch_Team? {
        didSet {
            self.levelLeftValueLb.text = "Loading"
            self.levelRightValueLb.text = "Loading"
            self.maxNumLeftValueLb.text = "Loading"
            self.maxNumRightValueLb.text = "Loading"
            self.ratioLeftValueLb.text =  "%"
            self.ratioRightValueLb.text =  "%"
            self.consumeValueLb.text = "Loading"

            loadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
            make.width.equalTo(212)
        }
        

        self.initSubViews()
        closeButton.isHidden = false

    }
    
    public func loadData() {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }

        CSNetworkManager.shared.getDispatchUpgradeParams(address,
                                                  team_id: "\(data?.id ?? 0)") { (response: UpgradeLevelModel) in
            self.levelLeftValueLb.text = response.current?.level
            self.levelRightValueLb.text = response.next?.level
            self.maxNumLeftValueLb.text = response.current?.max_nft
            self.maxNumRightValueLb.text = response.next?.max_nft
            self.ratioLeftValueLb.text = (response.current?.adventure_scale ?? "") + "%"
            self.ratioRightValueLb.text = (response.next?.adventure_scale ?? "") + "%"
            self.consumeValueLb.text = response.next?.need_adventure
        }
    }
    
    @objc func clickUpgradeBtn(_ sender : UIButton) {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }


        CSNetworkManager.shared.postDispatchUpgradeParams(address,
                                                          team_id: "\(data?.id ?? 0)") { (response: BlankContent) in
            
            LSHUD.showSuccess("success")
            self.reloadHandle?()
            self.clickCloseButton(self.closeButton)
            
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let currentLevel : LevelView = LevelView()
    let nextLevel : LevelView = LevelView()
    let nextIcon = UIImageView()
    
    let levelLeftValueLb = UILabel()

    let levelRightValueLb = UILabel()

    let maxNumLeftValueLb = UILabel()

    let maxNumRightValueLb = UILabel()

    let ratioLeftValueLb = UILabel()

    let ratioRightValueLb = UILabel()

    let consumeValueLb = UILabel()
    
    // 刷新列表
    var reloadHandle: (() -> ())?

    func initSubViews()  {
        
        
        let titleLb = UILabel()
        titleLb.text = "Expedition Level Up"
        titleLb.textColor = .white
        titleLb.font = .ls_JostRomanFont(16)
        
        self.contentView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(18)
        }
        
        
        let subContentView = UIView()
        subContentView.backgroundColor = .ls_color("#3F3F3F")
        subContentView.layer.cornerRadius = 10
        subContentView.layer.masksToBounds = true
        self.contentView.addSubview(subContentView)
        
        subContentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(176)
            make.height.equalTo(151)
            make.top.equalTo(titleLb.snp.bottom).offset(12)
        }
        
        let subLevelTitle = UILabel()
        subLevelTitle.text = "Level".ls_localized
        subLevelTitle.textColor =  .ls_color("#999999")
        subLevelTitle.font = .ls_JostRomanRegularFont(11)
        subContentView.addSubview(subLevelTitle)
        subLevelTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
        
        let levelConvertIcon = UIImageView()
        levelConvertIcon.image = .ls_bundle("_level_convert@2x")
        subContentView.addSubview(levelConvertIcon)
        levelConvertIcon.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.centerX.equalToSuperview()
            make.top.equalTo(subLevelTitle.snp.bottom).offset(2)
        }
        
        levelLeftValueLb.text = "0".ls_localized
        levelLeftValueLb.textColor =  .ls_color("#FFFFFF")
        levelLeftValueLb.font = .ls_JostRomanFont(16)
        subContentView.addSubview(levelLeftValueLb)
        levelLeftValueLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalTo(levelConvertIcon)
        }
        levelRightValueLb.text = "1".ls_localized
        levelRightValueLb.textColor =  .ls_color("#46F490")
        levelRightValueLb.font = .ls_JostRomanFont(16)
        subContentView.addSubview(levelRightValueLb)
        levelRightValueLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.centerY.equalTo(levelConvertIcon)
        }


        let maxNumLb = UILabel()
        maxNumLb.text = "Maximum number of NFTs".ls_localized
        maxNumLb.textColor =  .ls_color("#999999")
        maxNumLb.font = .ls_JostRomanRegularFont(11)
        subContentView.addSubview(maxNumLb)
        maxNumLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(levelConvertIcon.snp.bottom).offset(9)
        }
        
        let maxNumConvertIcon = UIImageView()
        maxNumConvertIcon.image = .ls_bundle("_level_convert@2x")
        subContentView.addSubview(maxNumConvertIcon)
        maxNumConvertIcon.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.centerX.equalToSuperview()
            make.top.equalTo(maxNumLb.snp.bottom).offset(2)
        }
        maxNumLeftValueLb.text = "0".ls_localized
        maxNumLeftValueLb.textColor =  .ls_color("#FFFFFF")
        maxNumLeftValueLb.font = .ls_JostRomanFont(16)
        subContentView.addSubview(maxNumLeftValueLb)
        maxNumLeftValueLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalTo(maxNumConvertIcon)
        }
        maxNumRightValueLb.text = "1".ls_localized
        maxNumRightValueLb.textColor =  .ls_color("#46F490")
        maxNumRightValueLb.font = .ls_JostRomanFont(16)
        subContentView.addSubview(maxNumRightValueLb)
        maxNumRightValueLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.centerY.equalTo(maxNumConvertIcon)
        }


        
        let ratioLb = UILabel()
        ratioLb.text = "Ratio of adventure value gained".ls_localized
        ratioLb.textColor =  .ls_color("#999999")
        ratioLb.font = .ls_JostRomanRegularFont(11)
        subContentView.addSubview(ratioLb)
        ratioLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(maxNumConvertIcon.snp.bottom).offset(9)
        }
        
        let ratioConvertIcon = UIImageView()
        ratioConvertIcon.image = .ls_bundle("_level_convert@2x")
        subContentView.addSubview(ratioConvertIcon)
        ratioConvertIcon.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.centerX.equalToSuperview()
            make.top.equalTo(ratioLb.snp.bottom).offset(2)
        }
        ratioLeftValueLb.text = "0".ls_localized
        ratioLeftValueLb.textColor =  .ls_color("#FFFFFF")
        ratioLeftValueLb.font = .ls_JostRomanFont(16)
        subContentView.addSubview(ratioLeftValueLb)
        ratioLeftValueLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalTo(ratioConvertIcon)
        }
        ratioRightValueLb.text = "1".ls_localized
        ratioRightValueLb.textColor =  .ls_color("#46F490")
        ratioRightValueLb.font = .ls_JostRomanFont(16)
        subContentView.addSubview(ratioRightValueLb)
        ratioRightValueLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.centerY.equalTo(ratioConvertIcon)
        }
        
                
        
        let levelUpBtn = UIButton(type: .custom)
        levelUpBtn.setTitle("Level Up", for: .normal)
        levelUpBtn.titleLabel?.font = .ls_JostRomanFont(16)
        levelUpBtn.addTarget(self, action: #selector(clickUpgradeBtn(_:)), for: .touchUpInside)
        levelUpBtn.layer.masksToBounds = true
        levelUpBtn.layer.cornerRadius = 7
        levelUpBtn.layer.borderColor = UIColor.white.cgColor
        levelUpBtn.layer.borderWidth = 1
        contentView.addSubview(levelUpBtn)
        levelUpBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 156, height: 34))
            make.top.equalTo(subContentView.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
        }
        
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.48, green: 0.34, blue: 0.88, alpha: 1).cgColor, UIColor(red: 0.56, green: 0.34, blue: 0.88, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = CGRectMake(0, 0, 156, 34)
        levelUpBtn.layer.insertSublayer(gradient1, at: 0)

        consumeValueLb.text = "10000"
        consumeValueLb.textColor = .ls_color("#999999")
        consumeValueLb.font = .ls_JostRomanFont(11)
        contentView.addSubview(consumeValueLb)
        consumeValueLb.snp.makeConstraints { make in
            make.top.equalTo(levelUpBtn.snp.bottom).offset(12)
            make.centerX.equalToSuperview().offset(30)
            make.height.equalTo(12)
        }

        let walkIcon = UIImageView()
        walkIcon.image = .ls_bundle("nft_dispatch_walk_value@2x")
        contentView.addSubview(walkIcon)

        walkIcon.snp.makeConstraints { make in
            make.size.equalTo(13)
            make.centerY.equalTo(consumeValueLb)
            make.right.equalTo(consumeValueLb.snp.left).offset(-2)
        }

        let consumeLb = UILabel()
        consumeLb.text = "Consume"
        consumeLb.textColor = .ls_color("#999999")
        consumeLb.font = .ls_JostRomanFont(11)
        contentView.addSubview(consumeLb)
        consumeLb.snp.makeConstraints { make in
            make.centerY.equalTo(consumeValueLb)
            make.right.equalTo(walkIcon.snp.left)
        }
    }
}

