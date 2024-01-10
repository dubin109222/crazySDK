//
//  CS_WalletPasswordVerifyAlert.swift
//  CrazySnake
//
//  Created by Lee on 03/04/2023.
//

import UIKit

class CS_WalletPasswordVerifyAlert: CS_BaseAlert {

    var accountInfo: AccountModel? = CS_AccountManager.shared.accountInfo
    var verifySuccess: CS_StringBlock?
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
            weakSelf?.confirmPassword = content ?? ""
        }
        view.codeDidEndEditing = { 
            if weakSelf?.confirmPassword.count == 6 {
                weakSelf?.verifyPassword()
            }
        }
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_text_gray(), UIFont.ls_JostRomanFont(12))
        label.numberOfLines = 0
        label.text = "crazy_str_pwd_confirm_desc".ls_localized
        return label
    }()

}

//MARK: action
extension CS_WalletPasswordVerifyAlert {
    func verifyPassword(){
        
        let encryptPwd = self.confirmPassword.ls_pwd_encode
        guard let address = accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: accountInfo?.private_key)
        guard let sign = sign else { return }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["pay_password"] = encryptPwd
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.verifyPassword(para) { (resp: CS_WalletSetPasswordResp) in
            LSHUD.hide()
            if resp.status == .success {
                if resp.data?.success == 1 {
                    self.dismissSelf()
                    self.verifySuccess?(encryptPwd)
                } else {
                    self.dismissSelf()
                    LSHUD.showError("Password not correct")
                }
            } else {
                self.dismissSelf()
                LSHUD.showError(resp.message)
            }
        }
        
//        dismissSelf()
//        verifySuccess?(encryptPwd)
    }
}


extension CS_WalletPasswordVerifyAlert {
    
    private func setupView() {
        tapDismissEnable = false
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_dark_3()
        contentView.layer.shadowRadius = 0
        contentView.ls_border(color: .ls_dark_5(),width: 1)
        closeButton.isHidden = false
        titleLabel.text = "crazy_str_pwd_verify".ls_localized
        
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
