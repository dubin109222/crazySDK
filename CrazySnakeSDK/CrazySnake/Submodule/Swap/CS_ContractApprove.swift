//
//  CS_ContractApprove.swift
//  CrazySnake
//
//  Created by Lee on 20/03/2023.
//

import UIKit
import web3swift
import BigInt

class CS_ContractApprove: NSObject {
        
    static func snakeTokenIsApproved(to: String?, response: @escaping((Bool) -> ())){
        DispatchQueue.global().async {
            guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
                approvedResponse(false, response)
                return
            }
            let approvedAmount = _snakeIsApproved(address, to: to)
            var isApproved = true
            if approvedAmount < 10000000 {
                isApproved = false
            }
            approvedResponse(isApproved, response)
        }
    }
    
    static func usdtTokenIsApproved(to: String?, response: @escaping((Bool) -> ())){
        DispatchQueue.global().async {
            guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
                approvedResponse(false, response)
                return
            }
            let approvedAmount = _usdtIsApproved(address, to: to)
            var isApproved = true
            if approvedAmount < 10000000 {
                isApproved = false
            }
            approvedResponse(isApproved, response)
        }
    }

    static func nftIsApproved(to: String?, response: @escaping((Bool) -> ())){
        DispatchQueue.global().async {
            guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
                approvedResponse(false, response)
                return
            }
            let isApproved = _isApprovedNFT(address, to: to)
            approvedResponse(isApproved, response)
        }
    }
    
}

//MARK: approve
extension CS_ContractApprove {
    
    
    static func estimateTokenApprovePara(to: String) -> [String:Any]? {
        
        let method = "approve"
        let paras = [to,"\(10000000000000)"] as [Any]
        let para = CS_ContractManager.getEstimateGasParas(contract: "USDT", method: method, paras: paras, otherParams: nil)

//        let para = CS_ContractManager.getEstimateGasParas(contract: "SnakeToken", method: method, paras: paras, otherParams: nil)
        return para
    }
    
    static func encodeDataTokenApprove(to: String) -> String? {
        let method = "approve"
        guard let to = EthereumAddress(to) else { return nil }
        
        guard let amountWei = Web3.Utils.parseToBigUInt("\(10000000000000)", units: .eth) else {
            return nil
        }
        let para = [to,amountWei] as [AnyObject]
        let function = ABI.Element.Function(
            name: method,
            inputs: [
                .init(name: "spender", type: .address),
                .init(name: "amount", type: .uint(bits: 256))],
            outputs: [.init(name: "", type: .bool)],
            constant: false,
            payable: false)
        let object = ABI.Element.function(function)

        let funcHash = object.encodeParameters(para)?.ls_hexString.ls_addHexPrefix()
        return funcHash
    }
    
    static func approveSnake(to: String, funcHash: String,response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.current_token.first else { return }
        let contract = contractModel.contract_address
        let contractName = contractModel.contract_name
        let apiId = "approve"
        DispatchQueue.global().async {
            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: address, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: nil,response: response)
        }
    }
    
    static func approveUSDT(to: String, funcHash: String,response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.usdt_token else { return }
        
        let contract = contractModel.contract_address
        let contractName = contractModel.contract_name
        let apiId = "approve"
        DispatchQueue.global().async {
            CS_ContractUSDTGasUtils.freeGas(privateKey: privateKey, address: address, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: nil,response: response)
        }
    }
    
    static func encodeDataNFTApprove(to: String) -> String? {
        let method = "setApprovalForAll"
        guard let to = EthereumAddress(to) else { return nil }
        
        
        let para = [to,true] as [AnyObject]
        let function = ABI.Element.Function(
            name: method,
            inputs: [
                .init(name: "operator", type: .address),
                .init(name: "approved", type: .bool)],
            outputs: [],
            constant: false,
            payable: false)
        let object = ABI.Element.function(function)

        let funcHash = object.encodeParameters(para)?.ls_hexString.ls_addHexPrefix()
        return funcHash
    }
    
    static func approveNFT(to: String, funcHash: String,response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.nft.first else { return }
        
        let contract = contractModel.contract_address
        let contractName = contractModel.contract_name
        let apiId = "setApprovalForAll"
        DispatchQueue.global().async {
            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: address, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: nil,response: response)
        }
    }
}


