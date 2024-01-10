//
//  RalanceListResp.swift
//  Platform
//
//  Created by Bob on 2021/10/8.
//  Copyright © 2021 Saving. All rights reserved.
//

import Foundation
import SwiftyJSON

class TranscationListResp: RespModel{

    var data : [TranscationModel] = [TranscationModel]()

    override init(_ json: JSON) {
        super.init(json)
        data = [TranscationModel]()
        let resultArray = json["data"].arrayValue
        for resultJson in resultArray{
            let value = TranscationModel(fromJson: resultJson)
            data.append(value)
        }
    }
}

class TranscationModel{

    var address = ""
    var tokenAddress: String?
    var hash = ""
    var from = ""
    var to = ""
    var value = ""
    var value_local = ""
    var timestamp = ""
    var fee = ""
    var fee_local = ""
    var block = ""
    var gas_limit = ""
    var gas_price = ""

    
    /// 0: fail  1:success  2:padding（deprecated）
    var orderStatus = 0
    /// 1:out  2: deposit
    var type = 1


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        tokenAddress = json["tokenAddress"].string
        hash = json["hash"].stringValue
        from = json["from"].stringValue
        to = json["to"].stringValue
        value = json["value"].stringValue
        value_local = json["valueLocal"].stringValue
        timestamp = json["timestamp"].stringValue
        orderStatus = json["orderStatus"].intValue
        fee = json["fee"].stringValue
        fee_local = json["feeLocal"].stringValue
        block = json["block"].stringValue
        gas_limit = json["gasLimit"].stringValue
        gas_price = json["gasPrice"].stringValue
    }

}



