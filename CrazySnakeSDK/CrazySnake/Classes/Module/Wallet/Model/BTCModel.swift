//
//  BTCModel.swift
//  Platform
//
//  Created by Lee on 06/01/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit
import SwiftyJSON

class BTCModel: NSObject {

}


class BTCBalanceModel: NSObject {
    var address: String = ""
    var total_received = 0
    var total_sent = 0
    var balance = 0
    var unconfirmed_balance = 0
    var final_balance = 0.0
    var n_tx = 0
    var unconfirmed_n_tx = 0
    var final_n_tx = 0

    override init() {
        super.init()
    }

    init(_ json: JSON) {
        address = json["address"].stringValue
        total_received = json["total_received"].intValue
        total_sent = json["total_sent"].intValue
        balance = json["balance"].intValue
        unconfirmed_balance = json["unconfirmed_balance"].intValue
        final_balance = json["final_balance"].doubleValue
        n_tx = json["n_tx"].intValue
        unconfirmed_n_tx = json["unconfirmed_n_tx"].intValue
        final_n_tx = json["final_n_tx"].intValue
    }
}
