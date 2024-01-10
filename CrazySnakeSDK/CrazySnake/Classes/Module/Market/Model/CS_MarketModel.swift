//
//  CS_MarketModel.swift
//  CrazySnake
//
//  Created by Lee on 23/04/2023.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CS_DiamondBalanceResp: RespModel{

    var data : CS_DiamondBalanceModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_DiamondBalanceModel(json["data"])
    }
}

struct CS_DiamondBalanceModel {
    var balance = ""
    
    init(_ json: JSON){
        balance = json["balance"].stringValue
    }
}

class CS_MarketListResp: BaseRespModel{

    var data : CS_MarketListModel?
}

class CS_MarketListModel: BaseListModel {

    var list : [CS_MarketModel] = [CS_MarketModel]()
}

struct Mock_MarketModel: HandyJSON {
    
}

struct CS_MarketModel: HandyJSON {
    var id = ""
    var game_id = ""
    var user_id = ""
    var sku_id = ""
    /// 1, 类型1nft，2道具
    var item_type = 0
    var item_id = ""
    var total = 0
    var balance = 0
    var price = ""
    var fee_token = ""
    /// 1, 状态 1上架中，2卖成功，3下架成功
    var status = 1
    var package = ""
    var propDetail: CS_NFTPropModel?
    var nftDetail: CS_NFTDataModel?
    var nftSetsDetail = [CS_NFTDataModel]()
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.propDetail <-- "detail"
        mapper <<< self.nftDetail <-- "detail"
        mapper <<< self.nftSetsDetail <-- "detail"
    }
    
    func isSelf() -> Bool {
        var isSelf = false
        if item_type == 1 {
            isSelf = nftDetail?.user?.isSelf() ?? false
        } else if item_type == 3 {
            isSelf = nftSetsDetail.first?.user?.isSelf() ?? false
        } else {
            isSelf = propDetail?.user?.isSelf() ?? false
        }
        return isSelf
    }
}

class CS_MarketSetsListResp: BaseRespModel{

    var data : CS_MarketSetsListModel?
    
}

class CS_MarketSetsListModel: BaseListModel {

    var list : [CS_NFTSetInfoModel] = [CS_NFTSetInfoModel]()
}

class CS_MarketSellResp: RespModel{

    var data : CS_MarketSellModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_MarketSellModel(json["data"])
    }
}

struct CS_MarketSellModel {
    /// 1 状态1成功，0失败
    var success = 1
    
    init(_ json: JSON){
        success = json["success"].intValue
    }
}
