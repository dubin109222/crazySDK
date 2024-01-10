//
//  CS_NFTStakeController.swift
//  CrazySnake
//
//  Created by Lee on 05/03/2023.
//

import UIKit
import JXSegmentedView
import Kingfisher
import HandyJSON


struct DispatchCommonModel: HandyJSON {
    var userPower: String?
    var userPowerStaking: String?
    var userTotalReward: String?
    var totalPower: String?
    var userPowerDispatch: String?
    var userReward: String?
}

class NFTStakingView: UICollectionView,JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}

class NFTDispatchView: UICollectionView,JXSegmentedListContainerViewListDelegate {
    
    func listView() -> UIView {
        return self
    }
}


class NFTDispatchCell: UICollectionViewCell {
    
    var lockTipsLb = UILabel()

    let lockIcon = UIImageView.init(image: .ls_bundle("nft_dispatch_lock@2x"))
    
    lazy var maskLockView: UIView = {
        let maskView = UIView()
        maskView.addSubview(lockIcon)
        lockIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(48)
            make.size.equalTo(CGSize.init(width: 25, height: 33))
        }
        
        lockTipsLb.numberOfLines = 0
        lockTipsLb.textAlignment = .center
        maskView.addSubview(lockTipsLb)
        lockTipsLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lockIcon.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        
        maskView.backgroundColor = .ls_color("#222222",alpha: 0.8)
        
        
        
