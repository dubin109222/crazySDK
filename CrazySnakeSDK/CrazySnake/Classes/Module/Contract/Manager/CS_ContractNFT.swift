//
//  CS_ContractNFT.swift
//  CrazySnake
//
//  Created by Lee on 30/05/2023.
//

import UIKit
import web3swift
import BigInt

class CS_ContractNFT: NSObject {

    
    static func encodeDataDeposit(token: String, ids: [Int]) -> String? {
        
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address, let address = EthereumAddress(walletAddress) else {
            return nil
        }
        
        guard let token = EthereumAddress(token) else {
            return nil
        }
        
        var paraList = [BigUInt]()
        for item in ids {
            let nftId = BigUInt(item)
            paraList.append(nftId)
        }
        
        let method = "depositBatchERC721"
        let para = [address,token,paraList] as [AnyObject]
        let function = ABI.Element.Function(
            name: method,
            inputs: [
                .init(name: "from", type: .address),
                .init(name: "token", type: .address),
                .init(name: "ids", type: .array(type: .uint(bits: 256), length: 0))],
            outputs: [],
            constant: false,
            payable: false)
        let object = ABI.Element.function(function)

        guard let funcHash = object.encodeParameters(para)?.ls_hexString.ls_addHexPrefix() else {
            return nil
        }
        return funcHash
    }
    
    static func estimateApprovePara(to: String) -> [String:Any]? {
        
        let method = "setApprovalForAll"
        let paras = [to,true] as [Any]
        
        let para = CS_ContractManager.getEstimateGasParas(contract: "SnakeNFT", method: method, paras: paras, otherParams: nil)
        
//        var para :[String:Any] = [:]
//        para["from"] = CS_AccountManager.shared.accountInfo?.wallet_address
//        para["contract"] = "SnakeNFT"
//        para["func"] = method
//        para["params"] = CS_ContractUtils.toJSONString(arrary: paras)
//        para["internal"] = "1"
        
        return para
    }
    
    static func approvePara(to: String) -> [String:Any] {
        
        let method = "setApprovalForAll"
        let paras = [to,true] as [Any]
        
        var para :[String:Any] = [:]
        para["contractName"] = "SnakeNFT"
        para["functionName"] = method
        para["params"] = CS_ContractUtils.toJSONString(arrary: paras)
        para["from"] = CS_AccountManager.shared.accountInfo?.wallet_address
        para["signatureType"] = "EIP712_SIGN"
//        para["otherParams"] = ""
        return para
    }
    
    static func depositPara(token: String, ids: [Int]) -> [String:Any]? {
        
        let contract = "NFTTransfer"
        let method = "depositBatchERC721"
        let paras = [CS_AccountManager.shared.accountInfo?.wallet_address ?? "",token,ids] as [Any]
        let para = CS_ContractManager.getEstimateGasParas(contract: contract, method: method, paras: paras, otherParams: nil,isInternal: true)
        return para
    }
    
    static func withdrawPara(token: String, ids: [Int]) -> [String:Any]? {
        
        let method = "withdrawBatchERC721"
        let paras = [CS_AccountManager.shared.accountInfo?.wallet_address ?? "",token,ids] as [Any]
        
        let para = CS_ContractManager.getEstimateGasParas(contract: "NFTTransfer", method: method, paras: paras, otherParams: nil,isInternal: true)
        return para
    }
    
}
