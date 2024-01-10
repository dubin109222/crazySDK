//
//  CS_EventModel.swift
//  CrazySnake
//
//  Created by Lee on 04/04/2023.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CS_EventModel: NSObject {

}

class CS_EventListResp: RespModel{

    var data: CS_EventListModel?
    
    override init(_ json: JSON) {
        super.init(json)
        
        if let model = JSONDeserializer<CS_EventListModel>.deserializeFrom(dict: json.dictionaryObject,designatedPath: "data") {
            self.data = model
        }
    }
}

struct CS_EventListModel : HandyJSON {
    var list: [CS_EventListItemModel] = []
}

struct CS_EventListItemModel : HandyJSON {
    var id = ""
    var name = ""
    var start_time = ""
    var end_time = ""
}

class CS_EventDetailResp: RespModel{

    var data: [CS_EventDetailModel] = [CS_EventDetailModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        
        if let model = JSONDeserializer<CS_EventDetailModel>.deserializeModelArrayFrom(array: json.dictionaryObject?["data"] as? Array<Any>) as? [CS_EventDetailModel] {
            self.data = model
        }

//        for dataJson in dataArray{
//            let value = CS_EventDetailModel(dataJson)
//            data.append(value)
//        }
    }
}

struct CS_EventDetailModel : HandyJSON {
    var item_id = ""
    var price = 0.0
    var origin_price = 0.0
    var sold = 0.0
    /// 库存
    var inventory = 0.0
    var discount = 0.0
    var can_buy_num = 0
    var props_type: CS_NFTPropsType = .unkown
    /// 状态，0未解锁，1可购买，2个人已买完
    var status = 1
    var buy_limit: [CS_EventButLimitModel] = []
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.props_type <-- "item_id"
    }

   
    
    func iconImage() -> UIImage? {
        return UIImage.ls_bundle("\(item_id)@2x")
    }
    
    func isSoldOut() -> Bool {
        var soldOut = false
        if can_buy_num == 0 {
            soldOut = true
        }
        if sold >= inventory {
            soldOut = true
        }
        return soldOut
    }
}

struct CS_EventButLimitModel : HandyJSON {
    var need_ticket_num = ""
    var can_buy_num = ""
    
}

class CS_EventRecordResp: RespModel{

    var data : CS_EventRecordListModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_EventRecordListModel(json["data"])
    }
}

class CS_EventRecordListModel: ListModel {
    var list : [CS_EventRecordModel] = [CS_EventRecordModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        let dataArray = json["list"].arrayValue
        for dataJson in dataArray{
            let value = CS_EventRecordModel(dataJson)
            list.append(value)
        }
    }
}

struct CS_EventRecordModel {
    var token = ""
    var item_id = ""
    var total_price = ""
    var num = 1
    /// 状态1成功，2失败，0确认中
    var status = 1
    var created_at: Double
    var props_type: CS_NFTPropsType = .unkown
    
    init(_ json: JSON){
        token = json["token"].stringValue
        item_id = json["item_id"].stringValue
        total_price = json["total_price"].stringValue
        num = json["num"].intValue
        status = json["status"].intValue
        created_at = json["created_at"].doubleValue
        props_type = CS_NFTPropsType(rawValue: json["item_id"].stringValue) ?? .unkown
    }
}
