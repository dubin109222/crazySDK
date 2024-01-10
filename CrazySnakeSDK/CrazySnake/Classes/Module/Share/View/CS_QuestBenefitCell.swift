//
//  CS_QuestBenefitCell.swift
//  CrazySnake
//
//  Created by Lee on 09/05/2023.
//

import UIKit

class CS_QuestBenefitCell: UICollectionViewCell {
    
    var clickClaimAction: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_color("#F8F8F8")
        return view
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("share_icon_quest_wallet@2x")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.numberOfLines = 0
        return label
    }()
    
    lazy var cytLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(10))
        label.text = "CYT"
        return label
    }()
    
    lazy var cytAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#D8CAFF"), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var cashLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(10))
        label.text = "Cash value"
        return label
    }()
    
    lazy var cashAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#FEFFCA"), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var claimedView: CS_QuestBenefitClaimedView = {
        let view = CS_QuestBenefitClaimedView()
        view.backgroundColor = .ls_black(0.8)
        view.ls_cornerRadius(5)
        view.isHidden = true
        return view
    }()
    
    lazy var completedView: CS_QuestBenefitCompletedView = {
        let view = CS_QuestBenefitCompletedView()
        view.backgroundColor = .ls_black(0.8)
        view.ls_cornerRadius(5)
        view.isHidden = true
        view.clickClaimAction = {
            self.clickClaimAction?()
        }
        return view
    }()
}

//MARK: data
extension CS_QuestBenefitCell {
    func setData(_ data: CS_ShareTaskModel) {
        titleLabel.text = data.describe
        cytAmountLabel.text = "+ \(data.reward_cyt)"
        cashAmountLabel.text = "+ \(data.reward_cash)"
        claimedView.isHidden = data.status != 2
        completedView.isHidden = data.status != 1
        completedView.setData(data)
    }
}


//MARK: open
extension CS_QuestBenefitCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: 100, height: 170)
    }
}

//MARK: UI
extension CS_QuestBenefitCell {
    
    fileprivate func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(iconView)
        backView.addSubview(infoView)
        infoView.addSubview(titleLabel)
        infoView.addSubview(cytLabel)
        infoView.addSubview(cytAmountLabel)
        infoView.addSubview(cashLabel)
        infoView.addSubview(cashAmountLabel)
        backView.addSubview(claimedView)
        backView.addSubview(completedView)
        
        backView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        claimedView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        completedView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.top.equalTo(4.5)
            make.width.height.equalTo(29)
        }
        
        infoView.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.bottom.equalTo(backView).offset(-1)
            make.width.equalTo(98)
            make.height.equalTo(133)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(6)
            make.right.equalTo(-6)
        }
        
        cytLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(46)
        }
        
        cytAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(cytLabel.snp.bottom).offset(0)
        }
        
        cashLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(cytAmountLabel.snp.bottom).offset(6)
        }
        
        cashAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(cashLabel.snp.bottom).offset(0)
        }
    }
}

class CS_QuestBenefitClaimedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var claimedButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 85, height: 25))
        button.setBackgroundImage(.ls_named("share_bg_quest_claimed@2x"), for: .normal)
        button.setTitle("crazy_str_claimed".ls_localized, for: .normal)
        button.titleLabel?.font = .ls_font(10)
        button.setTitleColor(.ls_color("#00F885"), for: .normal)
        button.setImage(.ls_named("swap_icon_progress_success@2x"), for: .normal)
        button.ls_layout(.imageLeft, padding: 5)
        return button
    }()
    
}

//MARK: UI
extension CS_QuestBenefitClaimedView {
    
    private func setupView() {
        addSubview(claimedButton)
        claimedButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(85)
            make.height.equalTo(25)
        }
    }
}


class CS_QuestBenefitCompletedView: UIView {
    
    var clickClaimAction: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#00F885"), .ls_boldFont(16))
        label.text = "crazy_str_completed".ls_localized
        label.textAlignment = .center
        return label
    }()
    
    lazy var cytLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(10))
        label.text = "CYT"
        return label
    }()
    
    lazy var cytAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#D8CAFF"), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var cashLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(10))
        label.text = "Cash value"
        return label
    }()
    
    lazy var cashAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#FEFFCA"), .ls_JostRomanFont(12))
        return label
    }()
    
    
    lazy var claimedButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setBackgroundImage(UIImage.ls_bundle("share_bg_quest_more_way@2x"), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("Claim".ls_localized, for: .normal)
        return button
    }()
    
}

//MARK: data
extension CS_QuestBenefitCompletedView {
    func setData(_ data: CS_ShareTaskModel) {
        cytAmountLabel.text = "+ \(data.reward_cyt)"
        cashAmountLabel.text = "+ \(data.reward_cash)"
    }
}

//MARK: action
extension CS_QuestBenefitCompletedView {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        clickClaimAction?()
    }
}


//MARK: UI
extension CS_QuestBenefitCompletedView {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(cytLabel)
        addSubview(cytAmountLabel)
        addSubview(cashLabel)
        addSubview(cashAmountLabel)
        addSubview(claimedButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.centerX.equalToSuperview()
        }
        
        cytLabel.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(37)
        }
        
        cytAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(cytLabel)
            make.top.equalTo(cytLabel.snp.bottom).offset(0)
        }
        
        cashLabel.snp.makeConstraints { make in
            make.left.equalTo(cytLabel)
            make.top.equalTo(cytAmountLabel.snp.bottom).offset(6)
        }
        
        cashAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(cytLabel)
            make.top.equalTo(cashLabel.snp.bottom).offset(0)
        }
        
        claimedButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-3)
            make.width.equalTo(78)
            make.height.equalTo(23)
        }
    }
}
