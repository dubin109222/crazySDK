//
//  CS_WalletController.swift
//  Platform
//
//  Created by Lee on 29/04/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit
import JXSegmentedView

class CS_WalletController: CS_WalletBaseController {
    
    var accountInfo: AccountModel? = CS_AccountManager.shared.accountInfo

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupData()
        registerNotication()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CS_AccountManager.shared.loadTokenBlance()
//        CS_NewFeatureAlert.showPage(.wallet)

    }
    
    func setupData() {
        topView.setDataAccount(accountInfo)
    }
    
    lazy var topBackView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 44, width: CS_kScreenW, height: 80))
        view.backgroundColor = UIColor.ls_color("#1E1E20")
        return view
    }()
    
    lazy var topView: CS_WalletAccountView = {
        let view = CS_WalletAccountView(frame: CGRect(x: 0, y: 44, width: CS_kScreenW, height: 80))
        view.setDataAccount(accountInfo)
        view.clickChangeAction = {
            self.clickChangeWallet()
        }
        return view
    }()
   
    lazy var receiveButton: CS_WalletItemView = {
        let button = CS_WalletItemView()
        button.setData(.ls_named("wallet_icon_receive@2x"), name: "crazy_str_receive".ls_localized)
        button.addTarget(self, action: #selector(clickReceiveButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var sendButton: CS_WalletItemView = {
        let button = CS_WalletItemView()
        button.setData(.ls_named("wallet_icon_send@2x"), name: "crazy_str_send".ls_localized)
        button.addTarget(self, action: #selector(clickSendButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var swapButton: CS_WalletItemView = {
        let button = CS_WalletItemView(frame: CGRect(x: 0, y: 0, width: 70, height: 58))
        button.setData(.ls_named("wallet_icon_swap@2x"), name: "crazy_str_swap".ls_localized)
        button.addTarget(self, action: #selector(clickSwapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickHistoryButton(_:)), for: .touchUpInside)
        button.setImage(.ls_bundle("wallet_icon_transfer_record@2x"), for: .normal)
        return button
    }()
    
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
        segment.titles = ["crazy_str_portfolio".ls_localized, "crazy_str_nft".ls_localized, "Game Assets".ls_localized]
        segment.isItemSpacingAverageEnabled = false
        segment.itemSpacing = 40
        segment.isTitleColorGradientEnabled = true
        segment.titleNormalColor = .ls_text_gray()
        segment.titleNormalFont = .ls_mediumFont(16)
        segment.titleSelectedColor = .ls_white()
        segment.titleSelectedFont = .ls_boldFont(16)
        return segment
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.delegate = self
        view.dataSource = segmentedDataSource
        view.contentEdgeInsetLeft = CS_ms(24)
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        indicator.indicatorColor = .ls_white()
        indicator.indicatorWidth = 30
        view.indicators = [indicator]
        view.listContainer = listContainerView
        return view
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_white(0.1)
        return view
    }()
}

extension CS_WalletController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}

extension CS_WalletController: JXSegmentedListContainerViewDataSource {
    public func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            let vc = CS_WalletTokenListController()
            return vc
        case 1:
            let vc = CS_WalletNFTListController()
            return vc
        case 2:
            let vc = CS_WalletGameAssetsController()
            return vc
        default:
            let vc = CS_WalletTokenListController()
            return vc
        }
    }
}

//MARK: notification
extension CS_WalletController {
    private func registerNotication(){
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletChange(_:)), name: NotificationName.walletChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletInfoChange(_:)), name: NotificationName.walletBalanceChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUserInfoChange(_:)), name: NotificationName.userInfoChanged, object: nil)
    }
    
    @objc private func notifyWalletChange(_ notify: Notification) {
        accountInfo = CS_AccountManager.shared.accountInfo
        topView.setDataAccount(accountInfo)
    }
    
    @objc private func notifyWalletInfoChange(_ notify: Notification) {
//        tableView.reloadData()
    }
    
    @objc private func notifyUserInfoChange(_ notify: Notification) {
        topView.setDataUser(CS_AccountManager.shared.userInfo)
    }
}

//MARK: action
extension CS_WalletController {
    
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
    
    @objc private func clickReceiveButton(_ sender: UIButton) {
        let alert = CS_WalletReceiveAlert()
        alert.show()
    }
    
    @objc private func clickSendButton(_ sender: UIButton) {
        let vc = CS_WalletChooseAssetController()
        presentVC(vc)
        vc.chooseTokenAction = { token in
            let vcSend = CS_WalletSendController()
            vcSend.token = token
            self.pushTo(vcSend)
        }
    }
    
    @objc private func clickSwapButton(_ sender: UIButton) {
        let vc = CS_SwapController()
//        vc.selectedIndex = 1
        pushTo(vc)
    }
    
    @objc private func clickHistoryButton(_ sender: UIButton) {
        let vc = CS_WalletTransferRecordController()
        present(vc, animated: false)
    }
}


//MARK: UI
extension CS_WalletController {
    fileprivate func setupView() {
        navigationView.titleLabel.text = "crazy_str_my_wallet".ls_localized
        
        view.addSubview(topBackView)
        topBackView.addSubview(topView)
        topBackView.addSubview(receiveButton)
        topBackView.addSubview(sendButton)
        topBackView.addSubview(swapButton)
        view.addSubview(segmentedView)
        view.addSubview(recordButton)
        view.addSubview(lineView)
        view.addSubview(listContainerView)
        
        topBackView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(80)
        }
        
        topView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(CS_kScreenW*0.5)
        }
        
        swapButton.snp.makeConstraints { make in
            make.centerY.equalTo(topBackView)
            make.right.equalTo(-26)
            make.width.equalTo(70)
            make.height.equalTo(50)
        }
          
        receiveButton.snp.makeConstraints { make in
            make.bottom.width.height.equalTo(swapButton)
            make.left.equalTo(topBackView.snp.centerX).offset(26)
        }
        
        sendButton.snp.makeConstraints { make in
            make.bottom.width.height.equalTo(swapButton)
            make.centerX.equalTo(topBackView).multipliedBy(1.5)
        }
      
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(topBackView.snp.bottom).offset(10)
            make.height.equalTo(36)
            make.left.right.equalTo(0)
        }
        
        recordButton.snp.makeConstraints { make in
            make.centerY.equalTo(segmentedView)
            make.right.equalTo(-CS_ms(24))
            make.width.height.equalTo(36)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(segmentedView)
            make.height.equalTo(1)
        }
        
        listContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(segmentedView.snp.bottom).offset(10)
        }
    }
}
