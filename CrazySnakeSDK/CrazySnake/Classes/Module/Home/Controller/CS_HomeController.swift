//
//  CS_HomeController.swift
//  CrazySnake
//
//  Created by Lee on 18/03/2023.
//

import UIKit
import SwiftyAttributes
import HandyJSON



class CS_HomeController: CS_BaseController {

    var currentGwei: Double = 0 {
        didSet {
            switch currentGwei {
            case 0...100 :
                self.gweiView.setImage(.ls_bundle("_gwei_home_low@2x"), for: .normal)
            case 100...300 :
                self.gweiView.setImage(.ls_bundle("_gwei_home_midd@2x"), for: .normal)
            default :
                self.gweiView.setImage(.ls_bundle("_gwei_home_heigh@2x"), for: .normal)
            }

        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.reloadGwei()
        
    }
    
    func reloadGwei() {
        // 刷新gwei值接口
        struct GweiModel : HandyJSON {
            var current_gwei: Double = 0
        }
        CSNetworkManager.shared.getGweiValue { (resp: GweiModel) in
            self.currentGwei = resp.current_gwei
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        registerNotication()
        CS_AccountManager.shared.preload()
        updateData()
        checkMessageTips()
        checkGuideStatus()

        CrazyPlatform.adjustTrackCommonEvent("i5nojk")
        
    }
    
    
    @objc func clickPushGuide(_ sender : UIButton) {
        sender.superview?.removeFromSuperview()
        self.pushTo(GuideTaskViewController())
    }
    // 检查新手引导是否完成
    private func checkGuideStatus() {
        
        LSHUD.showLoading()

        weak var weakSelf = self
        GuideMaskManager.checkGuideState(.guide_task_list) { [self] isFinish in
            LSHUD.hide()
            
            if !isFinish {
                //
                let maskView = UIView()
                maskView.backgroundColor = .ls_color("#0F0F1B",alpha: 0.7)
                maskView.addGestureRecognizer(UITapGestureRecognizer())
                maskView.frame = weakSelf?.view.bounds ?? .zero
                weakSelf?.view.addSubview(maskView)
                
                let guideBtn = UIButton(type: .custom)
                guideBtn.setImage(.ls_bundle("_guide_task_icon@2x"), for: .normal)
                maskView.addSubview(guideBtn)
                guideBtn.frame = weakSelf?.guideButton.frame ?? .zero
                guideBtn.addTarget(self, action: #selector(clickPushGuide(_:)), for: .touchUpInside)
                
                let handleIcon = UIImageView()
                handleIcon.image = .ls_bundle("_handle_icon@2x")
                maskView.addSubview(handleIcon)
                
                let iconView = UIImageView()
                iconView.image = .ls_bundle("_home_guide_icon@2x")
                maskView.addSubview(iconView)
                iconView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview().offset(-(340)/2)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(111)
                }
                
                let tipsLbBg = UIScrollView()
                tipsLbBg.backgroundColor = .ls_color("#232335")
                tipsLbBg.layer.masksToBounds = true
                tipsLbBg.layer.cornerRadius = 20
                maskView.addSubview(tipsLbBg)
                tipsLbBg.snp.makeConstraints { make in
                    make.left.equalTo(iconView.snp.right).offset(3)
                    make.width.equalTo(340)
                    make.height.equalTo(150)
                    make.centerY.equalTo(iconView)
                }

                let tipsLb = UILabel()
                tipsLb.numberOfLines = 0
                tipsLb.font = .ls_JostRomanFont(12)
                tipsLb.text = "Welcome to CrazyLand, where you will experience the charm of web3. Please click on the novice tasks in the upper right corner."
                tipsLb.textColor = .ls_color("#8989AE")
                tipsLbBg.addSubview(tipsLb)
                tipsLb.snp.makeConstraints { make in
                    make.width.equalTo(282)
                    make.top.equalToSuperview().offset(28)
                    make.left.equalToSuperview().offset(29)
                    make.right.equalToSuperview().offset(-29)
                    make.bottom.equalToSuperview().offset(-28)
                }
                
                handleIcon.snp.makeConstraints { make in
                    make.size.equalTo(45)
                    make.left.equalTo(guideBtn.snp.right).offset(-5)
                    make.top.equalTo(guideBtn.snp.bottom)
                }
                
                
//                GuideMaskView.show (tipsText: "Welcome to CrazyLand, where you will experience the charm of web3. Please click on the novice tasks in the upper right corner.",
//                                                  currentStep: "1",
//                                                  totalStep: "2",
//                                                  maskRect: weakSelf?.guideButton.frame){
//                    weakSelf?.pushTo(GuideTaskViewController())
//                } skipHandle: {
//                    GuideMaskManager.saveGuideState(.guide_task_list)
//                }
            }
        }
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubviewToFront(infoView)
    }
    
    func updateData(){
        
        navAmountView.iconView.image = TokenName.Snake.icon()
        navAmountView.amountLabel.text = Utils.formatAmount(TokenName.Snake.balance())
        navAmountView1.iconView.image = TokenName.GasCoin.icon()
        navAmountView1.amountLabel.text = Utils.formatAmount(TokenName.GasCoin.balance(),digits: 2)
    }
    
    func checkMessageTips() {
        struct MessageModel : HandyJSON {
            var action: String?
            var token: TokenName?
            var amount: String?
            var token_id : String?
        }
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {return}
        var para: [String:String] = [:]
        para["wallet_address"] = address

        CSNetworkManager.shared.getMessageTips(para) { (list: [MessageModel]) in
            var message = """
            You are involved in a violation and have been disabled and warned , Please contact customer service if you need help.
            """
            for item in list {
                if let token = item.token {
                    message.append(contentsOf: "\n\(token.name()) blocked:")
                } else if let action = item.action {
                    message.append(contentsOf: "\n\(action) blocked:")
                }
                if let amount = item.amount {
                    message.append(Utils.formatAmount(amount))
                }
                if let token_id = item.token_id {
                    message.append("#\(token_id)")
                }
            }
            let msgAlert = CS_MessageTipsAlert()
            msgAlert.data = CS_MessageTipsAlertModel(title: "Msg tips", content: message)
            msgAlert.show()

        }

    }
    
    func checkTips(){
        
        guard let account = CS_AccountManager.shared.accountInfo else { return }
        weak var weakSelf = self
        CS_AccountManager.shared.accountInfo?.checkWhetherSetPassword({
            checkBackup()
        })
        
        func checkBackup(){
            if account.backupStatus != "1" && account.mnemonic_word?.count ?? 0 > 0 {
                let alert = CS_BackupTipsAlert()
                alert.show()
                alert.clickConfrimAction = {
                    weakSelf?.toBackupVC()
                }
            }
        }
    }
    
    func toBackupVC() {
        guard let account = CS_AccountManager.shared.accountInfo else { return }
        if let mnemonic = account.mnemonic_word,mnemonic.count >= 0 {
            let vc = CS_WalletBackupController()
            vc.mnemonic = mnemonic
            vc.accountInfo = account
//            vc.privateKey = account.private_key ?? ""
            pushTo(vc)
        } else {
//            let vc = CS_WalletBackupController()
//            vc.isBackUpMnemonic = false
//            vc.privateKey = account.private_key ?? ""
//            pushTo(vc)
        }
    }
    
    func commontButton(_ frame: CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.titleLabel?.font = .ls_JostRomanFont(21)
        button.setTitleColor(.ls_white(), for: .normal)
        button.ls_cornerRadius(10)
        button.backgroundColor = .ls_color("#A7A4F3",alpha: 0.1)
        return button
    }
    
    lazy var infoView: CS_WalletAccountInfoView = {
        let view = CS_WalletAccountInfoView()
        view.setDataAccount(CS_AccountManager.shared.accountInfo)
        view.clickChangeAction = {
            self.clickChangeWallet()
        }
        return view
    }()
    
    lazy var rankButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickRankButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle( "home_icon_rank@2x"), for: .normal)
        return button
    }()
    
