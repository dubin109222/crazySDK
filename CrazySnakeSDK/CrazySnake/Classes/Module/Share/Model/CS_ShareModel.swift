//
//  CS_ShareModel.swift
//  CrazySnake
//
//  Created by Lee on 28/07/2023.
//

import UIKit
import HandyJSON


class CS_ShareResp: BaseRespModel{

    var data: CS_ShareDataModel?
}

struct CS_ShareDataModel: HandyJSON {
    
    var code = ""
    var master_wallet = ""
    var balance: CS_ShareBalanceModel?
    var withdraw: CS_ShareWithdrawModel?
    var reward: CS_ShareRewardModel?
    var cluster_num = 0
    var tasks = [CS_ShareTaskModel]()
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.code <-- "code.code"
        mapper <<< self.master_wallet <-- "master.wallet"
    }
}

struct CS_ShareBalanceModel: HandyJSON {
    
    var cyt = ""
    var cash = ""
    var cash2usdt = ""
    
}

struct CS_ShareWithdrawModel: HandyJSON {
    
    var usdt2cash = ""
    var total = ""
    var cash2usdt = ""
    var tokens = [CS_ShareTokenModel]()
    var list = [CS_ShareWithdrawItemModel]()
    
}

struct CS_ShareTokenModel: HandyJSON {
    
    var token = ""
    var name = ""
    var tokenName: TokenName = .SnakeToken
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.tokenName <-- "name"
    }
}

struct CS_ShareWithdrawItemModel: HandyJSON {
    
    var cash = ""
    var human = false
    var expired = Double.zero
    var valid = true
    var describe = ""
    
}

struct CS_ShareRewardModel: HandyJSON {
    
    var total: CS_ShareTotalModel?
    var daily = [CS_ShareDailyItemModel]()
    var daily_cash = ""
    var daily_cyt = ""
    var daily_cash2usdt = ""
    
}

struct CS_ShareTotalModel: HandyJSON {
    
    var cash = ""
    var cash2usdt = ""
    var cyt = ""
    var invite_cash = ""
    var invite_cyt = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.invite_cash <-- "invite.cash"
        mapper <<< self.invite_cyt <-- "invite.cyt"
    }
}

struct CS_ShareDailyItemModel: HandyJSON {
    
    var type = ""
    var cash = ""
    var cyt = ""
}

struct CS_ShareTaskModel: HandyJSON {
    
    var id = ""
    var type = 101
    var describe = ""
    var status = 0
    var reward_cyt = ""
    var reward_cash = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.reward_cash <-- "reward.cash"
        mapper <<< self.reward_cyt <-- "reward.cyt"
    }
}
