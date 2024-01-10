//
//  CS_NFTDispatchModel.swift
//  CrazySnake
//
//  Created by BigB on 2023/9/19.
//

import Foundation
import HandyJSON

// Define the Team model
struct NFT_DisPatch_Team: HandyJSON {
    var id: Int?
    var quality: Int?
    var level: Int?
    var max_level: Int?
    var status: Int?
    var unlock_cond: NFT_DisPatch_UnlockCondition?
    var dispatch_cond: NFT_DisPatch_DispatchCondition?
    var lock_time: Int?
    var remain_time: Int?
    var need_strength: Int?
    var power_scale: [[Int]]?
    var unlock_cond_nft_count: Int?
    var adventure_scale: Int?
    var reward: NFT_DisPatch_Reward?
    var power: Int?
    var stakingid: Int?
    var staking: NFT_DisPatch_Staking?
}

// Define the UnlockCondition model
struct NFT_DisPatch_UnlockCondition: HandyJSON {
    var num: Int?
    var quality: Int?
    var level: Int?
    var level_evolve: Int?
    var slots: Int?
}

// Define the DispatchCondition model
struct NFT_DisPatch_DispatchCondition: HandyJSON {
    var min_power: Int?
    var min_num: Int?
    var max_num: Int?
    var quality: [Int]?
}

// Define the Reward model
struct NFT_DisPatch_Reward: HandyJSON {
    var adventure: Int?
}

// Define the Staking model
struct NFT_DisPatch_Staking: HandyJSON {
    var image: String?
    var nft_count: Int?
    var endTime: Int?
}


// Define the Data model
struct NFT_DisPatch_DataModel: HandyJSON {
    var strength: NFT_DisPatch_Strength?
    var adventure: NFT_DisPatch_Adventure?
    var gas: NFT_DisPatch_Gas?
    var teams: [NFT_DisPatch_Team]?
}

// Define the Strength model
struct NFT_DisPatch_Strength: HandyJSON {
    var balance: Int?
    var prices: [NFT_DisPatch_Strength_Prices]?
    var recover_time: Int?
    var recover_max: Int?
    var recover_speed: Int?
}

struct NFT_DisPatch_Strength_Prices: HandyJSON {
    var price: Int = 0
    var icon: String = "1"
    var num: Int = 0
}

// Define the Adventure model
struct NFT_DisPatch_Adventure: HandyJSON {
    var balance: Int?
}

// Define the Gas model
struct NFT_DisPatch_Gas: HandyJSON {
    var balance: String?
}

