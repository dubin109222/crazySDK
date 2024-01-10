//
//  CS_StakeTokenRecordModel.swift
//  CrazySnake
//
//  Created by Lee on 17/03/2023.
//

import UIKit
import SwiftyJSON

class CS_StakeTokenRecordResp: RespModel{

    var data : CS_StakeTokenRecordListModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_StakeTokenRecordListModel(json["data"])
    }
}

class CS_StakeTokenRecordListModel: ListModel {
    var rewardPerSecond = ""
    var userAmount = ""
    var ticketAmount = ""
    var userPower = ""
    var userReward = ""
    var totalPower = ""
    var tokens : [CS_StakeTokenRecordModel] = [CS_StakeTokenRecordModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        rewardPerSecond = json["rewardPerSecond"].stringValue
        userAmount = json["userAmount"].stringValue
        ticketAmount = json["ticketAmount"].stringValue
        userPower = json["userPower"].stringValue
        userReward = json["userReward"].stringValue
        totalPower = json["totalPower"].stringValue
        let dataArray = json["tokens"].arrayValue
        for dataJson in dataArray{
            let value = CS_StakeTokenRecordModel(dataJson)
            tokens.append(value)
        }
    }
}

struct CS_StakeTokenRecordModel {
    var apr_ticket = ""
    var apr_token = ""
    var stakingid = ""
    var token = ""
    var amount = ""
    var staking_token: TokenName = .Snake
    var power = ""
    var ticket = ""
    var powerInit = ""
    var powerBonus = ""
    var reward_rate = ""
    var order_id = ""
    var period = 0
    var reward = ""
    var start_at = ""
    var end_at = ""
    var expired = false
    /// 0=质押中 1=已到期 2=质押等待中 3=反质押等待中
    var state = 1
    
    init(_ json: JSON){
        apr_ticket = json["apr_ticket"].stringValue
        apr_token = json["apr_token"].stringValue
        stakingid = json["stakingid"].stringValue
        token = json["token"].stringValue
//        staking_token = TokenName(rawValue: json["token"].stringValue) ?? .Snake
        amount = json["amount"].stringValue
        power = json["power"].stringValue
        ticket = json["ticket"].stringValue
        powerInit = json["powerInit"].stringValue
        powerBonus = json["powerBonus"].stringValue
        reward_rate = json["reward_rate"].stringValue
        order_id = json["order_id"].stringValue
        period = json["period"].intValue
        reward = json["reward"].stringValue
        start_at = json["start_at"].stringValue
        end_at = json["end_at"].stringValue
        expired = json["expired"].boolValue
        state = json["state"].intValue
        
    }
}
