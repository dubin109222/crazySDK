//
//  CS_ContractGasUtils.swift
//  CrazySnake
//
//  Created by Lee on 20/03/2023.
//

import UIKit
import web3swift
import BigInt

class CS_ContractGasUtils: NSObject {
    
    static let biconomyForwarderAbi = "[\n    {\n      \"inputs\": [\n        {\n            \"internalType\": \"address\",\n            \"name\": \"from\",\n            \"type\": \"address\"\n        },\n        {\n            \"internalType\": \"uint256\",\n            \"name\": \"batchId\",\n            \"type\": \"uint256\"\n        },\n      ],\n      \"name\": \"getNonce\",\n      \"outputs\": [\n          {\n              \"internalType\": \"uint256\",\n              \"name\": \"\",\n              \"type\": \"uint256\"\n          }\n      ],\n      \"stateMutability\": \"view\",\n      \"type\": \"function\",\n    }\n]\n"


    static let ZERO_ADDRESS = "0x0000000000000000000000000000000000000000"
    
    static let domainType = [
        [ "name": "name", "type": "string" ],
        [ "name": "version", "type": "string" ],
        [ "name": "verifyingContract", "type": "address" ],
        [ "name": "salt", "type": "bytes32" ],
    ];

    static let forwardRequestType = [
        [ "name": "from", "type": "address" ],
        [ "name": "to", "type": "address" ],
        [ "name": "token", "type": "address" ],
        [ "name": "txGas", "type": "uint256" ],
        [ "name": "tokenGasPrice", "type": "uint256" ],
        [ "name": "batchId", "type": "uint256" ],
        [ "name": "batchNonce", "type": "uint256" ],
        [ "name": "deadline", "type": "uint256" ],
        [ "name": "data", "type": "bytes" ],
    ];
    
    static func freeGas(privateKey: String , address: String, apiId: String, functionSignature: String, contractAddress: String?,contractName: String,otherParams: [String:Any]?, response: @escaping((CSResultRespon) -> ())){
        guard let contractAddress = contractAddress else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let forwarderAddress = CS_AccountManager.shared.basicConfig?.contract?.forward?.contract_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        let chainId = Config.chain.chainId()
        let deadline = Int(Date().timeIntervalSince1970) + 3600
        guard let nonce =  getNonce(address: address) else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let nonceStr = Web3.Utils.formatToEthereumUnits(nonce, toUnits: .wei, decimals: 0) else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let domainData = buildDomainData(chainId: chainId, forwarderAddress: forwarderAddress) else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        guard let domainSeparator = buildDomainSeparator(chainId: chainId, forwarderAddress: forwarderAddress) else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        CSSDKManager.shared.deadline = deadline
        let requestPara = [
            "from": address,
            "to": contractAddress,
            "token": ZERO_ADDRESS,
            "txGas": 5000000,
            "tokenGasPrice": "0",
            "batchId": 0,
            "batchNonce": Int(nonceStr) ?? 0,
            "deadline": deadline,
            "data": functionSignature
        ] as [String : Any]
                
        let requestParaSign = [
            "from": address,
            "to": contractAddress,
            "token": ZERO_ADDRESS,
            "txGas": 5000000,
            "tokenGasPrice": 0,
            "batchId": 0,
            "batchNonce": Int(nonceStr) ?? 0,
            "deadline": deadline,
            "data": functionSignature
        ] as [String : Any]

        let dataToSign = [
            "types": [
                "EIP712Domain": domainType,
                "ERC20ForwardRequest": forwardRequestType,
            ],
            "domain": domainData,
            "primaryType": "ERC20ForwardRequest",
            "message": requestParaSign,
        ] as [String : Any]
        let signPrefixed = sign(privateKey: privateKey, dataToSign: dataToSign)

        let params = [requestPara, domainSeparator , signPrefixed ?? ""] as [Any]
        
        var para :[String:Any] = [:]
        para["from"] = address
        para["contractName"] = contractName
        para["functionName"] = apiId
        para["params"] = params
        para["signatureType"] = "EIP712_SIGN"
        if let otherParams = otherParams {
            para["otherParams"] = otherParams
        }
        CSNetworkManager.shared.postFreeGasByName(para) { resp in
            if resp.status == .success {
                
                if let tx_hash = resp.data?.tx_hash {
                    let para = ["txHash":tx_hash]
                    CSUtils.contractResponse(.success, content: para, response)
                } else {
                    CSUtils.contractResponse(.gasLimitError, response)
                }
                
            } else {
                LSLog(resp.message)
                CSUtils.contractResponse(.httpError, response)
            }
        }
    }
    
