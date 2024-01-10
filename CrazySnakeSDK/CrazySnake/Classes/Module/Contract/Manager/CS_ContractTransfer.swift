//
//  CS_ContractTransfer.swift
//  CrazySnake
//
//  Created by Lee on 21/03/2023.
//

import UIKit
import web3swift
import BigInt

class CS_ContractTransfer: NSObject {
    
    static func getEstimateTokenTransferPara(to: String,amount: String, notSnake:Bool = false) -> [String:Any]? {
        
        guard let amountWei = try? EthUnitManager.getWeiBigStringFrom(ethString: amount) else {
            return nil
        }
        let paras = [to, amountWei] as [Any]
        var contract = "SnakeToken"
        var method = "transfer"
        let other_params = ["amount": amount]
        let para = CS_ContractManager.getEstimateGasParas(contract: contract, method: method, paras: paras, otherParams: other_params)
        return para
    }
    
    static func getEstimateMarketBuyPara(to: String,amount: String,notSnake : Bool = false) -> [String:Any]? {
        
        guard let amountWei = try? EthUnitManager.getWeiBigStringFrom(ethString: amount) else {
            return nil
        }
        let paras = [to, amountWei] as [Any]
        var contract = "SnakeToken"
        var method = "transfer"
        let other_params = ["type":53,"amount": amount] as [String : Any]
        if notSnake {
            contract = ""
            method = ""
        }
        let para = CS_ContractManager.getEstimateGasParas(contract: contract, method: method, paras: paras, otherParams: other_params)
        return para
    }
    
    static func encodeDataTransferTokenSnake(to: String,amount: String) -> String? {
        
        guard let toAddress = EthereumAddress(to) else {
            return nil
        }
        
        guard let amountWei = Web3.Utils.parseToBigUInt(amount, units: .eth) else {
            return nil
        }
        let para = [toAddress, amountWei] as [AnyObject]
        let method = "transfer"
        let function = ABI.Element.Function(
            name: method,
            inputs: [
                .init(name: "_to", type: .address),
                .init(name: "_value", type: .uint(bits: 256))],
            outputs: [.init(name: "success", type: .bool)],
            constant: false,
            payable: false)
        let object = ABI.Element.function(function)

        guard let funcHash = object.encodeParameters(para)?.ls_hexString.ls_addHexPrefix() else {
            return nil
        }
        return funcHash
    }
    
    static func transferSnakeToken(to: String,amount: String, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.current_token.first else { return }
        
        let contract = contractModel.contract_address
        let contractName = contractModel.contract_name
        let apiId = "transfer"
        let otherParams = ["amount":amount]
        DispatchQueue.global().async {

            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: otherParams,response: response)
        }
    }

}

//MARK: usdt
extension CS_ContractTransfer {
    
    static func encodeDataTransferTokenUSDT(to: String,amount: String) -> String? {
        
        guard let toAddress = EthereumAddress(to) else {
            return nil
        }
        
        guard let amountWei = Web3.Utils.parseToBigUInt(amount, units: .Mwei) else {
            return nil
        }
        let para = [toAddress, amountWei] as [AnyObject]
        let method = "transfer"
        let function = ABI.Element.Function(
            name: method,
            inputs: [
                .init(name: "recipient", type: .address),
                .init(name: "amount", type: .uint(bits: 256))],
            outputs: [.init(name: "success", type: .bool)],
            constant: false,
            payable: false)
        let object = ABI.Element.function(function)

        guard let funcHash = object.encodeParameters(para)?.ls_hexString.ls_addHexPrefix() else {
            return nil
        }
        return funcHash
    }
    
    static func transferUSDTToken(to: String,amount: String, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.usdt_token else { return }
        
        let contract = contractModel.contract_address
        let contractName = contractModel.contract_name
        let apiId = "transfer"
        DispatchQueue.global().async {

            CS_ContractUSDTGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: nil,response: response)
        }
    }

}

