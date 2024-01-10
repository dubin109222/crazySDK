//
//  CS_GameRecordCell.swift
//  CrazySnake
//
//  Created by Lee on 18/05/2023.
//

import UIKit
import SwiftyAttributes

class CS_GameRecordCell: UITableViewCell {

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
    
    func setData(_ model: CS_SessionInfoModel?) {
        guard let model = model else { return }
        if model.red_score > model.blue_score {
            teamBackView.image = UIImage.ls_bundle("games_bg_record_red_team@2x")
            teamIcon.image = UIImage.ls_bundle("games_icon_red_team@2x")
            teamLabel.attributedText = "Red".withTextColor(.ls_color("#E94F73")) + " Team".attributedString
        } else {
            teamBackView.image = UIImage.ls_bundle("games_bg_record_blue_team@2x")
            teamIcon.image = UIImage.ls_bundle("games_icon_blue_team@2x")
            teamLabel.attributedText = "Blue".withTextColor(.ls_color("#605CFF")) + " Team".attributedString
        }
        
        sessionLabel.text = "S\(model.round_id)"
        dateLabel.text = Date.ls_intervalToDateStr(model.start_time, format: "yyyy/MM/dd\nHH:mm:ss")
        
        redAmountLabel.text = model.red_amount
        blueAmountLabel.text = model.blue_amount
        redRandomLabel.text = "\(model.red_score)"
        blueRandomLabel.text = "\(model.blue_score)"
        
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
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var redTokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = TokenName.Diamond.icon()
        return view
    }()
    
    lazy var redAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    lazy var blueTokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = TokenName.Diamond.icon()
        return view
    }()
    
    lazy var blueAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
    lazy var redIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("games_icon_red_team@2x")
        return view
    }()
    
    lazy var redRandomLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.text = "-"
        return label
    }()
    
    lazy var blueIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("games_icon_blue_team@2x")
        return view
    }()
    
    lazy var blueRandomLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.text = "-"
        return label
    }()
}

//MARK: UI
extension CS_GameRecordCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(teamBackView)
        backView.addSubview(teamIcon)
        backView.addSubview(sessionLabel)
        backView.addSubview(teamLabel)
        backView.addSubview(dateLabel)
        backView.addSubview(redTokenIcon)
        backView.addSubview(redAmountLabel)
        backView.addSubview(blueTokenIcon)
        backView.addSubview(blueAmountLabel)
        backView.addSubview(redIcon)
        backView.addSubview(redRandomLabel)
        backView.addSubview(blueIcon)
        backView.addSubview(blueRandomLabel)
        
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
        
        redTokenIcon.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(11)
            make.width.height.equalTo(24)
        }
        
        redAmountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(redTokenIcon)
            make.top.equalTo(redTokenIcon.snp.bottom).offset(2)
        }
        
        blueTokenIcon.snp.makeConstraints { make in
            make.top.width.height.equalTo(redTokenIcon)
            make.centerX.equalTo(contentView).multipliedBy(1.3)
        }
        
        blueAmountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(blueTokenIcon)
            make.top.equalTo(redAmountLabel)
        }
        
        redIcon.snp.makeConstraints { make in
            make.left.equalTo(472)
            make.top.equalTo(8)
            make.width.height.equalTo(16)
        }
        
        redRandomLabel.snp.makeConstraints { make in
            make.left.equalTo(redIcon.snp.right).offset(6)
            make.centerY.equalTo(redIcon)
        }
        
        blueIcon.snp.makeConstraints { make in
            make.centerX.width.height.equalTo(redIcon)
            make.top.equalTo(redIcon.snp.bottom).offset(10)
        }
        
        blueRandomLabel.snp.makeConstraints { make in
            make.left.equalTo(redRandomLabel)
            make.centerY.equalTo(blueIcon)
        }
    }
}