    lazy var guideButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickGuideButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle( "_guide_task_icon@2x"), for: .normal)

        return button
    }()
    
    lazy var gweiView: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(.ls_bundle("_gwei_home_low@2x"), for: .normal)
        btn.addTarget(self, action: #selector(clickGweiBtn), for: .touchUpInside)
        // FIXME: 接口没上，所以隐藏
        btn.isHidden = true
        return btn
    }()

    
    lazy var marketButton: UIButton = {
        let button = commontButton(CGRect(x: 0, y: 0, width: 133, height: 155))
        button.addTarget(self, action: #selector(clickMarketButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_market".ls_localized, for: .normal)
        button.setBackgroundImage(UIImage.ls_bundle("home_market_bg@2x"), for: .normal)
        button.setImage(UIImage.ls_bundle("home_market_icon@2x"), for: .normal)
        button.ls_layout(.imageTop,padding: 8)
        return button
    }()
    
    lazy var myWalletButton: UIButton = {
        let button = commontButton(CGRect(x: 0, y: 0, width: 205, height: 58))
        button.addTarget(self, action: #selector(clickWalletButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_my_wallet".ls_localized, for: .normal)
        button.backgroundColor = .ls_color("#A7A4F3",alpha: 0.1)
        button.setImage(UIImage.ls_bundle("home_my_wallet_icon@2x"), for: .normal)
        button.ls_layout(.imageLeft,padding: 15)
        return button
    }()

    lazy var stakeButton: UIButton = {
        let button = commontButton(CGRect(x: 0, y: 0, width: 205, height: 58))
        button.addTarget(self, action: #selector(clickStakeButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_token_stake".ls_localized, for: .normal)
        button.backgroundColor = .ls_color("#A7A4F3",alpha: 0.1)
        button.setImage(UIImage.ls_bundle("home_stake_icon@2x"), for: .normal)
        button.ls_layout(.imageLeft,padding: 15)
        return button
    }()

    lazy var myNFTButton: UIButton = {
        let button = commontButton(CGRect(x: 0, y: 0, width: 214, height: 85))
        button.addTarget(self, action: #selector(clickMyNFTButton(_:)), for: .touchUpInside)
//        button.setTitle("My NFTs", for: .normal)
        button.titleLabel?.numberOfLines = 0
        let att = "crazy_str_my_nft".ls_localized.attributedString + "\n".attributedString + "crazy_str_see_your_nfts_here".ls_localized.withFont(.ls_JostRomanFont(12))
        button.setAttributedTitle(att, for: .normal)
        button.setBackgroundImage(UIImage.ls_bundle("home_my_nft_bg@2x"), for: .normal)
        button.setImage(UIImage.ls_bundle("home_my_nft_icon@2x"), for: .normal)
        button.ls_layout(.imageLeft,padding: 12)
        return button
    }()

    lazy var stakeNFTButton: UIButton = {
        let button = commontButton(CGRect(x: 0, y: 0, width: 214, height: 85))
        button.addTarget(self, action: #selector(clickNFTStakeButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_nft_stake".ls_localized, for: .normal)
        button.setBackgroundImage(UIImage.ls_bundle("home_nft_stake_bg@2x"), for: .normal)
        button.setImage(UIImage.ls_bundle("home_nft_stake_icon@2x"), for: .normal)
        button.ls_layout(.imageLeft,padding: 12)
        return button
    }()

    lazy var swapButton: UIButton = {
        let button = commontButton(CGRect(x: 0, y: 0, width: 100, height: 74))
        button.addTarget(self, action: #selector(clickSwapButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_swap".ls_localized, for: .normal)
        button.setImage(UIImage.ls_bundle("home_swap_icon@2x"), for: .normal)
        button.ls_layout(.imageTop,padding: -20)
        return button
    }()

    lazy var labButton: UIButton = {
        let button = commontButton(CGRect(x: 0, y: 0, width: 130, height: 74))
        button.addTarget(self, action: #selector(clickNFTLabButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_nft_lab".ls_localized, for: .normal)
        button.setImage(UIImage.ls_bundle("home_lab_icon@2x"), for: .normal)
        button.ls_layout(.imageTop,padding: -20)
        return button
    }()

    lazy var funGamesButton: UIButton = {
        let button = commontButton(CGRect(x: 0, y: 0, width: 130, height: 74))
        button.addTarget(self, action: #selector(clickFunGameButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_fun_games".ls_localized, for: .normal)
        button.setImage(UIImage.ls_bundle("home_games_icon@2x"), for: .normal)
        button.ls_layout(.imageTop,padding: -20)
        return button
    }()

    lazy var eventsButton: UIButton = {
        let button = commontButton(CGRect(x: 0, y: 0, width: 100, height: 74))
        button.addTarget(self, action: #selector(clickEventsButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_events".ls_localized, for: .normal)
        button.setImage(UIImage.ls_bundle("home_events_icon@2x"), for: .normal)
        button.ls_layout(.imageTop,padding: -20)
        return button
    }()

    lazy var moreButton: UIButton = {
        let button = commontButton(CGRect(x: 0, y: 0, width: 60, height: 74))
        button.addTarget(self, action: #selector(clickMoreButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("home_icon_share@2x"), for: .normal)
        button.setTitle("crazy_str_share".ls_localized, for: .normal)
        button.ls_layout(.imageTop,padding: -20)
        return button
    }()

    private var clickGasCount = 0

}

//MARK: notification
extension CS_HomeController {
    
    private func registerNotication(){
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletChange(_:)), name: NotificationName.walletChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletInfoChange(_:)), name: NotificationName.walletBalanceChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUserInfoChange(_:)), name: NotificationName.userInfoChanged, object: nil)
    }
    
    @objc private func notifyWalletChange(_ notify: Notification) {
        infoView.setDataAccount(CS_AccountManager.shared.accountInfo)
    }
    
    @objc private func notifyWalletInfoChange(_ notify: Notification) {
        updateData()
    }
    
    @objc private func notifyUserInfoChange(_ notify: Notification) {
        infoView.setDataUser(CS_AccountManager.shared.userInfo)
    }
}

//MARK: action
extension CS_HomeController {
    @objc private func clickChangeWallet() {
        let vc = CS_WalletChooseController()
        let nav = NavigationController(rootViewController: vc)
        presentVC(nav)
        weak var weakSelf = self
        vc.clickImportAction = {
            let vc = CS_ImportWalletController()
            vc.isNew = false
            weakSelf?.pushTo(vc)
        }
        vc.clickAddAction = {
            let vc = CS_WalletMnemonicsTipsController()
            CSSDKManager.shared.walletLoginType = 1
            weakSelf?.pushTo(vc)
        }
        vc.clickSettingAction = { account in
            let vc = CS_SettingController()
            vc.accountInfo = account
            weakSelf?.pushTo(vc)
        }
    }
    
    @objc private func clickRankButton(_ sender: UIButton) {
        let vc = CS_RankController()
        CrazyPlatform.pushTo(vc)
    }
    
    @objc private func clickGuideButton(_ sender: UIButton) {
        let vc = GuideTaskViewController()
        CrazyPlatform.pushTo(vc)
    }
    
    @objc private func clickGweiBtn() {
        self.reloadGwei()
        
        let vc = CS_GweiGasAlertController()
        vc.showTitle = "Gwei index too high".ls_localized
        vc.current_gwei = self.currentGwei
        vc.cancelBtn.isHidden = true
        vc.confirmButton.isHidden = true
        vc.iknowBtn.isHidden = false
        vc.titleDesLb.text = """
"Gwei" is a unit of measurement in the ethereum network that represents the cost of fuel needed to execute a transaction or contract on the network. The higher the gwei index, the higher the cost of Gas Coin, and it is recommended that you choose to trade when the gwei index is low.
"""
        self.present(vc, animated: true)

    }
    
    
    override func clickRightButton() {
        let vc = CS_HomsSocialController()
        present(vc, animated: false)
    }
    
    @objc private func clickMarketButton(_ sender: UIButton) {
        CrazyPlatform.toMarketController()
    }
    
    @objc private func clickWalletButton(_ sender: UIButton) {
        CrazyPlatform.toCS_WalletController()
    }
    
    @objc private func clickStakeButton(_ sender: UIButton) {
        CrazyPlatform.toStakeController()
    }
    
    @objc private func clickMyNFTButton(_ sender: UIButton) {
        CrazyPlatform.toMineNFTController()
    }
    
    @objc private func clickNFTStakeButton(_ sender: UIButton) {
        CrazyPlatform.toNFTStakeController()
    }
    
    @objc private func clickSwapButton(_ sender: UIButton) {
        CrazyPlatform.toSwapController()
    }
    
    @objc private func clickNFTLabButton(_ sender: UIButton) {
        CrazyPlatform.toNFTLabController()
    }
    
    @objc private func clickFunGameButton(_ sender: UIButton) {
        CrazyPlatform.toGamesController()
    }
    
    @objc private func clickEventsButton(_ sender: UIButton) {
        CrazyPlatform.toEventController()
    }
    
    @objc private func clickMoreButton(_ sender: UIButton) {
        if CS_AccountManager.shared.shareConfig?.share_link == nil
            || CS_AccountManager.shared.shareConfig?.share_link?.count == 0{
            LSHUD.showInfo("You do not have permission to share")
            return
        }
        CrazyPlatform.toShareController()
    }
    
}

//MARK: UI
extension CS_HomeController {
    
    @objc func clickGasView() {
        clickGasCount += 1
        if clickGasCount % 10 == 0 {
            let textToCopy = CrazyPlatform.deviceId
            UIPasteboard.general.string = textToCopy
        }
    }
    
    private func setupView() {
        
        navigationView.backgroundColor = .clear
        navigationView.backView.backgroundColor = .clear
        navigationView.backView.image = nil
//        navigationView.titleImageView.image = UIImage.ls_bundle("home_title_name@2x")
        backView.image = UIImage.ls_bundle("home_page_bg@2x")
        rightButton.isHidden = false
        rightButton.setImage(UIImage.ls_bundle( "icon_wallet_setting"), for: .normal)
        navAmountView.isHidden = false
        
        navAmountView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickGasView)))
        navAmountView1.isHidden = false
        
        navigationView.addSubview(rankButton)
        navigationView.addSubview(guideButton)
        navigationView.addSubview(gweiView)
        
        view.addSubview(infoView)
        view.addSubview(marketButton)
        view.addSubview(myWalletButton)
        view.addSubview(stakeButton)
        view.addSubview(myNFTButton)
        view.addSubview(stakeNFTButton)
        view.addSubview(swapButton)
        view.addSubview(labButton)
        view.addSubview(funGamesButton)
        view.addSubview(eventsButton)
        view.addSubview(moreButton)
        
        infoView.snp.makeConstraints { make in
            make.left.equalTo(60)
            make.top.equalTo(0)
            make.height.equalTo(62)
            make.width.equalTo(200)
        }
        
        rankButton.snp.makeConstraints { make in
            make.right.equalTo(rightButton.snp.left).offset(-4)
            make.centerY.equalTo(navigationView)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        guideButton.snp.makeConstraints { make in
            make.right.equalTo(rankButton.snp.left).offset(-4)
            make.centerY.equalTo(navigationView)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        gweiView.snp.makeConstraints { make in
            make.right.equalTo(guideButton.snp.left).offset(-4)
            make.centerY.equalTo(navigationView)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }

        
        
        navAmountView.snp.remakeConstraints { make in
            make.right.equalTo(gweiView.snp.left).offset(-4)
            make.centerY.equalTo(navigationView)
            make.width.equalTo(150)
            make.height.equalTo(34)
        }
        
        marketButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.centerX).offset(-160)
            make.top.equalTo(85)
            make.width.equalTo(131)
            make.height.equalTo(155)
        }
        
        myWalletButton.snp.makeConstraints { make in
            make.top.equalTo(marketButton)
            make.left.equalTo(marketButton.snp.right).offset(10)
            make.width.equalTo(205)
            make.height.equalTo(58)
        }
        
        stakeButton.snp.makeConstraints { make in
            make.top.equalTo(myWalletButton)
            make.left.equalTo(myWalletButton.snp.right).offset(17)
            make.width.equalTo(205)
            make.height.equalTo(58)
        }
        
        myNFTButton.snp.makeConstraints { make in
            make.bottom.equalTo(marketButton)
            make.centerX.equalTo(myWalletButton)
            make.width.equalTo(214)
            make.height.equalTo(85)
        }
        
        stakeNFTButton.snp.makeConstraints { make in
            make.bottom.equalTo(marketButton)
            make.centerX.equalTo(stakeButton)
            make.width.equalTo(214)
            make.height.equalTo(85)
        }
        
        swapButton.snp.makeConstraints { make in
            make.left.equalTo(marketButton).offset(4)
            make.top.equalTo(marketButton.snp.bottom).offset(4)
            make.width.equalTo(100)
            make.height.equalTo(74)
        }
        
        labButton.snp.makeConstraints { make in
            make.top.equalTo(swapButton)
            make.left.equalTo(swapButton.snp.right).offset(10)
            make.width.equalTo(130)
            make.height.equalTo(74)
        }
        
        funGamesButton.snp.makeConstraints { make in
            make.top.equalTo(swapButton)
            make.left.equalTo(labButton.snp.right).offset(10)
            make.width.equalTo(130)
            make.height.equalTo(74)
        }
        
        eventsButton.snp.makeConstraints { make in
            make.top.equalTo(swapButton)
            make.left.equalTo(funGamesButton.snp.right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(74)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(swapButton)
            make.left.equalTo(eventsButton.snp.right).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(74)
        }
    }
}

