//
//  CS_NFTStakeModel.swift
//  CrazySnake
//
//  Created by Lee on 13/03/2023.
//

import UIKit
import SwiftyJSON
import HandyJSON



class CS_NFTStakeInfoResp: RespModel{

    var data : CS_NFTStakeInfoModel?
    
    override init(_ json: JSON) {
        super.init(json)
        
        if let model = JSONDeserializer<CS_NFTStakeInfoModel>.deserializeFrom(json: json.rawString(), designatedPath: "data") {
            data = model
        }

    }
}

struct CS_NFTStakeInfoLevelModel : HandyJSON {
    var pow_left : Int = 0
    var pow_right : Int = 0
    var airdrop : Int = 0
}

struct CS_NFTStakeInfoAirDropModel : HandyJSON{
    var cur : CS_NFTStakeInfoLevelModel?
    var next : CS_NFTStakeInfoLevelModel?
}

struct CS_NFTStakeInfoModel : HandyJSON {
    var rewardPerSecond = 0
    var userPower = 0
    var userReward = ""
    var userBoostReward = 0
    var userTotalReward = ""
    var totalPower = 0
    var nfts : [CS_NFTStakeNFTModel] = [CS_NFTStakeNFTModel]()
    var slots = 5
    var maxSlots = 20
    var nextSlotCostCards = 1
    var totalStakedNftCount = 0
    var currentAirdrop = 0
    var airDrop : CS_NFTStakeInfoAirDropModel?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.currentAirdrop <-- "airDrop.cur.airdrop"
    }

    
    func hasMoreSolt() -> Bool {
        if totalStakedNftCount < maxSlots {
            return true
        } else {
            return false
        }
    }
}

struct CS_NFTStakeNFTModel : HandyJSON {
    var id = ""
    var owner = ""
    var nfts : [CS_NFTStakeGroupItemModel] = [CS_NFTStakeGroupItemModel]()
    var group_class = 0
    var image = ""
    var group = false
    var reward = "0.0"
    var power = 0
    var powerInit = 0
    var powerBonus = 0
    var create:Double = 0
    var profile_image = ""
    var background_image = ""
    
}

struct CS_NFTStakeGroupItemModel : HandyJSON {
    var id = ""
    var group_class = 0
    var quality: CS_NFTQuality = .unkown
    var image = ""
}

class CS_NFTStakeSuitableResp: BaseRespModel{

    var data = [CS_NFTStakeSuitableItemModel]()
}

struct CS_NFTStakeSuitableItemModel: HandyJSON {
    var group_class = 0
    var image = ""
    var profile_image = ""
    var background_image = ""
    var qualities = [CS_NFTQuality]()
    /// 质押数据，qualities返回的是[0,0,1,1,1,0]的结构，0、1表示是否拥有对应品质的nft
    var qualitiesList = [Int]()
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.group_class <-- "class"
        mapper <<< self.qualitiesList <-- "qualities"
    }
}

class CS_EstimateGasPriceResp: RespModel{

    var data: CS_EstimateGasPriceModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_EstimateGasPriceModel(json["data"])
    }
}

struct CS_EstimateGasPriceModel {
    var gas = ""
    var balance = ""
    var contract = ""
    
    var current_gwei : Double = 0
    var is_gwei_high = false
    
    init(_ json: JSON){
        gas = json["gas"].stringValue
        balance = json["balance"].stringValue
        contract = json["contract"].stringValue
        current_gwei = Double(json["current_gwei"].stringValue) ?? 0
        is_gwei_high = json["is_gwei_high"].boolValue

    }
}

class CS_NFTSetInfoResp: BaseRespModel{

    var data: [CS_NFTSetInfoModel] = [CS_NFTSetInfoModel]()
}

struct CS_NFTSetInfoModel: HandyJSON {
    var set_class = ""
    var image = ""
    var qualities = [CS_NFTQuality]()
    var qualitiesList = [Int]()
    var profile_image = ""
    var background_image = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.set_class <-- "class"
        mapper <<< self.qualitiesList <-- "qualities"
    }
}
