//
//  CS_ContractUSDTGasUtils.swift
//  CrazySnake
//
//  Created by Lee on 27/03/2023.
//

import UIKit
import web3swift
import BigInt

class CS_ContractUSDTGasUtils: NSObject {

    static let ZERO_ADDRESS = "0x0000000000000000000000000000000000000000"
    
    static let domainType = [
        [ "name": "name", "type": "string" ],
        [ "name": "version", "type": "string" ],
        [ "name": "verifyingContract", "type": "address" ],
        [ "name": "salt", "type": "bytes32" ],
    ];

    static let metaTransactionType = [
        [ "name": "nonce", "type": "uint256" ],
        [ "name": "from", "type": "address" ],
        [ "name": "functionSignature", "type": "bytes" ]
    ];
    
    static func freeGas(privateKey: String , address: String, apiId: String, functionSignature: String, contractAddress: String?,contractName: String,otherParams: [String:Any]?, response: @escaping((CSResultRespon) -> ())){
        guard let contractAddress = contractAddress else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let forwarderAddress = CS_AccountManager.shared.basicConfig?.contract?.usdt_token?.contract_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        let chainId = Config.chain.chainId()
        let deadline = Int(Date().timeIntervalSince1970) + 3600
        guard let nonce =  getNonce(privateKey: privateKey,address: address) else {
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
        
        CSSDKManager.shared.deadline = deadline
        let requestPara = [
            "nonce": Int(nonceStr) ?? 0,
            "from": address,
            "functionSignature": functionSignature
        ] as [String : Any]
                
        let dataToSign = [
            "types": [
                "EIP712Domain": domainType,
                "MetaTransaction": metaTransactionType,
            ],
            "domain": domainData,
            "primaryType": "MetaTransaction",
            "message": requestPara,
        ] as [String : Any]
        guard let signature = sign(privateKey: privateKey, dataToSign: dataToSign) else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }

        let params = [address, functionSignature , signature.r.ls_hexString.ls_addHexPrefix(), signature.s.ls_hexString.ls_addHexPrefix(),signature.v] as [Any]
        
        var para :[String:Any] = [:]
        para["from"] = address
        para["contractName"] = contractName
        para["functionName"] = apiId
        para["params"] = params
//        para["gas_coin"] = gasPrice
        if let otherParams = otherParams {
//            para["other_params"] = otherParams
            para["otherParams"] = otherParams
        }
        CSNetworkManager.shared.postFreeGasByName(para) { resp in
            if resp.status == .success {
                
                if let tx_hash = resp.data?.tx_hash {
                    let resultPara = ["txHash":tx_hash]
                    CSUtils.contractResponse(.success, content: resultPara, response)
                } else {
                    CSUtils.contractResponse(.gasLimitError, response)
                }
                
            } else {
                LSLog(resp.message)
                CSUtils.contractResponse(.httpError, response)
            }
        }
    }
    
    static func sign(privateKey: String, dataToSign: [String: Any]) -> SECP256K1.UnmarshaledSignature? {

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
            
            let signature = SECP256K1.unmarshalSignature(signatureData: signData)
            
            return signature
//            let signStr = signData.ls_hexString.ls_addHexPrefix()
////            LSLog("signPrefixed:\(signStr)")
//            return signStr

        } catch  {
            LSLog(error)
            return nil
        }
        
    }
    
    static func getNonce(privateKey: String, address: String) -> BigUInt? {
        guard let web3 = CSUtils.walletWeb3(privateKey) else {
            return nil
        }
        guard let forwarderAddress = CS_AccountManager.shared.basicConfig?.contract?.usdt_token?.contract_address else { return nil}
        guard let contractEAddress = EthereumAddress(forwarderAddress) else {
            
            return nil
        }
        guard let walletEAddress = EthereumAddress(address) else {
            
            return nil
        }
//        guard let web3 = defaultWeb3() else { return  nil }
        guard let contract = web3.contract(biconomyForwarderAbi, at:contractEAddress, abiVersion: 2) else {
            return nil
        }
        
        let parameters = [walletEAddress] as [AnyObject]
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
        if let url = URL(string: "https://hidden-icy-pond.matic.quiknode.pro/11189a53b4b29f5a5421f64637bc69a3319ed3b6/"), let provider = Web3HttpProvider(url) {
            web3Item = web3(provider: provider)
        }
        return web3Item
    }
}

