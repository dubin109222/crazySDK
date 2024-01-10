//
//  CS_WalletSetPasswordAlert.swift
//  CrazySnake
//
//  Created by Lee on 03/04/2023.
//

import UIKit
import SwiftyAttributes

class CS_WalletSetPasswordAlert: CS_BaseAlert {

    var accountInfo: AccountModel? = CS_AccountManager.shared.accountInfo
    var oldPassword: String?
    var setPasswordSuccess: CS_NoParasBlock?
    
    var isConfirm = false
    private var password = ""
    private var confirmPassword = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var codeView: CS_CodeTextField = {
        let view = CS_CodeTextField()
        weak var weakSelf = self
        view.codeDidChange = { content in
            if weakSelf?.isConfirm == false {
                weakSelf?.password = content ?? ""
            } else {
                weakSelf?.confirmPassword = content ?? ""
            }
        }
        view.codeDidEndEditing = {
            if weakSelf?.isConfirm == false {
                if weakSelf?.password.count == 6 {
                    weakSelf?.isConfirm = true
                    weakSelf?.titleLabel.text = "crazy_str_pwd_verify".ls_localized
                    weakSelf?.tipsLabel.text = "crazy_str_pwd_confirm_desc".ls_localized
                    weakSelf?.codeView.pasteCode(nil)
                }
            } else {
                if weakSelf?.confirmPassword.count == 6 {
                    weakSelf?.verifyPassword()
                }
            }
        }
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_text_gray(), UIFont.ls_JostRomanFont(12))
        label.numberOfLines = 0
        label.attributedText = "Set a ".attributedString + "6-digit".withTextColor(.ls_green()) + " security code Changed password will be used for.".attributedString
        return label
    }()

}

//MARK: action
extension CS_WalletSetPasswordAlert {
    func verifyPassword(){
        guard self.password == self.confirmPassword else {
            CS_ToastView.showError("Password not correct")
            return
        }
        
        guard let address = accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: accountInfo?.private_key)
        guard let sign = sign else { return }
        let encryptPwd = password.ls_pwd_encode
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["pay_password"] = encryptPwd
        para["nonce"] = nonce
        para["sign"] = sign
        
        if let oldPwd = oldPassword, oldPwd.count > 0 {
            para["old_pay_password"] = oldPwd
        }
        
        LSHUD.showLoading()
        CSNetworkManager.shared.userSetPassword(para) { (resp: CS_WalletSetPasswordResp) in
            LSHUD.hide()
            if resp.status == .success {
                if resp.data?.success == 1 {
                    self.setPasswordSuccess?()
                    self.dismissSelf()
                } else {
                    
                }
            } else {
                LSHUD.showError(resp.message)
            }
        }
        
        
//        accountInfo?.password = encryptPwd;
//        accountInfo?.updateRealm()
//        setPasswordSuccess?()
//        dismissSelf()
    }
}


extension CS_WalletSetPasswordAlert {
    
    private func setupView() {
        tapDismissEnable = false
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_dark_3()
        contentView.layer.shadowRadius = 0
        contentView.ls_border(color: .ls_dark_5(),width: 1)
        closeButton.isHidden = false
        titleLabel.text = "crazy_str_pwd_set".ls_localized
        
        contentView.addSubview(codeView)
        contentView.addSubview(tipsLabel)
        
        contentView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(60)
            make.width.equalTo(401)
            make.height.equalTo(162)
        }
        
        codeView.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.top.equalTo(52)
            make.width.equalTo(370)
            make.height.equalTo(42)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(-32)
            make.top.equalTo(105)
        }
    }
}
