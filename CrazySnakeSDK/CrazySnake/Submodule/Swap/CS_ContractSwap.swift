//
//  CS_ContractSwap.swift
//  CrazySnake
//
//  Created by Lee on 20/03/2023.
//

import UIKit
import web3swift
import BigInt
import SwiftyJSON

enum CS_SwapType: String {
    case SnakeToUSDT = "44"
    case USDTToSnake = "45"
    
    func fromContract() -> String {
        var contract = ""
        switch self {
        case .SnakeToUSDT:
            contract = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address ?? ""
        case .USDTToSnake:
            contract = CS_AccountManager.shared.basicConfig?.contract?.usdt_token?.contract_address ?? ""
        }
        return contract
    }
    
    func toContract() -> String {
        var contract = ""
        switch self {
        case .SnakeToUSDT:
            contract = CS_AccountManager.shared.basicConfig?.contract?.usdt_token?.contract_address ?? ""
        case .USDTToSnake:
            contract = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address ?? ""
        }
        return contract
    }
}

class CS_ContractSwap: NSObject {
    
    static let shared = CS_ContractSwap()
    private override init() {
        super.init()
    }
    
    /// swap is approved
    /// - Parameters:
    ///   - swapType: 1: Snake->USDT 2: USDT->Snake
    static func swapIsApproved(swapType: CS_SwapType, response: @escaping((Bool) -> ())){
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper?.contract_address else {
            response(false)
            return
        }
        switch swapType {
        case .SnakeToUSDT:
            CS_ContractApprove.snakeTokenIsApproved(to: contract, response: response)
        case .USDTToSnake:
            CS_ContractApprove.usdtTokenIsApproved(to: contract, response: response)
//        default:
//            break
        }
    }
    
    /// swap is approved
    /// - Parameters:
    ///   - swapType: 1: Snake->USDT 2: USDT->Snake
    static func approve(swapType: CS_SwapType, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
        DispatchQueue.global().async {
            _approve(swapType: swapType,funcHash: funcHash, response: response)
        }
    }
    
    func swapTokenPara(swapType: CS_SwapType, amount: String, amountOutMin: String) -> [String:Any]? {
        
        var apiId = ""
        if Config.chain == .Polygon {
            if swapType == .SnakeToUSDT {
                apiId = "swapSnakeToUsdt"
            } else if swapType == .USDTToSnake {
                apiId = "swapUsdtToSnake"
            }
        } else if Config.chain == .Platon {
            if swapType == .SnakeToUSDT {
                apiId = "swapExactTokenToUsdt"
            } else if swapType == .USDTToSnake {
                apiId = "swapExactTokenToToken"
            }
        }
        

        
        var amountWei: String?
        if swapType == .USDTToSnake {
            //U to S
            amountWei = EthUnitUtils.getWei(amount: amount, token: .USDT)
            
        } else {
            amountWei = EthUnitUtils.getWei(amount: amount, token: .Snake)
            
        }
        
        
        var amountOutMinWei: String?
        if swapType == .SnakeToUSDT {
            amountOutMinWei = EthUnitUtils.getWei(amount: amountOutMin, token: .USDT)
        } else {
            amountOutMinWei = EthUnitUtils.getWei(amount: amountOutMin, token: .Snake)
        }
        
        let gasFee = 3000
        var params = [Any]()
        if Config.chain == .Polygon {
            params = [CS_AccountManager.shared.accountInfo?.wallet_address ?? "",
                      amountWei ?? amount,
                      amountOutMinWei ?? amountOutMin,
                      gasFee,
                      2000] as [Any]
        } else if Config.chain == .Platon {
            params = [
                CS_AccountManager.shared.accountInfo?.wallet_address ?? "",
                CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address ?? "",
                amountWei ?? amount,
                amountOutMinWei ?? amountOutMin,
                0,
                2000
            ] as [Any]
        }
        
        if Config.chain == .Polygon {
            if swapType == .USDTToSnake {
                params = [amountWei ?? amount,amountOutMinWei ?? amountOutMin,gasFee] as [Any]
            }
        }
        
        var para :[String:Any] = [:]
        para["from"] = CS_AccountManager.shared.accountInfo?.wallet_address
        para["contract"] = CS_AccountManager.shared.basicConfig?.contract?.swapper?.contract_name ?? ""
        para["func"] = apiId
        para["params"] = toJSONString(arrary: params)
        para["internal"] = 0
        if swapType == .SnakeToUSDT {
            para["internal"] = "1"
        }
        let otherParams = ["amount":amount] as [String : Any]
        
        para["other_params"] = toJSONString(dict: otherParams)
        return para
    }
    