    static func sign(privateKey: String, dataToSign: [String: Any]) -> String? {

        do {
   
            guard let dataToSignStr = String.ls_convertDictionaryToString(dict: dataToSign) else { return nil }

            let typedData = try JSONDecoder().decode(EIP712TypedData.self, from: Data(dataToSignStr.utf8))
            let result = try typedData.signableHash(version: EIP712TypedDataSignVersion.v3)
//            LSLog(dataToSignStr)
//            let res = result.ls_hexString
//            LSLog("dataEncoder:\(res)")
            guard let data = CSUtils.hexStringToPrivateKey(privateKey) else {
                return nil
            }
            let (signData, _) = SECP256K1.signForRecovery(hash: result,
                                                                             privateKey: data,
                                                                             useExtraEntropy: false)
            
            guard let signData = signData else {
                return nil
            }
            
            let signStr = signData.ls_hexString.ls_addHexPrefix()
//            LSLog("signPrefixed:\(signStr)")
            return signStr

        } catch  {
            LSLog(error)
            return nil
        }
        
    }
    
    static func getNonce(address: String) -> BigUInt? {
        guard let forwarderAddress = CS_AccountManager.shared.basicConfig?.contract?.forward?.contract_address else { return nil}
        guard let contractEAddress = EthereumAddress(forwarderAddress) else {
            
            return nil
        }
        guard let walletEAddress = EthereumAddress(address) else {
            
            return nil
        }
        guard let web3 = CSUtils.defalutWeb3() else { return  nil }
        guard let contract = web3.contract(biconomyForwarderAbi, at:contractEAddress, abiVersion: 2) else {
            return nil
        }
        
        let parameters = [walletEAddress, BigUInt.zero] as [AnyObject]
        let method = "getNonce"
        var options = CSUtils.defaultOptions()
        options.from = walletEAddress
        guard let tx = contract.write(
            method,
            parameters: parameters,
            extraData: Data(),
            transactionOptions: options) else {
                return nil
            }
        
        do {
            let result = try tx.call()
            if let item = result["0"] as? BigUInt {
                return item
            }
            return nil
        } catch  {
            LSLog(error)
            return nil
        }
    }
    
    static func defaultWeb3() -> web3? {
        var web3Item: web3?
    
//    https://hidden-icy-pond.matic.quiknode.pro/11189a53b4b29f5a5421f64637bc69a3319ed3b6/
        if let url = URL(string: "https://fastrpc.crazysnake.io/"), let provider = Web3HttpProvider(url) {
            web3Item = web3(provider: provider)
        }
        return web3Item
    }
}

extension CS_ContractGasUtils{
    
    static func buildDomainData(chainId: Int, forwarderAddress: String) -> [String: Any]? {
        let salt = "\(chainId)".ls_decimalToHex().ls_hexWithPrefixZeroPadded().ls_addHexPrefix()

        let domainData = [
            "name": "Biconomy Forwarder",
            "version": "1",
            "verifyingContract": forwarderAddress,
            "salt": salt
        ]

        return domainData
    }

    static func buildDomainSeparator(chainId: Int, forwarderAddress: String) -> String? {
        guard let domainData = buildDomainData(chainId: chainId, forwarderAddress: forwarderAddress) else {
            return nil
        }
        do {

            let EIP712Domain = try web3swift.ABIEncoder.soliditySha3("EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)").ls_hexString
            let name = try web3swift.ABIEncoder.soliditySha3(domainData["name"] ?? "").ls_hexString
            let version = try web3swift.ABIEncoder.soliditySha3(domainData["version"] ?? "").ls_hexString
            let eAddress = forwarderAddress.ls_stripHexPrefix().ls_hexWithPrefixZeroPadded()
            let soltData = "\(chainId)".ls_decimalToHex().ls_hexWithPrefixZeroPadded()

            let shaHex = "0x"+EIP712Domain+name+version+eAddress+soltData
            let shaData2 = try web3swift.ABIEncoder.soliditySha3(shaHex)
            let domainSeparator = "0x" + shaData2.ls_hexString
            return domainSeparator

        } catch  {
            LSLog(error)
            return nil
        }
    }
}

