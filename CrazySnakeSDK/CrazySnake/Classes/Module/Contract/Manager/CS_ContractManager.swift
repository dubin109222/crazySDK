//
//  CS_ContractManager.swift
//  CrazySnake
//
//  Created by Lee on 13/07/2023.
//

import UIKit
import web3swift
import BigInt

class CS_ContractManager: NSObject {
    
    static func getEstimateGasParas(contract: String, method: String, paras: [Any]?, otherParams: [String:Any]?, isInternal: Bool = false) -> [String:Any]? {
        
        var para :[String:Any] = [:]
        para["from"] = CS_AccountManager.shared.accountInfo?.wallet_address
        para["contract"] = contract
        para["func"] = method
        if let paras = paras {
            para["params"] = CS_ContractUtils.toJSONString(arrary: paras)
        }
        if let otherParams = otherParams {
            para["other_params"] = CS_ContractUtils.toJSONString(dict: otherParams)
        }
        if isInternal {
            para["internal"] = "1"
        }
        return para
    }
    
    static func getFreeGasParas(contract: String, method: String, paras: [Any]?, otherParams: [String:Any]?, needPwd: Bool = false) -> [String:Any]? {
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return nil }
        
        var para :[String:Any] = [:]
        para["nonce"] = nonce
        para["sign"] = sign
        para["from"] = CS_AccountManager.shared.accountInfo?.wallet_address
        para["contractName"] = contract
        para["signatureType"] = "EIP712_SIGN"
        para["functionName"] = method
        if let paras = paras {
            para["params"] = CS_ContractUtils.toJSONString(arrary: paras)
        }
        if let otherParams = otherParams {
            para["otherParams"] = CS_ContractUtils.toJSONString(dict: otherParams)
        }
        if needPwd {
            para["pay_password"] = CS_AccountManager.shared.accountInfo?.password
        }
        return para
    }
    
    static func estimateApprovePara(to: String) -> [String:Any]? {
        
        let method = "setApprovalForAll"
        let paras = [to,true] as [Any]
        
        var para :[String:Any] = [:]
        para["from"] = CS_AccountManager.shared.accountInfo?.wallet_address
        para["contract"] = "SnakeNFT"
        para["func"] = method
        para["params"] = CS_ContractUtils.toJSONString(arrary: paras)
//        para["internal"] = "1"
        
        return para
    }
}

