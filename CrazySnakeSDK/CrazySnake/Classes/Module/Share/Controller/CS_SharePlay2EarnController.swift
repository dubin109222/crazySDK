//
//  CS_SharePlay2EarnController.swift
//  CrazySnake
//
//  Created by Lee on 08/05/2023.
//

import UIKit
import JXSegmentedView

class CS_SharePlay2EarnController: CS_BaseEmptyController {
    
    let shareStr = ["""
                    Have you played Crazy Slither today?
                    Let's see who's up to some adventures!
                    """,
                    """
                    Before go to bed, how about a relaxing game of Crazy Slither!
                    """,
                    """
                    In Crazy Slither everything you do is rewarded!
                    """].randomElement() ?? ""

    
    var clickEarnMoreAction: CS_NoParasBlock?
    var clickWithdrawAction: CS_NoParasBlock?
    var data: CS_ShareDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        loadData()
    }
    

    lazy var leftView: CS_SharePlay2earnLeftView = {
        let view = CS_SharePlay2earnLeftView()
        view.backgroundColor = .ls_color("#ABABAB", alpha:0.6)
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var rightView: CS_SharePlay2earnRightView = {
        let view = CS_SharePlay2earnRightView()
        view.backgroundColor = .ls_color("#ABABAB", alpha:0.6)
        view.ls_cornerRadius(5)
        weak var weakSelf = self
        view.clickShareAction = { link in
            weakSelf?.clickShare(link)
        }
        view.clickLinkAction = {
            weakSelf?.linkAction()
        }
        view.clickMoreAction = {
            let vc = CS_ShareMoreInfomationController()
            weakSelf?.present(vc, animated: false, completion: nil)
        }
        return view
    }()
    
    lazy var earnMoreButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickEarnMoreButton(_:)), for: .touchUpInside)
        button.setBackgroundImage(UIImage.ls_bundle("share_bg_more_btn@2x"), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_earn_more".ls_localized, for: .normal)
        return button
    }()
    
    lazy var withdrawButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickWithdrawButton(_:)), for: .touchUpInside)
        button.setBackgroundImage(UIImage.ls_bundle("share_bg_withdraw_btn@2x"), for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("Withdraw".ls_localized, for: .normal)
        return button
    }()

}

//MARK: action
extension CS_SharePlay2EarnController {
    @objc private func clickEarnMoreButton(_ sender: UIButton) {
        clickEarnMoreAction?()
    }
    
    @objc private func clickWithdrawButton(_ sender: UIButton) {
        clickWithdrawAction?()
    }
    
    @objc private func clickShare(_ link: String?) {

        let url = URL(string: link!)
        let text = shareStr
        let items: [Any] = [text , url]
        
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
        presentVC(vc)

    }
    

    
    

}

//MARK: request
extension CS_SharePlay2EarnController {
    func loadData() {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        
        CSNetworkManager.shared.getSharePageData(address) { resp in
            if resp.status == .success {
                self.data = resp.data
                self.updateData()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func linkAction(){
        guard var link = rightView.inputField.textField.text, link.count > 0 else {
            LSHUD.showError("crazy_str_error".ls_localized)
            return
        }
        
        if let code = link.components(separatedBy: "%3D").last {
            link = code
        }
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sign"] = sign
        para["nonce"] = nonce
        LSHUD.showLoading()
        weak var weakSelf = self
        CSNetworkManager.shared.bindShareLink(address, code: link,para: para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                LSHUD.showSuccess(resp.message)
                weakSelf?.loadData()
            } else {
                LSHUD.showError(resp
                    .message)
            }
        }
        
    }
}


extension CS_SharePlay2EarnController {
    func updateData() {
        guard let data = self.data else { return }
        leftView.setData(data)
        rightView.setData(data)
    }
    
    func setupView(){
        navigationView.isHidden = true
        
        view.addSubview(leftView)
        view.addSubview(rightView)
        view.addSubview(earnMoreButton)
        view.addSubview(withdrawButton)
        
        leftView.snp.makeConstraints { make in
            make.right.equalTo(view.snp.centerX).offset(-5)
            make.top.equalTo(10)
            make.width.equalTo(285*CS_kRate)
            make.height.equalTo(234*CS_kRateHeight)
        }
        
        rightView.snp.makeConstraints { make in
            make.left.equalTo(leftView.snp.right).offset(10)
            make.top.equalTo(10)
            make.width.equalTo(289*CS_kRate)
            make.height.equalTo(276*CS_kRateHeight)
        }
        
        earnMoreButton.snp.makeConstraints { make in
            make.right.equalTo(leftView.snp.centerX).offset(-10)
            make.bottom.equalTo(-10)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.left.equalTo(leftView.snp.centerX).offset(10)
            make.bottom.equalTo(-10)
        }
    }
}

extension CS_SharePlay2EarnController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

