//
//  Const.swift
//  constellation
//
//  Created by Lee on 2020/4/3.
//  Copyright © 2020 Constellation. All rights reserved.
//

import Foundation
import UIKit

let CS_kKeyWindow = UIApplication.shared.keyWindow!

let CS_kScreenW = UIScreen.main.bounds.size.width

let CS_kScreenH = UIScreen.main.bounds.size.height

let CS_kRate = CS_kScreenW/667.0

let CS_kRateHeight = CS_kScreenH/375.0

//let CS_kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
let kScreenW = UIScreen.main.bounds.size.width

let kScreenH = UIScreen.main.bounds.size.height

let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height

let kNavBarHeight:CGFloat = kStatusBarHeight + 44

let kTabBarHeight:CGFloat = kStatusBarHeight > 20 ? 83:49

let CS_kStatusBarHeight:CGFloat = 20

let CS_kNavBarHeight:CGFloat = CS_kStatusBarHeight + 44

let CS_kSafeAreaHeight:CGFloat = CS_kIsSmallPhone ? 0:20

let CS_kContentHight: CGFloat = CS_kScreenH - CS_kNavBarHeight

let CS_kIsSmallPhone = CS_kScreenW <= 667

let CS_kNavBarHeightPresent = 56

//

let kRegionCode = NSLocale.current.regionCode ?? "US"

let kRegionChina = "CN".elementsEqual(kRegionCode)


// MARK: KEYS

let CS_kAppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

let CS_kAppBuildVersion:String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

/// margin side
func CS_ms(_ margin: Double, padding: Double = 30) -> Double {
    return CS_kIsSmallPhone ? margin : (margin + padding)
}

/// value * CS_kRateHeight
func CS_RH(_ margin: Double) -> Double {
    return margin*CS_kRateHeight
}
