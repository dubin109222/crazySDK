//
//  CS_GameMyRecordCell.swift
//  CrazySnake
//
//  Created by Lee on 22/05/2023.
//

import UIKit
import SwiftyAttributes

class CS_GameMyRecordCell: UITableViewCell {
    
    var clickClaimAction: CS_NoParasBlock?
    var model: CS_MineHistoryModel?

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
    
    func setData(_ model: CS_MineHistoryModel?) {
        guard let model = model else { return }
        self.model = model
        if model.position == 1 {
            teamBackView.image = UIImage.ls_bundle("games_bg_record_red_team@2x")
            teamIcon.image = UIImage.ls_bundle("games_icon_red_team@2x")
            teamLabel.attributedText = "Red".withTextColor(.ls_color("#E94F73")) + " Team".attributedString
        } else {
            teamBackView.image = UIImage.ls_bundle("games_bg_record_blue_team@2x")
            teamIcon.image = UIImage.ls_bundle("games_icon_blue_team@2x")
            teamLabel.attributedText = "Blue".withTextColor(.ls_color("#605CFF")) + " Team".attributedString
        }
        
        sessionLabel.text = "S\(model.round_id)"
        if let time = TimeInterval(model.created_at) {
            dateLabel.text = Date.ls_intervalToDateStr(time, format: "yyyy/MM/dd\nHH:mm:ss")
        } else {
            dateLabel.text = "--"
        }
        if model.status == 3 {
            if model.position == 1 {
                betTeamIcon.image = UIImage.ls_bundle("games_icon_blue_team@2x")
            } else {
                betTeamIcon.image = UIImage.ls_bundle("games_icon_red_team@2x")
            }
            betStatusLabel.text = "No Luck".ls_localized
            betStatusLabel.textColor = .ls_color("#C6C6C6")
            rewardLabel.textColor = .ls_color("#FF9494")
        } else {
            if model.position == 1 {
                betTeamIcon.image = UIImage.ls_bundle("games_icon_red_team@2x")
            } else {
                betTeamIcon.image = UIImage.ls_bundle("games_icon_blue_team@2x")
            }
            betStatusLabel.text = "Get Luck".ls_localized
            betStatusLabel.textColor = .ls_color("#02F9B1")
            rewardLabel.textColor = .ls_color("#00FFB5")
        }
        
        amountLabel.text = "\(model.amount)"
        rewardLabel.text = "\(model.rewards)"
        updateConfirmButton()
    }
    
    private func updateConfirmButton() {
        guard let model = model else { return }
        confirmButton.isHidden = false
        confirmButton.setBackgroundImage(nil, for: .normal)
        switch model.status {
        case -1,0:
            confirmButton.ls_border(color: .ls_color("#E18456"))
            confirmButton.setTitleColor(.ls_color("#E18456"), for: .normal)
            confirmButton.setTitle("Comfirming".ls_localized, for: .normal)
        case 1:
            confirmButton.setBackgroundImage(UIImage.ls_bundle("common_bg_button_purpose@2x"), for: .normal)
            confirmButton.setTitleColor(.ls_white(), for: .normal)
            confirmButton.ls_border(color: .clear)
            confirmButton.setTitle("Claim".ls_localized, for: .normal)
        case 2:
            confirmButton.ls_border(color: .ls_color("#AC7CFF"))
            confirmButton.setTitleColor(.ls_color("#AC7CFF"), for: .normal)
            confirmButton.setTitle("Claimed".ls_localized, for: .normal)
        case 3:
            confirmButton.ls_border(color: .ls_color("#999999"))
            confirmButton.setTitleColor(.ls_color("#999999"), for: .normal)
            confirmButton.setTitle("crazy_str_finished".ls_localized, for: .normal)
        default:
            confirmButton.isHidden = true
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2()
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var teamBackView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("games_bg_record_red_team@2x")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var sessionLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.backgroundColor = .ls_black(0.2)
        label.ls_cornerRadius(2)
        return label
    }()
    
    lazy var teamIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("games_icon_red_team@2x")
        return view
    }()
    
    lazy var teamLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(19))
        label.attributedText = "Red".withTextColor(.ls_color("#E94F73")) + " Team".attributedString
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var betTeamIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("games_icon_red_team@2x")
        return view
    }()
    
    lazy var betStatusLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    lazy var amountIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("game_icon_my_record_in@2x")
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.text = "-"
        return label
    }()
    
    lazy var rewardIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_token_diamond@2x")
        return view
    }()
    
    lazy var rewardLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#00FFB5"), .ls_JostRomanFont(12))
        label.text = "-"
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 75, height: 24))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("Claim".ls_localized, for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(12)
        return button
    }()
}

//MARK: action
extension CS_GameMyRecordCell {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        if model?.status == 1 {
            clickClaimAction?()
        }
    }
}


//MARK: UI
extension CS_GameMyRecordCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(teamBackView)
        backView.addSubview(teamIcon)
        backView.addSubview(sessionLabel)
        backView.addSubview(teamLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(betTeamIcon)
        backView.addSubview(betStatusLabel)
        backView.addSubview(amountIcon)
        backView.addSubview(amountLabel)
        backView.addSubview(rewardIcon)
        backView.addSubview(rewardLabel)
        backView.addSubview(confirmButton)
        
        backView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(0)
            make.bottom.equalTo(-5)
        }
        
        teamBackView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(backView)
            make.width.equalTo(139)
        }
        
        teamIcon.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.left.equalTo(16)
            make.width.height.equalTo(16)
        }
        
        sessionLabel.snp.makeConstraints { make in
            make.left.equalTo(42)
            make.top.equalTo(12)
            make.width.equalTo(56)
            make.height.equalTo(14)
        }
        
        teamLabel.snp.makeConstraints { make in
            make.left.equalTo(sessionLabel)
            make.top.equalTo(sessionLabel.snp.bottom).offset(2)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(0.65)
            make.centerY.equalTo(backView)
//            make.width.equalTo(76)
        }
        
        betTeamIcon.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(16)
            make.width.height.equalTo(16)
        }
        
        betStatusLabel.snp.makeConstraints { make in
            make.centerX.equalTo(betTeamIcon)
            make.top.equalTo(betTeamIcon.snp.bottom).offset(2)
        }
        
        amountIcon.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(1.2)
            make.top.equalTo(8)
            make.width.height.equalTo(14)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(amountIcon.snp.right).offset(6)
            make.centerY.equalTo(amountIcon)
        }
        
        rewardIcon.snp.makeConstraints { make in
            make.centerX.width.height.equalTo(amountIcon)
            make.top.equalTo(amountIcon.snp.bottom).offset(10)
        }
        
        rewardLabel.snp.makeConstraints { make in
            make.left.equalTo(amountLabel)
            make.centerY.equalTo(rewardIcon)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalTo(-32)
            make.centerY.equalTo(backView)
            make.width.equalTo(75)
            make.height.equalTo(24)
        }
    }
}