    func toJSONString(arrary:[Any]?)->String{
        
        if let arrary = arrary {
            let data = try? JSONSerialization.data(withJSONObject: arrary)
            
            let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            return strJson! as String
        }else{
            return ""
        }
    }
    
    func toJSONString(dict:Dictionary<String, Any>?)->String{
        
        if let dict = dict {
            let data = try? JSONSerialization.data(withJSONObject: dict)
            
            let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            return strJson! as String
        }else{
            return ""
        }
    }
    
    func encodeDataSwapToken(swapType: CS_SwapType, amount: String, amountOutMin: String) -> String? {
        
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address, let address = EthereumAddress(walletAddress) else {
            return nil
        }
        var amountBig: BigUInt?
        if swapType == .USDTToSnake {
            //U to S
            amountBig = Web3.Utils.parseToBigUInt("\(amount)", units: .Mwei)
        } else {
            amountBig = Web3.Utils.parseToBigUInt("\(amount)", units: .eth)
            
        }
        guard let amountBig = amountBig else {
            return nil
        }
        
        var amountOutMinWei: BigUInt?
        if swapType == .SnakeToUSDT {
            amountOutMinWei = Web3.Utils.parseToBigUInt(amountOutMin, units: .Mwei)
        } else {
            amountOutMinWei = Web3.Utils.parseToBigUInt(amountOutMin, units: .eth)
        }
        guard let amountOutMinWei = amountOutMinWei else {
            return nil
        }
        var method = ""
        var inputs: [ABI.Element.InOut] = []
        let gasFee = 3000
        var paras = [amountBig,amountOutMinWei,BigUInt(gasFee)] as [AnyObject]
//        var paras: [AnyObject] = []
        if Config.chain == .Polygon {
            if swapType == .SnakeToUSDT {
                method = "swapSnakeToUsdt"
                paras = [address,amountBig,amountOutMinWei,BigUInt(gasFee),BigUInt(1000)] as [AnyObject]
                inputs = [
                    .init(name: "_sender", type: .address),
                    .init(name: "_amountIn", type: .uint(bits: 256)),
                    .init(name: "_amountOutMin", type: .uint(bits: 256)),
                    .init(name: "_poolFee", type: .uint(bits: 24)),
                    .init(name: "_lockTime", type: .uint(bits: 256))]
            } else if swapType == .USDTToSnake {
                method = "swapUsdtToSnake"
                inputs = [
                    .init(name: "_amountIn", type: .uint(bits: 256)),
                    .init(name: "_amountOutMin", type: .uint(bits: 256)),
                    .init(name: "_poolFee", type: .uint(bits: 24))]
                
            } else {
                return nil
            }
        } else if Config.chain == .Platon {
            if swapType == .SnakeToUSDT {
                method = "swapExactTokenToUsdt"
                // FIXME: snake to usdt 参数错误，但是好像不会走这个判断
                paras = [address,amountBig,amountOutMinWei,BigUInt(gasFee),BigUInt(1000)] as [AnyObject]
                inputs = [
                    .init(name: "_sender", type: .address),
                    .init(name: "_amountIn", type: .uint(bits: 256)),
                    .init(name: "_amountOutMin", type: .uint(bits: 256)),
                    .init(name: "_poolFee", type: .uint(bits: 24)),
                    .init(name: "_lockTime", type: .uint(bits: 256))]
            } else if swapType == .USDTToSnake {
                method = "swapExactTokenToToken"
                paras = [
                    CS_AccountManager.shared.basicConfig?.contract?.usdt_token?.contract_address ?? "",
                    CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address ?? "",
                    amountBig,
                    amountOutMinWei,
                    BigUInt(gasFee)
                ] as [AnyObject]
                inputs = [
                    .init(name: "_tokenIn", type: .address),
                    .init(name: "_tokenOut", type: .address),
                    .init(name: "_amountIn", type: .uint(bits: 256)),
                    .init(name: "_amountOutMin", type: .uint(bits: 256)),
                    .init(name: "_poolFee", type: .uint(bits: 24))
                ]
            }
        }
        
        let function = ABI.Element.Function(
            name: method,
            inputs: inputs,
            outputs: [],
            constant: false,
            payable: false)
        
        let object = ABI.Element.function(function)

        guard let funcHash = object.encodeParameters(paras)?.ls_hexString.ls_addHexPrefix() else {
            return nil
        }
        return funcHash
    }
    
