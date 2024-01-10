//
//  ChainModel.swift
//  Platform
//
//  Created by Lee on 03/11/2021.
//  Copyright © 2021 ELFBOX. All rights reserved.
//

import UIKit

//enum WalletChainType: String, CaseIterable {
//    case ALL = "ALL"
//    case ETH = "Ethereum"
//    case ETHTEST = "Ethereum-TEST"
//    case BSC = "BSC"
//    case BSCTEST = "BSC-TEST"
//    /// Polygon
//    case Polygon = "Polygon"
//    /// Polygon test
//    case PTest = "PTest"
//    case Mumbai = "Mumbai"
//
//    static func chainType() -> WalletChainType {
//        return .Polygon
//    }
//
//    func chainId() -> Int {
//        switch self {
//        case .ETH:
//            return 1
//        case .ETHTEST:
//            return 42
//        case .BSC:
//            return 56
//        case .BSCTEST:
//            return 97
//        case .Polygon:
//            return 137
//        case .Mumbai:
//            return 80001
//        case .PTest:
//            return 3
//        default:
//            return 0
//        }
//    }
//
//    fileprivate static let endPointETHMainnet = "https://mainnet.infura.io/v3/dc8db8da40c34114ac9f892bd47d8878"
//    fileprivate static let endPointETHTestnet = "https://mainnet.infura.io/v3/dc8db8da40c34114ac9f892bd47d8878"
//    fileprivate static let endPointBSCMainnet = "https://bsc-dataseed.binance.org/"
//    fileprivate static let endPointBSCTestnet = "https://data-seed-prebsc-1-s1.binance.org:8545/"
//    fileprivate static let endPointPolygonMainnet = "https://polygon-mainnet.g.alchemy.com/v2/vHM6_6FA0kId6hqHe9sMtUrR6U5nYd7F"
////    fileprivate static let endPointMumbaiTestnet = "https://rpc-mumbai.maticvigil.com"
//    fileprivate static let endPointMumbaiTestnet = "https://rpc-mumbai.matic.today"
//    fileprivate static let endPointPTestnet = "https://ropsten.infura.io/v3/b3acc2ce56344d229d48d2c1fa5bd51f"
//
//    fileprivate static let endPointSolanaMainnet = "https://api.mainnet-beta.solana.com"
//    fileprivate static let endPointSolanaTestnet = "https://api.testnet.solana.com"
////    fileprivate static let endPointSolanaTestnet = "https://api.devnet.solana.com"
//
//    func endPoint() -> String {
//        switch self {
//        case .ETH:
//            return WalletChainType.endPointETHMainnet
//        case .ETHTEST:
//            return WalletChainType.endPointETHTestnet
//        case .BSC:
//            return WalletChainType.endPointBSCMainnet
//        case .BSCTEST:
//            return WalletChainType.endPointBSCTestnet
//        case .Polygon:
//            if let urlStr = CSSDKManager.shared.rpc_node {
//                return urlStr
//            } else {
//                return WalletChainType.endPointPolygonMainnet
//            }
//        case .Mumbai:
//            return WalletChainType.endPointMumbaiTestnet
//        case .PTest:
//            return WalletChainType.endPointPTestnet
//        default:
//            return ""
//        }
//    }
//
//}

enum WalletChainType: String, CaseIterable {
    case ALL = "ALL"
    case ETH = "Ethereum"
    case ETHTEST = "Ethereum-TEST"
    case BSC = "BSC"
    case BSCTEST = "BSC-TEST"
    /// Polygon
    case Polygon = "Polygon"
    case Platon = "Platon"
    /// Polygon test
    case PTest = "PTest"
    case Mumbai = "Mumbai"
    
    static func chainType() -> WalletChainType {
        if kShowWalletTestChain {
            return .PTest
        } else {
            return .Polygon
        }
    }
    
    var name : String {
        return self.rawValue
    }
    
    func chainId() -> Int {
        switch self {
        case .ETH:
            return 1
        case .ETHTEST:
            return 42
        case .BSC:
            return 56
        case .BSCTEST:
            return 97
        case .Polygon:
            return 137
        case .Platon:
            return 210425
        case .Mumbai:
            return 80001
        case .PTest:
            return 3
        default:
            return 0
        }
    }
    
    fileprivate static let endPointETHMainnet = "https://mainnet.infura.io/v3/dc8db8da40c34114ac9f892bd47d8878"
    fileprivate static let endPointETHTestnet = "https://mainnet.infura.io/v3/dc8db8da40c34114ac9f892bd47d8878"
    fileprivate static let endPointBSCMainnet = "https://bsc-dataseed.binance.org/"
    fileprivate static let endPointBSCTestnet = "https://data-seed-prebsc-1-s1.binance.org:8545/"
    fileprivate static let endPointPolygonMainnet = "https://fastrpc.crazysnake.io/"
    fileprivate static let endPointPlatonMainnet = "https://fastrpc.crazysnake.io/platon"
//    fileprivate static let endPointPolygonMainnet = "https://polygon-mainnet.g.alchemy.com/v2/vHM6_6FA0kId6hqHe9sMtUrR6U5nYd7F"
//    fileprivate static let endPointMumbaiTestnet = "https://rpc-mumbai.maticvigil.com"
    fileprivate static let endPointMumbaiTestnet = "https://rpc-mumbai.matic.today"
    fileprivate static let endPointPTestnet = "https://ropsten.infura.io/v3/b3acc2ce56344d229d48d2c1fa5bd51f"

    fileprivate static let endPointSolanaMainnet = "https://api.mainnet-beta.solana.com"
    fileprivate static let endPointSolanaTestnet = "https://api.testnet.solana.com"
//    fileprivate static let endPointSolanaTestnet = "https://api.devnet.solana.com"

    func endPoint() -> String {
        switch self {
        case .ETH:
            return WalletChainType.endPointETHMainnet
        case .ETHTEST:
            return WalletChainType.endPointETHTestnet
        case .BSC:
            return WalletChainType.endPointBSCMainnet
        case .BSCTEST:
            return WalletChainType.endPointBSCTestnet
        case .Polygon:
            return WalletChainType.endPointPolygonMainnet
        case .Platon:
            return WalletChainType.endPointPlatonMainnet
        case .Mumbai:
            return WalletChainType.endPointMumbaiTestnet
        case .PTest:
            return WalletChainType.endPointPTestnet
        default:
            return ""
        }
    }
    
    func isTestChain() -> Bool {
        switch self {
        case .ETH:
            return false
        case .ETHTEST:
            return true
        case .BSC:
            return false
        case .BSCTEST:
            return true
        case .Polygon:
            return false
        case .Mumbai:
            return true
        case .PTest:
            return true
        default:
            return false
        }
    }
}
