//
//  ETHScanResp.swift
//  Platform
//
//  Created by Lee on 11/10/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit
import SwiftyJSON

class EtherScanResp: NSObject {
    
    enum ResultCode: String {
        case no_transactions_found = "0"
        case success = "1"
    }
    
    var message: String?
    var status: EtherScanResp.ResultCode?

    override init() {
        super.init()
    }

    init(_ json: JSON) {
        status = EtherScanResp.ResultCode(rawValue: json["status"].stringValue)
        message = json["message"].string
    }

}
