//
//  CS_StakeTokenRecordCell.swift
//  CrazySnake
//
//  Created by Lee on 17/03/2023.
//

import UIKit
import SwiftyAttributes

class CS_StakeTokenRecordCell: UITableViewCell {
    
    var clickClaimAction: CS_NoParasBlock?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ model: CS_StakeTokenRecordModel?){
        guard let model = model else { return }
        
        amountLabel.attributedText = "\(model.amount) ".attributedString + "\n\(model.staking_token.name())".withFont(.ls_JostRomanFont(12)).withTextColor(.ls_text_gray())
        
        let start = model.start_at.ls_intervaltoDateStr("yyyy~MM~dd HH:mm:ss") ?? "--"
        let end = model.end_at.ls_intervaltoDateStr("yyyy~MM~dd HH:mm:ss") ?? "--"
        startLabel.text = start+"(UTC)"
        unlockLabel.text = end+"(UTC)"
        cytLabel.attributedText = "\(model.ticket)".attributedString + " CYT".withTextColor(.ls_white()).withFont(.ls_JostRomanFont(12))
        rewardLabel.attributedText =  "\(model.reward)".attributedString + " \(model.staking_token.name())".withTextColor(.ls_white()).withFont(.ls_JostRomanFont(12))
        timeLabel.text = displayTimeName(model.period)
        let apr = String(format: "%.2f%%", (Double(model.apr_token) ?? 0)*100)
        aprLabel.attributedText = "APR ".withTextColor(.ls_white()).withFont(.ls_JostRomanFont(12)) + "\(apr)".attributedString
        
        stakingButton.isHidden = model.state == 1
        let text = model.state == 0 ? "crazy_str_staking".ls_localized : "crazy_str_confirming".ls_localized
        stakingButton.setTitle(text, for: .normal)
        withdrawButton.isHidden = model.state != 1
    }
    
    func displayTimeName(_ duration: Int) -> String {
        var name = ""
        switch duration {
        case 0:
            name = "7 Day"
        case 1:
            name = "14 Day"
        case 2:
            name = "1 Month"
        case 3:
            name = "3 Month"
        case 4:
            name = "6 Month"
        case 5:
            name = "1 Year"
        default:
            name = ""
        }
        return name
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#3A3A3A")
        view.ls_cornerRadius(15)
        return view
    }()
  
    lazy var stakingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 24))
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_staking".ls_localized, for: .normal)
        button.setImage(UIImage.ls_bundle("stake_icon_token_stake_time@2x"), for: .normal)
        button.ls_layout(.imageLeft,padding: 4)
        return button
    }()
    
    lazy var withdrawButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 90, height: 24))
        button.addTarget(self, action: #selector(clickWithdrawButton(_:)), for: .touchUpInside)
        button.titleLabel?.font = .ls_JostRomanFont(14)
        button.setTitle("Claim".ls_localized, for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var aprLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#00FFB5"), .ls_JostRomanFont(16))
        label.textAlignment = .center
        return label
    }()

    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(16))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var cytLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#10D499"), UIFont.ls_JostRomanFont(16))
        label.textAlignment = .center
        return label
    }()
    
    lazy var rewardLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_color("#FFE04D"), UIFont.ls_JostRomanFont(16))
        label.textAlignment = .center
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), UIFont.ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()
    
    lazy var startLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_color("#D2AFFF"), UIFont.ls_JostRomanFont(10))
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateIcon: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(10))
        label.textAlignment = .center
        label.text = "~"
        return label
    }()
    
    lazy var unlockLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_color("#FFB6A0"), UIFont.ls_JostRomanFont(10))
        label.textAlignment = .center
        return label
    }()
}

//MARK: action
extension CS_StakeTokenRecordCell {
    @objc private func clickWithdrawButton(_ sender: UIButton) {
        clickClaimAction?()
    }
}


//MARK: UI
extension CS_StakeTokenRecordCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(amountLabel)
        backView.addSubview(startLabel)
        backView.addSubview(dateIcon)
        backView.addSubview(unlockLabel)
        backView.addSubview(cytLabel)
        backView.addSubview(rewardLabel)
        backView.addSubview(timeLabel)
        backView.addSubview(aprLabel)
        backView.addSubview(stakingButton)
        backView.addSubview(withdrawButton)
        
        backView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(contentView)
            make.top.equalTo(10)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backView).multipliedBy(0.2)
            make.centerY.equalTo(backView)
        }
        
        startLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backView).multipliedBy(0.6)
            make.top.equalTo(6)
        }
        
        dateIcon.snp.makeConstraints { make in
            make.centerX.equalTo(startLabel)
            make.centerY.equalTo(backView)
        }
        
        unlockLabel.snp.makeConstraints { make in
            make.centerX.equalTo(startLabel)
            make.bottom.equalTo(-6)
        }
        
        cytLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backView).multipliedBy(1.1)
            make.top.equalTo(6)
        }
        
        rewardLabel.snp.makeConstraints { make in
            make.centerX.equalTo(cytLabel)
            make.bottom.equalTo(-6)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backView).multipliedBy(1.5)
            make.top.equalTo(6)
        }
        
        aprLabel.snp.makeConstraints { make in
            make.centerX.equalTo(timeLabel)
            make.bottom.equalTo(-6)
        }
        
        stakingButton.snp.makeConstraints { make in
            make.centerX.equalTo(backView).multipliedBy(1.85)
            make.centerY.equalTo(backView)
            make.width.equalTo(120)
            make.height.equalTo(24)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.center.height.equalTo(stakingButton)
            make.width.equalTo(90)
        }
        
    }
}


