//
//  NFTModel.swift
//  Platform
//
//  Created by Lee on 27/06/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class NFTDataListResp: BaseRespModel{

    var data : NFTListModel?
}

class CS_NFTUpgradeResp: BaseRespModel{

    var data: CS_NFTDataModel?

}

class NFTListModel: BaseListModel {
//    var quality = 0
    var list : [CS_NFTDataModel] = [CS_NFTDataModel]()
    
}

class NFTDetailResp: BaseRespModel{

    var data : CS_NFTDataModel?
}

enum NFTDataState: Int, HandyJSONEnum {
    case unknow = -1
    case freedom = 0
    case incubating = 10
    case selling = 20
    case list_confirming = 30
    case deposit_confirming = 31
    case staking = 100
    case dispatching = 101
    case setSelling = 200
    case battling = 110
    case disable = 120
    
    func dispalyName () -> String{
        switch self {
        case .battling:
            return "crazy_str_fighting".ls_localized
        case .disable:
            return "Disable".ls_localized
        case .dispatching:
            return "Dispatching".ls_localized
        case .unknow:
            return "unknow".ls_localized
        case .freedom:
            return "Freedom".ls_localized
        case .incubating:
            return "crazy_str_incubation".ls_localized
        case .selling:
            return "crazy_str_market_selling".ls_localized
        case .list_confirming:
            return "crazy_str_with_up_confirming".ls_localized
        case .deposit_confirming:
            return "crazy_str_confirming".ls_localized
        case .staking:
            return "crazy_str_staking".ls_localized
        case .setSelling:
            return "crazy_str_market_selling".ls_localized
        }
    }
}

enum CS_NFTQuality: Int, HandyJSONEnum {
    case unkown
    case quality_1 = 1
    case quality_2 = 2
    case quality_3 = 3
    case quality_4 = 4
    case quality_5 = 5
    case quality_6 = 6
    
    func name() -> String {
        switch self {
        case .quality_1:
            return "Common"
        case .quality_2:
            return "Good"
        case .quality_3:
            return "Excellent"
        case .quality_4:
            return "Rare"
        case .quality_5:
            return "Epic"
        case .quality_6:
            return "Legendary"
        default:
            return "Unkown"
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .quality_1:
            return .ls_color("#8DFF8E")
        case .quality_2:
            return .ls_color("#5DDAFF")
        case .quality_3:
            return .ls_color("#FD95FF")
        case .quality_4:
            return .ls_color("#FFA095")
        case .quality_5:
            return .ls_color("#FFC700")
        case .quality_6:
            return .ls_color("#FF5563")
        default:
            return .ls_color("#999999")
        }
    }
    
    /// 用于绘制系列组的品质说明图（扇形图）
    func qualityColor() -> UIColor {
        switch self {
        case .quality_1:
            return .ls_color("#7AFF65")
        case .quality_2:
            return .ls_color("#4992F9")
        case .quality_3:
            return .ls_color("#B256F7")
        case .quality_4:
            return .ls_color("#FF60B6")
        case .quality_5:
            return .ls_color("#FEC843")
        case .quality_6:
            return .ls_color("#FF4646")
        default:
            return .ls_color("#999999")
        }
    }
    
    func icon() -> UIImage? {
        return UIImage.ls_bundle("nft_icon_nft_quality_\(self.rawValue)@2x")
    }
    
    func iconPower() -> UIImage? {
        return UIImage.ls_bundle("nft_icon_nft_item_power_\(self.rawValue)@2x")
    }
    
    func iconBouns() -> UIImage? {
        return UIImage.ls_bundle("nft_icon_nft_item_bonus_\(self.rawValue)@2x")
    }
    
    func iconIncubate() -> UIImage? {
        return UIImage.ls_bundle("nft_icon_nft_item_incubate_\(self.rawValue)@2x")
    }
}

struct CS_NFTDataModel: HandyJSON {
    
    var id = ""
    var game_id = ""
    var nft_id = ""
    var user_id = ""
    var token_id = ""
    var image = ""
    var json_file = ""
    var sex = 0
    var level = 0
    var type = 0
    var quality = CS_NFTQuality.unkown
    var power = 0
    var power_origin = 0
    var power_base = 0
    var power_evolve = 0
    var level_evolve = 0
    var experience = 0
    var current_experience = 0
    var nft_class = ""
    var is_new = false
    var father = ""
    var mother = ""
    var incubation_current_times = 0
    var status: NFTDataState = .unknow
    var is_chain = 0
    var destroyed_at = ""
    var updated_at = ""
    var created_at = ""
    var incubation_max_times = 0
    var total_power = 0
    var essences = 0
    var evolve: CS_NFTEvolveModel?
    var upgrade: CS_NFTUpgradeModel?
    var user: CS_NFTUserModel?
    var max_upgrade_level = 0
    var profile_image = ""
    var background_id = 0
    var background_image = ""
    var support_games = [String]()
    var contract_name : String = ""
    
    var price: String = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.nft_class <-- "class"
    }
    
    func disPlayName() -> String {
        let languageModel = CS_AccountManager.shared.languageList.first(where: {$0.ID == self.nft_class })

        return languageModel?.name ?? ""
    }

    
    func qualityColor() -> UIColor {
        switch quality {
        case .quality_1:
            return .ls_color("#8DFF8E")
        case .quality_2:
            return .ls_color("#5DDAFF")
        case .quality_3:
            return .ls_color("#FD95FF")
        case .quality_4:
            return .ls_color("#FFA095")
        case .quality_5:
            return .ls_color("#FFC700")
        case .quality_6:
            return .ls_color("#FF5563")
        default:
            return .ls_color("#999999")
        }
    }
}

