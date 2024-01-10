//
//  CS_ImportWalletController.swift
//  Platform
//
//  Created by Bob on 2021/9/28.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit
//import WalletCore

class CS_ImportWalletController: CS_WalletBaseController {
    
    /// There is no wallet.
    var isNew = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func hideKeyboardGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardGesture(_:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var contentBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#171718")
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_boldFont(24))
        label.numberOfLines = 0
        label.text = "crazy_str_enter_mnemonics_or_secret_label".ls_localized
        return label
    }()

    lazy var wordMenmonics: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 299, height: 109))
        textView.textColor = .ls_white()
        textView.ls_border(color: .ls_white())
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .ls_color("#171718")
        textView.font = .ls_JostRomanFont(12)
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets.init(top: 11, left: 11, bottom: 0, right: 19)
        return textView
    }()
    
    lazy var placeHolder: UILabel = {
        let lab: UILabel = UILabel()
        lab.font = .ls_mediumFont(12)
        lab.text = "Separate mnemonics with spaces. Support 12-word mnemonic import, support plaintext private key import.".ls_localized
        lab.textColor = .ls_text_gray()
        lab.numberOfLines = 0
        lab.lineBreakMode = .byWordWrapping
        return lab
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 310, height: 50))
        button.setTitle("crazy_str_import".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_red(), UIFont.ls_font(10))
        label.textAlignment = .center
        label.text = "crazy_str_enter_mnemonics_or_secret_warning".ls_localized
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
}

extension CS_ImportWalletController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHolder.isHidden = !textView.text.isEmpty
        
        isBtnEnble()
    }
}

extension CS_ImportWalletController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(string)
        return true
    }
}

//MARK: action
extension CS_ImportWalletController {
        
    @objc func clickConfirmButton(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let inputContent = wordMenmonics.text, inputContent.isEmpty == false else {
            LSHUD.showError("crazy_str_error_params_illegal".ls_localized)
            return
        }
        let isMnemonic = Utils.isMnemonic(inputContent)
        if isMnemonic {
            if Mnemonic.isValid(mnemonic: inputContent) == false {
                LSHUD.showError("Mnemonic not correct".ls_localized)
                return
            }
        } else {
            guard let address = Utils.getWalletAddress(privateKey: inputContent), Utils.isEthAddress(address) else {
                LSHUD.showError("Not correct".ls_localized)
                return
            }
        }

        if isMnemonic {
            createWalletByMnemonic(inputContent)
        } else {
            createWalletByPrivateKey(inputContent)
        }
    }

    private func isBtnEnble() {
        let mnemonic = wordMenmonics.text?.count ?? 0

        if (mnemonic > 0) {
            confirmButton.isEnabled = true
        }else {
            confirmButton.isEnabled = false
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        isBtnEnble()
    }
}

//MARK: create walley
private extension CS_ImportWalletController {
    
    func createWalletByMnemonic(_ mnemonic: String) {
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .ethereum)
        let wAccount = wallet.generateAccount()
        
        let privateKey = wAccount.rawPrivateKey
        let list = AccountModel.findAccountList()
        if let _ = list.first(where: {$0.private_key == privateKey}) {
            LSHUD.showError("Wallet is already exsit".ls_localized)
            return
        }

        let account = AccountModel()
        account.mnemonic_word = mnemonic
        account.private_key = privateKey
        let address = wAccount.address
        account.wallet_address = address
        account.backupStatus = "1"
        account.save()
        if isNew {
            CSSDKManager.shared.walletLoginType = 2
        } else {
            CSSDKManager.shared.walletLoginType = 1
        }
        CS_AccountManager.shared.accountInfo = account

        
        UserDefaults.standard.setValue(account.id, forKey: CacheKey.lastSelectedAccountId)
//        if isNew {
//            UIApplication.shared.keyWindow?.rootViewController = UITabBarController()
//        } else {
//            UIViewController.current()?.navigationController?.popToRootViewController(animated: true)
//        }
        NotificationCenter.default.post(name: NotificationName.importMenmonicWalletSuccess, object: nil)

    }
    
    func createWalletByPrivateKey(_ privateKey: String) {
        
        debugPrint(Utils.getWalletAddress(privateKey: privateKey))
        let list = AccountModel.findAccountList()
        if let _ = list.first(where: {$0.private_key == privateKey}) {
            LSHUD.showError("Wallet is already exsit".ls_localized)
            return
        }
        
        let account = AccountModel()
        account.private_key = privateKey
        account.wallet_address = Utils.getWalletAddress(privateKey: privateKey)
        account.backupStatus = "1"
        account.save()
        if isNew {
            CSSDKManager.shared.walletLoginType = 2
        } else {
            CSSDKManager.shared.walletLoginType = 1
        }
        CS_AccountManager.shared.accountInfo = account
        
        UserDefaults.standard.setValue(account.id, forKey: CacheKey.lastSelectedAccountId)
//        if isNew {
//            UIApplication.shared.keyWindow?.rootViewController = UITabBarController()
//        } else {
//            UIViewController.current()?.navigationController?.popToRootViewController(animated: true)
//        }
        NotificationCenter.default.post(name: NotificationName.importMenmonicWalletSuccess, object: nil)
    }
}


//MARK: UI
extension CS_ImportWalletController {
 
    private func setupView() {
  
        navigationView.titleLabel.text = "crazy_str_import_wallet".ls_localized
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize.zero
        view.addSubview(contentBackView)
        contentBackView.addSubview(contentLabel)
        contentBackView.addSubview(wordMenmonics)
        contentBackView.addSubview(placeHolder)
        contentBackView.addSubview(warningLabel)
        contentBackView.addSubview(confirmButton)
        
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
        
        contentBackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(self.contentBackView).offset(32)
            make.top.equalTo(self.contentBackView).offset(20)
            make.right.equalTo(-120)
        }
        
        wordMenmonics.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.left.equalTo(contentLabel)
            make.right.equalTo(-32)
            make.height.equalTo(109)
        }
        
        placeHolder.snp.makeConstraints { make in
            make.left.top.equalTo(wordMenmonics).offset(12)
            make.right.equalTo(wordMenmonics).offset(-12)
        }
        
        confirmButton.snp.remakeConstraints { make in
            make.top.equalTo(wordMenmonics.snp.bottom).offset(39)
            make.centerX.equalToSuperview()
            make.width.equalTo(310)
            make.height.equalTo(50)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.left.right.equalTo(wordMenmonics)
            make.top.equalTo(confirmButton.snp.bottom).offset(12)
        }
    }
}
