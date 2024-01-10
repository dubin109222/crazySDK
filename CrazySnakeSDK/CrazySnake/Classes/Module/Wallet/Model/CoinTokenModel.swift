//
//  CoinModel.swift
//  Platform
//
//  Created by Lee on 27/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit
import SwiftyJSON
import BigInt
import web3swift
import HandyJSON

enum TokenName: String, HandyJSONEnum {
    case Snake = "SNAKE"
    case SnakeToken = "SnakeToken"
    case USDT = "USDT"
    case GasCoin = "GasCoin"
    case Matic = "Matic"
    case CYT = "CYT"
    case Diamond = "Diamond"
    case FISH = "FISH"
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.rawValue == rhs.rawValue {
            return true
        }
        if (lhs.rawValue == "SNAKE" && rhs.rawValue == "SnakeToken") ||
            (lhs.rawValue == "SnakeToken" && rhs.rawValue == "SNAKE") {
            return true
        }
        return false
    }

    case Diamond2 = "Diamond2"
        
    func name() -> String {
        var type = ""
        switch self {
        case .FISH:
            type = "FISH"
        case .SnakeToken : fallthrough
        case .Snake:
            type = "SNAKE"
        case .USDT:
            type = "USDT"
        case .GasCoin:
            type = "GasCoin"
        case .Matic:
            type = "MATIC"
        case .CYT:
            type = "CYT"
        case .Diamond:
            type = "Diamond"
//        case .FISH:
//            type = "FishToken"
        case .Diamond2:
            type = "Diamond2"
        }
        return type
    }
    
    func freeGasType() -> String {
        var type = ""
        switch self {
        case .FISH: fallthrough
        case .Snake:
            type = "103"
        case .USDT:
            type = "102"
        default:
            type = ""
        }
        return type
    }
    
    func iconName() -> String {
        switch self {
        case .FISH: fallthrough
        case .SnakeToken: fallthrough
        case .Snake:
            return "icon_token_snake@2x"
        case .USDT:
            return "icon_token_usdt@2x"
        case .GasCoin:
            return "icon_token_gascoin@2x"
        case .Matic:
            return "icon_token_matic@2x"
        case .CYT:
            return "icon_token_cyt@2x"
        case .Diamond:
            return "icon_token_diamond@2x"
        case .FISH:
            return "icon_token_snake@2x"
        case .Diamond2:
            return "icon_token_diamond@2x"
//        default:
//            return "icon_token_snake@2x"

        }
    }
    
    func icon() -> UIImage? {
        return UIImage.ls_bundle(iconName())
    }
    
    func balance() -> String {
        
        if let token = CS_AccountManager.shared.coinTokenList.first(where: {$0.token == self}) {
            return token.balance
        }
        return "0"
    }
}

class WalletBalanceResp: RespModel{

    var data : [CoinTokenModel] = [CoinTokenModel]()
    
    override init(_ json: JSON) {
        super.init(json)
//        quality = json["quality"].intValue
        let dataArray = json["data"].arrayValue
        for dataJson in dataArray{
            let value = CoinTokenModel(dataJson)
            data.append(value)
        }
    }
}

struct CoinTokenModel {

    var token: TokenName?
    var contract_address: String = ""
    var balance: String = "0"
    var game_name: String?
    
    init(_ json: JSON){
        token = TokenName(rawValue: json["token"].stringValue)
        contract_address = json["contract_address"].stringValue
        balance = json["balance"].stringValue
        game_name = json["game_name"].stringValue

    }
    
}
