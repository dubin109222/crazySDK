//
//  PSUtils+Wallet.swift
//  CrazySnake
//
//  Created by Lee on 24/02/2023.
//

import UIKit
//import WalletCore
import web3swift
import BigInt

extension Utils{
    static func getPrivateKeyByMnemonic(_ mnemonic: String) -> String? {
        let seed = Mnemonic.createSeed(mnemonic:mnemonic)
        let wAccount = Wallet(seed: seed, coin: .ethereum).generateAccount()
        return wAccount.rawPrivateKey
    }
    
    static func getWalletAddress(privateKey: String) -> String? {
        // 1. 创建一个以太坊钱包对象
        // 1. 将私钥转换为 Data 类型
        guard let privateKeyData = Data.fromHex(privateKey) else {
            // 私钥转换失败
            print("私钥转换失败")

            return nil
        }

        // 2. 创建以太坊钱包对象
        guard let keystore = try? EthereumKeystoreV3(privateKey: privateKeyData, password: "") else {
            // 私钥导入失败
            print("私钥导入失败")

            return nil
        }
      

        // 2. 从私钥中获取钱包地址
        guard let address = keystore.getAddress()?.address else {
            // 获取地址失败
            print("获取地址失败")

            return nil
        }

        return address
    }
    
    fileprivate static func _sign(privateKey: String, dataToSign: Data?) -> String? {

        guard let dataToSign = dataToSign else { return nil }
        
        guard let data = CSUtils.hexStringToPrivateKey(privateKey) else {
            return nil
        }
        let (signData, _) = SECP256K1.signForRecovery(hash: dataToSign,
                                                      privateKey: data,
                                                      useExtraEntropy: false)
        
        guard let signData = signData else {
            return nil
        }
        let signStr = signData.ls_hexString.ls_addHexPrefix()
        return signStr
    }
    
    static func signInfo(privateKey: String?) -> (String, String?){
        let content = String.ls_randomStr(len: 24)
        guard let privateKey = privateKey else { return (content, nil) }
        guard let signData = content.data(using: .utf8), let message = Web3.Utils.hashPersonalMessage(signData) else {
            return (content, nil)
        }
        
        guard var signed = _sign(privateKey: privateKey, dataToSign: message) else {
            return (content, nil)
        }
//        signed[64] += 27
//
//        let result = "0x"+CSUtils.convertDataToHexString(signed)
        return (content, signed)
    }
    
    static func sign(privateKey: String?, content: String?) -> String? {
        guard let content = content else { return nil }
        guard let privateKey = privateKey else { return nil }
        guard let signData = content.data(using: .utf8), let message = Web3.Utils.hashPersonalMessage(signData) else {
            return nil
        }
        
        guard let data = CSUtils.hexStringToPrivateKey(privateKey) else {
            return nil
        }
        
        guard var signed = _sign(privateKey: privateKey, dataToSign: message) else {
            return nil
        }
        return signed
//        guard var signed = privateData.sign(digest: message, curve: .secp256k1) else {
//            return nil
//        }
//        signed[64] += 27
//
//        let result = "0x"+CSUtils.convertDataToHexString(signed)
//        return result
    }
}
