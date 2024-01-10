//
//  CS_RankModel.swift
//  CrazySnake
//
//  Created by Lee on 13/06/2023.
//

import UIKit
import SwiftyJSON

class CS_RankTotalPowerResp: RespModel{

    var data : CS_RankTotalPowerListModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_RankTotalPowerListModel(json["data"])
    }
}

class CS_RankTotalPowerListModel: ListModel {
    
    var person: CS_RankTotalPowerModel?
    var list : [CS_RankTotalPowerModel] = [CS_RankTotalPowerModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        person = CS_RankTotalPowerModel(json["person"])
        let dataArray = json["list"].arrayValue
        for dataJson in dataArray{
            let value = CS_RankTotalPowerModel(dataJson)
            list.append(value)
        }
    }
}

struct CS_RankTotalPowerModel {
    var rank = 0
    var user_id = ""
    var wallet_address = ""
    var avatar_image = ""
    var nums = 0
    var total_power = ""
    var name = ""
    var total_amount = ""
    var token_id = ""
    var quality = CS_NFTQuality.unkown
    
    
    init(_ json: JSON){
        rank = json["rank"].intValue
        user_id = json["user_id"].stringValue
        wallet_address = json["wallet_address"].stringValue
        avatar_image = json["avatar_image"].stringValue
        nums = json["nums"].intValue
        total_power = json["total_power"].stringValue
        name = json["name"].stringValue
        total_amount = json["total_amount"].stringValue
        token_id = json["token_id"].stringValue
        quality = CS_NFTQuality(rawValue: json["quality"].intValue) ?? .unkown
    }
}