    func swapToken(gasPrice: String?,swapType: CS_SwapType, amount: String, amountOutMin: String, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        var amountBig: BigUInt?
        if swapType == .USDTToSnake {
            //U to S
            amountBig = Web3.Utils.parseToBigUInt("\(amount)", units: .Mwei)
        } else {
            amountBig = Web3.Utils.parseToBigUInt("\(amount)", units: .eth)
            
        }
        guard let amountBig = amountBig else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        let amountWeiString = Web3.Utils.formatToEthereumUnits(amountBig, toUnits: .wei, decimals: 0)
        var amountOutMinWei: BigUInt?
        if swapType == .SnakeToUSDT {
            amountOutMinWei = Web3.Utils.parseToBigUInt(amountOutMin, units: .Mwei)
        } else {
            amountOutMinWei = Web3.Utils.parseToBigUInt(amountOutMin, units: .eth)
        }
        guard let amountOutMinWei = amountOutMinWei else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        let amountOutWeiString = Web3.Utils.formatToEthereumUnits(amountOutMinWei, toUnits: .wei, decimals: 0)
        var otherParams: [String: Any]? = nil
        var apiId = ""
        if Config.chain == .Polygon {
            if swapType == .SnakeToUSDT {
                apiId = "swapSnakeToUsdt"
            } else if swapType == .USDTToSnake {
                apiId = "swapUsdtToSnake"
                otherParams = ["contract_name": "SnakeToken"]
            } else {
                CSUtils.contractResponse(.invalidFormat, response)
                return
            }
        } else if Config.chain == .Platon {
            if swapType == .SnakeToUSDT {
                apiId = "swapExactTokenToUsdt"
            } else if swapType == .USDTToSnake {
                apiId = "swapExactTokenToToken"
                otherParams = ["contract_name": "SnakeToken"]
            }
        }
        
        let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper?.contract_address
        var contractName = ""
        if Config.chain == .Polygon {
            contractName = "SwapperV2"
        } else if Config.chain == .Platon {
            contractName = "DipoleSwapperV2"
        }
        
        DispatchQueue.global().async {

            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: otherParams,response: response)
        }
    }

    func encodeDataWithdraw(sid: String) -> String? {
        
        guard let sid = Web3.Utils.parseToBigUInt("\(sid)", units: .wei) else {
            return nil
        }
        let para = [sid] as [AnyObject]
        let method = "withdrawToken"
        let function = ABI.Element.Function(
            name: method,
            inputs: [
                .init(name: "_sid", type: .uint(bits: 256))],
            outputs: [],
            constant: false,
            payable: false)
        let object = ABI.Element.function(function)

        guard let funcHash = object.encodeParameters(para)?.ls_hexString.ls_addHexPrefix() else {
            return nil
        }
        return funcHash
    }
    
    static func getEstimateSwapWithdrawPara(sid: String,id: String) -> [String:Any]? {
        
        let paras = [sid] as [Any]
        var contract = ""
        if Config.chain == .Polygon {
            contract = "SwapperV2"
        } else if Config.chain == .Platon {
            contract = "DipoleSwapperV2"
        }
        let method = "withdrawToken"
        let other_params = ["id": id]
        let para = CS_ContractManager.getEstimateGasParas(contract: contract, method: method, paras: paras, otherParams: other_params)
        return para
    }
    
    func swapWithdraw(id: String, amount: String, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
        guard let privateKey = CS_AccountManager.shared.accountInfo?.private_key else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        guard let walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper?.contract_address
        var contractName = ""
        if Config.chain == .Polygon {
            contractName = "SwapperV2"
        } else if Config.chain == .Platon {
            contractName = "DipoleSwapperV2"
        }
        let apiId = "withdrawToken"
        let otherParams = [
            "type": "47",
            "amount": amount,
            "id": id]
        DispatchQueue.global().async {
            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: otherParams,response: response)
        }
    }
}