//MARK: isApproved
fileprivate extension CS_ContractApprove {
    static func _snakeIsApproved(_ address: String , to: String?) -> Double {
        guard let walletAddress = EthereumAddress(address) else {
            return 0
        }
        
        guard let to = to,let toContract = EthereumAddress(to) else {
            return 0
        }
        
        guard let web3Item = CSUtils.defalutWeb3() else {
            return 0
        }
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.current_token.first else { return 0 }
        
        
        guard let erc20ContractAddress = EthereumAddress(contractModel.contract_address) else {
            return 0
        }
        
        guard let contract = web3Item.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2) else {
            return 0
        }
        
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let method = "allowance"
        guard let tx = contract.write(
            method,
            parameters: [walletAddress, toContract] as [AnyObject],
            extraData: Data(),
            transactionOptions: options) else {
            return 0
        }
        
        do {
            let result = try tx.call()
            guard let approvedAmount = result["0"] as? BigUInt  else {
                return 0
            }
            
            guard let balanceString = Web3.Utils.formatToEthereumUnits(approvedAmount, toUnits: .eth, decimals: 8) else {
                return 0
            }
            return Double(balanceString) ?? 0
        } catch {
            LSLog(error)
            return 0
        }
    }
    
    static func _usdtIsApproved(_ address: String , to: String?) -> Double {
        guard let walletAddress = EthereumAddress(address) else {
            return 0
        }
        
        guard let to = to,let toContract = EthereumAddress(to) else {
            return 0
        }
        
        guard let web3Item = CSUtils.defalutWeb3() else {
            return 0
        }
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.usdt_token else { return 0 }
        
        guard let erc20ContractAddress = EthereumAddress(contractModel.contract_address) else {
            return 0
        }
        
        guard let contract = web3Item.contract(Web3.Utils.erc20ABI, at: erc20ContractAddress, abiVersion: 2) else {
            return 0
        }
        
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let method = "allowance"
        guard let tx = contract.write(
            method,
            parameters: [walletAddress, toContract] as [AnyObject],
            extraData: Data(),
            transactionOptions: options) else {
            return 0
        }
        
        do {
            let result = try tx.call()
            guard let approvedAmount = result["0"] as? BigUInt  else {
                return 0
            }
            
            guard let balanceString = Web3.Utils.formatToEthereumUnits(approvedAmount, toUnits: .eth, decimals: 8) else {
                return 0
            }
            return Double(balanceString) ?? 0
        } catch {
            LSLog(error)
            return 0
        }
    }
    
    static func _isApprovedNFT(_ address: String , to: String?) -> Bool {
        guard let walletAddress = EthereumAddress(address) else {
            return false
        }
        guard let to = to,let toContract = EthereumAddress(to) else {
            return false
        }
        guard let web3Item = CSUtils.defalutWeb3() else {
            return false
        }
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.nft.first else { return false }
        
        guard let erc20ContractAddress = EthereumAddress(contractModel.contract_address) else {
            return false
        }
        
//        guard let contract = web3Item.contract(CSContractUtils.SnakeNFT, at: erc20ContractAddress, abiVersion: 2) else {
//            return false
//        }
        guard let contract = web3Item.contract(Web3.Utils.erc721ABI, at: erc20ContractAddress, abiVersion: 2) else {
            return false
        }
        
        var options = TransactionOptions.defaultOptions
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let method = "isApprovedForAll"
        guard let tx = contract.write(
            method,
            parameters: [walletAddress, toContract] as [AnyObject],
            extraData: Data(),
            transactionOptions: options) else {
            return false
            }

        do {
            let result = try tx.call()
            guard let isApproved = result["0"] as? Bool  else {
                return false
                }
            return isApproved
        } catch {
            LSLog(error)
            return false
        }
    }
}


//MARK: inner
extension CS_ContractApprove {
    static func approvedResponse(_ isApproved:Bool, _ response: @escaping((Bool) -> ())) {
        DispatchQueue.main.async {
            response(isApproved)
        }
    }
}

