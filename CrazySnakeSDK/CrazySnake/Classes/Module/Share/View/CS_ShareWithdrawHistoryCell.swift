//
//  CS_ShareWithdrawHistoryCell.swift
//  CrazySnake
//
//  Created by Lee on 08/08/2023.
//

import UIKit
import SwiftyAttributes

class CS_ShareWithdrawHistoryCell: UITableViewCell {

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
    
    func setData(_ model: CS_ShareWithdrawHistoryModel?, index: Int){
        guard let model = model else { return }
        backView.backgroundColor = index%2 == 0 ? .ls_dark_3() : .ls_dark_2()
        dateLabel.text = Date.ls_intervalToDateStr(model.create_time, format: "yyyy/MM/dd")
        
        amountLabel.attributedText = model.token_amount.withTextColor(.ls_color("#46F490")) + " \(model.token)".attributedString
        
        if model.status == 0 {
            completeButton.setTitleColor(.ls_color("#7FF199"), for: .normal)
            completeButton.setImage(UIImage.ls_bundle("swap_icon_history_complete@2x")?.withRenderingMode(.alwaysTemplate), for: .normal)
            completeButton.imageView?.tintColor = .ls_color("#7FF199")
            completeButton.setTitle("crazy_str_tip_success".ls_localized, for: .normal)
        } else if model.status == 3 || model.status == 4 {
            completeButton.setTitleColor(.ls_color("#FF835D"), for: .normal)
            completeButton.setImage(UIImage.ls_bundle("swap_icon_history_error@2x"), for: .normal)
            completeButton.setTitle("crazy_str_failed".ls_localized, for: .normal)
        } else {
            completeButton.setTitleColor(.ls_text_gray(), for: .normal)
            completeButton.setImage(nil, for: .normal)
            completeButton.setTitle("crazy_str_processing".ls_localized, for: .normal)
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_boldFont(12))
        label.textAlignment = .center
        return label
    }()
     
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_boldFont(12))
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
extension CS_ShareWithdrawHistoryCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(completeButton)
        
        backView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(0.35)
            make.centerY.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(1)
            make.centerY.equalTo(backView)
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(contentView).multipliedBy(1.65)
            make.width.equalTo(83)
            make.height.equalTo(24)
        }
    }
}
