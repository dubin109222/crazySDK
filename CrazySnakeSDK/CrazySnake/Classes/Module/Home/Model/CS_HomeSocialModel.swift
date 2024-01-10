//
//  CS_HomeSocialModel.swift
//  CrazySnake
//
//  Created by Lee on 10/04/2023.
//

import UIKit

struct CS_HomeSocialModel {
    var icon = ""
    var title = ""
    var link = ""
    var code = ""
    var isWkWebview = false
    
    static func socialList() -> [CS_HomeSocialModel] {
        var list = [CS_HomeSocialModel]()
//        list.append(CS_HomeSocialModel(icon: "home_social_icon_social@2x",title: "Social",link: ""))
        list.append(CS_HomeSocialModel(icon: "home_social_icon_support@2x",title: "crazy_str_support".ls_localized,link: ConfigWebUrl.feedback,isWkWebview: true))
        // FIXME:
//    测试地址：https://service-test.crazysnake.io/feedback/
//    线上地址：https://service.crazyland.io/feedback/
        list.append(CS_HomeSocialModel(icon: "home_social_icon_whitepaper@2x",title: "crazy_str_white_paper".ls_localized,link: "https://whitepaper.crazyland.io/crazy-land/"))
        list.append(CS_HomeSocialModel(icon: "home_social_icon_voucher@2x",title: "Voucher",code: "Voucher"))
        list.append(CS_HomeSocialModel(icon: "home_social_icon_discord@2x",title: "crazy_str_discord".ls_localized,link: "https://discord.gg/vm6RxHXUav"))
        list.append(CS_HomeSocialModel(icon: "home_social_icon_telegram@2x",title: "Telegram",link: "https://t.me/CrazyLand_official"))
        return list
    }
}
