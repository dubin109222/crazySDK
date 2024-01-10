//
//  CS_ShareWithdrawModel.swift
//  CrazySnake
//
//  Created by Lee on 08/08/2023.
//

import UIKit
import HandyJSON

class CS_ShareSwapResp: BaseRespModel{

    var data: CS_ShareSwapDataModel?
}

struct CS_ShareSwapDataModel: HandyJSON {
    
    var cash = ""
    var cyt = ""
    var token = ""
    
}

class CS_ShareWithdrawHistoryResp: BaseRespModel{

    var data = [CS_ShareWithdrawHistoryModel]()
}

struct CS_ShareWithdrawHistoryModel: HandyJSON {
    
    var id = ""
    /*
     0 = 已完成
     1 = 等待链上确认
     2 = 等待人工审核
     3 = 链上处理失败
     4 = 人工审核未通过
     */
    var status = 0
    var token = ""
    var cash_amount = ""
    var token_amount = ""
    var tx_hash = ""
    var descibe = ""
    var create_time: Double = 0.0
    var expired_time: Double = 0.0
    
}

class CS_ShareFirendsResp: BaseRespModel{

    var data = [CS_ShareFriendModel]()
}

struct CS_ShareFriendModel: HandyJSON {
    
    var share_level = 0
    var wallet = ""
    var daily: CS_ShareFriendItemModel?
    var total: CS_ShareFriendItemModel?
    var create_time: Double = 0
    var level = 0
    
}

struct CS_ShareFriendItemModel: HandyJSON {
    var cash = ""
    var cash_1 = ""
    var cash_2 = ""
}
