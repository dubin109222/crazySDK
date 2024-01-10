//
//  EthUnitUtils.swift
//  CrazySnake
//
//  Created by Lee on 20/09/2022.
//

import UIKit
import BigInt
import web3swift

class EthUnitUtils: NSObject {
    static let kGwei = "1000000000"
    
    //from ETH to Wei
    public static func getWeiBigStringFrom(ethString:String) throws -> String {
        guard let eth = Web3.Utils.parseToBigUInt(ethString, units: .eth) else {
            return "0"
        }
        guard let balString =  Web3.Utils.formatToEthereumUnits(eth, toUnits: .wei, decimals: 0) else {
            return "0"
        }
        return balString
    }

    //from wei to eth
    public static func getETHFrom(weiString:String) throws -> String {
       guard let weiBig = BigUInt(weiString) else {
           return "0"
       }
       guard let balString =  Web3.Utils.formatToEthereumUnits(weiBig, toUnits: .eth, decimals: 8) else {
           return "0"
       }
       return balString;
    }
    
    //from wei to usdt
    public static func getUSDTFrom(weiString:String) throws -> String {
       guard let weiBig = BigUInt(weiString) else {
           return "0"
       }
       guard let balString =  Web3.Utils.formatToEthereumUnits(weiBig, toUnits: .Mwei, decimals: 6) else {
           return "0"
       }
       return balString;
    }
    
    /// from price to eth
    public static func getEthFrom(hex:String) throws -> String {
        
        let hexStr = hex.replacingOccurrences(of: "0x", with: "")
        let decimal = hexStr.ls_hexToDecimalString()
        
        guard let weiBig1 = BigUInt(decimal)else {
            return "0"
        }
        
        guard let balString =  Web3.Utils.formatToEthereumUnits(weiBig1, toUnits: .eth, decimals: 8) else {
            return "0"
        }
        return balString;
    }
    
    /// from price to eth
    public static func getGweiFrom(hex:String) throws -> String {
        
        let hexStr = hex.replacingOccurrences(of: "0x", with: "")
        let decimal = hexStr.ls_hexToDecimalString()
        
        guard let weiBig1 = BigUInt(decimal)else {
            return "0"
        }
        guard let weiBig2 = BigUInt(kGwei) else {
            return "0"
        }
        let priceWei = weiBig1/weiBig2 ;
        return "\(priceWei)"
    }
    
    /// from price to eth
    public static func getEthFrom(price:String,wei:String) throws -> String {
        guard let weiBig1 = BigUInt(price)else {
            return "0"
        }
        guard let weiBig2 = BigUInt(kGwei) else {
            return "0"
        }
        let priceWei = weiBig1 * weiBig2;
        
        guard let weiBig3 = BigUInt(wei) else {
            return "0"
        }
        let priceAmount = priceWei * weiBig3;
        
        guard let balString =  Web3.Utils.formatToEthereumUnits(priceAmount, toUnits: .eth, decimals: 8) else {
            return "0"
        }
        return balString;
    }
    
    /// from price to eth
    public static func getEthFrom(priceWei:String,wei:String) throws -> String {
        guard let weiBig1 = BigUInt(priceWei)else {
            return "0"
        }
        
        guard let weiBig2 = BigUInt(wei) else {
            return "0"
        }
        let priceAmount = weiBig1 * weiBig2;
        
        guard let balString =  Web3.Utils.formatToEthereumUnits(priceAmount, toUnits: .eth, decimals: 8) else {
            return "0"
        }
        return balString;
    }

    //from 0x00 to wei
    public static func getWeiFromUnit(unitString:String,decimal:Int) throws -> String {
       guard let balance = Web3.Utils.parseToBigUInt(unitString, decimals: decimal) else {
           return "0"
       }
       guard let balString =  Web3.Utils.formatToEthereumUnits(balance, toUnits: .wei, decimals: 8) else {
           return "0"
       }
       return balString
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
    
    /// price wei
    public static func getPriceGWei(wei:String) throws -> String {
        guard let weiBig1 = Double(wei)else {
            return "0"
        }
//        guard let weiBig2 = BigUInt(kGwei) else {
//            return "0"
//        }
        let priceWei = weiBig1 / 1000000000.0;
        
        return "\(priceWei)"
    }

    //wei *
    public static func getMultiWei(wei1:String,wei2:String) throws -> String {
       guard let weiBig1 = BigUInt(wei1)else {
           return "0"
       }
       guard let weiBig2 = BigUInt(wei2) else {
           return "0"
       }
       let wei = weiBig1 * weiBig2;
       guard let balString = Web3.Utils.formatToEthereumUnits(wei, toUnits: .wei, decimals: 8) else {
           return "0"
       }
       return balString;
    }

    //wei +
    public static func getSumWei(wei1:String,wei2:String) throws -> String {
        guard let weiBig1 = BigUInt(wei1)else {
            return "0"
        }
        guard let weiBig2 = BigUInt(wei2) else {
            return "0"
        }
        let wei = weiBig1 + weiBig2;
        guard let balString = Web3.Utils.formatToEthereumUnits(wei, toUnits: .wei, decimals: 8) else {
            return "0"
        }
        return balString;
    }
    
    
    public static func getWei(amount:String, token:TokenName) -> String?{
        guard let amountBig = Web3.Utils.parseToBigUInt(amount, units: .eth) else {
            return nil
        }
        
        if token == .USDT {
            let usdtWei = Web3.Utils.formatToEthereumUnits(amountBig, toUnits: .Microether, decimals: 0)
            return usdtWei
        } else {
            let ethWei = Web3.Utils.formatToEthereumUnits(amountBig, toUnits: .wei, decimals: 0)
            return ethWei
        }
    }
    
    public static func getAmount(wei:String, token:TokenName) -> String?{
        guard let amountWeiBig = Web3.Utils.parseToBigUInt(wei, units: .wei) else {
            return nil
        }
        
        if token == .USDT {
            
            let usdt = Web3.Utils.formatToEthereumUnits(amountWeiBig, toUnits: .Mwei, decimals: 6)
            return usdt
        } else {
            let eth = Web3.Utils.formatToEthereumUnits(amountWeiBig, toUnits: .eth, decimals: 8)
            return eth
        }
    }
    
}
