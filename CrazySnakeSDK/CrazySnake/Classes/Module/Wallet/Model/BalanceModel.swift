//
//	Result.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class BalanceListResp: RespModel{

    var data : [BalanceModel] = [BalanceModel]()

    override init(_ json: JSON) {
        super.init(json)
        data = [BalanceModel]()
        let resultArray = json["data"].arrayValue
        for resultJson in resultArray{
            let value = BalanceModel(fromJson: resultJson)
            data.append(value)
        }
    }
}

class BalanceModel{

    var id = ""
    var token_rates = ""
    var chain_type = ""
    var address = ""
    var tokenAddress: String?
    var balance = ""
    var balance_local = ""
    var isMainToken = false

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        token_rates = json["tokenRates"].stringValue
        chain_type = json["chainType"].stringValue
        address = json["address"].stringValue
        tokenAddress = json["tokenAddress"].stringValue
        balance = json["balance"].stringValue
        balance_local = json["balanceLocal"].stringValue
        isMainToken = json["isMainToken"].boolValue
    }

}
