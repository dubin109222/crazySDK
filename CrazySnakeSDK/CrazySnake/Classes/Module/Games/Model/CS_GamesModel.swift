//
//  CS_GamesModel.swift
//  CrazySnake
//
//  Created by Lee on 17/05/2023.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CS_SessionInfoResp: RespModel{

    var data : CS_SessionInfoModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_SessionInfoModel(json["data"])
    }
}

enum CS_SessionStatus: Int {
    case confirming = 0
    case beging = 1
    case ending = 2
    case done = 3
}

struct CS_SessionInfoModel {

    var id = ""
    var game_id = ""
    var round_id = 0
    var start_time:Double = 0
    var close_time:Double = 0
    var total_amount = ""
    var red_amount = ""
    var blue_amount = ""
    var oracle_called = ""
    ///  状态0 开启确认中，1当前轮开启，2结算中，3结算完成
    var status = CS_SessionStatus.ending
    var red_score = 0
    var blue_score = 0
    var red_users = ""
    var blue_users = ""
    ///  赢的钱
    var reward_base_amount = ""
    /// 扣5个点后的总金额
    var reward_amount = ""
    var token_contract_name = ""
    var token_contract_address = ""
    var contract_name = ""
    var contract_address = ""
    var jump_url = ""
    var current_time:Double = 0
    var config: CS_SessionConfigModel?
    var user_round: CS_SessionUserRoundModel?
    
    init(_ json: JSON){
        id = json["id"].stringValue
        game_id = json["game_id"].stringValue
        round_id = json["round_id"].intValue
        start_time = json["start_time"].doubleValue
        close_time = json["close_time"].doubleValue
        total_amount = json["total_amount"].stringValue
        red_amount = json["red_amount"].stringValue
        blue_amount = json["blue_amount"].stringValue
        oracle_called = json["oracle_called"].stringValue
        status = CS_SessionStatus(rawValue: json["status"].intValue) ?? .ending
        red_score = json["red_score"].intValue
        blue_score = json["blue_score"].intValue
        red_users = json["red_users"].stringValue
        blue_users = json["blue_users"].stringValue
        reward_base_amount = json["reward_base_amount"].stringValue
        reward_amount = json["reward_amount"].stringValue
        token_contract_name = json["token_contract_name"].stringValue
        token_contract_address = json["token_contract_address"].stringValue
        contract_name = json["contract_name"].stringValue
        contract_address = json["contract_address"].stringValue
        jump_url = json["jump_url"].stringValue
        current_time = json["current_time"].doubleValue
        config = CS_SessionConfigModel(json["config"])
        user_round = CS_SessionUserRoundModel(json["user_round"])
    }
    
}

struct CS_SessionConfigModel {
    var bet_min = ""
    var bet_max = ""
    var withdraw_min = ""
    
    init(_ json: JSON){
        bet_min = json["bet_min"].stringValue
        bet_max = json["bet_max"].stringValue
        withdraw_min = json["withdraw_min"].stringValue
    }
}

struct CS_SessionUserRoundModel {
    var position = 0
    var amount = ""
    var rewards = ""
    /// 0等待开奖，1可领奖，2已领奖，3失败，-1下注确认中（结算页面不展示）
    var status = 0
    var wallet_address = ""
    
    init(_ json: JSON){
        position = json["position"].intValue
        amount = json["amount"].stringValue
        rewards = json["rewards"].stringValue
        status = json["status"].intValue
        wallet_address = json["wallet_address"].stringValue
    }
}


class CS_SessionHistoryResp: RespModel{

    var data : CS_SessionHistoryListModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_SessionHistoryListModel(json["data"])
    }
}

class CS_SessionHistoryListModel: ListModel {
    var list : [CS_SessionInfoModel] = [CS_SessionInfoModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        let dataArray = json["list"].arrayValue
        for dataJson in dataArray{
            let value = CS_SessionInfoModel(dataJson)
            list.append(value)
        }
    }
}

class CS_MineHistoryResp: BaseRespModel{

    var data : CS_MineHistoryDataModel?

}

class CS_MineHistoryDataModel: BaseListModel {
    
    /// 1确认中，0暂无确认中的数据
    var claim_confirming = 0
    /// 可领取的round_id，为空的时候是空数组
    var claimable_round_ids = [Int]()
    /// 可领取的总金额
    var claimable_total_rewards = ""
    var list : [CS_MineHistoryModel] = [CS_MineHistoryModel]()
}

struct CS_MineHistoryModel: HandyJSON {
    var id = ""
    var fight_id = ""
    var user_id = ""
    /// 1, 位置1红队，2蓝队
    var position = 1
    var round_id = 0
    var amount = ""
    var rewards = ""
    /// 1, 状态 -1确认中，0等待开奖，1可领奖，2已领奖，3你输了
    var status = 1
    var created_at = ""
    var updated_at = ""
    var user: CS_NFTUserModel?
}


class CS_GameRankResp: BaseRespModel{

    var data : CS_GameRankDataModel?
}

class CS_GameRankDataModel: BaseListModel {
    
    var personal: CS_GameRankModel?
    var list : [CS_GameRankModel] = [CS_GameRankModel]()
}

struct CS_GameRankModel: HandyJSON {
    var total_amount = ""
    var total_rewards = ""
    var user_id = ""
    var round_id = ""
    var rank = 0
    var user: CS_NFTUserModel?
}
