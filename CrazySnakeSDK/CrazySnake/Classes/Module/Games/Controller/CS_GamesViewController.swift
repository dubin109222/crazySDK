//
//  CS_GamesViewController.swift
//  CrazySnake
//
//  Created by Lee on 16/05/2023.
//

import UIKit
import SwiftyAttributes

class CS_GamesViewController: CS_BaseController {

    var sessionInfo: CS_SessionInfoModel?
    var postionId = 1 // 1: red 2:blue
    var betAmount = "10"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        updateData()
        registerNotication()
        requestSessionInfo()   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countdownTimer.fire()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        countdownTimer.invalidate()
    }
    
    func updateData(){
        
        navAmountView.iconView.image = TokenName.Diamond.icon()
        navAmountView.amountLabel.text = Utils.formatAmount(TokenName.Diamond.balance())
//        navAmountView1.iconView.image = TokenName.GasCoin.icon()
//        navAmountView1.amountLabel.text = Utils.formatAmount(TokenName.GasCoin.balance(),digits: 2)
    }
    
    lazy var countdownTimer: Timer = {
        weak var weakSelf = self
        let timer = Timer(timeInterval: 5.0, repeats: true) { timer in
            weakSelf?.requestSessionInfo()
        }
        RunLoop.current.add(timer, forMode: .default)
        return timer
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var teamsView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2()
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var titleView: UIImageView = {
        let button = UIImageView()
        button.image = UIImage.ls_bundle("games_icon_guss_title@2x")
        return button
    }()
    
    lazy var sessionLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#FFF439"), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.backgroundColor = .ls_black(0.2)
        label.ls_cornerRadius(2)
        return label
    }()
    
    lazy var logoIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("games_icon_logo_guess@2x")
        return view
    }()

    lazy var linkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickLinkButton(_:)), for: .touchUpInside)
        button.titleLabel?.font = .ls_font(12)
        button.setTitleColor(.ls_text_gray(), for: .normal)
        
        return button
    }()
    
    lazy var linkIconButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickLinkButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("games_icon_share@2x"), for: .normal)
        return button
    }()
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = TokenName.Diamond.icon()
        return view
    }()
    
    lazy var tokenAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.text = "23322.1"
        return label
    }()
    
    lazy var poolSizeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.text = "crazy_str_pool_size".ls_localized
        return label
    }()
    
    lazy var countdownView: CS_GameCountView = {
        let view = CS_GameCountView()
        weak var weakSelf = self
        view.sesssionEndAction = {
            weakSelf?.requestSessionInfo()
        }
        return view
    }()
   
    lazy var redView: CS_GamesTeamView = {
        let view = CS_GamesTeamView()
        view.supportButton.addTarget(self, action: #selector(clickSupportRedButton(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var blueView: CS_GamesTeamView = {
        let view = CS_GamesTeamView()
        view.supportButton.addTarget(self, action: #selector(clickSupportBlueButton(_:)), for: .touchUpInside)
        view.backView.image = UIImage.ls_bundle("games_bg_blue_team@2x")
        view.iconView.image = UIImage.ls_bundle("games_icon_blue_team@2x")
        view.titleLabel.attributedText = "Blue".withTextColor(.ls_color("#605CFF")) + " Team".attributedString
        view.amountLabel.attributedText = "Blue Supporters".attributedString + " -".withTextColor(.ls_white())
        return view
    }()
    
    func createButton(_ title: String, imageName: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 38))
        button.titleLabel?.font = UIFont.ls_JostRomanFont(12)
        button.setTitleColor(.ls_gray(), for: .normal)
        button.setTitle(title, for: .normal)
        button.setImage(UIImage.ls_bundle(imageName), for: .normal)
        button.ls_layout(.imageTop,padding: 6)
        return button
    }
    
    lazy var historyButton: UIButton = {
        let button = createButton("crazy_str_history".ls_localized,imageName: "games_icon_history@2x")
        button.addTarget(self, action: #selector(clickHistoryButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var historyMyButton: UIButton = {
        let button = createButton("crazy_str_my_history".ls_localized, imageName: "games_icon_history_my@2x")
        button.addTarget(self, action: #selector(clickHistoryMyButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var rankButton: UIButton = {
        let button = createButton("crazy_str_rank".ls_localized,imageName: "games_icon_rank@2x")
        button.addTarget(self, action: #selector(clickRankButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var helpButton: UIButton = {
        let button = createButton("crazy_str_description".ls_localized,imageName: "games_icon_help@2x")
        button.addTarget(self, action: #selector(clickHelpButton(_:)), for: .touchUpInside)
        return button
    }()
}

//MARK: request
extension CS_GamesViewController {
    
    func requestNextInfoIfNeed() {
        if sessionInfo?.status != .beging || sessionInfo?.user_round?.status == -1 {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                weakSelf?.requestSessionInfo()
            }
        }
    }
    
    func requestSessionInfo() {
        
        weak var weakSelf = self
        var para :[String:Any] = [:]
        let wallet_address = CS_AccountManager.shared.accountInfo?.wallet_address
        para["wallet_address"] = wallet_address
        para["round_id"] = "0"
        CSNetworkManager.shared.getCurrentSessionInfo(para) { resp in
            LSHUD.hide()
            if resp.status == .success, let model = resp.data {
                weakSelf?.sessionInfo = model
                weakSelf?.updateSessionData()
//                weakSelf?.requestNextInfoIfNeed()
            }
        }
    }
    
    func updateSessionData(){
        guard let model = sessionInfo else { return }
        sessionLabel.text = "S\(model.round_id)"
        linkButton.setTitle(model.jump_url, for: .normal)
        tokenAmountLabel.text = model.total_amount
        
        countdownView.updateSessionInfo(model)
        redView.userRountView.isHidden = true
        redView.amountLabel.attributedText = "crazy_str_red".ls_localized.attributedString + "crazy_html_supporters_num".ls_localized_color(["",model.red_users])
        redView.balanceLabel.attributedText = "\(model.red_amount)".withTextColor(.ls_color("#C7A6F9")) + " \(model.token_contract_name)".withFont(.ls_JostRomanFont(12))
        redView.supportButton.isHidden = model.status != .beging
        blueView.userRountView.isHidden = true
//        blueView.amountLabel.attributedText = ("crazy_str_blue".ls_localized + "crazy_html_supporters_num".ls_localized).attributedString + " \(model.blue_users)".withTextColor(.ls_white())
        blueView.amountLabel.attributedText = "crazy_str_blue".ls_localized.attributedString + "crazy_html_supporters_num".ls_localized_color(["",model.blue_users])

        blueView.balanceLabel.attributedText = "\(model.blue_amount)".withTextColor(.ls_color("#C7A6F9")) + " \(model.token_contract_name)".withFont(.ls_JostRomanFont(12))
        blueView.supportButton.isHidden = model.status != .beging
        
        if let userRount = sessionInfo?.user_round {
            if userRount.position == 1 {
                redView.updateUserRound(userRount)
                blueView.supportButton.isHidden = true
            } else if userRount.position == 2 {
                blueView.updateUserRound(userRount)
                redView.supportButton.isHidden = true
            }
        }
    }
}


//MARK: action
extension CS_GamesViewController {
    
    @objc private func clickLinkButton(_ sender: UIButton) {
        if let model = sessionInfo, let url = URL(string: model.jump_url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func clickSupportRedButton(_ sender: UIButton) {
        let alert = CS_GameAmountInputAlert()
        alert.sessionConfig = sessionInfo?.config
        alert.show()
        weak var weakSelf = self
        alert.clickConfrimAction = { amount in
            weakSelf?.betAmount = amount
            weakSelf?.postionId = 1
            weakSelf?.supportTeam()
        }
    }
    
    @objc private func clickSupportBlueButton(_ sender: UIButton) {
        
        let alert = CS_GameAmountInputAlert()
        alert.sessionConfig = sessionInfo?.config
        alert.show()
        weak var weakSelf = self
        alert.clickConfrimAction = { amount in
            weakSelf?.betAmount = amount
            weakSelf?.postionId = 2
            weakSelf?.supportTeam()
        }
    }
    
    @objc private func clickHistoryButton(_ sender: UIButton) {
        let vc = CS_GamesRecordController()
        present(vc, animated: false)
    }
    
    @objc private func clickHistoryMyButton(_ sender: UIButton) {
        let vc = CS_GamesMineRecordController()
        present(vc, animated: false)
    }
    
    @objc private func clickRankButton(_ sender: UIButton) {
        let vc = CS_GamesRankController()
        present(vc, animated: false)
    }
    
    @objc private func clickHelpButton(_ sender: UIButton) {
        let alert = CS_GamesHelpAlert()
        alert.showWith(sessionInfo)
    }
    
}

//MARK: contract
extension CS_GamesViewController {
    func supportTeam() {
        
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.game_fight.first?.contract_address else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        LSHUD.showLoading()
        
        self.voteDiamond(address, contract: contract)
    }
    
    
    
    func voteDiamond(_ address : String , contract: String) {
        guard let model = sessionInfo else {
            return
        }

        let amount = betAmount
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
//        para["token_id"] = selectedModel?.token_id
        para["round_id"] = model.round_id
        para["amount"] = amount
        para["position"] = postionId
        para["sign"] = sign
        para["nonce"] = nonce
        LSHUD.showLoading()


        CSNetworkManager.shared.fightVoteDiamond(para) { resp in
            LSHUD.hide()
            LSHUD.showSuccess(resp.message)
        }

    }
}


//MARK: notification
extension CS_GamesViewController {
    private func registerNotication(){
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletInfoChange(_:)), name: NotificationName.walletBalanceChanged, object: nil)
    }
    
    @objc private func notifyWalletInfoChange(_ notify: Notification) {
        updateData()
    }
}


//MARK: UI
extension CS_GamesViewController {
    
    private func setupView() {
        navigationView.titleLabel.text = "crazy_str_guess_the_size".ls_localized
        navAmountView.isHidden = false
        navAmountView1.isHidden = true
        
        view.addSubview(contentView)
        contentView.addSubview(teamsView)
        contentView.addSubview(titleView)
        contentView.addSubview(sessionLabel)
        contentView.addSubview(logoIcon)
        contentView.addSubview(linkButton)
        contentView.addSubview(linkIconButton)
        teamsView.addSubview(tokenIcon)
        teamsView.addSubview(tokenAmountLabel)
        teamsView.addSubview(poolSizeLabel)
        teamsView.addSubview(countdownView)
        teamsView.addSubview(redView)
        teamsView.addSubview(blueView)
        contentView.addSubview(historyButton)
        contentView.addSubview(historyMyButton)
        contentView.addSubview(rankButton)
        contentView.addSubview(helpButton)
        
        contentView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(19))
            make.right.equalTo(-CS_ms(19))
            make.bottom.equalTo(-20)
            make.top.equalTo(navigationView.snp.bottom).offset(16)
        }
        
        teamsView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(185*CS_kRateHeight)
            make.top.equalTo(40)
        }
        
        titleView.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(8)
        }
        
        sessionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleView.snp.right).offset(20)
            make.centerY.equalTo(titleView)
            make.width.equalTo(56)
            make.height.equalTo(16)
        }
        
        logoIcon.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(5)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        linkIconButton.snp.makeConstraints { make in
            make.centerY.equalTo(sessionLabel)
            make.right.equalTo(-36)
            make.width.height.equalTo(12)
        }
        
        linkButton.snp.makeConstraints { make in
            make.centerY.equalTo(linkIconButton)
            make.right.equalTo(linkIconButton.snp.left).offset(-8)
            make.width.equalTo(140)
            make.height.equalTo(10)
        }
        
        redView.snp.makeConstraints { make in
            make.right.equalTo(teamsView.snp.centerX).offset(-93)
            make.centerY.equalTo(teamsView)
            make.width.equalTo(200)
            make.height.equalTo(162)
        }
        
        blueView.snp.makeConstraints { make in
            make.top.width.height.equalTo(redView)
            make.left.equalTo(redView.snp.right).offset(186)
        }
        
        poolSizeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(logoIcon)
            make.top.equalTo(logoIcon.snp.bottom).offset(36)
        }
        
        tokenAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(poolSizeLabel)
            make.bottom.equalTo(poolSizeLabel.snp.top).offset(-2)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.centerY.equalTo(poolSizeLabel.snp.top).offset(-1)
            make.right.equalTo(poolSizeLabel.snp.left).offset(-6)
            make.width.height.equalTo(24)
        }
        
        countdownView.snp.makeConstraints { make in
            make.centerX.equalTo(logoIcon)
            make.bottom.equalTo(-18)
            make.width.equalTo(122)
            make.height.equalTo(60)
        }
        
        historyMyButton.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.centerX).offset(-40)
            make.bottom.equalTo(-14)
            make.width.equalTo(70)
            make.height.equalTo(38)
        }
        
        historyButton.snp.makeConstraints { make in
            make.top.width.height.equalTo(historyMyButton)
            make.right.equalTo(historyMyButton.snp.left).offset(-80)
        }
        
        rankButton.snp.makeConstraints { make in
            make.top.width.height.equalTo(historyMyButton)
            make.left.equalTo(historyMyButton.snp.right).offset(80)
        }
        
        helpButton.snp.makeConstraints { make in
            make.top.width.height.equalTo(historyMyButton)
            make.left.equalTo(rankButton.snp.right).offset(80)
        }
    }
}
