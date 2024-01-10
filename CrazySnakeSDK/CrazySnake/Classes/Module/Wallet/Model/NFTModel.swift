//
//  NFTModel.swift
//  Platform
//
//  Created by Lee on 21/12/2021.
//  Copyright © 2021 ELFBOX. All rights reserved.
//

import UIKit
import SwiftyJSON

class MoralisResp: NSObject {
    
    enum ResultCode: String {
        case no_transactions_found = "0"
        case success = "1"
        case local_error = "-100"
    }
    
    var message: String?
    var status: MoralisResp.ResultCode?

    override init() {
        super.init()
    }

    init(_ json: JSON) {
        status = MoralisResp.ResultCode(rawValue: json["status"].stringValue)
        message = json["message"].string
    }
}

class NFTListResp: MoralisResp{

    var result = [NFTModel]()

    override init(_ json: JSON) {
        super.init(json)
        let resultArray = json["result"].arrayValue
        for item in resultArray{
            let value = NFTModel(fromJson: item)
            result.append(value)
        }
    }
}

struct NFTModel{

    var token_address = ""
    var token_id = ""
    var contract_type = ""
    var owner_of = ""
    var block_number = ""
    var block_number_minted = ""
    var token_uri = ""
    var metadata: NFTMetadata?
    var synced_at = ""
    var amount = ""
    var name = ""
    var symbol = ""
    
    init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        token_address = json["token_address"].stringValue
        token_id = json["token_id"].stringValue
        contract_type = json["contract_type"].stringValue
        owner_of = json["owner_of"].stringValue
        block_number = json["block_number"].stringValue
        block_number_minted = json["block_number_minted"].stringValue
        token_uri = json["token_uri"].stringValue
        metadata = NFTMetadata(fromJson: JSON.init(parseJSON:json["metadata"].stringValue))
        synced_at = json["synced_at"].stringValue
        amount = json["amount"].stringValue
        name = json["name"].stringValue
        symbol = json["symbol"].stringValue
    }
}

struct NFTMetadata {
    var name = ""
    var description = ""
    var image = ""
    var attributes = ""
    var is_valid = ""
    
    init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        name = json["name"].stringValue
        description = json["description"].stringValue
        image = json["image"].stringValue
        attributes = json["attributes"].stringValue
        is_valid = json["is_valid"].stringValue
    }
}


class NFTTransactionsListResp: MoralisResp{

    var result = [NFTTransactionsModel]()

    override init(_ json: JSON) {
        super.init(json)
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = NFTTransactionsModel(fromJson: resultJson)
            result.append(value)
        }
    }
}

struct NFTTransactionsModel{

    var hash = ""
    var nonce = ""
    var transaction_index = ""
    var from_address = ""
    var to_address = ""
    var value = ""
    var gas = ""
    var gas_price = ""
    var input = ""
    var receipt_cumulative_gas_used = ""
    var receipt_gas_used = ""
    var receipt_contract_address: String?
    var receipt_root: String?
    var receipt_status = ""
    var block_timestamp = ""
    var block_number = ""
    var block_hash = ""
    
    init(fromJson json: JSON){
        if json.isEmpty{
            return
        }
        hash = json["hash"].stringValue
        nonce = json["nonce"].stringValue
        transaction_index = json["transaction_index"].stringValue
        from_address = json["from_address"].stringValue
        to_address = json["to_address"].stringValue
        value = json["value"].stringValue
        gas = json["gas"].stringValue
        gas_price = json["gas_price"].stringValue
        input = json["input"].stringValue
        receipt_cumulative_gas_used = json["receipt_cumulative_gas_used"].stringValue
        receipt_gas_used = json["receipt_gas_used"].stringValue
        receipt_contract_address = json["isError"].string
        receipt_root = json["nonce"].string
        receipt_status = json["receipt_status"].stringValue
        block_timestamp = json["block_timestamp"].stringValue
        block_number = json["block_number"].stringValue
        block_hash = json["block_hash"].stringValue
    }

}
