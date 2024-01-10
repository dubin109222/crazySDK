//
//  CS_EventRecordCell.swift
//  CrazySnake
//
//  Created by Lee on 10/06/2023.
//

import UIKit
import SwiftyAttributes

class CS_EventRecordCell: UITableViewCell {

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
    
    func setData(_ model: CS_EventRecordModel?, index: Int){
        guard let model = model else { return }
        backView.backgroundColor = index%2 == 0 ? .ls_dark_3() : .ls_dark_2()
        
        iconView.image = model.props_type.iconImage()
        nameLabel.text = model.props_type.disPlayName()
        
        amountLabel.text = "\(model.num)"
        
        amountView.amountLabel.text = "\(model.total_price)"
        amountView.tokenButton.setTitle(model.token, for: .normal)
        amountView.tokenButton.setImage(TokenName.Snake.icon(), for: .normal)
        
        timeLabel.text = Date.ls_intervalToDateStr(model.created_at, format: "yyyy/MM/dd") + "(UTC)"
        
        if model.status == 1 {
            completeButton.setTitleColor(.ls_color("#7FF199"), for: .normal)
            completeButton.setImage(UIImage.ls_bundle("swap_icon_history_complete@2x")?.withRenderingMode(.alwaysTemplate), for: .normal)
            completeButton.imageView?.tintColor = .ls_color("#7FF199")
            completeButton.setTitle("crazy_str_tip_success".ls_localized, for: .normal)
        } else if model.status == 2 {
            completeButton.setTitleColor(.ls_color("#FF835D"), for: .normal)
            completeButton.setImage(UIImage.ls_bundle("swap_icon_history_error@2x"), for: .normal)
            completeButton.setTitle("crazy_str_failed".ls_localized, for: .normal)
        } else {
            completeButton.setTitleColor(.ls_text_gray(), for: .normal)
            completeButton.setImage(nil, for: .normal)
            completeButton.setTitle("crazy_str_confirming".ls_localized, for: .normal)
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_mediumFont(12))
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_mediumFont(16))
        label.textAlignment = .center
        return label
    }()
    
    lazy var amountView: CS_TokenAmountView = {
        let view = CS_TokenAmountView()
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_mediumFont(12))
        label.textAlignment = .center
        return label
    }()

    lazy var completeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 24))
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setImage(UIImage.ls_bundle("swap_icon_history_complete@2x"), for: .normal)
        button.setTitle("crazy_str_tip_success".ls_localized, for: .normal)
        button.setTitleColor(.ls_text_gray(), for: .normal)
        button.ls_layout(.imageLeft)
        return button
    }()
}

//MARK: UI
extension CS_EventRecordCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(amountView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(completeButton)
        
        backView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(contentView.snp.centerX).multipliedBy(0.18)
            make.width.equalTo(100)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(nameLabel.snp.left).offset(-10)
            make.width.equalTo(34)
            make.height.equalTo(30)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(0.6)
            make.centerY.equalToSuperview()
        }
        
        amountView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(1)
            make.width.equalTo(100)
            make.top.bottom.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.centerX.equalTo(contentView).multipliedBy(1.4)
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(contentView).multipliedBy(1.8)
            make.width.equalTo(83)
            make.height.equalTo(24)
        }
    }
}
