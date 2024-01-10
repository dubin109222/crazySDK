//
//  CS_BasicConfigModel.swift
//  CrazySnake
//
//  Created by Lee on 16/06/2023.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CS_BasicConfigModelResp: RespModel {
    
    var data: CS_BasicConfigDataModel?
    
    override init(_ json: JSON){
        super.init(json)
        if let model = JSONDeserializer<CS_BasicConfigDataModel>.deserializeFrom(json: json.rawString(),designatedPath: "data") {
            self.data = model
        }
    }
    
}

struct CS_BasicConfigDataModel: HandyJSON {
    
    var name = ""
    var game_id = 1
    var version = "1"
    var rpc_url = ""
    var contract: CS_BasicConfigContractModel?

}

struct CS_BasicConfigContractModel: HandyJSON {

    var current_token = [CS_BasicConfigContractItem]()
    var nft = [CS_BasicConfigContractItem]()
    var game_fight = [CS_BasicConfigContractItem]()
    var nft_transfer = [CS_BasicConfigContractItem]()
    var config: CS_BasicConfigContractItem?
    var cyt_token: CS_BasicConfigContractItem?
    var gas_coin_token: CS_BasicConfigContractItem?
    var usdt_token: CS_BasicConfigContractItem?
    var matic_token: CS_BasicConfigContractItem?
    var game_token = [CS_BasicConfigContractItem]()
    var cash_box: CS_BasicConfigContractItem?
    var forward: CS_BasicConfigContractItem?
    var token_stake: CS_BasicConfigContractItem?
    var swapper: CS_BasicConfigContractItem?
    var asset: CS_BasicConfigContractItem?
 
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.asset <-- "token_stake"
    }
}

struct CS_BasicConfigContractItem: HandyJSON {

    var game_id = 1
    var token_name: TokenName = .Snake
    var token_icon = ""
    var contract_name = ""
    var contract_address = ""
    
}
