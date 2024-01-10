//
//  CS_WalletAccountCell.swift
//  CrazyWallet
//
//  Created by Lee on 29/06/2023.
//

import UIKit

class CS_WalletAccountCell: UITableViewCell {

    var clickSettingAction: CS_NoParasBlock?
    
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
    
    func setData(_ model: AccountModel, current: AccountModel?){
        selectIcon.isHidden = model.id != current?.id
        if let iconUrl = model.iconUrl {
            let url = URL.init(string: iconUrl)
            iconView.kf.setImage(with: url, placeholder: UIImage.ls_placeHeader())
        } else {
            iconView.image = .ls_placeHeader()
        }
        
        nameLabel.text = model.nickName
        addressLabel.text = model.wallet_address
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#171718")
        return view
    }()
    
    lazy var selectIcon: UIImageView = {
        let view = UIImageView()
        view.image = .ls_named("wallet_icon_selected2@2x")
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_boldFont(18))
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_text_gray(), UIFont.ls_JostRomanFont(12))
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickSettingButton(_:)), for: .touchUpInside)
        button.setImage(.ls_named("icon_wallet_setting"), for: .normal)
        return button
    }()
}

//MARK: action
extension CS_WalletAccountCell {
    @objc private func clickSettingButton(_ sender: UIButton) {
        clickSettingAction?()
    }
}


//MARK: UI
extension CS_WalletAccountCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        contentView.addSubview(selectIcon)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(settingButton)
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalToSuperview()
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        selectIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(18)
            make.width.height.equalTo(14)
        }
    
        iconView.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.left.equalTo(backView).offset(47)
            make.width.height.equalTo(49)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(10)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.bottom.equalTo(iconView)
            make.left.equalTo(nameLabel)
            make.width.equalTo(102)
        }
        
        settingButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
            make.width.height.equalTo(24)
        }
    }
}
