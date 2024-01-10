//
//  CS_UserModel.swift
//  CrazySnake
//
//  Created by Lee on 16/06/2023.
//

import UIKit
import SwiftyJSON

class CS_UserInfoResp: RespModel {
    
    var data: CS_UserInfoModel?
    
    override init(_ json: JSON){
        super.init(json)
        self.data = CS_UserInfoModel(json["data"])
    }
    
}

struct CS_UserInfoModel {
    
    var id = ""
    var name = ""
    var wallet_address = ""
    var avatar = 101
    var device_id = ""
    var os = "1"
    var ip = ""
    var parent_id = 0
    var gas_coin_left = ""
    var gas_coin_used = ""
    var nft_staking_total_reward = ""
    var nft_staking_claimable_reward = ""
    var nft_staking_slots_count = 0
    var ticket_amount = ""
    var cash_amount = ""
    var avatar_image = ""
    
    init(_ json: JSON){
        id = json["id"].stringValue
        name = json["name"].stringValue
        wallet_address = json["wallet_address"].stringValue
        avatar = json["avatar"].intValue
        device_id = json["device_id"].stringValue
        os = json["os"].stringValue
        ip = json["ip"].stringValue
        parent_id = json["parent_id"].intValue
        gas_coin_left = json["avatar"].stringValue
        gas_coin_used = json["gas_coin_used"].stringValue
        nft_staking_total_reward = json["nft_staking_total_reward"].stringValue
        nft_staking_claimable_reward = json["nft_staking_claimable_reward"].stringValue
        nft_staking_slots_count = json["nft_staking_slots_count"].intValue
        ticket_amount = json["ticket_amount"].stringValue
        cash_amount = json["cash_amount"].stringValue
        avatar_image = json["avatar_image"].stringValue
    }
}

class CS_UserAvatarListResp: RespModel{

    var data : CS_UserAvatarListModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_UserAvatarListModel(json["data"])
    }
}

class CS_UserAvatarListModel: ListModel {
    var list : [CS_UserAvatarModel] = [CS_UserAvatarModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        let dataArray = json["list"].arrayValue
        for dataJson in dataArray{
            let value = CS_UserAvatarModel(dataJson)
            list.append(value)
        }
    }
}

struct CS_UserAvatarModel {

    var id = 1
    var avatar_id = 101
    var unlock_cyt = ""
    /// 状态1已解锁，0未解锁
    var status = 1
    var image = ""
    
    init(_ json: JSON?){
        guard let json = json else {
            return
        }
        id = json["id"].intValue
        avatar_id = json["avatar_id"].intValue
        unlock_cyt = json["unlock_cyt"].stringValue
        status = json["status"].intValue
        image = json["image"].stringValue
    }
}
