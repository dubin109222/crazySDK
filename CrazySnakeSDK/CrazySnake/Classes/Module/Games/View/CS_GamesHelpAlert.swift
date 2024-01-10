//
//  CS_GamesHelpAlert.swift
//  CrazySnake
//
//  Created by Lee on 19/05/2023.
//

import UIKit
import SwiftyAttributes

class CS_GamesHelpAlert: CS_BaseAlert {

    var sessionInfo: CS_SessionInfoModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showWith(_ model: CS_SessionInfoModel?) {
        sessionInfo = model
        titleLabel.text = "crazy_str_guess_the_size".ls_localized
        textView.text = "crazy_str_help_guess_hot_play".ls_localized
        linkButton.setTitle(model?.jump_url, for: .normal)
        show()
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

    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_font(12))
        label.attributedText = "crazy_html_length_of_match".ls_localized_color(["5"])
//        "Length of a Match: ".attributedString + "5 ".withTextColor(.ls_color("#00FFB5")).withFont(.ls_JostRomanFont(16)) + "minutes".attributedString
        return label
    }()
    
    lazy var linkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickLinkButton(_:)), for: .touchUpInside)
        button.titleLabel?.font = .ls_font(12)
        button.setTitleColor(.ls_color("#C7A6F9"), for: .normal)
        return button
    }()

    
    lazy var linkIconButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickLinkButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("games_icon_share@2x"), for: .normal)
        return button
    }()
    
    @objc private func clickLinkButton(_ sender: UIButton) {
        if let model = sessionInfo, let url = URL(string: model.jump_url) {
            UIApplication.shared.open(url)
        }
    }
}


extension CS_GamesHelpAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_color("#201D27")
        closeButton.isHidden = false
        
        contentView.addSubview(iconView)
        contentView.addSubview(textView)
        contentView.addSubview(infoLabel)
        contentView.addSubview(linkButton)
        contentView.addSubview(linkIconButton)
        
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
            make.right.equalTo(-10)
            make.bottom.equalTo(-40)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(textView)
            make.bottom.equalTo(-12)
        }
        
        linkIconButton.snp.makeConstraints { make in
            make.centerY.equalTo(infoLabel)
            make.right.equalTo(-16)
            make.width.height.equalTo(12)
        }
        
        linkButton.snp.makeConstraints { make in
            make.centerY.equalTo(linkIconButton)
            make.right.equalTo(linkIconButton.snp.left).offset(-8)
            make.width.equalTo(140)
            make.height.equalTo(10)
        }
    }
    
}
