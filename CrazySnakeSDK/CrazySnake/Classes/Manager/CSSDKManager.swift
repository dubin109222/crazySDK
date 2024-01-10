//
//  CSSDKManager.swift
//  CrazySnake
//
//  Created by Lee on 22/07/2022.
//

import UIKit

class CSSDKManager: NSObject {
    
    static let shared = CSSDKManager()
    
    var gameId = 1
    
    // 0:format 1:uat 2:test
    var serverType = 0
    
    var language: LanguageType = .English
    
    var walletMnemonic: String?
    
    var walletPrivateKey: Data?
    
    var walletAddress: String?
    
    var forwarder: String?
    var rpc_node: String?
    
    var deadline = 0
    
    /// 0: default 2:change 1:game login
    var walletLoginType = 0
    
    var lister: CS_IntBlock?

}
