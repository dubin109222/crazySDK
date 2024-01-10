//
//  CS_ContractUtils.swift
//  CrazySnake
//
//  Created by Lee on 20/03/2023.
//

import UIKit
import web3swift
import BigInt

class CS_ContractUtils: NSObject {
    
    static func contractWirte(privateKey: String, address: String,method: String, contractJson: String, contractAddress: String? , parameters: [AnyObject] = [AnyObject](),response: @escaping((CSResultRespon) -> ())){
        
        guard let web3 = CSUtils.walletWeb3(privateKey) else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        guard let contractAddress = contractAddress, let contractEAddress = EthereumAddress(contractAddress) else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        guard let contract = web3.contract(contractJson, at:contractEAddress, abiVersion: 2) else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        
        CSNetworkManager.shared.getContractGasPrice { resp in
            DispatchQueue.global().async {
                guard let fast = resp.data?.fast else {
                    CSUtils.contractResponse(.invalidFormat, response)
                    return
                }
                guard let (maxLimit, maxFee,maxPriorityFee) = estimateWriteGas(walletAddress, web3Item: web3, contract: contract, method: method, parameters: parameters,maxFee: fast.maxFee, maxPriorityFee: fast.maxPriorityFee) else {
                    CSUtils.contractResponse(.unknwon, response)
                    return
                }
                
                var options = TransactionOptions.defaultOptions
                options.gasLimit = .manual(maxLimit)
                options.type = .eip1559
                options.maxFeePerGas = .manual(maxFee)
                options.maxPriorityFeePerGas = .manual(maxPriorityFee)
                options.from = walletAddress
                guard let tx = contract.write(
                    method,
                    parameters: parameters,
                    extraData: Data(),
                    transactionOptions: options) else {
                    CSUtils.contractResponse(.invalidFormat, response)
                    return
                }
                
                do {
                    let result = try tx.send()
                    let para = ["txHash":result.hash]
                    CSUtils.contractResponse(.success, content: para, response)
                    
                } catch {
                    LSLog(error)
                    let e = error as? web3swift.Web3Error
                    CSUtils.contractResponse(-3, message: e?.errorDescription, content: nil, response)
                }
            }
        }
    }
}

// MARK: inner
extension CS_ContractUtils {
    static func estimateWriteGas(_ walletAddress: EthereumAddress, web3Item: web3,  contract: web3.web3contract, method: String, parameters: [AnyObject] = [AnyObject](), maxFee: String, maxPriorityFee: String) -> (BigUInt, BigUInt, BigUInt)? {
        var options = CSUtils.defaultOptions()
        options.from = walletAddress
        guard let tx = contract.write(
            method,
            parameters: parameters,
            extraData: Data(),
            transactionOptions: options) else {
                return nil
            }
        
        do {
            
            let gas = try tx.estimateGas()
            
            guard let gasLimit = Web3.Utils.formatToEthereumUnits(gas, toUnits: .wei, decimals: 0)  else {
                return nil
            }
            
            guard let maxFeeWei = Web3.Utils.parseToBigUInt(maxFee, units: .eth) else {
                return nil
            }
            
//            let maxFeeWei = try CSUtils.getPriceWei(price: "\(maxFee)")
//            let maxFeeWei22 = try Web3Utils.formatToEthereumUnits(maxFeeWei, toUnits: .wei)
            let maxPriorityFeeWei = try CSUtils.getPriceWei(price: "\(maxPriorityFee)")
            let maxLimit = "\(Int((Double(gasLimit) ?? 0)*1.5))"
            guard let maxBig = BigUInt(maxLimit) else { return nil }
            return (maxBig, maxFeeWei, maxPriorityFeeWei)
            
        } catch  {
            LSLog(error)
            return nil
        }
        
    }
    
    private static func _estimateWriteGas(_ walletAddress: EthereumAddress, web3Item: web3,  contract: web3.web3contract, method: String, parameters: [AnyObject] = [AnyObject]()) -> (BigUInt, BigUInt)? {
        var options = CSUtils.defaultOptions()
        options.from = walletAddress
        guard let tx = contract.write(
            method,
            parameters: parameters,
            extraData: Data(),
            transactionOptions: options) else {
                return nil
            }
        
        do {
            
            let gas = try tx.estimateGas()
            
            guard let gasLimit = Web3.Utils.formatToEthereumUnits(gas, toUnits: .wei, decimals: 0)  else {
                return nil
            }
            
            let gasBig = try web3Item.eth.getGasPrice()
            guard let gasPrice = Web3.Utils.formatToEthereumUnits(gasBig, toUnits: .wei, decimals: 0)  else {
                return nil
            }
            let maxLimit = "\(Int((Double(gasLimit) ?? 0)*1.5))"
            guard let maxBig = BigUInt(maxLimit) else { return nil }
            guard let priceBig = BigUInt(gasPrice) else { return nil }
            return (maxBig, priceBig)
            
        } catch  {
            LSLog(error)
            return nil
        }
        
    }
}

//MARK: jsonstring
extension CS_ContractUtils {
    
    static func toJSONString(arrary:[Any]?)->String{
        
        if let arrary = arrary {
            guard let data = try? JSONSerialization.data(withJSONObject: arrary) else {
                return ""
            }
            
            guard let strJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                return ""
            }
            
            return strJson as String
        }else{
            return ""
        }
    }
    
    static func toJSONString(dict:Dictionary<String, Any>?)->String{
        
        if let dict = dict {
            guard let data = try? JSONSerialization.data(withJSONObject: dict) else {
                return ""
            }
            
            guard let strJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                return ""
            }
            
            return strJson as String
        }else{
            return ""
        }
    }
}

