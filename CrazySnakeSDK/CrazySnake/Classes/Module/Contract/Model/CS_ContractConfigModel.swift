//
//  CS_ContractConfigModel.swift
//  CrazySnake
//
//  Created by Lee on 20/03/2023.
//

import UIKit
import SwiftyJSON

class CS_ContractABIResp: RespModel {
    
    var data: String?
    
    override init(_ dic: JSON){
        super.init(dic)
        self.data = dic["data"].rawString()
    }
    
}

class CS_ContractGasPriceResp: RespModel {
    
    var data: CS_ContractGasPriceDataModel?
    
    override init(_ dic: JSON){
        super.init(dic)
        self.data = CS_ContractGasPriceDataModel(dic["data"])
    }
    
}

struct CS_ContractGasPriceDataModel {
    
    var safeLow: CS_ContractGasPriceModel?
    var standard: CS_ContractGasPriceModel?
    var fast: CS_ContractGasPriceModel?
    
    var estimatedBaseFee = ""
    var maxFee = ""
    var blockTime = 0
    var blockNumber = 0
    
    init(_ dic: JSON){
        self.safeLow = CS_ContractGasPriceModel(dic["safeLow"])
        self.standard = CS_ContractGasPriceModel(dic["standard"])
        self.fast = CS_ContractGasPriceModel(dic["fast"])
        estimatedBaseFee = dic["estimatedBaseFee"].stringValue
        blockTime = dic["blockTime"].intValue
        blockNumber = dic["blockNumber"].intValue
    }
}

struct CS_ContractGasPriceModel {
    
    var maxPriorityFee = ""
    var maxFee = ""
    init(_ dic: JSON){
        maxPriorityFee = dic["maxPriorityFee"].stringValue
        maxFee = dic["maxFee"].stringValue
    }
}