        return maskView
    }()
    
    private func getTitleAttr() {
        var qualityStr = "Common"
        var attColor = UIColor.ls_color("#FFFFFF")
        switch data?.quality {
        case 1:
            qualityStr = "Common"
            attColor = .ls_color(r: 161, g: 252, b: 143)
        case 2:
            qualityStr = "Good"
            attColor = .ls_color(r: 122, g: 215, b: 254)

        case 3:
            qualityStr = "Excellent"
            attColor = .ls_color(r: 245, g: 155, b: 255)

        case 4:
            qualityStr = "Rare"
            attColor = .ls_color(r: 207, g: 120, b: 128)

        case 5:
            qualityStr = "Epic"
            attColor = .ls_color(r: 247, g: 200, b: 28)

        case 6:
            qualityStr = "Legendary"
            attColor = .ls_color(r: 241, g: 100, b: 99)

        default:
            qualityStr = "Common"
        }
        
        let titleAtts = NSMutableAttributedString()
        titleAtts.append(NSMutableAttributedString(string: qualityStr, attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: attColor]))
        titleAtts.append(NSMutableAttributedString(string: " Adventurn team", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#FFFFFF")]))

        leftNameLb.attributedText = titleAtts
        
        levelLb.text = "Lv.\(data?.level ?? 1)"
        levelLb.textColor = attColor

    }

    
    private func getLockTitleAttr() -> NSMutableAttributedString {
        /**
         1 当解锁条件里 等级=1 进化等级=0
         拥有X个XX品质的NFT（0/x）
         2 当解锁条件里 等级>1 进化等级=0 （0/x）
         拥有X个等级达到XX级的XX品质NFT
         3 当解锁条件里 等级=1,进化等级>0 （0/x）
         拥有X个进化等级达到XX级的XX品质NFT
         4 当解锁条件里 等级>1，进化等级>0 （0/x）
         拥有X个等级达到XX级并且进化等级达到XX级的XX品质NFT（0/x）
         */
        
        var qualityStr = "Common"
        switch data?.quality {
        case 1:
            qualityStr = "Common"
        case 2:
            qualityStr = "Good"
        case 3:
            qualityStr = "Excellent"
        case 4:
            qualityStr = "Rare"
        case 5:
            qualityStr = "Epic"
        case 6:
            qualityStr = "Legendary"
        default:
            qualityStr = "Common"
        }
        
        var attrString = NSMutableAttributedString()
        attrString.append(NSMutableAttributedString(string: "Having ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
        attrString.append(NSMutableAttributedString(string: "\(data?.unlock_cond?.num ?? 0) ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#46F490")]))
        attrString.append(NSMutableAttributedString(string: "NFTs of ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
        attrString.append(NSMutableAttributedString(string: "\(qualityStr) ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#46F490")]))
        attrString.append(NSMutableAttributedString(string: "quality ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
        if (data?.unlock_cond?.level ?? 0) > 1 {
            attrString.append(NSMutableAttributedString(string: "with ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
            attrString.append(NSMutableAttributedString(string: "levels reaching ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
            attrString.append(NSMutableAttributedString(string: "\(data?.unlock_cond?.level ?? 1) ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#46F490")]))
        }
        if (data?.unlock_cond?.level_evolve ?? 0) > 1 {
            if (data?.unlock_cond?.level ?? 0) > 1 {
                attrString.append(NSMutableAttributedString(string: "and ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))

            } else {
                attrString.append(NSMutableAttributedString(string: "with ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
            }
            attrString.append(NSMutableAttributedString(string: "evolution levels reaching ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
            attrString.append(NSMutableAttributedString(string: "\(data?.unlock_cond?.level_evolve ?? 1) ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#46F490")]))
        }
        
        attrString.append(NSMutableAttributedString(string: "(", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
        attrString.append(NSMutableAttributedString(string: "\(data?.unlock_cond_nft_count ?? 0) ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#46F490")]))
        attrString.append(NSMutableAttributedString(string: "/ \(data?.unlock_cond?.num ?? 0))", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
        
        if ((data?.unlock_cond_nft_count ?? 0) > (data?.unlock_cond?.num ?? 0)
            && (data?.unlock_cond?.slots ?? 0) > 0) {
            attrString = NSMutableAttributedString()
            attrString.append(NSMutableAttributedString(string: "Unlocked by consuming ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
            attrString.append(NSMutableAttributedString(string: "\(data?.unlock_cond?.slots ?? 0) ", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#46F490")]))
            attrString.append(NSMutableAttributedString(string: "Pit Card", attributes: [.font: UIFont.ls_JostRomanFont(12),.foregroundColor: UIColor.ls_color("#CCCCCC")]))
            lockIcon.image = .ls_bundle("200304@2x")
        } else {
            lockIcon.image = .ls_bundle("nft_dispatch_lock@2x")
        }

        return attrString
        
    }
    

    var data: NFT_DisPatch_Team? {
        didSet {
            getTitleAttr()
            
            if (oldValue?.status == 0 || oldValue?.status == -1)
                && (data?.status != 0 || data?.status != -1) {
                self.maskLockView.removeFromSuperview()
            }
            self.rightView.removeFromSuperview()
            self.rightView = createRightView()
            self.contentView.addSubview(self.rightView)
            self.rightView.snp.makeConstraints { make in
                make.left.equalTo(self.cardImg.snp.right)
                make.top.equalTo(self.topView.snp.bottom).offset(6)
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            addBtn.isHidden = true
            if self.data?.status == 0 || self.data?.status == -1 {
                
                
                lockTipsLb.attributedText = self.getLockTitleAttr()
                
                
                self.cardImg.image = .ls_bundle("nft_dispatch_card_add@2x")
                self.contentView.addSubview(self.maskLockView)
                self.maskLockView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            else if self.data?.status == 1 {
                self.cardImg.image = .ls_bundle("nft_dispatch_card_add@2x")
                addBtn.isHidden = false
            }
            else if self.data?.status == 2 {
                if let url = URL.init(string: data?.staking?.image ?? "") {
                    self.cardImg.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
                }
            }
            else if self.data?.status == 3 {
                self.cardImg.image = .ls_bundle("nft_dispatch_finish@2x")
            } else {
                self.cardImg.image = .ls_bundle("icon_loading_data@2x")
            }
        }
    }
    
    public var claimHandle: ((NFT_DisPatch_Team) -> ())?
    
    @objc func clickClaimBtn(_ sender: UIButton) {
        guard let dispatchData = self.data else {
            return
        }
        
        self.claimHandle?(dispatchData)
    }
    
    fileprivate func createRightView() -> UIView {
        let rightView = UIView()
        
        // 未解锁
        if self.data?.status == 0 || self.data?.status == -1 {
            let vStack = UIView()
            rightView.addSubview(vStack)
            
            
            var lastView : UIView
            do {
                let contentView = UIView()
                
                
                let pointImg = UIImageView()
                pointImg.image = UIImage.ls_bundle("ntf_dispatch_point@2x")
                contentView.addSubview(pointImg)
                pointImg.snp.makeConstraints { make in
                    make.size.equalTo(7)
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
                
                let titleLb = UILabel()
                titleLb.text = "Adventure time "
                titleLb.font = .ls_JostRomanFont(10)
                titleLb.textColor = UIColor.ls_color("#999999")
                contentView.addSubview(titleLb)
                titleLb.snp.makeConstraints { make in
                    make.left.equalTo(pointImg.snp.right).offset(4.5)
                    make.centerY.equalTo(pointImg)
                }
                
                let valueLb = UILabel()
                valueLb.text = String.formatSecondsToHHMMSS(seconds: (data?.lock_time ?? 0))
                valueLb.font = .ls_JostRomanFont(10)
                valueLb.textColor = .ls_color("#FFFDBE")
                contentView.addSubview(valueLb)
                valueLb.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(17.5)
                }
                
                vStack.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.right.top.equalToSuperview()
                    make.bottom.equalTo(valueLb)
                    make.height.equalTo(17.5)

                }
                lastView = contentView
            }
            
            do {
                let contentView = UIView()
                
                let pointImg = UIImageView()
                pointImg.image = UIImage.ls_bundle("ntf_dispatch_point@2x")
                contentView.addSubview(pointImg)
                pointImg.snp.makeConstraints { make in
                    make.size.equalTo(7)
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()

                }
                
                let titleLb = UILabel()
                titleLb.text = "Hash Needed"
                titleLb.textColor = UIColor.ls_color("#999999")
                titleLb.font = .ls_JostRomanFont(10)
                contentView.addSubview(titleLb)
                titleLb.snp.makeConstraints { make in
                    make.left.equalTo(pointImg.snp.right).offset(4.5)
                    make.centerY.equalTo(pointImg)
                }
                
                let valueLb = UILabel()
                valueLb.text = "\(data?.dispatch_cond?.min_power ?? 0)"
                valueLb.font = .ls_JostRomanFont(12)
                valueLb.textColor = UIColor.ls_color("#D0BEFF")
                contentView.addSubview(valueLb)
                valueLb.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(17.5)

                }
                contentView.frame = CGRect(x: 0, y: 0, width: 172, height: 12)
                
                vStack.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(lastView.snp.bottom)
                    make.bottom.equalTo(valueLb)
                    make.height.equalTo(17.5)

                }
                lastView = contentView
            }
            
            do {
                let contentView = UIView()
                
                let pointImg = UIImageView()
                pointImg.image = UIImage.ls_bundle("ntf_dispatch_point@2x")
                contentView.addSubview(pointImg)
                pointImg.snp.makeConstraints { make in
                    make.size.equalTo(7)
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()

                }
                
                let titleLb = UILabel()
                titleLb.text = "NFT Amount"
                titleLb.textColor = UIColor.ls_color("#999999")
                titleLb.font = .ls_JostRomanFont(10)
                contentView.addSubview(titleLb)
                titleLb.snp.makeConstraints { make in
                    make.left.equalTo(pointImg.snp.right).offset(4.5)
                    make.centerY.equalTo(pointImg)
                }
                
                let valueLb = UILabel()
                valueLb.text = "\(data?.dispatch_cond?.min_num ?? 0) - \(data?.dispatch_cond?.max_num ?? 0)"
                valueLb.font = .ls_JostRomanFont(12)
                valueLb.textColor = UIColor.ls_color("#D0BEFF")
                contentView.addSubview(valueLb)
                valueLb.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(17.5)

                }
                
                vStack.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(lastView.snp.bottom)
                    make.height.equalTo(17.5)
                }
                lastView = contentView
            }
            vStack.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(9.5)
                make.right.equalToSuperview().offset(-12)
                make.top.equalToSuperview()
                make.height.equalTo(17.5*3)
            }
            
          
            
            let lineView = UIView()
            lineView.backgroundColor = .ls_color(r: 81, g: 81, b: 81)
            rightView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.top.equalTo(vStack.snp.bottom)
                make.height.equalTo(1)
                make.left.right.equalTo(vStack)
            }
            
            let energyLb = UILabel()
            energyLb.font = .ls_JostRomanFont(12)
            energyLb.text = "\(data?.need_strength ?? 0)"
            energyLb.textColor = .ls_color("#FFBB50")
            rightView.addSubview(energyLb)
            energyLb.snp.makeConstraints { make in
                make.centerX.equalTo(lineView).offset(8)
                make.top.equalTo(lineView.snp.bottom)
                make.height.equalTo(17.5)
            }
            
            let energyIcon = UIImageView.init(image: .ls_bundle("nft_dispatch_energy@2x"))
            rightView.addSubview(energyIcon)
            energyIcon.snp.makeConstraints { make in
                make.centerY.equalTo(energyLb)
                make.size.equalTo(CGSize(width: 16, height: 13))
                make.right.equalTo(energyLb.snp.left).offset(-3.5)
            }
            
            let exploringBtn = UIButton(type: .custom)
            exploringBtn.setTitle("Exploring", for: .normal)
            exploringBtn.titleLabel?.font = .ls_JostRomanFont(12)
            exploringBtn.layer.cornerRadius = 10
            exploringBtn.layer.masksToBounds = true
            exploringBtn.layer.borderColor = UIColor.white.cgColor
            exploringBtn.layer.borderWidth = 1
            rightView.addSubview(exploringBtn)
            exploringBtn.snp.makeConstraints { make in
                make.top.equalTo(energyIcon.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
                make.width.equalTo(113)
                make.height.equalTo(30)
            }
            
        }
        else if self.data?.status == 1 {
            let vStack = UIView()
            rightView.addSubview(vStack)
            
            
            var lastView : UIView
            do {
                let contentView = UIView()
                
                
                let pointImg = UIImageView()
                pointImg.image = UIImage.ls_bundle("ntf_dispatch_point@2x")
                contentView.addSubview(pointImg)
                pointImg.snp.makeConstraints { make in
                    make.size.equalTo(7)
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
                
                let titleLb = UILabel()
                titleLb.text = "Adventure team"
                titleLb.font = .ls_JostRomanFont(10)
                titleLb.textColor = UIColor.ls_color("#999999")
                contentView.addSubview(titleLb)
                titleLb.snp.makeConstraints { make in
                    make.left.equalTo(pointImg.snp.right).offset(4.5)
                    make.centerY.equalTo(pointImg)
                }
                
                let valueLb = UILabel()
                valueLb.text = String.formatSecondsToHHMMSS(seconds: (data?.lock_time ?? 0))
                valueLb.font = .ls_JostRomanFont(10)
                valueLb.textColor = .ls_color("#FFFDBE")
                contentView.addSubview(valueLb)
                valueLb.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(17.5)
                }
                
                vStack.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.right.top.equalToSuperview()
                    make.bottom.equalTo(valueLb)
                    make.height.equalTo(17.5)
                    
                }
                lastView = contentView
            }
            
            do {
                let contentView = UIView()
                
                let pointImg = UIImageView()
                pointImg.image = UIImage.ls_bundle("ntf_dispatch_point@2x")
                contentView.addSubview(pointImg)
                pointImg.snp.makeConstraints { make in
                    make.size.equalTo(7)
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
                
                let titleLb = UILabel()
                titleLb.text = "Hash Needed"
                titleLb.textColor = UIColor.ls_color("#999999")
                titleLb.font = .ls_JostRomanFont(10)
                contentView.addSubview(titleLb)
                titleLb.snp.makeConstraints { make in
                    make.left.equalTo(pointImg.snp.right).offset(4.5)
                    make.centerY.equalTo(pointImg)
                }
                
                let valueLb = UILabel()
                valueLb.text = "\(data?.dispatch_cond?.min_power ?? 0)"
                valueLb.font = .ls_JostRomanFont(12)
                valueLb.textColor = UIColor.ls_color("#D0BEFF")
                contentView.addSubview(valueLb)
                valueLb.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(17.5)
                    
                }
                contentView.frame = CGRect(x: 0, y: 0, width: 172, height: 12)
                
                vStack.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(lastView.snp.bottom)
                    make.bottom.equalTo(valueLb)
                    make.height.equalTo(17.5)
                    
                }
                lastView = contentView
            }
            
            do {
                let contentView = UIView()
                
                let pointImg = UIImageView()
                pointImg.image = UIImage.ls_bundle("ntf_dispatch_point@2x")
                contentView.addSubview(pointImg)
                pointImg.snp.makeConstraints { make in
                    make.size.equalTo(7)
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
                
                let titleLb = UILabel()
                titleLb.text = "NFT Amount"
                titleLb.textColor = UIColor.ls_color("#999999")
                titleLb.font = .ls_JostRomanFont(10)
                contentView.addSubview(titleLb)
                titleLb.snp.makeConstraints { make in
                    make.left.equalTo(pointImg.snp.right).offset(4.5)
                    make.centerY.equalTo(pointImg)
                }
                
                let valueLb = UILabel()
                valueLb.text = "\(data?.dispatch_cond?.min_num ?? 0) - \(data?.dispatch_cond?.max_num ?? 0)"
                valueLb.font = .ls_JostRomanFont(12)
                valueLb.textColor = UIColor.white
                contentView.addSubview(valueLb)
                valueLb.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(17.5)
                }
                
                vStack.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(lastView.snp.bottom)
                    make.height.equalTo(17.5)
                }
                lastView = contentView
            }
            
            vStack.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(9.5)
                make.right.equalToSuperview().offset(-12)
                make.top.equalToSuperview()
                make.height.equalTo(17.5*3)
            }
            
            
            let lineView = UIView()
            lineView.backgroundColor = .ls_color(r: 81, g: 81, b: 81)
            rightView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.top.equalTo(vStack.snp.bottom)
                make.height.equalTo(1)
                make.left.right.equalTo(vStack)
            }
            
            let energyLb = UILabel()
            energyLb.font = .ls_JostRomanFont(12)
            energyLb.text = "\(data?.need_strength ?? 0)"
            energyLb.textColor = .ls_color("#FFBB50")
            rightView.addSubview(energyLb)
            energyLb.snp.makeConstraints { make in
                make.centerX.equalTo(lineView).offset(8)
                make.top.equalTo(lineView.snp.bottom)
                make.height.equalTo(17.5)
            }
            
            let energyIcon = UIImageView.init(image: .ls_bundle("nft_dispatch_energy@2x"))
            rightView.addSubview(energyIcon)
            energyIcon.snp.makeConstraints { make in
                make.centerY.equalTo(energyLb)
                make.size.equalTo(CGSize(width: 16, height: 13))
                make.right.equalTo(energyLb.snp.left).offset(-3.5)
            }
            
            let exploringBtn = UIButton(type: .custom)
            exploringBtn.setTitle("Go exploring", for: .normal)
            exploringBtn.isUserInteractionEnabled = false
            exploringBtn.titleLabel?.font = .ls_JostRomanFont(12)
            exploringBtn.layer.cornerRadius = 10
            exploringBtn.layer.masksToBounds = true
            exploringBtn.layer.borderColor = UIColor.white.cgColor
            exploringBtn.layer.borderWidth = 1
            rightView.addSubview(exploringBtn)
            exploringBtn.snp.makeConstraints { make in
                make.top.equalTo(energyIcon.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
                make.width.equalTo(113)
                make.height.equalTo(30)
            }
        }
        else if self.data?.status == 2 {
            let vStack = UIView()
            rightView.addSubview(vStack)
            
            
            var lastView : UIView
            do {
                let contentView = UIView()
                
                
                let pointImg = UIImageView()
                pointImg.image = UIImage.ls_bundle("ntf_dispatch_point@2x")
                contentView.addSubview(pointImg)
                pointImg.snp.makeConstraints { make in
                    make.size.equalTo(7)
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
                
                let titleLb = UILabel()
                titleLb.text = "Time Left"
                titleLb.font = .ls_JostRomanFont(10)
                titleLb.textColor = UIColor.ls_color("#999999")
                contentView.addSubview(titleLb)
                titleLb.snp.makeConstraints { make in
                    make.left.equalTo(pointImg.snp.right).offset(4.5)
                    make.centerY.equalTo(pointImg)
                }
                
                let valueLb = UILabel()
                valueLb.text = String.formatSecondsToHHMMSS(seconds: (data?.remain_time ?? 0))
                valueLb.font = .ls_JostRomanFont(10)
                valueLb.textColor = .ls_color("#FFFDBE")
                contentView.addSubview(valueLb)
                valueLb.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(17.5)
                }
                
                vStack.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.right.top.equalToSuperview()
                    make.bottom.equalTo(valueLb)
                    make.height.equalTo(17.5)

                }
                lastView = contentView
            }
            
            do {
                let contentView = UIView()
                
                let pointImg = UIImageView()
                pointImg.image = UIImage.ls_bundle("ntf_dispatch_point@2x")
                contentView.addSubview(pointImg)
                pointImg.snp.makeConstraints { make in
                    make.size.equalTo(7)
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()

                }
                
                let titleLb = UILabel()
                titleLb.text = "Team Hash"
                titleLb.textColor = UIColor.ls_color("#999999")
                titleLb.font = .ls_JostRomanFont(10)
                contentView.addSubview(titleLb)
                titleLb.snp.makeConstraints { make in
                    make.left.equalTo(pointImg.snp.right).offset(4.5)
                    make.centerY.equalTo(pointImg)
                }
                
                let valueLb = UILabel()
                valueLb.text = "\(data?.power ?? 0)"
                valueLb.font = .ls_JostRomanFont(12)
                valueLb.textColor = UIColor.ls_color("#D0BEFF")
                contentView.addSubview(valueLb)
                valueLb.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(17.5)

                }
                contentView.frame = CGRect(x: 0, y: 0, width: 172, height: 12)
                
                vStack.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(lastView.snp.bottom)
                    make.bottom.equalTo(valueLb)
                    make.height.equalTo(17.5)

                }
                lastView = contentView
            }
            
            do {
                let contentView = UIView()
                
                let pointImg = UIImageView()
                pointImg.image = UIImage.ls_bundle("ntf_dispatch_point@2x")
                contentView.addSubview(pointImg)
                pointImg.snp.makeConstraints { make in
                    make.size.equalTo(7)
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()

                }
                
                let titleLb = UILabel()
                titleLb.text = "NFT Amount"
                titleLb.textColor = UIColor.ls_color("#999999")
                titleLb.font = .ls_JostRomanFont(10)
                contentView.addSubview(titleLb)
                titleLb.snp.makeConstraints { make in
                    make.left.equalTo(pointImg.snp.right).offset(4.5)
                    make.centerY.equalTo(pointImg)
                }
                
                let valueLb = UILabel()
                valueLb.text = "\(data?.staking?.nft_count ?? 0)"
                valueLb.font = .ls_JostRomanFont(12)
                valueLb.textColor = UIColor.white
                contentView.addSubview(valueLb)
                valueLb.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(17.5)

                }
                
                vStack.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(lastView.snp.bottom)
                    make.height.equalTo(17.5)
                }
                lastView = contentView
            }
            
            do {
                let contentView = UIView()
                
                let pointImg = UIImageView()
                pointImg.image = UIImage.ls_bundle("ntf_dispatch_point@2x")
                contentView.addSubview(pointImg)
                pointImg.snp.makeConstraints { make in
                    make.size.equalTo(7)
                    make.left.equalToSuperview()
                    make.centerY.equalToSuperview()

                }
                
                let titleLb = UILabel()
                titleLb.text = "Extra Hash"
                titleLb.textColor = UIColor.ls_color("#999999")
                titleLb.font = .ls_JostRomanFont(10)
                contentView.addSubview(titleLb)
                titleLb.snp.makeConstraints { make in
                    make.left.equalTo(pointImg.snp.right).offset(4.5)
                    make.centerY.equalTo(pointImg)
                }
                
                let valueLb = UILabel()
                let value = (data?.power_scale ?? []).first(where: {$0.first == data?.staking?.nft_count})?.last ?? 0
                valueLb.text = "+\(value)"
                valueLb.font = .ls_JostRomanFont(12)
                valueLb.textColor = UIColor.white
                contentView.addSubview(valueLb)
                valueLb.snp.makeConstraints { make in
                    make.right.equalToSuperview()
                    make.top.equalToSuperview()
                    make.height.equalTo(17.5)

                }
                
                vStack.addSubview(contentView)
                contentView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(lastView.snp.bottom)
                    make.height.equalTo(17.5)
                }
                lastView = contentView
            }
            vStack.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(9.5)
                make.right.equalToSuperview().offset(-12)
                make.top.equalToSuperview()
                make.height.equalTo(17.5*4)
            }
            
          
            
            let lineView = UIView()
            lineView.backgroundColor = .ls_color(r: 81, g: 81, b: 81)
            rightView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.top.equalTo(vStack.snp.bottom)
                make.height.equalTo(1)
                make.left.right.equalTo(vStack)
            }
            
            
            let exploringBtn = UIButton(type: .custom)
            exploringBtn.setTitle("Exploring....", for: .normal)
            exploringBtn.setTitleColor(.ls_color("#FFBB50"), for: .normal)
            exploringBtn.titleLabel?.font = .ls_JostRomanFont(12)
   
            rightView.addSubview(exploringBtn)
            exploringBtn.snp.makeConstraints { make in
                make.top.equalTo(lineView.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
                make.width.equalTo(113)
                make.height.equalTo(30)
            }
            
//            let topBgView = UIView()
//            topBgView.backgroundColor = .ls_color("#2B2B2B")
//            rightView.insertSubview(topBgView, at: 0)
//            topBgView.snp.makeConstraints { make in
//                make.left.right.top.equalToSuperview()
//                make.bottom.equalTo(lineView.snp.top)
//            }
        }
        else if self.data?.status == 3 {
            let endLb = UILabel()
            endLb.textColor = .white
            endLb.text = "End of exploration"
            endLb.font = .ls_JostRomanFont(16)
            
            rightView.addSubview(endLb)
            endLb.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(5)
            }
            
            let tipsLb = UILabel()
            tipsLb.textColor = .ls_color("#999999")
            tipsLb.font = .ls_JostRomanFont(14)
            tipsLb.text = "Adventure spoils"
            rightView.addSubview(tipsLb)
            tipsLb.snp.makeConstraints { make in
                make.top.equalTo(endLb.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
            }
            
            let walkValueLb = UILabel()
            walkValueLb.textColor = .white
            walkValueLb.font = .ls_JostRomanFont(10)
            walkValueLb.text = "\(data?.reward?.adventure ?? 0)"
            rightView.addSubview(walkValueLb)
            
            walkValueLb.snp.makeConstraints { make in
                make.centerX.equalToSuperview().offset(5)
                make.top.equalTo(tipsLb.snp.bottom).offset(3)
            }
            
            let walkIcon = UIImageView.init(image: .ls_bundle("nft_dispatch_walk_value@2x"))
            rightView.addSubview(walkIcon)
            walkIcon.snp.makeConstraints { make in
                make.size.equalTo(12)
                make.centerY.equalTo(walkValueLb)
                make.right.equalTo(walkValueLb.snp.left).offset(-1)
            }
            
            let claimBtn = UIButton(type: .custom)
            claimBtn.setTitle("Claim", for: .normal)
            claimBtn.addTarget(self, action: #selector(clickClaimBtn(_:)), for: .touchUpInside)
            claimBtn.titleLabel?.font = .ls_JostRomanFont(12)
            rightView.addSubview(claimBtn)
            claimBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(walkValueLb.snp.bottom).offset(3)
                make.size.equalTo(CGSize(width: 103, height: 24))
            }
            claimBtn.layer.cornerRadius = 7
            claimBtn.layer.masksToBounds = true
            claimBtn.layer.borderColor = UIColor.white.cgColor
            claimBtn.layer.borderWidth = 1
            
            let gradient1 = CAGradientLayer()
            gradient1.colors = [UIColor(red: 0.48, green: 0.34, blue: 0.88, alpha: 1).cgColor, UIColor(red: 0.56, green: 0.34, blue: 0.88, alpha: 1).cgColor]
            gradient1.locations = [0, 1]
            gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient1.frame = CGRect(origin: .zero, size: CGSize.init(width: 103, height: 24))
            claimBtn.layer.insertSublayer(gradient1, at: 0)
            

        }
        
        return rightView
    }
    
    var rightView: UIView = UIView()
    
    var cardImg: UIImageView = UIImageView()
    var topView: UIView = UIView()
    
    // title
    let leftNameLb = UILabel()
    let levelLb = UILabel()

    public var upgradeLevelHandle: ((NFT_DisPatch_Team) -> ())?
    
     @objc func clickAddLevelBtn(_ sender : UIButton) {
        guard let dispatchModel = self.data else {
            return
        }
         guard data?.level != data?.max_level else {
             LSHUD.showInfo("team is max level")
             return
         }
         
        self.upgradeLevelHandle?(dispatchModel)
    }
    
    let addBtn = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        
        topView.backgroundColor = UIColor.ls_color("#333333")
        topView.layer.cornerRadius = 5
        topView.layer.masksToBounds = true
        self.contentView.addSubview(topView)
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(22.5)
            make.top.equalToSuperview().offset(6.5)
            make.left.equalToSuperview().offset(9.5)
            make.right.equalToSuperview().offset(-8.5)
        }
        
        leftNameLb.textColor = .white
        leftNameLb.font = .ls_JostRomanFont(12)
        topView.addSubview(leftNameLb)
        
        leftNameLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(9)
        }
        addBtn.isHidden = true
        addBtn.setImage(UIImage.ls_bundle("nft_dispatch_add@2x"), for: .normal)
        addBtn.addTarget(self, action: #selector(clickAddLevelBtn(_:)), for: .touchUpInside)
        topView.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-4)
            make.size.equalTo(18)
        }
        
        levelLb.font = .ls_JostRomanFont(14)
        levelLb.textColor = UIColor.ls_color("#46F490")
        topView.addSubview(levelLb)
        levelLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(addBtn.snp.left).offset(-12)
        }
        
        cardImg.image = .ls_bundle("icon_loading_data@2x")
        self.contentView.addSubview(cardImg)
        cardImg.snp.makeConstraints { make in
            make.left.equalTo(11)
            make.bottom.equalTo(-6)
            make.size.equalTo(CGSize(width: 106, height: 112))
        }
        
       
        
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.ls_color(r: 81, g: 81, b: 81).cgColor
        self.layer.borderWidth = 1

        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CS_NFTStakeController: CS_BaseEmptyController {

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var page = 1
    private var quality = 0
    private var dataSource = [CS_NFTStakeNFTModel]()
    var isMock = false
    
    lazy var moreMockData : [CS_NFTStakeNFTModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTStakeNFTModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "nft_stake.nfts") as? [CS_NFTStakeNFTModel] {
                return model
            }
        }
        return []
    }()
    
    lazy var mockData: [CS_NFTStakeNFTModel] = []


    private var dispatchData: NFT_DisPatch_DataModel? {
        didSet {
            self.staminaLb.text = "\(dispatchData?.strength?.balance ?? 0)"
        }
    }
    private var commonData: DispatchCommonModel? {
        didSet {
            myPowerView.amountLabel.text = "\(commonData?.userPowerStaking ?? "0")"
            bonusView.amountLabel.text = "\(commonData?.userPowerDispatch ?? "0")"
            claimView.amountLabel.text = "\(commonData?.userReward ?? "0")"

        }
    }
    
    private var percentageInfo:CS_NFTStakeInfoModel?
    private var stakeInfo:CS_NFTStakeInfoModel?
    private var gasInfo: CS_EstimateGasPriceModel?
    
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
//        segment.titles = ["NFT Staking".ls_localized]
        segment.titles = ["NFT Staking".ls_localized, "NFT Dispatch".ls_localized]
