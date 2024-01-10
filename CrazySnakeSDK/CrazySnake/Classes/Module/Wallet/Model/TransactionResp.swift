//
//  TransactionResp.swift
//  Platform
//
//  Created by Lee on 18/10/2021.
//  Copyright © 2021 ELFBOX. All rights reserved.
//

import UIKit
import web3swift

struct TransactionResp {

    var success: Bool = false
    var message: String?
    var hash: String?
    
    init(_ success: Bool, message: String?){
        self.success = success
        self.message = message
    }
    
    init(_ success: Bool, message: String?, hash: String?){
        self.success = success
        self.message = message
        self.hash = hash
    }
    
}

struct TransferListenResp {

    var success: Bool = false
    var list = [TransferResult]()
    
    init(_ success: Bool, list: [TransferResult]?){
        self.success = success
        if let list = list {
            self.list = list
        }
    }
    
}

struct TransferResult {
    var address: String?
    var tokenId: String?
    var hash: String?
    
    init() {
    }
    
    init(_ address: String?, tokenId: String?){
        self.address = address
        self.tokenId = tokenId
    }
    
    init(_ address: String?, tokenId: String?, hash: String?){
        self.address = address
        self.tokenId = tokenId
        self.hash = hash
    }
    
    static func praseListenResult(_ result: EventParserResultProtocol) -> TransferResult {
        var model = TransferResult()
        for item in result.decodedResult {
            if item.key == "to" {
                if let address = item.value as? EthereumAddress {
                    model.address = address.address
                }
            }
            
            if item.key == "tokenId" {
                model.tokenId = "\(item.value)"
            }
        }
        
        if let data = result.eventLog?.transactionHash{
            model.hash = "0x\(data.ls_hexEncodedString())"
        }
        
        return model
    }
}

struct EggPriceResp {

    var success: Bool = false
    var message: String?
    var price: String?
    
    init(_ success: Bool, message: String?){
        self.success = success
        self.message = message
    }
    
    init(_ success: Bool, message: String?, price: String?){
        self.success = success
        self.message = message
        self.price = price
    }
    
}
