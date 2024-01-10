//
//  PlatformUI.swift
//  CrazySnake
//
//  Created by Lee on 23/02/2023.
//

import UIKit
import Adjust
import FBSDKShareKit


class CrazyPlatformAdjustDelegate: NSObject,AdjustDelegate {
    
    var adjustUrl: URL? = nil

    public func adjustDeeplinkResponse(_ deeplink: URL?) -> Bool {
        self.linkCode(deeplink)
        
        return false
    }
    
    private func linkCode(_ deeplink: URL?){
        
        // url 是：“crazy://launch?invited_code=55378269\u0026adjust_no_sdkclick=1”
        // 对url中，取出invited_code的值
        let urlStr = deeplink?.absoluteString
        let urlArr = urlStr?.components(separatedBy: "&")
        var code = ""
        for str in urlArr ?? [] {
            if str.contains("invited_code") {
                let codeArr = str.components(separatedBy: "=")
                if codeArr.count > 1 {
                    code = codeArr[1]
                }
            }
        }
        
        if code.count == 0 {
            self.adjustUrl = deeplink
            return
        }

                
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            self.adjustUrl = deeplink
            return
        }
        
        self.adjustUrl = nil
        
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sign"] = sign
        para["nonce"] = nonce

//        weak var weakSelf = self
        CSNetworkManager.shared.bindShareLink(address, code: code,para: para) { resp in
            if resp.status == .success {
            } else {
            }
        }
        
    }

    
    
    public func checkShareCode() {
        guard let adjustAttribution = adjustUrl else {
            return
        }
        self.linkCode(adjustUrl)
    }
    

}


open class CrazyPlatform: NSObject {
    
    static let adjustDelegata: CrazyPlatformAdjustDelegate = CrazyPlatformAdjustDelegate()
    
    /// 获取签名随机字符串（同步）
    static let CRAZY_METHODS_TYPE_GET_SIGNATURE_RANDOM = "crazy_methods_type_get_signature_random"
    /// 获取钱包地址（同步）
    static let CRAZY_METHODS_TYPE_WALLET_ADDRESS = "crazy_methods_type_wallet_address"
    /// 获取钱包私钥（同步）
    static let CRAZY_METHODS_TYPE_WALLET_PRIVATE_KEY = "crazy_methods_type_wallet_private_key"
    /// 去创建钱包（同步）
    static let CRAZY_METHODS_TYPE_TO_CREATE_WALLET = "crazy_methods_type_to_create_wallet"
    /// 去导入钱包（同步）
    static let CRAZY_METHODS_TYPE_TO_IMPORT_WALLET = "crazy_methods_type_to_import_wallet"
    /// 直接创建钱包（异步）
    static let CRAZY_METHODS_TYPE_DIRECT_CREATE_WALLET = "crazy_methods_type_direct_create_wallet"
    /// 去钱包中心    (同步)
    static let CRAZY_METHODS_TYPE_TO_WALLET = "crazy_methods_type_to_wallet"
    /// 去钱包中心NFT
    static let CRAZY_METHODS_TYPE_TO_WALLET_NFT = "crazy_methods_type_to_wallet_nft"
    /// 启动页拉取钱包配置（异步）
    static let CRAZY_METHODS_TYPE_TO_LAUNCHER = "crazy_methods_type_to_launcher"
    /// 备份助记词弹框（同步）
    static let CRAZY_METHODS_TYPE_TO_BACKUP_DIALOG = "crazy_methods_type_to_backup_dialog"
    /// 设置密码弹框（同步）
    static let CRAZY_METHODS_TYPE_TO_SET_PAYMENT_DIALOG = "crazy_methods_type_to_set_payment_dialog"
    /// 去主页（同步）
    static let CRAZY_METHODS_TYPE_TO_MAIN = "crazy_methods_type_to_main"
    /// 去nft lab（同步）
    static let CRAZY_METHODS_TYPE_TO_NFT_LAB = "crazy_methods_type_to_nft_lab"
    /// 去nft stake（同步）
    static let CRAZY_METHODS_TYPE_TO_NFT_STAKE = "crazy_methods_type_to_nft_stake"
    /// 去my list（同步）
    static let CRAZY_METHODS_TYPE_TO_MY_NFT = "crazy_methods_type_to_my_nft"
    /// 游戏内转账交易签名（异步）
    static let CRAZY_METHODS_TYPE_GAME_SEND_TRANSFER = "crazy_methods_type_game_send_transfer"
    /// 去市场（同步）
    static let CRAZY_METHODS_TYPE_TO_MARKET = "crazy_methods_type_to_market"
    /// 去趣味游戏（同步）
    static let CRAZY_METHODS_TYPE_TO_FUNGAME = "crazy_methods_type_to_fungame"
    /// 清除当前钱包状态（被踢号用）（同步）
    static let CRAZY_METHODS_TYPE_CLEAR_LOGIN_INFO = "crazy_methods_type_clear_login_info"
    