//MARK: GasCoin
extension CS_ContractSwap {
    static func getEstimateSwapGasCoinPara(to: String,amount: String,gasCoin: String) -> [String:Any]? {
        
        guard let amountWei = try? EthUnitManager.getWeiBigStringFrom(ethString: amount) else {
            return nil
        }
        
        guard let contractModel = CS_AccountManager.shared.basicConfig?.contract?.current_token.first else { return nil }
        
        let paras = [to, amountWei] as [Any]
        let contract = contractModel.contract_name
        let method = "transfer"
        let other_params = ["type":"1","amount": amount,"gas_coin":gasCoin]
        let para = CS_ContractManager.getEstimateGasParas(contract: contract, method: method, paras: paras, otherParams: other_params)
        return para
    }
    
    static func swapGasCoin(amount: String, gasCoin: String, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
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
        let otherParams = ["type": "1",
                           "amount": amount,
                           "gas_coin": gasCoin]
        DispatchQueue.global().async {

            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: otherParams,response: response)
        }
    }
}

//MARK: Diamond
extension CS_ContractSwap {
    static func getEstimateSwapDiamondPara(contract: String, to: String, amount: String) -> [String:Any]? {
        
        guard let amountWei = try? EthUnitManager.getWeiBigStringFrom(ethString: amount) else {
            return nil
        }
        let paras = [to, amountWei] as [Any]
        let contract = contract
        let method = "transfer"
        let other_params = ["amount": amount]
        let para = CS_ContractManager.getEstimateGasParas(contract: contract, method: method, paras: paras, otherParams: other_params)
        return para
    }
    
    static func swapDiamond(id: String, game_id: String, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
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
        let otherParams = ["type": "4",
                           "id": id,
                           "game_id": game_id]
        DispatchQueue.global().async {

            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: otherParams,response: response)
        }
    }
}

//MARK: Events
extension CS_ContractSwap {
    static func eventBuy(amount: String,id: String,item_id: String, num: String, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
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
        let otherParams = ["type": "2",
                           "amount": amount,
                           "id": id,
                           "item_id":item_id,
                           "num":num]
        DispatchQueue.global().async {

            CS_ContractGasUtils.freeGas(privateKey: privateKey, address: walletAddress, apiId: apiId, functionSignature: funcHash, contractAddress: contract,contractName: contractName,otherParams: otherParams,response: response)
        }
    }
}

//MARK: inner
extension CS_ContractSwap {
    static func _approve(swapType: CS_SwapType, funcHash: String, response: @escaping((CSResultRespon) -> ())) {
        
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper?.contract_address else {
            CSUtils.contractResponse(.invalidFormat, response)
            return
        }
        
        if swapType == .USDTToSnake {
            CS_ContractApprove.approveUSDT(to: contract, funcHash: funcHash, response: response)
        } else {
            CS_ContractApprove.approveSnake(to: contract, funcHash: funcHash, response: response)
        }
        
    }
}