//        segment.itemWidth = 100
        segment.itemSpacing = 20
        segment.isTitleColorGradientEnabled = true
        segment.isItemSpacingAverageEnabled = false
        segment.titleNormalColor = .ls_color("#CCCCCC")
        segment.titleNormalFont = .ls_mediumFont(16)
        segment.titleSelectedColor = .ls_color("#C7A6F9")
        segment.titleSelectedFont = .ls_boldFont(16)
        return segment
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.delegate = self
        view.dataSource = segmentedDataSource
        view.defaultSelectedIndex = 0

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        indicator.indicatorColor = .ls_color("#C7A6F9")
        indicator.indicatorWidth = 30
        
        view.indicators = [indicator]
        view.listContainer = listContainerView
        return view
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        return view
    }()
    
    let staminaLb = UILabel()
    let staminaIcon = UIImageView()
    let staminaBtn = UIButton(type: .custom)
    @objc func clickStaminBtn(_ sender : UIButton) {
        let alert = CS_GetStaminaAlert()
        alert.data = dispatchData
        alert.show()
        weak var weakSelf = self
        alert.reloadHandle = { balance in
            weakSelf?.navAmountView.amountLabel.text = balance
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        GuideMaskManager.checkGuideState(.nft_stake) { isFinish in
            self.isMock = !isFinish
            self.requestList()
            self.emptyStyle = .loading
            
            if self.isMock {
                self.collectionView.reloadData()
                self.updateInfoView()
                self.guideStepOne()
            }
        }
        emptyStyle = .loading
        // Do any additional setup after loading the view.
        // FIXME: 屏蔽
//        CS_NewFeatureAlert.showPage(.stakeNFT)
    }
    
    func updateData(){
        navAmountView.iconView.image = TokenName.GasCoin.icon()
        navAmountView.amountLabel.text = self.dispatchData?.gas?.balance
        navAmountView1.iconView.image = .ls_bundle("nft_dispatch_walk_value@2x")
        navAmountView1.amountLabel.text = "\(self.dispatchData?.adventure?.balance ?? 0)"

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    lazy var contentBackView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(15)
//        view.backgroundColor = UIColor.ls_dark_2(0.8)
        view.backgroundColor = .ls_color("#333333")
        return view
    }()
    
    lazy var selectedLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(19))
        label.text = "NFT Staking list"
        return label
    }()
    
    private lazy var collectionView: NFTStakingView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CS_NFTStakeCell.itemSize()
        layout.scrollDirection = .horizontal
        let view = NFTStakingView(frame: self.view.bounds, collectionViewLayout: layout)
        view.backgroundColor = .ls_dark_2()
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.register(CS_NFTStakeCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_NFTStakeCell.self))
        view.register(CS_CSNFTStakeAddCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_CSNFTStakeAddCell.self))
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    private lazy var dispatchCollectionView: NFTDispatchView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSizeMake(310, 153)
        layout.scrollDirection = .horizontal
        let view = NFTDispatchView(frame: self.view.bounds, collectionViewLayout: layout)
        view.backgroundColor = .ls_color("#2B2B2B")
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.register(NFTDispatchCell.self, forCellWithReuseIdentifier: NSStringFromClass(NFTDispatchCell.self))
        return view
    }()
    
    lazy var totlePowerView: CS_NFTStakeInfoItemView = {
        let view = CS_NFTStakeInfoItemView()
        view.titleLabel.text = "crazy_str_total_hash_power".ls_localized
        return view
    }()

    lazy var airdropAmountView: CS_NFTStakeInfoItemView = {
        let view = CS_NFTStakeInfoItemView()
//        let attM = NSMutableAttributedString(attributedString: "Airdrop ".withTextColor(.ls_text_gray()))
//        attM.append("Snake".withTextColor(.ls_purpose_01()))
//        attM.append(" Amount".withTextColor(.ls_text_gray()))
//        view.titleLabel.attributedText = attM
        view.titleLabel.text = "Airdrop Amount".ls_localized
        view.helpIcon.isHidden = false
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickAirdropHelpBtn(_:))))
        return view
    }()
    
    lazy var amountView: CS_NFTStakeInfoItemView = {
        let view = CS_NFTStakeInfoItemView()
        view.titleLabel.text = "Staked power".ls_localized
        return view
    }()
    
    lazy var myPowerView: CS_NFTStakeInfoItemView = {
        let view = CS_NFTStakeInfoItemView()
        view.titleLabel.text = "My Dispatch Power".ls_localized
        return view
    }()
    
    lazy var bonusView: CS_NFTStakeInfoItemView = {
        let view = CS_NFTStakeInfoItemView()
        view.titleLabel.text = "My Dispatch Power".ls_localized
        return view
    }()
    
    lazy var percentageView: CS_NFTStakeInfoRewardView = {
        let view = CS_NFTStakeInfoRewardView()
        view.titleLabel.text = "My Percentage".ls_localized
        return view
    }()

    lazy var rewardView: CS_NFTStakeInfoRewardView2 = {
        let view = CS_NFTStakeInfoRewardView2()
        view.titleLabel.text = "crazy_str_total_rewards".ls_localized
        return view
    }()
    
    lazy var claimView: CS_NFTStakeInfoRewardView2 = {
        let view = CS_NFTStakeInfoRewardView2()
        view.titleLabel.text = "Claim".ls_localized
        view.amountLabel.textColor = .ls_color("#46F490")
        return view
    }()
    
    lazy var claimButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 164, height: 40))
        button.addTarget(self, action: #selector(clickClaimButton(_:)), for: .touchUpInside)
        button.setTitle("Claim".ls_localized, for: .normal)
        return button
    }()
    
    @objc func clickAirdropHelpBtn(_ sender : UITapGestureRecognizer) {
        let alert = CS_AirDropDetailsAlert()
        alert.data = stakeInfo?.airDrop
        alert.show()
    }
}



