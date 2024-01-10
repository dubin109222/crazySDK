//
//  CS_MarketHistoryModel.swift
//  CrazySnake
//
//  Created by Lee on 26/04/2023.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CS_MarketHistoryResp: BaseRespModel{

    var data : CS_MarketHistoryListModel?
}

class CS_MarketHistoryListModel: BaseListModel {

    var list : [CS_MarketHistoryModel] = [CS_MarketHistoryModel]()
}

struct CS_MarketHistoryModel: HandyJSON {
    var item_id = ""
    var nft_class = ""
    /// 1, 类型1nft，2道具
    var item_type = 0
    var id = ""
    var nft_market_id = ""
    var user_id = ""
    var num = 0
    var price = ""
    var trade_time = ""
    var fee = ""
    var fee_token = ""
    var buyer: CS_NFTUserModel?
    var seller: CS_NFTUserModel?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.nft_class <-- "class"
    }
}

