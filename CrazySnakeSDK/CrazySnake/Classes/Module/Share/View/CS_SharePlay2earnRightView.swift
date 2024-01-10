//
//  CS_SharePlay2earnRightView.swift
//  CrazySnake
//
//  Created by Lee on 08/05/2023.
//

import UIKit
import SwiftyAttributes

import FacebookCore
import FacebookShare


class CS_SharePlay2earnRightView: UIView {
    
    var shareStr: String {
        return ["""
                    Have you played Crazy Slither today?
                    Let's see who's up to some adventures!
                    """,
                    """
                    Before go to bed, how about a relaxing game of Crazy Slither!
                    """,
                    """
                    In Crazy Slither everything you do is rewarded!
                    """].randomElement() ?? ""
    }

    
    var clickLinkAction: CS_NoParasBlock?
    var clickMoreAction: CS_NoParasBlock?
    var clickShareAction: CS_StringBlock?

    var data: CS_ShareDataModel!
    var shareLink = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#333333")
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#F8F8F8")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_boldFont(12))
        label.text = "crazy_str_referral_information".ls_localized
        return label
    }()
    
    lazy var mytitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#F8F8F8"), .ls_boldFont(12))
        label.text = "crazy_str_my_invite_link".ls_localized
        return label
    }()
    
    lazy var myLinkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickMyLinkButton(_:)), for: .touchUpInside)
        button.titleLabel?.font = .ls_font(10)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.backgroundColor = .ls_color("#3A3A3A")
        button.ls_cornerRadius(5)
        return button
    }()
    
    lazy var copyButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickMyLinkButton(_:)), for: .touchUpInside)
        button.setImage(.ls_named("icon_wallet_copy"), for: .normal)
        return button
    }()
    
    lazy var referralLinkLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#F8F8F8"), .ls_boldFont(12))
        label.text = "crazy_str_connect_referral_link".ls_localized
        return label
    }()
    
    lazy var inputField: CS_FieldInputView = {
        let view = CS_FieldInputView()
        view.updateAddressInput()
        view.textField.placeholder = "crazy_str_please_enter_the_invitation_code_bind".ls_localized
        return view
    }()
    
    lazy var linkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickLinkButton(_:)), for: .touchUpInside)
        button.backgroundColor = .ls_color("#8E53E9")
        button.ls_cornerRadius(5)
        button.titleLabel?.font = .ls_mediumFont(12)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_link".ls_localized, for: .normal)
        return button
    }()
    
    lazy var rewardsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#F8F8F8"), .ls_boldFont(12))
        label.text = "crazy_str_total_rewards".ls_localized
        return label
    }()
    
    lazy var rewardsView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#3A3A3A")
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var cytLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(10))
        label.text = "crazy_str_cyt".ls_localized
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
        label.text = "crazy_str_cash_value".ls_localized
        label.textAlignment = .center
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
    
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickMoreButton(_:)), for: .touchUpInside)
        button.titleLabel?.font = .ls_font(10)
        button.setTitleColor(.ls_color("#C09EFF"), for: .normal)
        button.setTitle("See more".ls_localized, for: .normal)
        return button
    }()
    
    lazy var telegramButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickTelegramButton(_:)), for: .touchUpInside)
        button.setImage(.ls_named("share_icon_share_telegarm@2x"), for: .normal)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickShareButton(_:)), for: .touchUpInside)
        button.setImage(.ls_named("share_icon_share_system@2x"), for: .normal)
        return button
    }()
    
    lazy var facebookButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickShareFacebook(_:)), for: .touchUpInside)
        button.setImage(.ls_named("_share_facebook_icon@2x"), for: .normal)
        return button
    }()
    
    lazy var whatsAppButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickWhatsAppButton(_:)), for: .touchUpInside)
        button.setImage(.ls_named("_share_whats_icon@2x"), for: .normal)
        return button
    }()
    
    lazy var twitterButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickShareTwitter(_:)), for: .touchUpInside)
        button.setImage(.ls_named("_share_twitter_icon@2x"), for: .normal)
        return button
    }()
    
    lazy var discordButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickShareDiscord(_:)), for: .touchUpInside)
        button.setImage(.ls_named("_share_discord_icon@2x"), for: .normal)
        return button
    }()


}