extension CS_NFTStakeController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
//        return 1
        return 2
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return self.collectionView
        } else {
            return self.dispatchCollectionView
        }
    }
}

extension CS_NFTStakeController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index == 0 {
            amountView.amountLabel.text = "\(stakeInfo?.totalStakedNftCount ?? 0)"
            amountView.titleLabel.text = "Staked power".ls_localized

            self.navAmountView.isHidden = true
            self.navAmountView1.isHidden = true
            self.staminaIcon.isHidden = true
            self.staminaLb.isHidden = true
            self.staminaBtn.isHidden = true
        } else {
            
            amountView.amountLabel.text = "\(dispatchData?.teams?.filter({$0.status == 2}).count ?? 0)"
            amountView.titleLabel.text = "Dispatched Amount".ls_localized

            self.navAmountView.isHidden = false
            self.navAmountView1.isHidden = false
            self.staminaIcon.isHidden = false
            self.staminaLb.isHidden = false
            self.staminaBtn.isHidden = false
        }
    }
}

extension CS_NFTStakeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 18, bottom: 0, right: 18)
    }
}

extension CS_NFTStakeController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        if collectionView == self.collectionView {
            if indexPath.row == 0 && (stakeInfo?.hasMoreSolt() == true || isMock){
                let cell: CS_CSNFTStakeAddCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_CSNFTStakeAddCell.self), for: indexPath) as! CS_CSNFTStakeAddCell
                cell.setData(stakeInfo)
                return cell
            }
            let cell: CS_NFTStakeCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTStakeCell.self), for: indexPath) as! CS_NFTStakeCell
            let model: CS_NFTStakeNFTModel!
            if stakeInfo?.hasMoreSolt() == true || isMock{
                model = isMock ? mockData[indexPath.row - 1] : dataSource[indexPath.row-1]
            } else {
                model = isMock ? mockData[indexPath.row] : dataSource[indexPath.row]
            }
            cell.setData(model)
            weak var weakSelf = self
            cell.clickUnstakeAction = {
                if model.group {
                    weakSelf?.unstakeSet(model, index: indexPath.row)
                } else {
                    weakSelf?.unstakeSingle(model, index: indexPath.row)
                }
            }
            

            return cell
        } else {
            
  
            let cell: NFTDispatchCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(NFTDispatchCell.self), for: indexPath) as! NFTDispatchCell
            
            cell.data = self.dispatchData?.teams?[indexPath.row]
            
            
            weak var weakSelf = self
            
            cell.upgradeLevelHandle = { itemData in
                
                let alert = CS_UpgradeLevelAlert()
                alert.data = itemData
                alert.reloadHandle = {
                    weakSelf?.requestList()
                }
                alert.show()
                return
            }
            
            cell.claimHandle = { itemData in
                
                
                guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
                    weakSelf?.emptyStyle = .empty
                    weakSelf?.collectionView.reloadData()
                    
                    return
                }
                
                struct DispatchClaimResponse: HandyJSON {
                    var adventure: String?
                }
                
                CSNetworkManager.shared.postDispatchClaimParams(wallet_address: address,
                                                               team_id: "\(itemData.id ?? 0)") { (respons: DispatchClaimResponse) in
                    
                    let popoverView = CS_NFTStateDispatchCongratulations()
                    popoverView.getValue = respons.adventure
                    popoverView.show()

                    
                    CSNetworkManager.shared.getDispatchParams(address) { (data: NFT_DisPatch_DataModel) in
                        weakSelf?.dispatchData = data
                        weakSelf?.updateData()
                        weakSelf?.dispatchCollectionView.reloadData()
                    }
                }
            }
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            if stakeInfo?.hasMoreSolt() == true || isMock {
                return isMock ? (mockData.count + 1) : (dataSource.count + 1)
            } else {
                return isMock ? mockData.count : dataSource.count
            }
        } else {
            return dispatchData?.teams?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            if indexPath.row == 0 && stakeInfo?.hasMoreSolt() == true {
                if stakeInfo?.slots ?? 0 > stakeInfo?.totalStakedNftCount ?? 0 {
                    clickChooseNFT()
                } else {
                    clickUnlockSlot()
                }
                return
            }
            let model: CS_NFTStakeNFTModel!
            if stakeInfo?.hasMoreSolt() == true {
                model = dataSource[indexPath.row-1]
            } else {
                model = dataSource[indexPath.row]
            }
            if model.group {
                let vc = CS_NFTStakeSetDetailController()
                vc.detailModel = model
                present(vc, animated: false)
                weak var weakSelf = self
                vc.unstakeSuccess = {
                    weakSelf?.requestList()
                }
            } else {
                let vc = CS_NFTStakeDetailController()
                vc.detailModel = model
                present(vc, animated: false)
                weak var weakSelf = self
                vc.unstakeSuccess = {
                    weakSelf?.requestList()
                }
            }
        } else {
            
//            let alert = CS_AirDropDetailsAlert()
//            alert.data = stakeInfo?.airDrop
//            alert.show()
//            return

            
            let itemData = dispatchData?.teams?[indexPath.row]
            if itemData?.status == 1 {
                let vc = CS_DispatchChooseNFTsController()
                vc.data = itemData
                weak var weakSelf = self
                vc.nftStakeSuccss = {
                    weakSelf?.requestList()
                }
                self.pushTo(vc)
            }
        }
    }
    
    
    
    
    func clickChooseNFT(){
        let alert = CS_NFTStakeChooseAlert()
        alert.show()
        weak var weakSelf = self
        alert.clickSingleAction = {
            let vc = CS_NFTStakeSingleController()
            vc.nftStakeSuccss = {
                weakSelf?.requestList()
            }
            weakSelf?.pushTo(vc)
        }
        alert.clickSetAction = {
            let vc = CS_NFTStakeSetController()
            vc.nftStakeSuccss = {
                weakSelf?.requestList()
            }
            weakSelf?.pushTo(vc)
        }
    }
    
    func clickUnlockSlot(){
        let vc = CS_StakeUnlockSoltController()
        vc.stakeInfo = stakeInfo
        present(vc, animated: false)
        weak var weakSelf = self
        vc.unlockSuccess = {
            weakSelf?.requestList()
        }
    }
}

