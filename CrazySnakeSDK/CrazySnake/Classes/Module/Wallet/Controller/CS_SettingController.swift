//
//  CS_SettingController.swift
//  Platform
//
//  Created by Lee on 29/04/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit

class CS_SettingController: CS_WalletBaseController {
    
    var accountInfo: AccountModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        registerNotication()
    }
    
    lazy var accountView: CS_WalletAccountInfoView = {
        let view = CS_WalletAccountInfoView()
        view.exchangeButton.isHidden = true
        view.setDataAccount(accountInfo)
        view.clickChangeAction = {
            let vc = CS_WalletEditorController()
            vc.accountInfo = self.accountInfo
            self.presentVC(vc)
        }
        return view
    }()
    
    lazy var reviseButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickReviseButton(_:)), for: .touchUpInside)
        button.backgroundColor = .ls_color("#202030")
        button.ls_cornerRadius(12)
        button.titleLabel?.font = .ls_font(12)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("Revise".ls_localized, for: .normal)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.register(SettingNormalCell.self, forCellReuseIdentifier: NSStringFromClass(SettingNormalCell.self))
        view.backgroundColor = .ls_color("171718")
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 100, right: 0)
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickDeleteButton(_:)), for: .touchUpInside)
        button.setTitleColor(.ls_red(), for: .normal)
        button.titleLabel?.font = .ls_boldFont(16)
        button.setTitle("Delete Wallet", for: .normal)
        button.ls_cornerRadius(10)
        button.ls_border(color: .ls_white(0.1))
        return button
    }()

}


//MARK: Notification
extension CS_SettingController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUserInfoChange(_:)), name: NotificationName.userInfoChanged, object: nil)
    }
    
    @objc private func notifyUserInfoChange(_ notify: Notification) {
        let account = notify.object as? AccountModel
        accountView.setDataAccount(account)
    }
}

//MARK: TableView
extension CS_SettingController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mnemonic = accountInfo?.mnemonic_word,mnemonic.count >= 0 {
            return 4
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SettingNormalCell.self)) as! SettingNormalCell
        cell.backupButton.isHidden = true
        switch indexPath.row {
        case 0:
            cell.iconView.image = .ls_named("wallet_icon_setting_privatekey@2x")
            cell.nameLabel.text = "View Private Key".ls_localized
        case 1:
            cell.iconView.image = .ls_named("wallet_icon_setting_password@2x")
            cell.nameLabel.text = "Change Payments Password".ls_localized
        case 2:
            cell.iconView.image = .ls_named("wallet_icon_setting_backup@2x")
            cell.nameLabel.text = "Bind Apple Account"
        case 3:
            cell.iconView.image = .ls_named("wallet_icon_setting_backup@2x")
            cell.nameLabel.text = "Backup Wallet"
            cell.backupButton.isHidden = false
            cell.backupButton.setIsBackup(accountInfo?.backupStatus == "1")
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf = self
        guard let account = accountInfo else {
            LSHUD.showError("crazy_str_error_params_illegal".ls_localized)
            return
        }
        
        switch indexPath.row {
        case 0:
            clickViewPrivateKey(account)
            break
        case 1:
            account.verifyPassword { pwd in
                let alert = CS_WalletSetPasswordAlert()
                alert.accountInfo = account
                alert.oldPassword = pwd
                alert.show()
            }
        case 2:
            LSHUD.showInfo("Not open yet")
//            let vc = CS_BindAppleAccount()
//            weakSelf?.pushTo(vc)
        case 3:
            account.verifyPassword { pwd in
                if let mnemonic = account.mnemonic_word,mnemonic.count >= 0 {
                    let vc = CS_WalletBackupController()
                    vc.mnemonic = mnemonic
                    vc.accountInfo = weakSelf?.accountInfo
                    weakSelf?.pushTo(vc)
                }
            }
        default:
            break
        }
    }
    
    func clickViewPrivateKey(_ account: AccountModel){
        account.verifyPassword { pwd in
            let alert = CS_WalletConfirmAlert()
            alert.confirmButton.setTitle("Copy", for: .normal)
            alert.confirmButton.setTitleColor(.ls_color("#61CA7A"), for: .normal)
            alert.cancelButton.setTitle("Close", for: .normal)
            alert.show("View Private Key", content: account.private_key)
            alert.clickConfirmAction = {
                UIPasteboard.general.string = account.private_key
                LSHUD.showSuccess("crazy_str_copied".ls_localized)
            }
        }
    }
}

//MARK: action
extension CS_SettingController {
    
    @objc private func clickReviseButton(_ sender: UIButton) {
        let vc = CS_WalletEditorController()
        vc.accountInfo = self.accountInfo
        self.presentVC(vc)
    }
    
    @objc private func clickDeleteButton(_ sender: UIButton) {
        let alert = CS_WalletConfirmAlert()
        alert.confirmButton.setTitle("Delete", for: .normal)
        alert.confirmButton.setTitleColor(.ls_red(), for: .normal)
        alert.show("Tips", content: "Delete wallet?")
        alert.clickConfirmAction = {
            self.deleteWallet()
        }
    }
    
    func deleteWallet(){
        let isCurrent = CS_AccountManager.shared.accountInfo?.id == accountInfo?.id
        accountInfo?.deleteFromRealm()
        let dataSource = AccountModel.findAccountList()
        if isCurrent {
            let model = dataSource.first
            CS_AccountManager.shared.accountInfo = model
            UserDefaults.standard.setValue(model?.id, forKey: CacheKey.lastSelectedAccountId)
            NotificationCenter.default.post(name: NotificationName.walletChanged, object: model)
        }
        
        if dataSource.count > 0 {
            pop()
        } else {
            popTo(CS_HomeController.self)
//            UIApplication.shared.keyWindow?.rootViewController = CS_HomeController()
        }
    }
}


//MARK: UI
extension CS_SettingController {
    
    private func setupView() {
//        titleImage = UIImage(named: "title_settings")
        navigationView.titleLabel.text = "Settings".ls_localized
        view.addSubview(accountView)
        view.addSubview(reviseButton)
        view.addSubview(tableView)
        view.addSubview(deleteButton)
        
        accountView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(navigationView.snp.bottom).offset(20)
            make.width.equalTo(CS_kScreenW*0.6)
            make.height.equalTo(74)
        }
        
        reviseButton.snp.makeConstraints { make in
            make.centerY.equalTo(accountView)
            make.right.equalTo(-32)
            make.width.equalTo(68)
            make.height.equalTo(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(self.accountView.snp.bottom).offset(0)
            make.bottom.equalTo(-28)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-22)
            make.width.equalTo(311)
            make.height.equalTo(51)
        }
    }
}
