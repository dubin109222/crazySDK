//
//  AccountModel.swift
//  Platform
//
//  Created by Lee on 25/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit

class AccountModel: NSObject {
    
    var id: String = ""
    var password: String?
    var mnemonic_word: String?
    var private_key: String?
    var wallet_address: String?
    // 1: 已备份
    var backupStatus: String = ""
    var iconUrl: String?
    var nickName: String?
    /// meaningful when isMnemonicAccount == false
    //    var chainType: WalletChainType?
    
    static let kAcountAmountNumber = "kAcountAmountNumber"
    
    var isMnemonicAccount: Bool {
        get {
            guard let mnemonic = mnemonic_word, mnemonic.count > 0 else { return false }
            return true
        }
    }
    
    override init() {
        super.init()
        self.id = "account_\(Date().timeIntervalSince1970)"
    }
    
    func toDic() -> NSMutableDictionary{
        let model = NSMutableDictionary()
        model["id"] = id
        model["password"] = password
        model["private_key"] = private_key
        model["mnemonic_word"] = mnemonic_word
        model["wallet_address"] = wallet_address
        model["backupStatus"] = backupStatus
        model["iconUrl"] = iconUrl
        model["nickName"] = nickName
        return model
    }
    
    static func toModel(_ para: NSMutableDictionary?) -> AccountModel? {
        guard let para = para else { return nil }
        let model = AccountModel()
        model.id = (para["id"] as? String) ?? ""
        model.password = para["password"] as? String
        model.private_key = para["private_key"] as? String
        model.mnemonic_word = para["mnemonic_word"] as? String
        model.wallet_address = para["wallet_address"] as? String
        model.backupStatus = (para["backupStatus"] as? String) ?? ""
        model.iconUrl = para["iconUrl"] as? String
        model.nickName = para["nickName"] as? String
        return model
    }
    
    func checkWhetherSetPassword(_ success: @escaping() ->()?){
        let para: [String: Any] = ["wallet_address":wallet_address ?? ""]
//        LSHUD.showLoading()
        CSNetworkManager.shared.checkWhetherSetPassword(para) { (resp: CS_WalletHavePasswordResp) in
//            LSHUD.hide()
            if resp.status == .success {
                if resp.data?.is_set == 1 {
                    success()
                } else {
                    let alert = CS_PasswordTipsAlert()
                    alert.show()
                    alert.clickConfrimAction = {
                        let alert = CS_WalletSetPasswordAlert()
                        alert.accountInfo = self
                        alert.show()
                        alert.setPasswordSuccess = {
                            success()
                        }
                    }
                }
            } else {
                
            }
        }
    }
    
    func verifyPassword(_ success: @escaping(_ password: String?) ->()){
        checkWhetherSetPassword() {
            let alert = CS_WalletPasswordVerifyAlert()
            alert.accountInfo = self
            alert.show()
            alert.verifySuccess = { pwd in
                success(pwd)
            }
        }
    }
}

extension AccountModel {
    
    static func fileUrl() -> URL? {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        guard let path = docPath else {
            LSLog("path is nil")
            return nil
        }
//        /cs_paltform
        let fileURL = path + ("/cs_account.plist")
        let url = URL(fileURLWithPath: fileURL)
        return url
    }
    
    @discardableResult
    func save() -> Bool {
        guard let url = AccountModel.fileUrl() else {
            LSLog("file url is nil")
            return false
        }
        var para = NSMutableDictionary(contentsOf: url)
        if para == nil {
            para = NSMutableDictionary()
        }
        para?[id] = self.toDic()
        do {
            try para?.write(to: url)
            return true
        } catch {
            LSLog(error)
            return false
        }
    }
    
    @discardableResult
    func deleteFromRealm() -> Bool {
        guard let url = AccountModel.fileUrl() else {
            LSLog("file url is nil")
            return false
        }
        let para = NSMutableDictionary(contentsOf: url)
        para?[id] = nil
        do {
            try para?.write(to: url)
            return true
        } catch {
            LSLog(error)
            return false
        }
    }
    
    @discardableResult
    func updateRealm() -> Bool {
        guard let url = AccountModel.fileUrl() else {
            LSLog("file url is nil")
            return false
        }
        let para = NSMutableDictionary(contentsOf: url)
        para?[id] = self.toDic()
        do {
            try para?.write(to: url)
            return true
        } catch {
            LSLog(error)
            return false
        }
    }
    
    static func findAccountList() -> [AccountModel] {
        var resultList = [AccountModel]()
        guard let url = AccountModel.fileUrl() else {
            LSLog("file url is nil")
            return resultList
        }
        let para = NSMutableDictionary(contentsOf: url)
        guard let allKeys = para?.allKeys else {
            LSLog("keys is nil")
            return resultList
        }

        for item in allKeys {
            if let key = item as? String,let account = AccountModel.findAccount(key) {
                resultList.append(account)
            }
        }
        return resultList
    }
    
    static func findAccount(_ accountId: String?) -> AccountModel? {
        guard let url = AccountModel.fileUrl() else {
            LSLog("file url is nil")
            return nil
        }
        let para = NSMutableDictionary(contentsOf: url)
        let account = AccountModel.toModel(para?[accountId ?? ""] as? NSMutableDictionary)
        return account
    }
    
    @discardableResult
    static func clearAccount(_ accountId: String?) -> Bool {
        guard let url = AccountModel.fileUrl() else {
            LSLog("file url is nil")
            return false
        }
        let para = NSMutableDictionary(contentsOf: url)
        para?[accountId ?? ""] = nil
        do {
            try para?.write(to: url)
            return true
        } catch {
            LSLog(error)
            return false
        }
    }
    
    func update(_ user: CS_UserInfoModel?) {
        guard let user = user else { return }
        iconUrl = user.avatar_image
        nickName = user.name
        save()
    }
}