    static let CRAZY_METHODS_TYPE_TO_SUPPORT = "crazy_methods_type_to_support"
    static let CRAZY_METHODS_TYPE_TO_NFT_LAB_UPGRADE = "crazy_methods_type_to_nft_lab_upgrade"
    static let CRAZY_METHODS_TYPE_TO_NFT_LAB_CONVERSION = "crazy_methods_type_to_nft_lab_conversion"
    static let CRAZY_METHODS_TYPE_TO_NFT_LAB_EVA = "crazy_methods_type_to_nft_lab_eva"
    static let CRAZY_METHODS_TYPE_TO_TOKEN_STAKE = "crazy_methods_type_to_token_stake"
    static let CRAZY_METHODS_TYPE_TO_NFT_LAB_INCUBATION = "crazy_methods_type_to_nft_lab_incubation"
    static let CRAZY_METHODS_TYPE_TO_MISSION_WALL = "crazy_methods_type_to_mission_wall"
    static let CRAZY_METHODS_TYPE_TO_APPLE_AUTH_DIALOG = "crazy_methods_type_to_apple_auth_dialog"
    static let Crazy_METHODS_TYPE_TO_SWAP = "crazy_methods_type_to_swap"
    static let CRAZY_METHODS_TYPE_TO_EVENTS = "crazy_methods_type_to_events"
    static let CRAZY_METHODS_TYPE_TO_LOGIN = "crazy_methods_type_to_login"

    /// SDK version
    /// - Returns: current version
    @objc public static func getSDKVersion() -> String {
        return "1.0.0.00"
    }

    static public var deviceId : String = ""
    
    /// init SDK
    /// - Parameters:
    ///   - environment: 0:format 1:uat 2:test
    ///   - language: 1:English 2:Chinese
    ///   - response: whether sucessful
    @objc public static func initSDK(gameId: Int,environment: Int,language: Int , deviceId: String){
        PlatformUIConfig.uiConfig()
        self.deviceId = deviceId
        CSSDKManager.shared.gameId = 1
        CSSDKManager.shared.serverType = environment

        CSSDKManager.shared.language = LanguageType(rawValue: language) ?? .English
        CS_AccountManager.shared.preload()
    }

    
    /// init adjust config - appDidLaunch add code
    @objc public static func initAdjust(from appToken: String,environment:String,adjustDelegate : AdjustDelegate & NSObjectProtocol) {
        let adjustConfig = ADJConfig(
            appToken: appToken,
            environment: environment)
        adjustConfig?.logLevel = ADJLogLevelVerbose
        adjustConfig?.delegate = adjustDelegate 
        adjustConfig?.linkMeEnabled = true
        Adjust.appDidLaunch(adjustConfig)
        
        // 初始化adjust完成
        CSSDKManager.shared.lister?(201)
        
        
    }
    
    @objc public static func sdkWithApplication(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) {
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

    }
    
    
    
    /// Record events
    @objc public static func adjustTrackCommonEvent(_ eventToken: String) {
        let event = ADJEvent(eventToken: eventToken)
        Adjust.trackEvent(event)
    }
    
    /// Record event revenue
    @objc public static func adjustTrackRevenueEvent(_ eventToken: String,
                                                      revenue: Double,
                                                      currency: String) {
        let event = ADJEvent(eventToken: eventToken)
        event?.setRevenue(revenue, currency: currency)
        Adjust.trackEvent(event)
        
    }
    
    @objc public static var backupStatus: String? {
        return CS_AccountManager.shared.accountInfo?.backupStatus
    }
    
    
    @objc public static func changeLanguageTo(language: Int){
        CSSDKManager.shared.language = LanguageType(rawValue: language) ?? .English
    }
    
    /// Code码对应：999（切换钱包）200:（登录钱包
    @objc public static func setListner(response: @escaping((Int) -> ())){
        CSSDKManager.shared.lister = response
    }
    
    @discardableResult
    @objc public static func startSyncMethods(_ method: String) -> Any? {
        CrazyPlatform.startSyncMethods(method, para: nil)
    }
    
