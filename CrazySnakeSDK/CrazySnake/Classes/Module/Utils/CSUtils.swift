//
//  CSUtils.swift
//  CrazySnake
//
//  Created by Lee on 22/07/2022.
//

import UIKit
import web3swift
import BigInt

let kGwei = "1000000000"
let kEthGasLimit = "210000"
let kEthTokenGasLimit = "80000"
let kDefaultGasPrice = 18
let kCrazyGasPrice = 48

class CSUtils: NSObject {
        
    static func defalutWeb3() -> web3? {
        let chain = Config.chain
        let network = Networks.Custom(networkID: BigUInt(chain.chainId()))
        var web3Item: web3?
        if let url = URL(string: chain.endPoint()), let provider = Web3HttpProvider(url,network: network) {
            web3Item = web3(provider: provider)
        }
        return web3Item
    }
    
    static func createBIP32Keystore(_ privateKeyString: String) -> BIP32Keystore? {
        let password = "web3swift"
        if let privateKey = hexStringToPrivateKey(privateKeyString) {
            guard let keystore = try? BIP32Keystore(seed: privateKey, password: password) else {
                return nil
            }
            return keystore
        }
        return nil
    }
    
    static func walletWeb3() -> web3? {
        let password = "web3swift"
        var keystoreManager: KeystoreManager?
        if let privateKey = CSSDKManager.shared.walletPrivateKey {
            guard let keystore = try? EthereumKeystoreV3(privateKey: privateKey, password: password) else {
                return nil
            }
            keystoreManager = KeystoreManager([keystore])
        }
        
        if let mnemonics = CSSDKManager.shared.walletMnemonic {
            guard let keystore = try? BIP32Keystore(
                mnemonics: mnemonics,
                password: password,
                mnemonicsPassword: "",
                language: .english) else {
                return nil
            }
            keystoreManager = KeystoreManager([keystore])
        }
        
        guard let keystoreManager = keystoreManager else { return nil }
        
        let chain = Config.chain
        let network = Networks.Custom(networkID: BigUInt(chain.chainId()))
        var web3Item: web3?
        if let url = URL(string: chain.endPoint()), let provider = Web3HttpProvider(url,network: network) {
            web3Item = web3(provider: provider)
        } else {
            return nil
        }
        web3Item?.addKeystoreManager(keystoreManager)
        return web3Item
    }
    
    static func walletWeb3(_ privateKeyString: String) -> web3? {
        let password = "web3swift"
        var keystoreManager: KeystoreManager?
        if let privateKey = hexStringToPrivateKey(privateKeyString) {
            guard let keystore = try? EthereumKeystoreV3(privateKey: privateKey, password: password) else {
                return nil
            }
            keystoreManager = KeystoreManager([keystore])
        }
        
        
        guard let keystoreManager = keystoreManager else { return nil }
        
        let chain = Config.chain
        let network = Networks.Custom(networkID: BigUInt(chain.chainId()))
        var web3Item: web3?
        if let url = URL(string: chain.endPoint()), let provider = Web3HttpProvider(url,network: network) {
            web3Item = web3(provider: provider)
        } else {
            return nil
        }
        web3Item?.addKeystoreManager(keystoreManager)
        return web3Item
    }
    
    /// price wei
    public static func getPriceWei(price:String) throws -> BigUInt {
        guard let weiBig1 = BigUInt(price)else {
            return "0"
        }
        guard let weiBig2 = BigUInt(kGwei) else {
            return "0"
        }
        let priceWei = weiBig1 * weiBig2;
        
        return priceWei
    }
    
    static func contractResponse(_ code:ResultCode, content: Any? = nil) -> CSResultRespon {
        let result = CSResultRespon()
        result.code = code.rawValue
        result.data = content
        return result
    }
    
    static func contractResponse(_ code:ResultCode, message: String?, content: Any? = nil) -> CSResultRespon {
        let result = CSResultRespon()
        result.code = code.rawValue
        result.message = message
        result.data = content
        return result
    }
    
    /// result respon in main thread
    /// - Parameters:
    ///   - code: result code 0: success
    ///   - message: log message
    ///   - content: content
    static func contractResponse(_ code:Int, message: String?, content: Any? = nil, _ response: @escaping((CSResultRespon) -> ())) {
        DispatchQueue.main.async {
            let result = CSResultRespon()
            result.code = code
            result.message = message
            result.data = content
            response(result)
        }
    }
    
    static func contractResponse(_ code:ResultCode, content: Any? = nil, _ response: @escaping((CSResultRespon) -> ())) {
        DispatchQueue.main.async {
            let result = CSResultRespon()
            result.code = code.rawValue
            result.data = content
            response(result)
        }
    }
    
    static func defaultOptions() -> TransactionOptions {
         
        var options = TransactionOptions.defaultOptions
        options.gasLimit = .manual(BigUInt(800000))
        if let priceWei = try? CSUtils.getPriceWei(price: "\(kCrazyGasPrice)") {
            options.gasPrice = .manual(priceWei)
        } else {
            options.gasPrice = .automatic
        }
        return options
    }
    
    static func convertDataToHexString(_ data: Data) -> String {
        return data.ls_hexString
    }
    
    static func hexStringToPrivateKey(_ baseString: String?) -> Data? {
        guard let baseString = baseString else { return nil }
        return Data(hexString: baseString)
    }
    
}


extension Data {
    public var ls_hexString: String {
        return map({ String(format: "%02x", $0) }).joined()
    }
}

extension String {
    func ls_hasHexPrefix() -> Bool {
        return self.hasPrefix("0x")
    }

    func ls_stripHexPrefix() -> String {
        if self.hasPrefix("0x") {
            let indexStart = self.index(self.startIndex, offsetBy: 2)
            return String(self[indexStart...])
        }
        return self
    }

    func ls_addHexPrefix() -> String {
        if !self.hasPrefix("0x") {
            return "0x" + self
        }
        return self
    }

}