extension CS_ContractUSDTGasUtils{
    
    static func buildDomainData(chainId: Int, forwarderAddress: String) -> [String: Any]? {
        let salt = "\(chainId)".ls_decimalToHex().ls_hexWithPrefixZeroPadded().ls_addHexPrefix()

        let domainData = [
            "name": "(PoS) Tether USD",
            "version": "1",
            "verifyingContract": forwarderAddress,
            "salt": salt
        ]

        return domainData
    }
}

fileprivate let biconomyForwarderAbi = "[\n    {\n      \"inputs\": [],\n      \"stateMutability\": \"nonpayable\",\n      \"type\": \"constructor\"\n    },\n    {\n      \"anonymous\": false,\n      \"inputs\": [\n        {\n          \"indexed\": true,\n          \"internalType\": \"address\",\n          \"name\": \"owner\",\n          \"type\": \"address\"\n        },\n        {\n          \"indexed\": true,\n          \"internalType\": \"address\",\n          \"name\": \"spender\",\n          \"type\": \"address\"\n        },\n        {\n          \"indexed\": false,\n          \"internalType\": \"uint256\",\n          \"name\": \"value\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"name\": \"Approval\",\n      \"type\": \"event\"\n    },\n    {\n      \"anonymous\": false,\n      \"inputs\": [\n        {\n          \"indexed\": false,\n          \"internalType\": \"address\",\n          \"name\": \"userAddress\",\n          \"type\": \"address\"\n        },\n        {\n          \"indexed\": false,\n          \"internalType\": \"address payable\",\n          \"name\": \"relayerAddress\",\n          \"type\": \"address\"\n        },\n        {\n          \"indexed\": false,\n          \"internalType\": \"bytes\",\n          \"name\": \"functionSignature\",\n          \"type\": \"bytes\"\n        }\n      ],\n      \"name\": \"MetaTransactionExecuted\",\n      \"type\": \"event\"\n    },\n    {\n      \"anonymous\": false,\n      \"inputs\": [\n        {\n          \"indexed\": true,\n          \"internalType\": \"address\",\n          \"name\": \"from\",\n          \"type\": \"address\"\n        },\n        {\n          \"indexed\": true,\n          \"internalType\": \"address\",\n          \"name\": \"to\",\n          \"type\": \"address\"\n        },\n        {\n          \"indexed\": false,\n          \"internalType\": \"uint256\",\n          \"name\": \"value\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"name\": \"Transfer\",\n      \"type\": \"event\"\n    },\n    {\n      \"inputs\": [\n        {\n          \"internalType\": \"address\",\n          \"name\": \"owner\",\n          \"type\": \"address\"\n        },\n        {\n          \"internalType\": \"address\",\n          \"name\": \"spender\",\n          \"type\": \"address\"\n        }\n      ],\n      \"name\": \"allowance\",\n      \"outputs\": [\n        {\n          \"internalType\": \"uint256\",\n          \"name\": \"\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"stateMutability\": \"view\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [\n        {\n          \"internalType\": \"address\",\n          \"name\": \"spender\",\n          \"type\": \"address\"\n        },\n        {\n          \"internalType\": \"uint256\",\n          \"name\": \"amount\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"name\": \"approve\",\n      \"outputs\": [\n        {\n          \"internalType\": \"bool\",\n          \"name\": \"\",\n          \"type\": \"bool\"\n        }\n      ],\n      \"stateMutability\": \"nonpayable\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [\n        {\n          \"internalType\": \"address\",\n          \"name\": \"account\",\n          \"type\": \"address\"\n        }\n      ],\n      \"name\": \"balanceOf\",\n      \"outputs\": [\n        {\n          \"internalType\": \"uint256\",\n          \"name\": \"\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"stateMutability\": \"view\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [],\n      \"name\": \"decimals\",\n      \"outputs\": [\n        {\n          \"internalType\": \"uint8\",\n          \"name\": \"\",\n          \"type\": \"uint8\"\n        }\n      ],\n      \"stateMutability\": \"view\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [\n        {\n          \"internalType\": \"address\",\n          \"name\": \"spender\",\n          \"type\": \"address\"\n        },\n        {\n          \"internalType\": \"uint256\",\n          \"name\": \"subtractedValue\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"name\": \"decreaseAllowance\",\n      \"outputs\": [\n        {\n          \"internalType\": \"bool\",\n          \"name\": \"\",\n          \"type\": \"bool\"\n        }\n      ],\n      \"stateMutability\": \"nonpayable\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [\n        {\n          \"internalType\": \"address\",\n          \"name\": \"userAddress\",\n          \"type\": \"address\"\n        },\n        {\n          \"internalType\": \"bytes\",\n          \"name\": \"functionSignature\",\n          \"type\": \"bytes\"\n        },\n        {\n          \"internalType\": \"bytes32\",\n          \"name\": \"sigR\",\n          \"type\": \"bytes32\"\n        },\n        {\n          \"internalType\": \"bytes32\",\n          \"name\": \"sigS\",\n          \"type\": \"bytes32\"\n        },\n        {\n          \"internalType\": \"uint8\",\n          \"name\": \"sigV\",\n          \"type\": \"uint8\"\n        }\n      ],\n      \"name\": \"executeMetaTransaction\",\n      \"outputs\": [\n        {\n          \"internalType\": \"bytes\",\n          \"name\": \"\",\n          \"type\": \"bytes\"\n        }\n      ],\n      \"stateMutability\": \"payable\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [\n        {\n          \"internalType\": \"address\",\n          \"name\": \"user\",\n          \"type\": \"address\"\n        }\n      ],\n      \"name\": \"getNonce\",\n      \"outputs\": [\n        {\n          \"internalType\": \"uint256\",\n          \"name\": \"nonce\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"stateMutability\": \"view\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [\n        {\n          \"internalType\": \"address\",\n          \"name\": \"spender\",\n          \"type\": \"address\"\n        },\n        {\n          \"internalType\": \"uint256\",\n          \"name\": \"addedValue\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"name\": \"increaseAllowance\",\n      \"outputs\": [\n        {\n          \"internalType\": \"bool\",\n          \"name\": \"\",\n          \"type\": \"bool\"\n        }\n      ],\n      \"stateMutability\": \"nonpayable\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [\n        {\n          \"internalType\": \"uint256\",\n          \"name\": \"_amount\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"name\": \"mintTokens\",\n      \"outputs\": [],\n      \"stateMutability\": \"nonpayable\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [],\n      \"name\": \"name\",\n      \"outputs\": [\n        {\n          \"internalType\": \"string\",\n          \"name\": \"\",\n          \"type\": \"string\"\n        }\n      ],\n      \"stateMutability\": \"view\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [],\n      \"name\": \"symbol\",\n      \"outputs\": [\n        {\n          \"internalType\": \"string\",\n          \"name\": \"\",\n          \"type\": \"string\"\n        }\n      ],\n      \"stateMutability\": \"view\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [],\n      \"name\": \"totalSupply\",\n      \"outputs\": [\n        {\n          \"internalType\": \"uint256\",\n          \"name\": \"\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"stateMutability\": \"view\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [\n        {\n          \"internalType\": \"address\",\n          \"name\": \"to\",\n          \"type\": \"address\"\n        },\n        {\n          \"internalType\": \"uint256\",\n          \"name\": \"amount\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"name\": \"transfer\",\n      \"outputs\": [\n        {\n          \"internalType\": \"bool\",\n          \"name\": \"\",\n          \"type\": \"bool\"\n        }\n      ],\n      \"stateMutability\": \"nonpayable\",\n      \"type\": \"function\"\n    },\n    {\n      \"inputs\": [\n        {\n          \"internalType\": \"address\",\n          \"name\": \"from\",\n          \"type\": \"address\"\n        },\n        {\n          \"internalType\": \"address\",\n          \"name\": \"to\",\n          \"type\": \"address\"\n        },\n        {\n          \"internalType\": \"uint256\",\n          \"name\": \"amount\",\n          \"type\": \"uint256\"\n        }\n      ],\n      \"name\": \"transferFrom\",\n      \"outputs\": [\n        {\n          \"internalType\": \"bool\",\n          \"name\": \"\",\n          \"type\": \"bool\"\n        }\n      ],\n      \"stateMutability\": \"nonpayable\",\n      \"type\": \"function\"\n    }\n  ]\n"


