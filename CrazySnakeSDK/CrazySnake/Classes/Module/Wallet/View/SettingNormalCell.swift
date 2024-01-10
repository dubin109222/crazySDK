//
//  SettingNormalCell.swift
//  Platform
//
//  Created by Lee on 29/04/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit

class SettingNormalCell: UITableViewCell {
    
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
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_boldFont(14))
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_text_gray(), UIFont.ls_JostRomanFont(12))
        return label
    }()
    
    lazy var arrowIcon: UIImageView = {
        let view = UIImageView()
        view.image = .ls_bundle("icon_seetting_arrow")
        view.isHidden = true
        return view
    }()
    
    lazy var backupButton: CS_WalletBackupButton = {
        let button = CS_WalletBackupButton()
        button.ls_cornerRadius(12)
        button.isHidden = true
        button.isUserInteractionEnabled = false
        button.coverButton.isUserInteractionEnabled = false
        return button
    }()

}

//MARK: data
extension SettingNormalCell {
    
}


//MARK: UI
extension SettingNormalCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(iconView)
        backView.addSubview(nameLabel)
        backView.addSubview(infoLabel)
        backView.addSubview(arrowIcon)
        backView.addSubview(backupButton)
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
    
        iconView.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.left.equalTo(backView).offset(15)
            make.width.height.equalTo(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(6)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(iconView)
            make.left.equalTo(nameLabel)
        }
        
        arrowIcon.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.right.equalTo(backView).offset(-21)
        }
        
        backupButton.snp.makeConstraints { make in
            make.centerY.equalTo(arrowIcon)
            make.right.equalTo(arrowIcon.snp.left).offset(-12)
            make.width.equalTo(64)
            make.height.equalTo(24)
        }
    }
}
