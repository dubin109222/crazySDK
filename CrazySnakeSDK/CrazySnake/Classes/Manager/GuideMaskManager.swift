//
//  GuideMaskManager.swift
//  CrazySnake
//
//  Created by BigB on 2023/12/8.
//
// 管理引导

import UIKit
import HandyJSON



enum GuideTask : String {
    case guide_task_list = "guide_task_list"
    case gas_coin_list = "guide_swap_gas_coin"
    case game_token_list = "guide_swap_game_token"
    case swap_detail = "guide_swap_swap"
    case market_nft = "guide_market"
    case stake_token = "guide_token_stake"
    case nft_list = "guide_my_nft"
    case nft_stake = "guide_nft_stake"
    case nft_level_up = "guide_nft_lab_levelup"
    case nft_evolution = "guide_nft_lab_evolve"
    case nft_recycle = "guide_nft_lab_recall"
    case nft_incubation = "guide_nft_lab_incubation"
    case event = "guide_event"
}


class GuideMaskManager: NSObject {
    public static func checkGuideState(_ key : GuideTask, isFinishHandle: @escaping ((Bool) -> ())) {
        
        UIViewController.current()?.view.isUserInteractionEnabled = false

        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            UIViewController.current()?.view.isUserInteractionEnabled = true
            LSHUD.hide()
            return
        }
        
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["ck_key"] = key
        
        CSNetworkManager.shared.checkAnimation(para) { (model: AnimationModel) in
            UIViewController.current()?.view.isUserInteractionEnabled = true

            isFinishHandle(model.data)

        }
    }
    
    public static func saveGuideState(_ key : GuideTask) {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["ck_key"] = key

        CSNetworkManager.shared.saveAnimation(para) { (resp: AnimationModel) in
            
        }

    }
}
