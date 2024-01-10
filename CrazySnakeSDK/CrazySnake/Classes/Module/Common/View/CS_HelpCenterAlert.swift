//
//  CS_HelpCenterAlert.swift
//  CrazySnake
//
//  Created by Lee on 28/03/2023.
//

import UIKit

class CS_HelpCenterAlert: CS_BaseAlert {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_helpcenter@2x")
        return view
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .ls_color("#2B2734")
        view.font = .ls_JostRomanFont(12)
        view.textColor = .ls_text_gray()
        view.isEditable = false
        view.textContainerInset = UIEdgeInsets.init(top: 24, left: 16, bottom: 16, right: 16)
        return view
    }()

}

//MARK: function
extension CS_HelpCenterAlert {
    static func showEvent(){
        let alert = CS_HelpCenterAlert()
        alert.titleLabel.text = "crazy_str_event".ls_localized
        alert.textView.text = "crazy_str_help_event".ls_localized
        alert.show()
    }
    
    static func showShareTips(){
        let alert = CS_HelpCenterAlert()
        alert.titleLabel.text = "crazy_str_play_2_earn".ls_localized
        alert.textView.text = "crazy_str_help_share_cash_value".ls_localized
        alert.show()
    }
    
    static func showTokenStake(){
        let alert = CS_HelpCenterAlert()
        alert.titleLabel.text = "crazy_str_token_stake".ls_localized
        alert.textView.text = "crazy_str_help_token_stake".ls_localized
        alert.show()
    }
    
    static func showStakeNFT(){
        let alert = CS_HelpCenterAlert()
        alert.titleLabel.text = "crazy_str_nft_stake".ls_localized
        alert.textView.text = "crazy_str_help_nft_stake".ls_localized
        alert.show()
    }
    
    static func showNFTRecycle(){
        let alert = CS_HelpCenterAlert()
        alert.titleLabel.text = "crazy_str_conversion".ls_localized
        alert.textView.text = "crazy_str_help_recycle".ls_localized
        alert.show()
    }
    
    static func showNFTIncubation(){
        let alert = CS_HelpCenterAlert()
        alert.titleLabel.text = "crazy_str_incubator".ls_localized
        alert.textView.text = "crazy_str_help_incubation".ls_localized
        alert.show()
    }
    
    static func showLuckColorTips(){
        let alert = CS_HelpCenterAlert()
        alert.titleLabel.text = "crazy_str_guess_the_size".ls_localized
        alert.textView.text = "".ls_localized
        alert.show()
    }
    
    static func showStakeCytTips(){
        let alert = CS_HelpCenterAlert()
        alert.titleLabel.text = "crazy_str_token_stake".ls_localized
        alert.textView.text = "".ls_localized
        alert.show()
    }
    
    static func show(){
        let alert = CS_HelpCenterAlert()
        alert.titleLabel.text = "crazy_str_token_stake".ls_localized
        alert.textView.text = "".ls_localized
        alert.show()
    }
}

extension CS_HelpCenterAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_color("#201D27")
        closeButton.isHidden = false
        
        contentView.addSubview(iconView)
        contentView.addSubview(textView)
        
        contentView.snp.remakeConstraints { make in
            make.top.equalTo(73)
            make.left.equalTo(106)
            make.right.equalTo(-88)
            make.bottom.equalTo(-45)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.centerY.equalTo(closeButton)
            make.width.height.equalTo(18)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(contentView).offset(48)
            make.centerY.equalTo(iconView)
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(44)
            make.right.bottom.equalTo(-10)
        }
    }
    
}