    @discardableResult
    @objc public static func startSyncMethods(_ method: String, para: [String: Any]?) -> Any? {
        var resp: Any?
        if method == CRAZY_METHODS_TYPE_GET_SIGNATURE_RANDOM {
            resp = Utils.sign(privateKey: para?["secret"] as? String, content: para?["random"] as? String)
        } else if method == CRAZY_METHODS_TYPE_WALLET_ADDRESS {
            resp = CS_AccountManager.shared.accountInfo?.wallet_address
        } else if method == CRAZY_METHODS_TYPE_WALLET_PRIVATE_KEY {
            resp = CS_AccountManager.shared.accountInfo?.private_key
        } else if method == CRAZY_METHODS_TYPE_TO_CREATE_WALLET {
            CSSDKManager.shared.walletLoginType = 2
            toCreateWalletController()
            resp = true
        } else if method == CRAZY_METHODS_TYPE_TO_IMPORT_WALLET {
            toImportWalletController()
        } else if method == CRAZY_METHODS_TYPE_TO_WALLET {
            CSSDKManager.shared.walletLoginType = 2
            toCS_WalletController()
        } else if method == CRAZY_METHODS_TYPE_TO_WALLET_NFT {
            CSSDKManager.shared.walletLoginType = 2
            toCS_WalletNFTController()
        } else if method == CRAZY_METHODS_TYPE_TO_BACKUP_DIALOG {
            let alert = CS_BackupTipsAlert()
            alert.show()
            alert.clickConfrimAction = {
                CrazyPlatform.toBackupVC()
            }
        } else if method == CRAZY_METHODS_TYPE_TO_SET_PAYMENT_DIALOG {
            let alert = CS_WalletSetPasswordAlert()
            alert.show()
        } else if method == CRAZY_METHODS_TYPE_TO_MAIN {
            //            CSSDKManager.shared.walletLoginType = 1
            toHomeController()
            resp = true
        } else if method == CRAZY_METHODS_TYPE_TO_NFT_LAB {
            toNFTLabController()
            resp = true
        } else if method == CRAZY_METHODS_TYPE_TO_NFT_STAKE {
            toNFTStakeController()
            resp = true
        } else if method == CRAZY_METHODS_TYPE_TO_MY_NFT {
            toMineNFTController()
            resp = true
        } else if method == CRAZY_METHODS_TYPE_TO_MARKET {
            toMarketController()
            resp = true
        } else if method == CRAZY_METHODS_TYPE_TO_FUNGAME {
            toGamesController()
            resp = true
        } else if method == CRAZY_METHODS_TYPE_CLEAR_LOGIN_INFO {
            AccountModel.clearAccount(CS_AccountManager.shared.accountInfo?.id)
            CS_AccountManager.shared.accountInfo = nil
            resp = true
        } else if method == CRAZY_METHODS_TYPE_TO_SUPPORT {
            toFeedbackController()
        } else if method == CRAZY_METHODS_TYPE_TO_NFT_LAB_UPGRADE {
            toNFTLabController()
        } else if method == CRAZY_METHODS_TYPE_TO_NFT_LAB_CONVERSION {
            toNFTLabController()
        } else if method == CRAZY_METHODS_TYPE_TO_NFT_LAB_EVA {
            toNFTLabController()
        } else if method == CRAZY_METHODS_TYPE_TO_NFT_LAB_INCUBATION {
            toNFTLabController()
        } else if method == CRAZY_METHODS_TYPE_TO_TOKEN_STAKE {
            toTokenSnakeController()
        } else if method == Crazy_METHODS_TYPE_TO_SWAP {
            toSwapController()
        } else if method == CRAZY_METHODS_TYPE_TO_MISSION_WALL {
            toShareController()
        } else if method == CRAZY_METHODS_TYPE_TO_APPLE_AUTH_DIALOG {
            
        } else if method == CRAZY_METHODS_TYPE_TO_EVENTS {
            toEventController()
        } else if method == CRAZY_METHODS_TYPE_TO_LOGIN {
            toLoginController()
        }
        
        

        return resp
    }
    
    @objc public static func startAsyncMethods(_ method: String, para: [String: Any]? = nil, response: @escaping((CrazyBaseResponse) -> ())){
        if method == CRAZY_METHODS_TYPE_DIRECT_CREATE_WALLET {
            CSSDKManager.shared.walletLoginType = 2
            CS_PlatformAsyncUtils.createWallet(response)
        } else if method == CRAZY_METHODS_TYPE_TO_LAUNCHER {
            CS_PlatformAsyncUtils.launcher(response)
        } else if method == CRAZY_METHODS_TYPE_GAME_SEND_TRANSFER {
            CS_PlatformAsyncUtils.swapGasCoin(para: para, response)
        }
    }
    
    static func toBackupVC() {
        guard let account = CS_AccountManager.shared.accountInfo else { return }
        if let mnemonic = account.mnemonic_word,mnemonic.count >= 0 {
            let vc = CS_WalletBackupController()
            vc.mnemonic = mnemonic
            vc.accountInfo = account
//            vc.privateKey = account.private_key ?? ""
            CrazyPlatform.pushTo(vc)
        } else {
//            let vc = CS_WalletBackupController()
//            vc.isBackUpMnemonic = false
//            vc.privateKey = account.private_key ?? ""
//            CrazyPlatform.pushTo(vc)
        }
    }
    
