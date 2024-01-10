//
//  CS_QuestMoreWayCell.swift
//  CrazySnake
//
//  Created by Lee on 09/05/2023.
//

import UIKit
import SwiftyAttributes

class CS_QuestMoreWayCell: UITableViewCell {

    var clickConfirmAction: CS_NoParasBlock?
    var data: CS_ShareDailyItemModel?
    
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
    
    lazy var backView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    lazy var infoView: CS_ShareReworadsView = {
        let view = CS_ShareReworadsView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_color("#F8F8F8")
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setBackgroundImage(UIImage.ls_bundle("share_bg_quest_more_way@2x"), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("Back to game", for: .normal)
        return button
    }()

}

//MARK: data
extension CS_QuestMoreWayCell {
    func setData(_ model: CS_ShareDailyItemModel?) {
        guard let model = model else { return }
        data = model
        
        infoView.cashLabel.attributedText = "+\(model.cash) ".withTextColor(.ls_color("#46F490"))+"crazy_str_cash_value".ls_localized.attributedString
        infoView.cytLabel.attributedText = "+\(model.cyt) ".withTextColor(.ls_color("#46F490"))+"crazy_str_cyt".ls_localized.attributedString
        
        switch model.type {
        case "advert":
            infoView.typeButton.setImage(.ls_named("share_icon_quest_ad@2x"), for: .normal)
            infoView.typeButton.setTitle("crazy_str_watch_ads".ls_localized, for: .normal)
            infoLabel.text = "crazy_str_watch_ads_desc".ls_localized
            confirmButton.setTitle("crazy_str_back_to_game".ls_localized, for: .normal)
        case "recharge":
            infoView.typeButton.setImage(.ls_named("share_icon_quest_recharge@2x"), for: .normal)
            infoView.typeButton.setTitle("crazy_str_game_recharge".ls_localized, for: .normal)
            infoLabel.attributedText = "crazy_str_games_recharge_desc".ls_localized_color([])
            confirmButton.setTitle("crazy_str_back_to_game".ls_localized, for: .normal)
        case "invite":
            infoView.typeButton.setImage(.ls_named("share_icon_quest_invite@2x"), for: .normal)
            infoView.typeButton.setTitle("crazy_str_invite_a_friend".ls_localized, for: .normal)
            infoLabel.text = "crazy_str_invite_a_friend_desc".ls_localized
            confirmButton.setTitle("crazy_str_invite_now".ls_localized, for: .normal)
        default: break
            
        }
        
    }
}


//MARK: action
extension CS_QuestMoreWayCell {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        clickConfirmAction?()
    }
}


//MARK: UI
extension CS_QuestMoreWayCell {
    
    private func setupView() {
        backgroundColor = .ls_color("#ABABAB",alpha: 0.6)
        
        contentView.addSubview(backView)
        backView.addSubview(infoView)
        backView.addSubview(infoLabel)
        backView.addSubview(confirmButton)
        
        backView.snp.makeConstraints { make in
            make.left.top.equalTo(5)
            make.right.bottom.equalTo(-5)
        }
        
        infoView.snp.makeConstraints { make in
            make.left.top.equalTo(backView).offset(5)
            make.bottom.equalTo(backView).offset(-5)
            make.width.equalTo(292)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-5)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(infoView.snp.right).offset(16)
            make.right.equalTo(confirmButton.snp.left).offset(-16)
        }
        
    }
}
