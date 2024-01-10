//
//  CS_WalletAccountInfoView.swift
//  CrazyWallet
//
//  Created by Lee on 30/06/2023.
//

import UIKit

class CS_WalletAccountInfoView: UIView {
    
    var clickChangeAction: CS_NoParasBlock?
    var account: AccountModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataUser(_ user: CS_UserInfoModel?) {
        if let model = user {
            let url = URL.init(string: model.avatar_image)
            avatarButton.kf.setImage(with: url, for: .normal, placeholder: UIImage.ls_placeHeader())
            nameButton.setTitle(model.name, for: .normal)
        }
    }

    func setDataAccount(_ account: AccountModel?) {
//        guard let account = account else { return }
        self.account = account
        if let iconUrl = account?.iconUrl {
            let url = URL.init(string: iconUrl)
            avatarButton.kf.setImage(with: url, for: .normal, placeholder: UIImage.ls_placeHeader())
        } else {
            avatarButton.setImage(.ls_placeHeader(), for: .normal)
        }
        nameButton.setTitle(account?.nickName, for: .normal)
        addressButton.setTitle(account?.wallet_address, for: .normal)
    }
    
    lazy var avatarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.ls_placeHeader(), for: .normal)
        button.addTarget(self, action: #selector(clickChangeWalletButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nameButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickChangeWalletButton(_:)), for: .touchUpInside)
        button.titleLabel?.font = .ls_JostRomanFont(19)
        button.setTitleColor(UIColor.ls_white(), for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var addressButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .ls_font(12)
        button.setTitleColor(UIColor.ls_color("#8E8E8E"), for: .normal)
        button.addTarget(self, action: #selector(clickAddressButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var copyButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickAddressButton(_:)), for: .touchUpInside)
        button.setImage(.ls_named("icon_wallet_copy"), for: .normal)
        return button
    }()
    
    lazy var exchangeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickChangeWalletButton(_:)), for: .touchUpInside)
        button.setImage(.ls_named("wallet_icon_arrow_down@2x"), for: .normal)
        return button
    }()

}

//MARK: action
extension CS_WalletAccountInfoView {
    @objc private func clickUserInfoButton(_ sender: UIButton) {

    }
    
    @objc private func clickChangeWalletButton(_ sender: UIButton) {
        clickChangeAction?()
    }
    
    @objc private func clickAddressButton(_ sender: UIButton) {
        guard account?.wallet_address != nil else {
            return
        }
        UIPasteboard.general.string = account?.wallet_address
        LSHUD.showSuccess("crazy_str_copied".ls_localized)
    }
}


//MARK: UI
extension CS_WalletAccountInfoView {
    
    private func setupView() {
        addSubview(avatarButton)
        addSubview(nameButton)
        addSubview(exchangeButton)
        addSubview(addressButton)
        addSubview(copyButton)
        
        avatarButton.snp.makeConstraints { make in
            make.top.equalTo(4)
            make.left.equalTo(0)
            make.width.height.equalTo(48)
        }
        
        nameButton.snp.makeConstraints { make in
            make.top.equalTo(avatarButton).offset(-4)
            make.left.equalTo(avatarButton.snp.right).offset(10)
        }
        
        exchangeButton.snp.makeConstraints { make in
            make.left.equalTo(nameButton.snp.right).offset(4)
            make.centerY.equalTo(nameButton)
            make.width.height.equalTo(18)
        }
        
        addressButton.snp.makeConstraints { make in
            make.left.equalTo(nameButton)
            make.bottom.equalTo(avatarButton).offset(4)
            make.width.equalTo(98)
        }
        
        copyButton.snp.makeConstraints { make in
            make.left.equalTo(addressButton.snp.right).offset(4)
            make.centerY.equalTo(addressButton)
            make.width.height.equalTo(18)
        }
    }
}
