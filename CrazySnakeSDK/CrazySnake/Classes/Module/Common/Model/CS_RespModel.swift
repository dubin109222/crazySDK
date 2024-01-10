//
//  RespModel.swift
//  constellation
//
//  Created by Lee on 2020/4/15.
//  Copyright © 2020 Constellation. All rights reserved.
//

import UIKit
import SwiftyJSON

//class RespModel: NSObject {
//    
//    var message: String?
//    var status: LSNetwork.ResultCode?
//    
//    override init() {
//        super.init()
//    }
//    
//    init(_ json: JSON) {
//        status = LSNetwork.ResultCode(rawValue: json["status"].int ?? -100)
//        message = json["message"].string
//    }
//    
//}

class ListModel: NSObject {
    
    var total = 0
    var current_page = 1
    
    override init() {
        super.init()
    }
    
    init(_ json: JSON) {
        total = json["total"].intValue
        current_page = json["current_page"].intValue
    }
    
}


//class WalletRespModel: NSObject {
//
//    var id: String?
//    var jsonrpc = ""
//    var error: RespErrorModel?
//
//    override init() {
//        super.init()
//    }
//
//    init(_ json: JSON) {
//        id = json["id"].string
//        jsonrpc = json["jsonrpc"].stringValue
//        error = RespErrorModel(json["error"])
//    }
//
//}