    @objc public static func toHomeController() {
        let vc = CS_HomeController()
        CrazyPlatform.gamePushTo(vc)
    }
    
    
    @objc public static func toLoginController() {
        let vc = CS_LoginViewController()
        CrazyPlatform.gamePushTo(vc)
    }
    
    @objc public static func toMineNFTController() {
        let vc = CSMyNFTController()
        CrazyPlatform.gamePushTo(vc)
    }
    
    @objc public static func toNFTLabController() {
        let vc = CS_NFTLabController()
        CrazyPlatform.gamePushTo(vc)
    }
    
    static func toGamesController() {
        LSHUD.showInfo("Not open yet")
        return
        let vc = CS_GamesViewController()
        CrazyPlatform.gamePushTo(vc)
    }
    
    @objc public static func toEventController() {
        let vc = CS_EventController()
        CrazyPlatform.gamePushTo(vc)
    }
    
    @objc public static func toShareController() {
        let vc = CS_ShareController()
        CrazyPlatform.gamePushTo(vc)
    }
    
    @objc public static func toNFTStakeController() {
        let vc = CS_NFTStakeController()
        CrazyPlatform.pushTo(vc)
    }
    
    @objc public static func toMarketController() {
        let vc = CS_MarketController()
        CrazyPlatform.gamePushTo(vc)
    }

    @objc public static func toCS_WalletController() {
        let vc = CS_WalletController()
        CrazyPlatform.gamePushTo(vc)
    }
    @objc public static func toCS_WalletNFTController() {
        let vc = CS_WalletController()
        vc.segmentedView.defaultSelectedIndex = 1
        vc.listContainerView.defaultSelectedIndex = 1
        CrazyPlatform.gamePushTo(vc)
    }

    @objc public static func toTokenSnakeController() {
        let vc = CS_StakeController()
        CrazyPlatform.gamePushTo(vc)
    }
    
    @objc public static func toTokenSnakeMyController() {
        let vc = CS_StakeController()
        vc.segmentedView.defaultSelectedIndex = 1
        vc.listContainerView.defaultSelectedIndex = 1
        CrazyPlatform.gamePushTo(vc)
    }

    
    @objc public static func toSwapController() {
        let vc = CS_SwapController()
//        vc.selectedIndex = 2
        CrazyPlatform.gamePushTo(vc)
    }
    
    @objc public static func toStakeController() {
        let vc = CS_StakeController()
        CrazyPlatform.gamePushTo(vc)
    }
    
    @objc public static func toFeedbackController() {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        let webVc = WebViewController()
        webVc.url =  ConfigWebUrl.feedback + "&wallet_address=\(address)"
        let _ = webVc.view
        webVc.loadUrl()

        CrazyPlatform.gamePushTo(webVc)
    }
    
    @objc public static func toImportWalletController() {
        let vc = CS_ImportWalletController()
        vc.isNew = true
        CrazyPlatform.gamePushTo(vc)
    }
    
    @objc public static func toCreateWalletController() {
        let vc = CS_WalletMnemonicsTipsController()
        CrazyPlatform.gamePushTo(vc)
    }
    
    static var gameFirstVc: UIViewController?
}

//MARK: action
extension CrazyPlatform {
    static func gamePushTo(_ vc: UIViewController) {
        if gameFirstVc != nil {
            debugPrint("⚠️ 调用错误")
        } else {
            gameFirstVc = vc
        }
        
        if let nav = UIViewController.current()?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            let nav = NavigationController(rootViewController: vc)
            UIViewController.current()?.present(nav, animated: true)
        }
    }
    
    static func backToGame() {
        
        if let baseVc = gameFirstVc as? CS_BaseController,
           baseVc.isPresentVC == true {
            gameFirstVc?.navigationController?.dismiss(animated: true)
        } else {
            debugPrint("debug --- ", gameFirstVc?.navigationController)
            gameFirstVc?.navigationController?.popToRootViewController(animated: true)
        }
        gameFirstVc = nil
    }
    
    static func pushTo(_ vc: CS_BaseController){
        if let nav = UIViewController.current()?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            vc.isPresentVC = true
            let nav = NavigationController(rootViewController: vc)
            UIViewController.current()?.present(nav, animated: true)
        }
    }
    
    static func pushTo(_ vc: CS_WalletBaseController){
        if let nav = UIViewController.current()?.navigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            vc.isPresentVC = true
            let nav = NavigationController(rootViewController: vc)
            UIViewController.current()?.present(nav, animated: true)
        }
    }
    
    static func popRoot() {
        DispatchQueue.main.async {
            UIViewController.current()?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
