//
//  CS_ContractGame.swift
//  CrazySnake
//
//  Created by Lee on 19/05/2023.
//

import UIKit
import web3swift
import BigInt

class CS_ContractGame: NSObject {

    static let shared = CS_ContractGame()
    private override init() {
        super.init()
//        loadABI()
    }
    
    private var contractABI: String?
    
    
    func loadABI(){
        CSNetworkManager.shared.getContractABI("TwoCrazySnake") { resp in
            if resp.status == .success {
                self.contractABI = resp.data
            }
        }
    }
    
    func encodeDataBet(roundId: Int, postion: Int,amount: String) -> String? {
        
        guard let amountWei = Web3.Utils.parseToBigUInt(amount, units: .eth) else {
            return nil
        }
        let round = BigUInt(roundId)
        let pos = BigUInt(postion)
        let para = [round,pos, amountWei] as [AnyObject]
        let method = "bet"
        let function = ABI.Element.Function(
            name: method,
            inputs: [
                .init(name: "_roundId", type: .uint(bits: 256)),
                .init(name: "_pos", type: .uint(bits: 8)),
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
    
    func bet(roundId: Int, postion: Int,amount: String, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.game_fight.first else { return }
        
        let contract = contractModel.contract_address
        let contractName = contractModel.contract_name
        let apiId = "bet"
//        let otherParams = ["type": "71",
//                           "id": roundId,
//                           "amount": amount,
//                           "position": postion] as [String : Any]
        DispatchQueue.global().async {

            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: nil,response: response)
        }
    }
    
    func encodeDataClaim(idList: [Int]) -> String? {
        
        var paraList = [BigUInt]()
        for item in idList {
            let nftId = BigUInt(item)
            paraList.append(nftId)
        }
        let para = [paraList] as [AnyObject]
        let method = "claim"
        let function = ABI.Element.Function(
            name: method,
            inputs: [
                .init(name: "_roundIds", type: .array(type: .uint(bits: 256), length: 0))],
            outputs: [],
            constant: false,
            payable: false)
        let object = ABI.Element.function(function)

        guard let funcHash = object.encodeParameters(para)?.ls_hexString.ls_addHexPrefix() else {
            return nil
        }
        return funcHash
    }
    
    static func getEstimateClaim(idList: [Int]) -> [String:Any]? {
        
        let paras = [idList] as [Any]
        let contract = "TwoCrazySnake"
        let method = "claim"
        let para = CS_ContractManager.getEstimateGasParas(contract: contract, method: method, paras: paras, otherParams: nil)
        return para
    }
    
    func claim(funcHash: String, response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.game_fight.first else { return }
    
        let contract = contractModel.contract_address
        let contractName = contractModel.contract_name
        let apiId = "claim"
//        let otherParams = ["type": "72"] as [String : Any]
        DispatchQueue.global().async {

            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: nil,response: response)
        }
    }
}

