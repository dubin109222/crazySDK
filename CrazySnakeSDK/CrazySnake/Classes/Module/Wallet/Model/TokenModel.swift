//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

class TokenListResp: RespModel{

	var data : [TokenModel] = [TokenModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = TokenModel(dataJson)
            data.append(value)
        }
    }
}

class TokenModel{

    var address : String!
    var currency : String!
    var fullName : String!
    var icon : String!
    var id : Int!
    var name : String!
    var network : String!
    var unique_id : String!
    var website : String!
    var address_kovan: String = ""

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(_ json: JSON){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        currency = json["currency"].stringValue
        fullName = json["full_name"].stringValue
        icon = json["icon"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        network = json["network"].stringValue
        unique_id = json["unique_id"].stringValue
        website = json["website"].stringValue
        address_kovan = json["address_kovan"].stringValue
    }
}

class TokenRateResp: RespModel{

    var data : [TokenRateModel] = [TokenRateModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = TokenRateModel(dataJson)
            data.append(value)
        }
    }
}

struct TokenRateModel {
    var unique_id = ""
    var rate = "0"
    
    init(_ json: JSON){
        unique_id = json["unique_id"].stringValue
        rate = "\(json["rate"].doubleValue)"
    }
}

