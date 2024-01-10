//
//  CS_PlatformAsyncUtils.swift
//  CrazySnake
//
//  Created by Lee on 10/05/2023.
//

import UIKit
import web3swift
//import WalletCore

class CS_PlatformAsyncUtils: NSObject {
    
    static func createWallet(_ response: @escaping((CrazyBaseResponse) -> ())){
        
        let mnemonic = Mnemonic.create()
        let seed = Mnemonic.createSeed(mnemonic:mnemonic)
        let wAccount = Wallet(seed: seed, coin: .ethereum).generateAccount()
        
        let account = AccountModel()
        account.mnemonic_word = mnemonic
        account.private_key = wAccount.rawPrivateKey
        account.wallet_address = wAccount.address
        LSHUD.hide()
        account.save()
        CS_AccountManager.shared.accountInfo = account
        
        
        UserDefaults.standard.setValue(account.id, forKey: CacheKey.lastSelectedAccountId)
        CrazyBaseResponse.response(200, message: "ok", content: wAccount.address, response)
    }
    
    static func launcher(_ response: @escaping((CrazyBaseResponse) -> ())){
        if let address =  CS_AccountManager.shared.accountInfo?.wallet_address {
            CrazyBaseResponse.response(200, message: "ok", content: address, response)
        } else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
        }
    }
    
    static func swapGasCoin(para: [String: Any]? = nil, _ response: @escaping((CrazyBaseResponse) -> ())){
        debugPrint("swapGasCoin start...")
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            return
        }
        guard let to = CS_AccountManager.shared.basicConfig?.contract?.cash_box?.contract_address else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            return
        }
        
        guard let amount = para?["request"] as? String else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            return
        }
        
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            return
        }

        let funcHash = CS_ContractTransfer.encodeDataTransferTokenSnake(to: to, amount: amount) ?? ""

        
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            return
        }
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.current_token.first else { return }
        
        let contractAddress = contractModel.contract_address
        
        let contractName = contractModel.contract_name
        let apiId = "transfer"
        let otherParams = ["type": "1",
                           "amount": amount,
                           "gas_coin": ""]

        guard let forwarderAddress = CS_AccountManager.shared.basicConfig?.contract?.forward?.contract_address else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            return
        }
        
        let chainId = Config.chain.chainId()
        let deadline = Int(Date().timeIntervalSince1970) + 3600
        guard let nonce =  CS_ContractGasUtils.getNonce(address: address) else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            return
        }
        guard let nonceStr = Web3.Utils.formatToEthereumUnits(nonce, toUnits: .wei, decimals: 0) else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            return
        }
        guard let domainData = CS_ContractGasUtils.buildDomainData(chainId: chainId, forwarderAddress: forwarderAddress) else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            return
        }
        
        guard let domainSeparator = CS_ContractGasUtils.buildDomainSeparator(chainId: chainId, forwarderAddress: forwarderAddress) else {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            return
        }
        
        CSSDKManager.shared.deadline = deadline
        let requestPara = [
            "from": address,
            "to": contractAddress,
            "token": CS_ContractGasUtils.ZERO_ADDRESS,
            "txGas": 5000000,
            "tokenGasPrice": "0",
            "batchId": 0,
            "batchNonce": Int(nonceStr) ?? 0,
            "deadline": deadline,
            "data": funcHash
        ] as [String : Any]
                
        let requestParaSign = [
            "from": address,
            "to": contractAddress,
            "token": CS_ContractGasUtils.ZERO_ADDRESS,
            "txGas": 5000000,
            "tokenGasPrice": 0,
            "batchId": 0,
            "batchNonce": Int(nonceStr) ?? 0,
            "deadline": deadline,
            "data": funcHash
        ] as [String : Any]

        let dataToSign = [
            "types": [
                "EIP712Domain": CS_ContractGasUtils.domainType,
                "ERC20ForwardRequest": CS_ContractGasUtils.forwardRequestType,
            ],
            "domain": domainData,
            "primaryType": "ERC20ForwardRequest",
            "message": requestParaSign,
        ] as [String : Any]
        let signPrefixed = CS_ContractGasUtils.sign(privateKey: privateKey, dataToSign: dataToSign)

        let params = [requestPara, domainSeparator , signPrefixed ?? ""] as [Any]
        
        var para :[String:Any] = [:]
        para["from"] = address
        para["contractName"] = contractName
        para["functionName"] = apiId
        para["params"] = params
        para["signatureType"] = "EIP712_SIGN"
        para["otherParams"] = otherParams

        do {
            // 将字典转换为 JSON 数据
            let jsonData = try JSONSerialization.data(withJSONObject: para, options: [])
            // 将 JSON 数据转换为字符串
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                CrazyBaseResponse.response(200, message: "ok", content: jsonString, response)
            } else {
                CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
            }
        } catch {
            CrazyBaseResponse.response(998, message: "crazy_str_failed".ls_localized, response)
        }

    }
}
