//
//  LSNotification.swift
//  constellation
//
//  Created by Lee on 2020/4/20.
//  Copyright © 2020 Constellation. All rights reserved.
//
/**
 Notification
 */

import UIKit


struct NotificationName {
    
    static let tabbarBadgeChange = NSNotification.Name(rawValue: "tabbarBadgeChange")
    static let homeDappRecordDidChange = NSNotification.Name(rawValue: "homeDappRecordDidChange")

    static let walletAccountInfoChanged = NSNotification.Name(rawValue: "walletAccountInfoChanged")
    static let importMenmonicWalletSuccess = NSNotification.Name(rawValue: "importMenmonicWalletSuccess")
    static let walletBalanceChanged = NSNotification.Name(rawValue: "walletBalanceChanged")
    static let walletChanged = NSNotification.Name(rawValue: "walletChanged")

    static let userInfoChanged = NSNotification.Name(rawValue: "userInfoChanged")
    
    static let accountDeleteWallet = NSNotification.Name(rawValue: "accountDeleteWallet")
    static let walletTokenListChange = NSNotification.Name(rawValue: "walletTokenListChange")
    
    static let CS_OpenBoxSuccess = NSNotification.Name(rawValue: "CS_OpenBoxSuccess")
    static let CS_NFTInfoChange = NSNotification.Name(rawValue: "CS_NFTInfoChange")
    
    //MARK: market
    static let CS_MarketRemoveOffer = NSNotification.Name(rawValue: "CS_MarketRemoveOffer")
    static let CS_MarketPlaceOffer = NSNotification.Name(rawValue: "CS_MarketPlaceOffer")
    static let CS_MarketBuyItem = NSNotification.Name(rawValue: "CS_MarketBuyItem")
}

class LSNotification: NSObject {
    
    
    
    static func showTabbarBadge(_ show: Bool = true, at index: Int, content: String = "") {
        let dic = ["show":show,
                   "index":index,
                   "number":0,
                   "content":content] as [String : Any]
        NotificationCenter.default.post(name: NotificationName.tabbarBadgeChange, object: dic)
    }
    
    
    static func showTabbarBadge(_ show: Bool = true, at index: Int, number: Int) {
        let dic = ["show":show,
                   "index":index,
                   "number":number,
                   "content":""] as [String : Any]
        NotificationCenter.default.post(name: NotificationName.tabbarBadgeChange, object: dic)
    }
    
    
    static func hiddenTabbarBadge(at index: Int) {
        let dic = ["show":false,
                   "index":index,
                   "number":0,
                   "content":""] as [String : Any]
        NotificationCenter.default.post(name: NotificationName.tabbarBadgeChange, object: dic)
    }
    

    
}
