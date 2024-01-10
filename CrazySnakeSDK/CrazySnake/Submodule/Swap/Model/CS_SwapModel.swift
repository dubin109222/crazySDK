//
//  CS_SwapModel.swift
//  CrazySnake
//
//  Created by Lee on 17/03/2023.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CS_SwapRatioResp: RespModel{

    var data : CS_SwapRatioModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_SwapRatioModel(json["data"])
    }
}

struct CS_SwapRatioModel {

    var from: TokenName?
    var to: TokenName?
    var ratio = "0"
    
    init(_ json: JSON){
        from = TokenName(rawValue: json["from"].stringValue)
        to = TokenName(rawValue: json["to"].stringValue)
        ratio = json["ratio"].stringValue
    }
    
}

class CS_SwapHistoryResp: RespModel{

    var data : CS_SwapHistoryListModel?
    
    override init(_ json: JSON) {
        super.init(json)
        data = CS_SwapHistoryListModel(json["data"])
    }
}

class CS_SwapHistoryListModel: ListModel {
    var list : [CS_SwapHistoryModel] = [CS_SwapHistoryModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        let dataArray = json["list"].arrayValue
        for dataJson in dataArray{
            let value = CS_SwapHistoryModel(dataJson)
            list.append(value)
        }
    }
}

struct CS_SwapHistoryModel {
    var id = ""
    /// 合约对应的id
    var sid = ""
    var token_in = ""
    var token_out = ""
    var amount_in = ""
    var amount_out = ""
    /// 进度条
    var progress = 0
    /// 进度条类型，1：3个，2：5个
    var progress_type = 1
    /// 状态0进行中，1已完成，2已失败，3可领取
    var status = 0
    var created_at = ""
    
    init(_ json: JSON){
        id = json["id"].stringValue
        sid = json["sid"].stringValue
        token_in = json["token_in"].stringValue
        token_out = json["token_out"].stringValue
        amount_in = json["amount_in"].stringValue
        amount_out = json["amount_out"].stringValue
        progress = json["progress"].intValue
        progress_type = json["progress_type"].intValue
        status = json["status"].intValue
        created_at = json["created_at"].stringValue
    }
    
    func payTokenName() -> String {
        let config = CS_AccountManager.shared.basicConfig?.contract
        var name = ""
        if token_out == config?.current_token.first?.contract_address {
            name = config?.current_token.first?.token_name.name() ?? ""
        } else if token_out == config?.usdt_token?.contract_address {
            name = config?.usdt_token?.token_name.name() ?? ""
        } else if token_out == "GasCoin" {
            name = config?.gas_coin_token?.token_name.name() ?? ""
        }
        return name
    }
    
    func payTokenIcon() -> UIImage? {
        let config = CS_AccountManager.shared.basicConfig?.contract
        var image: UIImage?
        if token_out == config?.current_token.first?.contract_address {
            image = TokenName.Snake.icon()
        } else if token_out == config?.usdt_token?.contract_address {
            image = TokenName.USDT.icon()
        } else if token_out == config?.gas_coin_token?.contract_address {
            image = TokenName.GasCoin.icon()
        }
        return image
    }
    
    func payAmount() -> String? {
        let config = CS_AccountManager.shared.basicConfig?.contract
        var name: String?
//        if token_in == "GasCoin" {
//            return amount_out
//        }
        if token_out == config?.current_token.first?.contract_address {
            name = EthUnitUtils.getAmount(wei: amount_out, token: .Snake)
        } else if token_out == config?.usdt_token?.contract_address {
            name = EthUnitUtils.getAmount(wei: amount_out, token: .USDT)
        } else if token_out == config?.gas_coin_token?.contract_address {
            name = amount_out
        }
        return Utils.formatAmount(name)
    }
    
    func getTokenName() -> String {
        let config = CS_AccountManager.shared.basicConfig?.contract
        var name = ""
        if token_in == config?.current_token.first?.contract_address {
            name = config?.current_token.first?.token_name.name() ?? ""
        } else if token_in == config?.usdt_token?.contract_address {
            name = config?.usdt_token?.token_name.name() ?? ""
        } else if token_in == config?.gas_coin_token?.contract_address {
            name = config?.gas_coin_token?.token_name.name() ?? ""
        }
        return name
    }
    
    func getTokenIcon() -> UIImage? {
        let config = CS_AccountManager.shared.basicConfig?.contract
        var image: UIImage?
        if token_in == config?.current_token.first?.contract_address {
            image = TokenName.Snake.icon()
        } else if token_in == config?.usdt_token?.contract_address {
            image = TokenName.USDT.icon()
        } else if token_in == config?.gas_coin_token?.contract_address {
            image = TokenName.GasCoin.icon()
        }
        return image
    }
    
    func getAmount() -> String? {
        let config = CS_AccountManager.shared.basicConfig?.contract
        var name: String?
        if token_in == config?.current_token.first?.contract_address {
            name = EthUnitUtils.getAmount(wei: amount_in, token: .Snake)
        } else if token_in == config?.usdt_token?.contract_address {
            name = EthUnitUtils.getAmount(wei: amount_in, token: .USDT)
        } else if token_in == config?.gas_coin_token?.contract_address {
            name = amount_in
        }
        return Utils.formatAmount(name)
    }
}

struct CS_SwapTokenItem : HandyJSON {
    // "is_confirming": 0,0不在确认中，1正在确认中
    var is_confirming = 0
    var gas_coin = ""
    var need_snake = ""
    
    var id = ""
    var token_amount = ""
    var currency_amount = ""
    var game_id : String = ""
    var currency : TokenName = TokenName.GasCoin
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.need_snake <-- "need_amount"
    }
}

class CS_SwapGasCoinResp: RespModel{

    var data: [CS_SwapGasCoinModel] = [CS_SwapGasCoinModel]()
    
    override init(_ json: JSON) {
        super.init(json)
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = CS_SwapGasCoinModel(dataJson)
            data.append(value)
        }
    }
}

struct CS_SwapGasCoinModel {
    var gas_coin = ""
    var need_snake = ""
    init(_ json: JSON) {
        gas_coin = json["gas_coin"].stringValue
        need_snake = json["need_amount"].stringValue
    }
}

class CS_SwapWelfareResp: RespModel{

    var data : [CS_SwapWelfareModel]?
    
    override init(_ json: JSON) {
        super.init(json)
        
        if let model = JSONDeserializer<CS_SwapWelfareModel>.deserializeModelArrayFrom(json: json.rawString(),designatedPath: "data") as? [CS_SwapWelfareModel] {
            data = model
        }
    }
}

struct CS_SwapConfigModel: HandyJSON {
    var from: TokenName?
    var to: TokenName?
}

struct CS_SwapWelfareModel: HandyJSON {

    var from: CS_SwapWelfareItem?
    var to: CS_SwapWelfareItem?
    var left_times = 0
    var amount = 0
    /// 1交易确认中，0没有确认中
    var is_confirming = 0
    
    
}

struct CS_SwapWelfareItem: HandyJSON {

    var contract_name = ""
    var contract_address = "contract_address"
    var token: TokenName?
    
}

