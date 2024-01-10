//
//  CS_NFTIncubateModel.swift
//  CrazySnake
//
//  Created by Lee on 09/03/2023.
//

import UIKit
import SwiftyJSON

class CS_NFTIncubaDetailResp: RespModel{

    var data: CS_NFTIncubaDetail?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_NFTIncubaDetail(json["data"])
    }
}

class CS_NFTIncubateSpeedUpResp: RespModel{

    var data: CS_NFTIncubaDetail?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_NFTIncubaDetail(json["data"])
    }
}

struct CS_NFTIncubaDetail {
    var id = ""
    var token_id_1 = ""
    var token_id_2 = ""
    var incubator_id = ""
    var sub_token_id = ""
    var power = 0
    var start_time = 0.0
    var end_time = 0.0
    var speedup = 0.0
    /// 状态1孵化中，2已完成，3孵化时间结束
    var status = 1
    var created_at = ""
    var updated_at = ""
    
    init(_ json: JSON){
        id = json["id"].stringValue
        token_id_1 = json["token_id_1"].stringValue
        token_id_2 = json["token_id_2"].stringValue
        incubator_id = json["incubator_id"].stringValue
        sub_token_id = json["sub_token_id"].stringValue
        power = json["power"].intValue
        start_time = json["start_time"].doubleValue
        end_time = json["end_time"].doubleValue
        speedup = json["speedup"].doubleValue
        status = json["status"].intValue
        created_at = json["created_at"].stringValue
        updated_at = json["updated_at"].stringValue
    }
}
