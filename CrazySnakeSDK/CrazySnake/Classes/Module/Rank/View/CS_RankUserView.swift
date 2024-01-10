//
//  CS_RankUserView.swift
//  CrazySnake
//
//  Created by Lee on 12/06/2023.
//

import UIKit

class CS_RankUserView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_RankTotalPowerModel?){
        guard let model = model else { return }
        let url = URL.init(string: model.avatar_image)
        iconView.kf.setImage(with: url , placeholder: UIImage.ls_bundle("common_default_head_icon@2x"), options: nil , completionHandler: nil)
        nameLabel.text = model.name
        addressLabel.text = model.wallet_address
        let isSelf = model.wallet_address.lowercased() == CS_AccountManager.shared.accountInfo?.wallet_address?.lowercased()
        selfIcon.isHidden = !isSelf
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.ls_cornerRadius(8)
        return view
    }()
    
    lazy var selfIcon: UILabel = {
        let label = UILabel()
        label.backgroundColor = .ls_color("#B33C18")
        label.ls_set(.ls_white(), .ls_font(9))
        label.textAlignment = .center
        label.text = "crazy_str_me".ls_localized
        label.isHidden = true
        label.ls_cornerRadius(4)
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_font(10))
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
}

//MARK: UI
extension CS_RankUserView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(selfIcon)
        addSubview(nameLabel)
        addSubview(addressLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(4)
            make.width.height.equalTo(32)
        }
        
        selfIcon.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.left).offset(-6)
            make.top.equalTo(iconView.snp.top).offset(-6)
            make.width.equalTo(18)
            make.height.equalTo(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(10)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(iconView)
            make.width.equalTo(64)
        }
    }
}
