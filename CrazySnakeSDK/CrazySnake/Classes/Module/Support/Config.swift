//
//  Config.swift
//  constellation
//
//  Created by Lee on 2020/4/3.
//  Copyright © 2020 Constellation. All rights reserved.
//

import UIKit


let kShowWalletTestChain = false

func LSLog<T>(_ message: T?,
                           file: String = #file,
                           method: String = #function,
                           line: Int = #line)
{
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(String(describing:  message))")
    #endif
}

class Config: NSObject {
    static let chain: WalletChainType = .Polygon

}



//block
typealias CS_NoParasBlock = () ->()

typealias CS_StringBlock = (String?) -> Void

typealias CS_IntBlock = (Int) -> Void
typealias CS_BoolBlock = (Bool) -> Void

#if DEBUG

fileprivate let kWebServerHost = "https://snake-h5.test.mtmt.app/"
#else

//fileprivate let kWebServerHost = "https://snake-h5.test.mtmt.app/"
fileprivate let kWebServerHost = "https://snake-h5.test.mtmt.app/"
#endif

struct ConfigWebUrl {
   
    static let web_home = "https://crazysnake.io/"
    static let feedback = url() + "feedback?language=\(CSSDKManager.shared.language.local())"
    
    
    static func url() -> String {
        var url = "https://service.crazyland.io/"
        // 0:format 1:uat 2:test
        switch CSSDKManager.shared.serverType {
        case 0:
            url = "https://service.crazyland.io/"
        case 2:
            url = "https://service-test.crazysnake.io/"
        default:
            url = "https://service.crazyland.io/"
        }
        return url
    }
    
}


struct ConfigUrl {
    
}
