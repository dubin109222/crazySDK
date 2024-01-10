//
//  CS_WalletRecordModel.swift
//  CrazySnake
//
//  Created by Lee on 23/05/2023.
//

import UIKit
import SwiftyJSON

class CS_WalletRecordResp: RespModel{

    var data : CS_WalletRecordListModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_WalletRecordListModel(json["data"])
    }
}

class CS_WalletRecordListModel: ListModel {
    var list : [CS_WalletRecordModel] = [CS_WalletRecordModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        let dataArray = json["list"].arrayValue
        for dataJson in dataArray{
            let value = CS_WalletRecordModel(dataJson)
            list.append(value)
        }
    }
}

struct CS_WalletRecordModel {
    var created_at: Double
    var to = ""
    var amount = ""
    /// 状态1成功，2失败，0确认中
    var status = 1
    var token: TokenName = TokenName.Snake
    
    init(_ json: JSON){
        created_at = json["created_at"].doubleValue
        to = json["to"].stringValue
        amount = json["amount"].stringValue
        status = json["status"].intValue
        token = TokenName(rawValue: json["token"].stringValue) ?? .Snake
    }
}
