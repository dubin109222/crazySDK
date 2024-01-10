//
//  CS_ContractTokenStake.swift
//  CrazySnake
//
//  Created by Lee on 20/03/2023.
//

import UIKit
import web3swift
import BigInt

class CS_ContractTokenStake: NSObject {

    static let shared = CS_ContractTokenStake()
    private override init() {
        super.init()
        loadABI()
    }
    
    private var contractABI: String?
    
    
    func loadABI(){
        CSNetworkManager.shared.getContractABI("TokenStake") { resp in
            if resp.status == .success {
                self.contractABI = resp.data
            }
        }
    }
    
    
    
    static func estimateGasStakeToken(amount: String,duraion: Int) -> [String:Any]? {
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.token_stake else {
            return nil
        }
        
        let contact = contractModel.contract_name
        let method = "stake"
        guard let token = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address else {
            return nil
        }
        guard let amountWei = try? EthUnitManager.getWeiBigStringFrom(ethString: amount) else {
            return nil
        }
        let paras = [token, amountWei] as [Any]
        let other_params = ["amount": amount,"duraion":duraion] as [String : Any]
        let para = CS_ContractManager.getEstimateGasParas(contract: contact, method: method, paras: paras, otherParams: other_params)
        return para
    }
    
    static func estimateGetGasStakeToken(amount: String) -> [String:Any]? {
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.token_stake else {
            return nil
        }
        
        let contact = contractModel.contract_name
        let method = "stake"
        guard let token = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address else {
            return nil
        }
        guard let amountWei = try? EthUnitManager.getWeiBigStringFrom(ethString: amount) else {
            return nil
        }
        let otherParams = ["amount": amount] as [String : Any]

        let paras = [token, amountWei] as [Any]
        let para = CS_ContractManager.getEstimateGasParas(contract: contact, method: method, paras: paras, otherParams: otherParams)
        return para
    }

    
    
    
    func stakeToken(amount: String, period: Int) -> [String:Any]? {
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.current_token.first else {
            return nil
        }
        let contact = contractModel.contract_name
        let method = "stake"
        let token = contractModel.contract_address
        guard let amountWei = try? EthUnitManager.getWeiBigStringFrom(ethString: amount) else {
            return nil
        }
        let paras = [token, amountWei] as [Any]
        let otherParams = ["duration": period,
                           "token_address": token] as [String : Any]
        let para = CS_ContractManager.getFreeGasParas(contract: contact, method: method, paras: paras, otherParams: otherParams)
        return para
    }
    
    func encodeDataStake(amount: String, period: Int) -> String? {
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.current_token.first else {
            return nil
        }
        guard let address = EthereumAddress(contractModel.contract_address) else {
            return nil
        }
        
        guard let amountWei = Web3.Utils.parseToBigUInt(amount, units: .eth) else {
            return nil
        }
//        let pid = BigUInt(period)
        let para = [address, amountWei] as [AnyObject]
        let method = "stake"
        let function = ABI.Element.Function(
            name: method,
            inputs: [
                .init(name: "_token", type: .address),
                .init(name: "_amount", type: .uint(bits: 256))],
            outputs: [],
            constant: false,
            payable: false)
        let object = ABI.Element.function(function)

        guard let funcHash = object.encodeParameters(para)?.ls_hexString.ls_addHexPrefix() else {
            return nil
        }
        return funcHash
    }
    
    func tokenStake(amount: String, period: Int, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let tokenModel = CS_AccountManager.shared.basicConfig?.contract?.current_token.first else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        let token = tokenModel.contract_address

        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.token_stake else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        let contract = contractModel.contract_address
        let contractName = contractModel.contract_name
        let apiId = "stake"
        let otherParams = ["duration": period,
                           "token_address": token] as [String : Any]
        DispatchQueue.global().async {

            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: otherParams,response: response)
        }
    }
    
    func encodeDataUnstake(amount: String) -> String? {
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.current_token.first else {
            return nil
        }
        let token = contractModel.contract_address
        guard let address = EthereumAddress(token) else {
            return nil
        }
        
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address,let walletAddressEth = EthereumAddress(walletAddress) else {
            return nil
        }
        
        guard let amountWei = Web3.Utils.parseToBigUInt(amount, units: .eth) else {
            return nil
        }
//        let pid = BigUInt(period)
        let para = [walletAddressEth,address, amountWei,BigUInt(0)] as [AnyObject]
        let method = "unstake"
        let function = ABI.Element.Function(
            name: method,
            inputs: [
                .init(name: "_user", type: .address),
                .init(name: "_token", type: .address),
                .init(name: "_principal", type: .uint(bits: 256)),
                .init(name: "_interest", type: .uint(bits: 256))],
            outputs: [],
            constant: false,
            payable: false)
        let object = ABI.Element.function(function)

        guard let funcHash = object.encodeParameters(para)?.ls_hexString.ls_addHexPrefix() else {
            return nil
        }
        return funcHash
    }
    
    func tokenUnstake(funcHash: String, response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        guard let tokenModel = CS_AccountManager.shared.basicConfig?.contract?.current_token.first else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        let token = tokenModel.contract_address
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.token_stake else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        let contract = contractModel.contract_address
        let contractName = contractModel.contract_name
        let apiId = "unstake"
        let otherParams = ["type": "33",
                           "tokenAddress": token] as [String : Any]
        DispatchQueue.global().async {

            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: otherParams,response: response)
        }
    }
}