struct CS_NFTEvolveModel: HandyJSON {
    var current_level: CS_NFTLevelModel?
    var next_level: CS_NFTLevelModel?
    var need_essences = 0
}

struct CS_NFTLevelModel: HandyJSON {
    var type = 0
    var num = 0
    var power = 0
    var level = 0
    
    func iconImage() -> UIImage? {
        if type > 0 && type < 13 {
            return UIImage.ls_bundle( "nft_icon_upgrade_\(type)@2x")
        }
        return UIImage.ls_bundle( "nft_icon_upgrade_1@2x")
    }
}

struct CS_NFTUpgradeModel: HandyJSON {
    var next_level: CS_NFTLevelModel?
    var next_bonus: CS_NFTLevelModel?
    var current_bonus: CS_NFTLevelModel?
}


struct CS_NFTUserModel: HandyJSON {
    var wallet_address = ""
    var name = ""
    var avatar_image = ""
    
    
    func isSelf() -> Bool {
        var isSelf = false
        if wallet_address.lowercased() == CS_AccountManager.shared.accountInfo?.wallet_address?.lowercased() {
            isSelf = true
        }
        return isSelf
    }
}

class CS_NFTPropListResp: BaseRespModel{

    var data : CS_NFTPropListModel?
}

class CS_NFTPropListModel: BaseListModel {
    var list : [CS_NFTPropModel] = [CS_NFTPropModel]()
}

enum CS_NFTPropsType: String,HandyJSONEnum {
    case unkown = ""
    /// 普通孵化器
    case indicatorCommon = "200101"
    /// 良好
    case indicatorGood = "200102"
    /// 优秀
    case indicatorExcellent = "200103"
    /// 稀有
    case indicatorRare = "200104"
    /// 史诗
    case indicatorEpic = "200105"
    /// 传说
    case indicatorLegendary = "200106"
    
    /// 进化精华
    case essenceEvolution = "200201"
    /// 进阶精华
    case essenceAdvanced = "200202"
    case feedSimple = "200301"
    case feedHighGrade = "200302"
    case feedSuper = "200303"
    /// 坑位卡
    case cardSlot = "200304"
    /// 孵化加速器
    case feedIncudate = "200305"
    /// NFT首抽盲盒
    case boxInitial = "301001"
    /// 普通
    case boxCommon = "301002"
    /// 良好
    case boxGood = "301003"
    /// 优秀
    case boxExcellent = "301004"
    /// 稀有
    case boxRare = "301005"
    /// 史诗
    case boxEpic = "301006"
    
    
    func iconImage() -> UIImage? {
        return UIImage.ls_bundle("\(self.rawValue)@2x")
    }
    
    func disPlayName() -> String {
        var name = ""
        
        debugPrint(CSSDKManager.shared.language.local())
        debugPrint(CS_AccountManager.shared.nameDescList)
        
        guard let language = CS_AccountManager.shared.nameDescList.first(where: {$0.language == CSSDKManager.shared.language.local()}) else {
            return name
        }
        
        guard let nameModel = language.data.first(where: {$0.ID == self.rawValue}) else {
            return name
        }
        name = nameModel.name
        return name
    }
    
    func displayDesc() -> String {
        var name = ""
//        debugPrint(CS_AccountManager.shared.nameDescList,CSSDKManager.shared.language.local())
        guard let language = CS_AccountManager.shared.nameDescList.first(where: {$0.language == CSSDKManager.shared.language.local()}) else {
            return name
        }
        
        
        guard let nameModel = language.data.first(where: {$0.ID == self.rawValue}) else {
            return name
        }
        debugPrint("la.. ",nameModel.ID)

        name = nameModel.desc
        return name
    }
    
    func disPlayNameTest() -> String {
        var name = ""
        switch self.rawValue {
        case "200101":
            name = "普通孵化器"
        case "200102":
            name = "良好孵化器"
        case "200103":
            name = "优秀孵化器"
        case "200104":
            name = "稀有孵化器"
        case "200105":
            name = "史诗孵化器"
        case "200106":
            name = "传说孵化器"
        case "200201":
            name = "进化精华"
        case "200202":
            name = "进阶精华"
        case "200301":
            name = "初级饲料包"
        case "200302":
            name = "中级饲料包"
        case "200303":
            name = "高级饲料包"
        case "200304":
            name = "坑位卡"
        case "200305":
            name = "孵化加速器"
        case "301001":
            name = "首抽盲盒"
        case "301002":
            name = "普通盲盒"
        case "301003":
            name = "良好盲盒"
        case "301004":
            name = "优秀盲盒"
        case "301005":
            name = "稀有盲盒"
        case "301006":
            name = "史诗盲盒"
        case "302001":
            name = "普通NFT卡包"
        default:
            name = "unkown"
        }
        return name
    }
    
    
}

struct CS_NFTPropModel: HandyJSON {
    var id = ""
    var user_id = ""
    var item_id = ""
    var num = 0
    var created_at = ""
    var updated_at = ""
    var icon = ""
    var extend_params: CS_NFTPropExtendParams?
    var user: CS_NFTUserModel?
    var frozen_num = 0
    var sub_type = 0
    
    var props_type: CS_NFTPropsType = .unkown
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.props_type <-- "item_id"
    }
    
    func disPlayName() -> String {
        let languageModel = CS_AccountManager.shared.languageList.first(where: {$0.ID == self.item_id })

        return languageModel?.name ?? ""
    }

    
    func showUseButton() -> Bool{
        var show = false
        switch item_id {
        case "301001","301002","301003","301004","301005","301006":
            show = true
        default:
            show = false
        }
        return show
    }
}

struct CS_NFTPropExtendParams: HandyJSON {
    var value = 0
}