//MARK: action
extension CS_NFTStakeController {
    override func clickRightButton() {
        CS_HelpCenterAlert.showStakeNFT()
    }
    
    @objc private func clickClaimButton(_ sender: UIButton) {
        
        if (Double(self.stakeInfo?.userReward ?? "") ?? 0) <= 0 {
            LSHUD.showInfo("User don't have reward value")
            return
        }

        
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.nftStakeClaimGasPrice(address) { resp in
            LSHUD.hide()
            if resp.status == .success {
                if let gas = resp.data {
                    let vc = CS_EstimateGasAlertController()
                    vc.showTitle = "Claim".ls_localized
                    vc.gasPrice = gas
                    vc.contractAddress = address
                    weakSelf?.present(vc, animated: false)
                    vc.clickConfirmAction = {
                        weakSelf?.stakeClaim()
                    }
                }
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}

//MARK: request
extension CS_NFTStakeController {
    
    func requestList() {
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        CSNetworkManager.shared.getStakeInfo(address) { resp in
            
            if resp.status == .success {
                weakSelf?.stakeInfo = resp.data
                weakSelf?.dataSource.removeAll()
                if let list = resp.data?.nfts {
                    weakSelf?.dataSource.append(contentsOf: list)
                }
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            if weakSelf?.isMock == false {
                weakSelf?.collectionView.reloadData()
                weakSelf?.updateInfoView()
            }
            
        }
        
        CSNetworkManager.shared.getDispatchParams(address) { (data: NFT_DisPatch_DataModel) in
            weakSelf?.dispatchData = data
            weakSelf?.updateData()
            weakSelf?.dispatchCollectionView.reloadData()
            
        }
        CSNetworkManager.shared.getDispatchParams(address) { (data: NFT_DisPatch_DataModel) in
            weakSelf?.dispatchData = data
            weakSelf?.updateData()
            weakSelf?.dispatchCollectionView.reloadData()
        }
        
        CSNetworkManager.shared.getDispatchCommonParams(address) { (data: DispatchCommonModel) in
            self.commonData = data
        }

    }
    
    func updateInfoView() {
        let totolPower = stakeInfo?.totalPower ?? 0
        let userPower = stakeInfo?.userPower ?? 0
        totlePowerView.amountLabel.text = "\(totolPower)"
        if segmentedView.selectedIndex == 0 {
            amountView.amountLabel.text = "\(stakeInfo?.totalStakedNftCount ?? 0)"
            amountView.titleLabel.text = "Staked power".ls_localized

        } else {
            amountView.amountLabel.text = "\(dispatchData?.teams?.filter({$0.status == 2}).count ?? 0)"
            amountView.titleLabel.text = "Dispatched Amount".ls_localized
        }
//        myPowerView.amountLabel.text = "\(userPower)"
        airdropAmountView.amountLabel.text = "\(stakeInfo?.currentAirdrop ?? 0)"
        if totolPower == 0 {
            percentageView.amountLabel.text = "--"
        } else {
            percentageView.amountLabel.text = String(format: "%.2f%%", (Double(userPower)/Double(totolPower))*100)
        }
        
        rewardView.amountLabel.text = Utils.formatAmount(stakeInfo?.userTotalReward)
    }
    
    func unstakeSingle(_ model: CS_NFTStakeNFTModel, index: Int){
        
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["stakingid"] = model.id
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.nftSingleUnstake(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
//                weakSelf?.dataSource.remove(at: index)
//                weakSelf?.collectionView.reloadData()
                weakSelf?.requestList()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func unstakeSet(_ model: CS_NFTStakeNFTModel, index: Int){
        
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["stakingid"] = model.id
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.nftUnstakeSet(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
//                weakSelf?.dataSource.remove(at: index)
//                weakSelf?.collectionView.reloadData()
                weakSelf?.requestList()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func stakeClaim() {
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.nftStakeClaim(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                LSHUD.showSuccess("Success")
                weakSelf?.requestList()
                CS_AccountManager.shared.loadTokenBlance()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
}

extension CS_NFTStakeController {
    func guideStepOne() {
        if self.isMock == true {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 0, section: 0)) {
                    let maskRect = cell.convert(cell.bounds, to: nil)
                    
                    GuideMaskView.show (tipsText: "Click to select NFT to be stake.",
                                        currentStep: "1",
                                        totalStep: "10",
                                        maskRect: maskRect,
                                        textWidthDefault: 223,
                                        direction: .left){
                        weakSelf?.guideStepTwo()
                        
                    } skipHandle: {
                        weakSelf?.guideStepEnd()
                    }
                }
            }
        }
    }
    
    func guideStepTwo() {
        let alert = CS_NFTStakeChooseAlert()
        alert.isMock = true
        alert.show()
        
            weak var weakSelf = self
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
                let cell = alert.singleView
                let maskRect = cell.convert(cell.bounds, to: nil)
                GuideMaskView.show (tipsText: "Click to select Single NFT to be stake.",
                                    currentStep: "2",
                                    totalStep: "10",
                                    maskRect: maskRect,
                                    textWidthDefault: 223,
                                    direction: .left,
                                    superView: alert){
                    alert.dismissSelf()
                    weakSelf?.guideStepThree()

                } skipHandle: {
                    weakSelf?.guideStepEnd()
                    alert.dismissSelf()
                }
            }

    }
    
    func guideStepThree() {
        weak var weakSelf = self

        let vc = CS_NFTStakeSingleController()
        vc.isMock = self.isMock
        vc.mockNext = { isSkip in
            if !isSkip {
                self.mockData = self.moreMockData
                self.collectionView.reloadData()
                weakSelf?.guideStepFour()
            } else {
                weakSelf?.guideStepEnd()
            }
        }
        self.pushTo(vc)

    }
    
    func guideStepFour() {
        let alert = CS_NFTStakeChooseAlert()
        alert.isMock = true
        alert.show()
        
            weak var weakSelf = self
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
                let cell = alert.setView
                let maskRect = cell.convert(cell.bounds, to: nil)
                GuideMaskView.show (tipsText: "Click to select NFT Set to be stake.",
                                    currentStep: "5",
                                    totalStep: "10",
                                    maskRect: maskRect,
                                    textWidthDefault: 223,
                                    direction: .right,
                                    superView: alert){
                    alert.dismissSelf()
                    
                    let vc = CS_NFTStakeSetController()
                    vc.isMock = true
                    vc.mockNextHandle = { isSkip in
                        if isSkip {
                            weakSelf?.guideStepEnd()
                        } else {
                            weakSelf?.guideStepFive()
                        }
                    }
                    weakSelf?.pushTo(vc)

                } skipHandle: {
                    weakSelf?.guideStepEnd()
                    alert.dismissSelf()
                }
            }
    }
    
    func guideStepFive() {
        weak var weakSelf = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 1, section: 0)) as? CS_NFTStakeCell {
                let maskRect = cell.unstakeButton.convert(cell.unstakeButton.bounds, to: nil)
                
                GuideMaskView.show (tipsText: "Click the button to cancel stake.",
                                    currentStep: "8",
                                    totalStep: "10",
                                    maskRect: maskRect,
                                    textWidthDefault: 223,
                                    direction: .up){
                    weakSelf?.guideStepSix()
                } skipHandle: {
                    weakSelf?.guideStepEnd()
                }
            }
        }
    }
    
    func guideStepSix() {
        weak var weakSelf = self
        let cell = claimView
        let maskRect = cell.convert(cell.bounds, to: nil)
        let cell2 = rewardView
        let maskRect2 = cell2.convert(cell2.bounds, to: nil)
        let newMaskRect = CGRect(x: maskRect2.origin.x, y: maskRect2.origin.y, width: maskRect.maxX - maskRect2.minX, height: maskRect.size.height)

        GuideMaskView.show (tipsText: "View stake results.",
                            currentStep: "9",
                            totalStep: "10",
                            maskRect: newMaskRect,
                            textWidthDefault: 223,
                            direction: .down){
            weakSelf?.guideStepSeven()
        } skipHandle: {
            weakSelf?.guideStepEnd()
        }
    }
    
    func guideStepSeven() {
        weak var weakSelf = self
        let cell = claimButton
        let maskRect = cell.convert(cell.bounds, to: nil)
        
        GuideMaskView.show (tipsText: "Click the button to extract stake results.",
                            currentStep: "10",
                            totalStep: "10",
                            maskRect: maskRect,
                            textWidthDefault: 223,
                            direction: .down){
            weakSelf?.guideStepEnd(isSkip: false)
        } skipHandle: {
            weakSelf?.guideStepEnd()
        }

    }
    
    func guideStepEnd( isSkip: Bool = true) {
        GuideMaskManager.saveGuideState(.nft_stake)
        self.isMock = false
        self.collectionView.reloadData()
    }
    
}

extension CS_NFTStakeController {
    func setupView(){
        navigationView.titleLabel.text = "crazy_str_nft_stake".ls_localized
        rightButton.isHidden = false
        view.addSubview(contentBackView)
//        contentBackView.addSubview(collectionView)
        contentBackView.addSubview(totlePowerView)
        contentBackView.addSubview(airdropAmountView)
        contentBackView.addSubview(amountView)
        contentBackView.addSubview(myPowerView)
        contentBackView.addSubview(bonusView)
        contentBackView.addSubview(percentageView)
        contentBackView.addSubview(rewardView)
        contentBackView.addSubview(claimView)
        contentBackView.addSubview(claimButton)
        
        contentBackView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(24))
            make.top.equalTo(navigationView.snp.bottom).offset(10)
            make.right.equalTo(-CS_ms(24))
            make.bottom.equalTo(-10)
        }
        
        
        contentBackView.addSubview(segmentedView)
//        segmentedView.backgroundColor = UIColor.red
        segmentedView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        
        self.staminaIcon.isHidden = true
        self.staminaLb.isHidden = true
        self.staminaBtn.isHidden = true

        staminaLb.font = .ls_JostRomanFont(16)
        staminaLb.textColor = .white
        staminaLb.text = "0"
        contentBackView.addSubview(staminaLb)
        staminaLb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(segmentedView)
            make.height.equalTo(36)
        }
        
