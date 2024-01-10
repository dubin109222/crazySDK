//
//  CS_SwapHistoryCell.swift
//  CrazySnake
//
//  Created by Lee on 27/03/2023.
//

import UIKit

class CS_SwapHistoryCell: UITableViewCell {

    var clickWithdrawAction: CS_NoParasBlock?
    var historyModel: CS_SwapHistoryModel?
    
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
    
    func setData(_ model: CS_SwapHistoryModel?){
        historyModel = model
        guard let model = model else { return }
        dateLabel.text = model.created_at
        payTokenButton.setImage(model.payTokenIcon(), for: .normal)
        payTokenButton.setTitle(model.payTokenName(), for: .normal)
        payLabel.text = model.amount_out
        
        getTokenButton.setImage(model.getTokenIcon(), for: .normal)
        getTokenButton.setTitle(model.getTokenName(), for: .normal)
        getLabel.text = model.amount_in

        
        claimButton.isHidden = model.status != 3
        processButton.isHidden = model.status != 0
        completeButton.isHidden = true
        if model.status == 1 || model.status == 2 {
            completeButton.isHidden = false
            if model.status == 1 {
                completeButton.setImage(UIImage.ls_bundle("swap_icon_history_complete@2x"), for: .normal)
                completeButton.setTitle("crazy_str_finished".ls_localized, for: .normal)
            } else {
                completeButton.setImage(UIImage.ls_bundle("swap_icon_history_error@2x"), for: .normal)
                completeButton.setTitle("crazy_str_failed".ls_localized, for: .normal)
            }
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#252525")
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.numberOfLines = 0
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var payTokenButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setImage(TokenName.Snake.icon(), for: .normal)
        button.setTitle(TokenName.Snake.rawValue, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.ls_layout(.imageLeft,padding: 6)
        return button
    }()
    
    lazy var payLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#46F490"), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()
    
    lazy var getTokenButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setImage(TokenName.Snake.icon(), for: .normal)
        button.setTitle(TokenName.Snake.rawValue, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.ls_layout(.imageLeft,padding: 6)
        return button
    }()
    
    lazy var getLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#AC7CFF"), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()

    lazy var claimButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 83, height: 24))
        button.addTarget(self, action: #selector(clickStatusButton(_:)), for: .touchUpInside)
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitle("Claim", for: .normal)
        return button
    }()
    
    lazy var processButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 83, height: 24))
        button.isUserInteractionEnabled = false
        button.ls_cornerRadius(7)
        button.ls_addColorLayer(.ls_color("#E1A156"), .ls_color("#E1B556"))
        button.setTitleColor(.ls_white(), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitle("crazy_str_in_process_".ls_localized, for: .normal)
        return button
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 24))
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setImage(UIImage.ls_bundle("swap_icon_history_complete@2x"), for: .normal)
        button.setTitle("crazy_str_finished".ls_localized, for: .normal)
        button.setTitleColor(.ls_text_gray(), for: .normal)
        button.ls_layout(.imageLeft)
        return button
    }()
}

//MARK: action
extension CS_SwapHistoryCell {
    @objc private func clickStatusButton(_ sender: UIButton) {
        clickWithdrawAction?()
    }
}


//MARK: UI
extension CS_SwapHistoryCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(payTokenButton)
        contentView.addSubview(payLabel)
        contentView.addSubview(getTokenButton)
        contentView.addSubview(getLabel)
        contentView.addSubview(claimButton)
        contentView.addSubview(processButton)
        contentView.addSubview(completeButton)
        
        backView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(0.25)
            make.top.equalTo(4)
            make.width.equalTo(76)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(dateLabel)
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
        }
        
        payTokenButton.snp.makeConstraints { make in
            make.top.equalTo(4)
            make.centerX.equalTo(contentView).multipliedBy(0.75)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        payLabel.snp.makeConstraints { make in
            make.bottom.equalTo(backView).offset(-5)
            make.centerX.equalTo(payTokenButton)
        }
        
        getTokenButton.snp.makeConstraints { make in
            make.centerY.equalTo(payTokenButton)
            make.centerX.equalTo(contentView).multipliedBy(1.25)
            make.width.height.equalTo(payTokenButton)
        }
        
        getLabel.snp.makeConstraints { make in
            make.centerY.equalTo(payLabel)
            make.centerX.equalTo(getTokenButton)
        }
        
        claimButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(contentView).multipliedBy(1.75)
            make.width.equalTo(83)
            make.height.equalTo(24)
        }
        
        processButton.snp.makeConstraints { make in
            make.edges.equalTo(claimButton)
        }
        
        completeButton.snp.makeConstraints { make in
            make.edges.equalTo(claimButton)
        }
    }
}
