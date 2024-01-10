//
//  CS_StakeTimeModel.swift
//  CrazySnake
//
//  Created by Lee on 17/03/2023.
//

import UIKit
import SwiftyJSON

class CS_StakeTimeResp: RespModel{

    var data : CS_StakeTimeDataModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_StakeTimeDataModel(json["data"])
    }
}

struct CS_StakeTimeDataModel {
    var ticket_amount = ""
    var detail : [CS_StakeTimeModel] = [CS_StakeTimeModel]()
    
    init(_ json: JSON) {
        ticket_amount = json["ticketAmount"].stringValue
        let dataArray = json["detail"].arrayValue
        for dataJson in dataArray{
            let value = CS_StakeTimeModel(dataJson)
            detail.append(value)
        }
    }
}

struct CS_StakeTimeModel {

    var duration = 0
    var day = 7
    /// 1, 类型1短期，2中期，3长期
    var type = 1
    var ratio: Double = 0.0
    var apr_ticket = ""
    var apr_token = ""
    
    init(_ json: JSON){
        duration = json["duration"].intValue
        day = json["day"].intValue
        type = json["type"].intValue
        ratio = json["ratio"].doubleValue
        apr_ticket = json["apr_ticket"].stringValue
        apr_token = json["apr_token"].stringValue
    }
    
    func cytAmount() -> Double {
        return Double(day)*ratio
    }
    
    func displayName() -> String {
        var name = ""
        switch duration {
        case 0:
            name = "crazy_str_7_day".ls_localized
        case 1:
            name = "crazy_str_14_day".ls_localized
        case 2:
            name = "crazy_str_1_month".ls_localized
        case 3:
            name = "crazy_str_3_month".ls_localized
        case 4:
            name = "crazy_str_6_month".ls_localized
        case 5:
            name = "crazy_str_1_year".ls_localized
        default:
            name = ""
        }
        return name
    }
    
}

