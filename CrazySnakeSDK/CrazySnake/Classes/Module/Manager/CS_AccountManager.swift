//
//  CS_AccountManager.swift
//  Platform
//
//  Created by Lee on 23/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit
import web3swift
import HandyJSON

struct ShareModel: HandyJSON {
    var game_id: String?
    var share_link: String?
}

struct LanguageModel: HandyJSON {
    var ID: String = ""
    var name:   String? = nil
    var desc:   String? = nil
    var type:   String? = nil
}


class CS_AccountManager: NSObject {
    

    
    static let shared = CS_AccountManager()
    
    private override init() {
        super.init()
    }
    
    var shareConfig: ShareModel?
    
    var accountExsit: Bool {
        get {
            if accountInfo == nil {
                return false
            }
            return true
        }
    }
    var accountInfo: AccountModel? {
        didSet {
            self.coinTokenList.removeAll()
            self.userLogin()
            self.loadTokenBlance()
            self.loadUserInfo()
        }
    }
    
    var userInfo: CS_UserInfoModel?

    var coinTokenList: [CoinTokenModel] = [CoinTokenModel]()
    
    var basicConfig: CS_BasicConfigDataModel?
    
    var nameDescList = [CS_NameDescLanguageModel]()
    
    var languageList: [LanguageModel] = []
}

extension CS_AccountManager {
    func preload() {
        self.loadBaseConfig()
        self.loadBaseLanguageConfig()
        self.loadShareConfig()
        self.loadCacheWalletInfo()
        self.loadConfigNameDesc()
    }
    
   
    func verifyPassword(_ success: @escaping() ->()){
        accountInfo?.verifyPassword({ pwd in
            success()
        })
    }
}

extension CS_AccountManager {
    
    func loadCacheWalletInfo() {
        
        guard let model = AccountModel.findAccount(UserDefaults.standard.string(forKey: CacheKey.lastSelectedAccountId)) else {
            return
        }
        accountInfo = model
    }
    
    func userLogin(){
        
        guard let address = accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: accountInfo?.private_key)
        guard let sign = sign else { return }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["nonce"] = nonce
        para["sign"] = sign
        CSNetworkManager.shared.userLogin(para) { resp in
            if resp.status == .success {
                
                CrazyPlatform.adjustDelegata.checkShareCode()
                
                if CSSDKManager.shared.walletLoginType == 1 {
                    CSSDKManager.shared.lister?(999)
                    CrazyPlatform.backToGame()

                } else if CSSDKManager.shared.walletLoginType == 2 {
                    CSSDKManager.shared.lister?(200)
                    CrazyPlatform.backToGame()
                }
                
                CSSDKManager.shared.walletLoginType = 0
                
            }
        }
    }
    
    
    func loadUserInfo(){
        
        guard let address = accountInfo?.wallet_address else { return }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        CSNetworkManager.shared.getUserInfo(para) { resp in
            if resp.status == .success {
                CS_AccountManager.shared.accountInfo?.update(resp.data)
                CS_AccountManager.shared.userInfo = resp.data
                NotificationCenter.default.post(name: NotificationName.userInfoChanged, object: nil)
            }
        }
    }
    
    func loadBaseConfig(){
        weak var weakSelf = self
        CSNetworkManager.shared.getBasicConfig { resp in
            if resp.status == .success {
                weakSelf?.basicConfig = resp.data
            }
        }
    }
    
    
    func loadBaseLanguageConfig(){
        weak var weakSelf = self
        CSNetworkManager.shared.getConfigLanguage(type: "\(CSSDKManager.shared.language.rawValue)") { (resp: [LanguageModel]) in
            weakSelf?.languageList = resp
        }
    }

    
    func loadShareConfig(){
        CSNetworkManager.shared.getShareConfig { (resp:ShareModel) in
            self.shareConfig = resp
        }
    }

    
    func loadConfigNameDesc(){
        guard nameDescList.count == 0 else {
            return
        }
        weak var weakSelf = self
        CSNetworkManager.shared.getConfigNameDesc { resp in
            weakSelf?.nameDescList.removeAll()
            weakSelf?.nameDescList.append(contentsOf: resp.data)
        }
    }
    
}

//MARK: request
extension CS_AccountManager{
    
    func loadTokenBlance() {
        
        guard let address = accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["filter"] = "1|1|1"
//        filter 1|0|0
        //gas_coin（默认1）|cyt（默认0）|matic(默认0)，1展示，0不展示
        // 默认all，获取单个传合约名，如CrazyToken
//        para["contract_name"] = "all"
        CSNetworkManager.shared.getWalletBlanceList(para) { resp in
            
            if resp.status == .success {
                weakSelf?.coinTokenList.removeAll()
                weakSelf?.coinTokenList.append(contentsOf: resp.data)
                NotificationCenter.default.post(name: NotificationName.walletBalanceChanged, object: nil)
            }
        }
    }
    
    
}
