//
//  CS_WalletAccountView.swift
//  CrazyWallet
//
//  Created by Lee on 30/06/2023.
//

import UIKit

class CS_WalletAccountView: UIView {

    var clickChangeAction: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataUser(_ user: CS_UserInfoModel?) {
        infoView.setDataUser(user)
    }
    
    func setDataAccount(_ account: AccountModel?) {
        infoView.setDataAccount(account)
    }
    
    lazy var infoView: CS_WalletAccountInfoView = {
        let view = CS_WalletAccountInfoView()
        view.clickChangeAction = {
            self.clickChangeAction?()
        }
        return view
    }()
    
    lazy var chainBack: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#242426")
        view.cornerRadius = 11.5
        return view
    }()
    
    lazy var chainIcon: UIButton = {
        let button = UIButton()
        button.setImage(.ls_named("icon_chain_polygon@2x")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    lazy var chainButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 23))
        button.setTitle(Config.chain.name.ls_localized, for: .normal)
        button.titleLabel?.font = .ls_font(12)
        button.setTitleColor(UIColor.ls_white(), for: .normal)
        button.setImage(.ls_named("wallet_icon_arrow_down@2x"), for: .normal)
        button.ls_layout(.imageRight,padding: 4)
        return button
    }()
}

//MARK: UI
extension CS_WalletAccountView {
    
    private func setupView() {
        addSubview(infoView)
        addSubview(chainBack)
        addSubview(chainIcon)
        addSubview(chainButton)
        
        infoView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(10)
            make.height.equalTo(62)
            make.width.equalTo(200)
        }
        
        chainButton.snp.makeConstraints { make in
            make.right.equalTo(-32)
            make.bottom.equalTo(-20)
            make.width.equalTo(80)
            make.height.equalTo(23)
        }
        
        chainIcon.snp.makeConstraints { make in
            make.centerY.equalTo(chainButton)
            make.right.equalTo(chainButton.snp.left).offset(-5)
            make.width.height.equalTo(24)
        }
        
        chainBack.snp.makeConstraints { make in
            make.centerY.equalTo(chainButton)
            make.height.equalTo(23)
            make.left.equalTo(chainIcon).offset(-12)
            make.right.equalTo(chainButton).offset(12)
        }
    }
}
