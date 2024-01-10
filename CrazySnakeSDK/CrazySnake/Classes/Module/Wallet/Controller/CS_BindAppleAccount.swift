//
//  CS_BindAppleCount.swift
//  CrazySnake
//
//  Created by BigB on 2023/7/25.
//

import Foundation
import SnapKit
import AuthenticationServices
import HandyJSON

class CS_BindAppleAccount : CS_BaseEmptyController {
    
    private var isBinding = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.titleLabel.text = "Bind Apple Account".ls_localized
        
        self.initSubViews()
        self.loadData()
    }
    
    private func loadData() {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        
        struct BindAccountModel : HandyJSON {
            var account: String?
        }

        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["type"] = 2
        
        LSHUD.showLoading()
        CSNetworkManager.shared.checkBindAccount(para) { (resp : BindAccountModel) in
            LSHUD.hide()
            if resp.account != nil && resp.account?.isEmpty != true {
                self.bindBtn.isHidden = true
                self.cancelBindBtn.isHidden = false
                self.changeBtn.isHidden = false
            } else {
                self.bindBtn.isHidden = false
                self.cancelBindBtn.isHidden = true
                self.changeBtn.isHidden = true

            }
        }
    }
    
    
    private func bindAccount(client_user: String , id_token: String) {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        
        struct BlankContent : HandyJSON {
            var success: String?
        }
        
        let account = CS_AccountManager.shared.accountInfo
        guard let address = account?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: account?.private_key)
        guard let sign = sign else { return }


        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["type"] = 2
        para["id_token"] = id_token
        para["client_user"] = client_user
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()

        if self.isBinding {
            CSNetworkManager.shared.bindAccount(para) { (resp : BlankContent) in
                if resp.success == "1" {
                    self.loadData()
                } else {
                    LSHUD.hide()
                }
            }
        } else {
            CSNetworkManager.shared.unbindAccount(para) { (resp : BlankContent) in
                if resp.success == "1" {
                    self.loadData()
                } else {
                    LSHUD.hide()
                }
            }

        }
    }
    
    
    let cancelBindBtn = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 200, height: 44))
    let bindBtn = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 200, height: 44))
    let changeBtn = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 200, height: 44))

    private func initSubViews() {
        let textView = UITextView()
        textView.isEditable = false
        self.view.addSubview(textView)
        
        textView.text = """
For the security of your account, you need to bind your Apple account It can only be played in the game on the CrazyLand platform later.
Operation transformation or other specific operation.
 There is an upper limit on the number of wallets that can be bound to each Apple account.
After reaching the upper limit, the Apple account cannot continue to bind the wallet.
Wallets bound to Apple accounts can also change the bound Apple
Account or unbind.
There will be a 30-day cooling-off period for the Apple account that is changed or unbound.
During the cooling-off period, no other wallets can be bound.
"""
        textView.backgroundColor = .clear
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(CS_ms(20))
            make.top.equalToSuperview().offset(CS_kNavBarHeight)
            make.bottom.equalToSuperview().offset(-60)
        }

        
        cancelBindBtn.setTitle("Cancel Bind", for: .normal)
        cancelBindBtn.addTarget(self, action: #selector(cancelBindAppleAccount), for: .touchUpInside)
        changeBtn.setTitle("Change Bind", for: .normal)
        changeBtn.addTarget(self, action: #selector(clickBindAppleAccout), for: .touchUpInside)

        self.view.addSubview(cancelBindBtn)
        self.view.addSubview(changeBtn)
        
        cancelBindBtn.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.centerX).offset(-10)
            make.top.equalTo(textView.snp.bottom)
            make.size.equalTo(CGSize.init(width: 200, height: 44))
        }
        
        changeBtn.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.centerX).offset(10)
            make.top.equalTo(textView.snp.bottom)
            make.size.equalTo(CGSize.init(width: 200, height: 44))
        }
        
        bindBtn.setTitle("Bind", for: .normal)
        bindBtn.addTarget(self, action: #selector(clickBindAppleAccout(_:)), for: .touchUpInside)
        self.view.addSubview(bindBtn)
        bindBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textView.snp.bottom)
            make.size.equalTo(CGSize.init(width: 200, height: 44))
        }

        
        cancelBindBtn.isHidden = true
        changeBtn.isHidden = true
        bindBtn.isHidden = true

    }

    // 取消绑定
    @objc func cancelBindAppleAccount() {
        self.isBinding = false
        self.requestAppleSign()
    }
    
    // 绑定苹果账号
    @objc func clickBindAppleAccout(_ sender: UIButton ) {
        self.isBinding = true
        self.requestAppleSign()
    }
    
    private func requestAppleSign() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let appleIDRequest = appleIDProvider.createRequest()
        // Request user's full name and email
        appleIDRequest.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [appleIDRequest])
        // Set the delegate to handle successful and failed authorization requests
        authorizationController.delegate = self
        // Set the delegate to provide a presentation context where the system can display the authorization interface to the user
        authorizationController.presentationContextProvider = self
        // Start the authorization flow during the controller's initialization
        authorizationController.performRequests()

    }
}
extension CS_BindAppleAccount : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension CS_BindAppleAccount : ASAuthorizationControllerDelegate {
    
    // MARK: - Apple Login

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // User logged in using ASAuthorizationAppleIDCredential
            let user = appleIDCredential.user
            let identityToken = appleIDCredential.identityToken
            
            if let identityTokenData = identityToken, let identityTokenStr = String(data: identityTokenData, encoding: .utf8) {
//                applyLoginPost(user: user, andToken: identityTokenStr)
                debugPrint("user --- ", user, "token" , identityTokenStr)
                self.bindAccount(client_user: user, id_token: identityTokenStr)
            } else {
                // Handle error while converting identityToken to String
                print("Error converting identityToken to String.")
            }
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // User logged in using an existing password credential (stored in iCloud Keychain)
            let user = passwordCredential.user
            let password = passwordCredential.password
            
            let alertstr = "The app has received your selected credential from the keychain. \n\n Username: \(user)\n Password: \(password)"
//            SVProgressHUD.showError(withStatus: alertstr)
        } else {
            print("Authorization information does not match.")
        }
    }
    


    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        var errorMsg: String? = nil
        if let authorizationError = error as? ASAuthorizationError {
            switch authorizationError.code {
            case .canceled:
                errorMsg = "User canceled the authorization request."
            case .failed:
                errorMsg = "Authorization request failed."
            case .invalidResponse:
                errorMsg = "Invalid authorization request response."
            case .notHandled:
                errorMsg = "Authorization request not handled."
            case .unknown:
                errorMsg = "Unknown reason for authorization request failure."
            @unknown default:
                break
            }
        } else {
            errorMsg = "An unknown error occurred during authorization."
        }
        print(errorMsg ?? "")
    }

}