//MARK: action
extension CS_SharePlay2earnRightView {
    
    @objc private func clickMoreButton(_ sender: UIButton) {
        clickMoreAction?()
    }
    
    @objc private func clickMyLinkButton(_ sender: UIButton) {
        UIPasteboard.general.string = shareLink
        LSHUD.showSuccess("crazy_str_copied".ls_localized)
    }
    
    @objc private func clickLinkButton(_ sender: UIButton) {
        clickLinkAction?()
    }
    
    @objc private func clickTelegramButton(_ sender: UIButton) {
//        clickShareAction?(shareLink)
        let urlString = "tg://msg?text=\(shareStr)\n\(shareLink)"
        let tgUrl = URL.init(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        
        if UIApplication.shared.canOpenURL(tgUrl!)
            {
            UIApplication.shared.open(tgUrl!, options: [:], completionHandler: { success in
                if success {
                    print("URL opened successfully")
                } else {
                    print("Failed to open the URL")
                }
            })
        } else
        {
            LSHUD.showError("Telegrame not installed")
        }
    }
    
    @objc private func clickWhatsAppButton(_ sender: UIButton) {
        let urlString = "whatsapp://send?text=\(shareStr)\n\(shareLink)"
        let tgUrl = URL.init(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        
        if UIApplication.shared.canOpenURL(tgUrl!)
            {
            UIApplication.shared.open(tgUrl!, options: [:], completionHandler: { success in
                if success {
                    print("URL opened successfully")
                } else {
                    print("Failed to open the URL")
                }
            })
        } else
        {
            LSHUD.showError("WhatsApp not installed")
        }
    }

    

    @objc private func clickShareFacebook(_ sender: UIButton) {
        let urlString = shareLink
        let tgUrl = URL.init(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

        let share = ShareLinkContent()
        share.contentURL = tgUrl!
        do {
            let dialog = ShareDialog(fromViewController: nil, content: share, delegate: nil)
            dialog.show()
        }
    }
    
    @objc private func clickShareDiscord(_ sender: UIButton) {
        
        // 复制到剪切板
        // 获取剪贴板对象
        let pasteboard = UIPasteboard.general
        let textToCopy = "\(shareStr)\n\(shareLink)"
        pasteboard.string = textToCopy
        LSHUD.showSuccess("Copied to the clipboard")

        let urlString = "discord://"
        let tgUrl = URL.init(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        
        if UIApplication.shared.canOpenURL(tgUrl!)
            {
            UIApplication.shared.open(tgUrl!, options: [:], completionHandler: { success in
                if success {
                    print("URL opened successfully")
                } else {
                    print("Failed to open the URL")
                }
            })
        } else {
            LSHUD.showError("Discord not installed")
        }
    }

    
    @objc private func clickShareTwitter(_ sender: UIButton) {
        
        let urlString = "twitter://post?message=\(shareStr)\n\(shareLink)"
        let tgUrl = URL.init(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        
        if UIApplication.shared.canOpenURL(tgUrl!)
            {
            UIApplication.shared.open(tgUrl!, options: [:], completionHandler: { success in
                if success {
                    print("URL opened successfully")
                } else {
                    print("Failed to open the URL")
                }
            })
        } else {
            LSHUD.showError("X not installed")
        }
    }
    
    @objc private func clickShareButton(_ sender: UIButton) {
        clickShareAction?(shareLink)
    }
}

//MARK: data
extension CS_SharePlay2earnRightView {
    func setData(_ data: CS_ShareDataModel) {
        self.data = data
        shareLink = "\(CS_AccountManager.shared.shareConfig?.share_link ?? "")?deep_link=crazy%3A%2F%2Flaunch%3Finvited_code%3D\(data.code)"
        myLinkButton.setTitle(shareLink, for: .normal)
        cytAmountLabel.text = data.reward?.total?.invite_cyt
        cashAmountLabel.text = data.reward?.total?.invite_cash
        inputField.textField.isEnabled = false
        linkButton.isHidden = true
        if data.master_wallet.count > 0 {
            inputField.textField.text = data.master_wallet
            referralLinkLabel.text = "crazy_str_connect_referral_link".ls_localized
        } else {
            inputField.textField.text = "Temporarily no inviter Wallet".ls_localized
            referralLinkLabel.text = "Inviter Wallet".ls_localized
        }
    }
}


//MARK: UI
extension CS_SharePlay2earnRightView {
    
    private func setupView() {
        addSubview(backView)
        backView.addSubview(topView)
        topView.addSubview(titleLabel)
        backView.addSubview(mytitleLabel)
        backView.addSubview(myLinkButton)
        backView.addSubview(copyButton)
        backView.addSubview(referralLinkLabel)
        backView.addSubview(inputField)
        backView.addSubview(linkButton)
        backView.addSubview(rewardsLabel)
        backView.addSubview(rewardsView)
        rewardsView.addSubview(cytLabel)
        rewardsView.addSubview(cytAmountLabel)
        rewardsView.addSubview(cashLabel)
        rewardsView.addSubview(cashAmountLabel)
        rewardsView.addSubview(moreButton)
        backView.addSubview(telegramButton)
        backView.addSubview(shareButton)
        backView.addSubview(facebookButton)
        backView.addSubview(twitterButton)
        backView.addSubview(whatsAppButton)
        backView.addSubview(discordButton)
        
        
        backView.snp.makeConstraints { make in
            make.left.top.equalTo(5)
            make.right.bottom.equalTo(-5)
        }
        
        topView.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
            make.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalTo(topView)
        }
        
        mytitleLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(topView.snp.bottom).offset(12)
        }
        
        copyButton.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.equalTo(mytitleLabel.snp.bottom).offset(2)
            make.width.equalTo(28)
            make.height.equalTo(32)
        }
        
        myLinkButton.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(copyButton.snp.left).offset(-10)
            make.centerY.equalTo(copyButton)
            make.height.equalTo(21)
        }
        
        referralLinkLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(myLinkButton.snp.bottom).offset(12)
        }
        
        linkButton.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.equalTo(referralLinkLabel.snp.bottom).offset(10)
            make.width.equalTo(44)
            make.height.equalTo(21)
        }
        