        staminaIcon.image = UIImage.ls_bundle("nft_dispatch_stamina_icon@2x")
        contentBackView.addSubview(staminaIcon)
        staminaIcon.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(segmentedView)
            make.right.equalTo(staminaLb.snp.left).offset(-3.5)
        }
        
        staminaBtn.addTarget(self, action: #selector(clickStaminBtn(_:)), for: .touchUpInside)
        contentBackView.addSubview(staminaBtn)
        staminaBtn.snp.makeConstraints { make in
            make.left.equalTo(staminaIcon)
            make.centerY.height.right.equalTo(staminaLb)
        }
        
        contentBackView.addSubview(listContainerView)
//        listContainerView.backgroundColor = .blue
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.equalTo(contentBackView)
            make.height.equalTo(180)
        }
        
        
        
        totlePowerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(44)
            make.bottom.equalTo(contentBackView).offset(-68)
        }
        
        do {
            let lineView = UIView()
            lineView.backgroundColor = .ls_color(r: 81, g: 81, b: 81)
            totlePowerView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(25)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview()
            }
        }

        
        
        airdropAmountView.snp.makeConstraints { make in
            make.left.equalTo(totlePowerView.snp.right)
            make.size.equalTo(totlePowerView)
            make.centerY.equalTo(totlePowerView)
        }
        do {
            let lineView = UIView()
            lineView.backgroundColor = .ls_color(r: 81, g: 81, b: 81)
            airdropAmountView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(25)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview()
            }
        }

        
        amountView.snp.makeConstraints { make in
            make.left.equalTo(airdropAmountView.snp.right)
            make.size.equalTo(totlePowerView)
            make.centerY.equalTo(totlePowerView)
        }
        do {
            let lineView = UIView()
            lineView.backgroundColor = .ls_color(r: 81, g: 81, b: 81)
            amountView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(25)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview()
            }
        }

        
        myPowerView.snp.makeConstraints { make in
            make.left.equalTo(amountView.snp.right)
            make.size.equalTo(totlePowerView)
            make.centerY.equalTo(totlePowerView)

        }
        do {
            let lineView = UIView()
            lineView.backgroundColor = .ls_color(r: 81, g: 81, b: 81)
            myPowerView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(25)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview()
            }
        }

        
        bonusView.snp.makeConstraints { make in
            make.left.equalTo(myPowerView.snp.right)
            make.size.equalTo(totlePowerView)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(totlePowerView)

        }
        do {
            let lineView = UIView()
            lineView.backgroundColor = .ls_color(r: 81, g: 81, b: 81)
            bonusView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.equalTo(25)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview()
            }
        }

        percentageView.snp.makeConstraints { make in
            make.left.equalTo(totlePowerView)
            make.top.equalTo(totlePowerView.snp.bottom).offset(17)
            make.width.equalTo(160)
            make.height.equalTo(44)

        }
        
        do {
            
            let lineView = UIView()
            lineView.backgroundColor = .ls_color(r: 81, g: 81, b: 81)
            contentBackView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.width.equalTo(1)
                make.height.centerY.equalTo(percentageView)
                make.left.equalTo(percentageView.snp.right).offset(1)
            }

        }
        
        rewardView.snp.makeConstraints { make in
            make.left.equalTo(totlePowerView).offset(172)
            make.top.equalTo(totlePowerView.snp.bottom).offset(17)
            make.width.equalTo(160)
            make.height.equalTo(44)
        }
        
        claimView.snp.makeConstraints { make in
            make.left.equalTo(contentBackView).offset(237 + 172)
            make.top.equalTo(rewardView)
            make.width.equalTo(140)
            make.height.equalTo(44)
        }
        
        claimButton.snp.makeConstraints { make in
            make.centerY.equalTo(rewardView)
            make.right.equalTo(bonusView)
            make.width.equalTo(164)
            make.height.equalTo(40)
        }
        
    }
}
