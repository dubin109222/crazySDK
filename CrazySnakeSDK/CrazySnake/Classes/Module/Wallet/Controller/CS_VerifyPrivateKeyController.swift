//
//  CS_VerifyPrivateKeyController.swift
//  CrazySnake
//
//  Created by Lee on 28/03/2023.
//

import UIKit

class CS_VerifyPrivateKeyController: CS_BaseController {

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
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(10)
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(19))
        label.text = "crazy_str_backup_confirm_label".ls_localized
        return label
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_text_light(), UIFont.ls_font(10))
        label.text = "crazy_str_backup_confirm_desc".ls_localized
        label.numberOfLines = 0
        return label
    }()

    lazy var wordMenmonics: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 348, height: 120))
        textView.textColor = .ls_blue()
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .ls_dark_4()
        textView.font = .ls_JostRomanFont(12)
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets.init(top: 11, left: 11, bottom: 0, right: 19)
        return textView
    }()
    
    lazy var placeHolder: UILabel = {
        let lab: UILabel = UILabel()
        lab.font = .ls_JostRomanFont(12)
        lab.text = "crazy_str_backup_confirm_hint".ls_localized
        lab.textColor = .ls_text_light()
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 174, height: 44))
        button.setTitle("crazy_str_complete_verify".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_text_light(), UIFont.ls_font(10))
        label.textAlignment = .center
        label.text = "crazy_str_backup_confirm_warning".ls_localized
        label.numberOfLines = 0
        return label
    }()
}

extension CS_VerifyPrivateKeyController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHolder.isHidden = !textView.text.isEmpty
        
        isBtnEnble()
    }
}

extension CS_VerifyPrivateKeyController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}

//MARK: action
extension CS_VerifyPrivateKeyController {
        
    @objc func clickConfirmButton(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let inputContent = wordMenmonics.text, inputContent.isEmpty == false else {
            LSHUD.showError("crazy_str_error_params_illegal".ls_localized)
            return
        }
        if inputContent == CS_AccountManager.shared.accountInfo?.private_key {
            CS_AccountManager.shared.accountInfo?.backupStatus = "1"
            CS_AccountManager.shared.accountInfo?.updateRealm()
            popTo(CS_HomeController.self)
        } else {
            LSHUD.showError("Not correct".ls_localized)
        }
    }

    private func isBtnEnble() {
        let mnemonic = wordMenmonics.text?.count ?? 0

        if (mnemonic > 0) {
            confirmButton.isEnabled = true
        }else {
            confirmButton.isEnabled = true
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        isBtnEnble()
    }
}


//MARK: UI
extension CS_VerifyPrivateKeyController {
 
    private func setupView() {
  
        navigationView.titleLabel.text = "crazy_str_backup".ls_localized
//        confirmButton.isEnabled = false
//        backView.image = nil;
        bottomBarView.isHidden = false

        
        view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize.zero
        scrollView.addSubview(contentBackView)
        contentBackView.addSubview(contentLabel)
        contentBackView.addSubview(tipsLabel)
        contentBackView.addSubview(wordMenmonics)
        wordMenmonics.addSubview(placeHolder)
        view.addSubview(warningLabel)
        contentBackView.addSubview(confirmButton)
        
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom)
        }
        
        contentBackView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(146)
            make.top.equalTo(scrollView).offset(24)
            make.right.equalTo(view).offset(-146)
            make.bottom.equalTo(view).offset(-56)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(self.contentBackView).offset(20)
            make.top.equalTo(contentBackView).offset(14)
            make.right.equalTo(self.contentBackView).offset(-20)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.right.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-12)
        }
        
        confirmButton.snp.remakeConstraints { make in
            make.centerX.equalTo(contentBackView).offset(0)
            make.bottom.equalTo(-16)
            make.width.equalTo(174)
            make.height.equalTo(44)
        }
         
        wordMenmonics.snp.makeConstraints { make in
            make.top.equalTo(tipsLabel.snp.bottom).offset(12)
            make.left.right.equalTo(contentLabel)
            make.bottom.equalTo(confirmButton.snp.top).offset(-20)
        }
        
        placeHolder.snp.makeConstraints { make in
            make.left.top.equalTo(12)
            make.right.equalTo(contentLabel).offset(-12)
        }
    }
}