        inputField.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(linkButton.snp.left).offset(0)
            make.centerY.equalTo(linkButton)
            make.height.equalTo(21)
        }
        
        rewardsLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(inputField.snp.bottom).offset(12)
        }
        
        rewardsView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(rewardsLabel.snp.bottom).offset(5)
            make.right.equalTo(-10)
            make.height.equalTo(44)
        }
        
        cytLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(8)
        }
        
        cytAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(cytLabel)
            make.bottom.equalTo(-4)
        }
        
        cashLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cytLabel)
            make.centerX.equalToSuperview()
        }
        
        cashAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(cashLabel)
            make.centerY.equalTo(cytAmountLabel)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
        
        telegramButton.snp.makeConstraints { make in
            make.left.equalTo(21)
            make.bottom.equalTo(-12)
            make.width.height.equalTo(34)
        }
        
        facebookButton.snp.makeConstraints { make in
            make.bottom.width.height.equalTo(telegramButton)
            make.left.equalTo(telegramButton.snp.right).offset(20)
        }
        
        twitterButton.snp.makeConstraints { make in
            make.bottom.width.height.equalTo(telegramButton)
            make.left.equalTo(facebookButton.snp.right).offset(20)
        }
        
        whatsAppButton.snp.makeConstraints { make in
            make.bottom.width.height.equalTo(telegramButton)
            make.left.equalTo(twitterButton.snp.right).offset(20)
        }

        discordButton.snp.makeConstraints { make in
            make.bottom.width.height.equalTo(telegramButton)
            make.left.equalTo(whatsAppButton.snp.right).offset(20)
        }
        
        shareButton.snp.makeConstraints { make in
            make.bottom.width.height.equalTo(telegramButton)
            make.left.equalTo(discordButton.snp.right).offset(20)
        }
        

    }
}
