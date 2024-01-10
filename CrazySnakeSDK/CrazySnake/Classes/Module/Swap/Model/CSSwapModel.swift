//
//  CSSwapModel.swift
//  CrazySnake
//
//  Created by Lee on 13/09/2022.
//

import UIKit
import SwiftyJSON
import HandyJSON

class RespModel: NSObject {
    
    var message: String?
    var status: LSNetwork.ResultCode?
    
    override init() {
        super.init()
    }
    
    init(_ json: JSON) {
        status = LSNetwork.ResultCode(rawValue: json["status"].int ?? -100)
        message = json["message"].string
    }
    
}

enum RespResultCode: Int, HandyJSONEnum {
    case success = 200
    case gas_limit = 1001
    case local_error = -100
    case serve_error = 500
}

class BaseRespModel: HandyJSON {
    var message: String?
    var status: RespResultCode?
    
    required init(){}
}

class BaseListModel: HandyJSON {
    
    var total = 0
    var current_page = 1
    
    required init(){}
}

class SwapAmountResp: RespModel{

    var data : String?
    
    override init(_ json: JSON) {
        super.init(json)
        data = json["data"].string
    }
}

class PostFreeGasResp: RespModel{

    var data : PostFreeGasModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = PostFreeGasModel(json["data"])
    }
}

class PostFreeGasModel: NSObject {
    
    var gas_coin_left : Int = 0
    var tx_hash: String?
    
    override init() {
        super.init()
    }
    
    init(_ json: JSON) {
        gas_coin_left = json["gas_coin_left"].intValue
        tx_hash = json["tx_hash"].string
    }
}

class GasFeeResp: RespModel{

    var data : GasFeeData?
    
    override init(_ json: JSON) {
        super.init(json)
        data = GasFeeData(json["data"])
    }
}

class GasFeeData: NSObject {
    
    var safeLow: GasFeeModel?
    var standard: GasFeeModel?
    var fast: GasFeeModel?
    var estimatedBaseFee : String?
    var blockTime: String?
    var blockNumber: String?
    
    override init() {
        super.init()
    }
    
    init(_ json: JSON) {
        safeLow = GasFeeModel(json["safeLow"])
        standard = GasFeeModel(json["standard"])
        fast = GasFeeModel(json["fast"])
        estimatedBaseFee = json["estimatedBaseFee"].string
        blockTime = json["blockTime"].string
        blockNumber = json["blockNumber"].string
    }
}

class GasFeeModel: NSObject {
    
    var maxPriorityFee : Int = 36
    var maxFee: Int = 36
    
    override init() {
        super.init()
    }
    
    init(_ json: JSON) {
        maxPriorityFee = json["maxPriorityFee"].intValue
        maxFee = json["maxFee"].intValue
    }
}
