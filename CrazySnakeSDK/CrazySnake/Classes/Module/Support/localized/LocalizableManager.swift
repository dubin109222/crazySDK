//
//  LocalizableManager.swift
//  Platform
//
//  Created by Lee on 07/12/2021.
//  Copyright © 2021 ELFBOX. All rights reserved.
//

import UIKit
import SwiftyAttributes

class LocalizableManager {
    
    static let filePath = "crazy_strings_\(CSSDKManager.shared.language.local()).data"
        
//    static func localize(_ string: String) -> String {
//        var localize = CS_Localized_EN
//        switch CSSDKManager.shared.language {
//        case .English:
//            localize = CS_Localized_EN
//        case .Chinese:
//            localize = CS_Localized_CN
//        default:
//            localize = CS_Localized_EN
//        }
//
//        guard let result = localize[string] else {
//            return string
//        }
//        return result
//    }
    
    struct IosItemAttModel : Codable {
        var color : String
        var content : String
    }

    
    static var localize : [String : [IosItemAttModel]]?
    
    static func localizeModel(_ string : String) -> [IosItemAttModel]? {
        if localize == nil {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return nil }
            guard let bundle = Bundle.init(path: bundlePath) else { return [] }
            
            if let filePath = bundle.path(forResource: filePath, ofType: nil) {
                do {
                    guard let fileDicData = try String.init(contentsOfFile: filePath, encoding: .utf8).data(using: .utf8) else {
                        return nil
                    }
                    let jsonDecoder = JSONDecoder.init()
                    localize = try jsonDecoder.decode([String : [IosItemAttModel]].self, from: fileDicData)
                } catch {
                    return nil
                }
            }
        }
        
        guard localize != nil else {
            debugPrint("⚠️⚠️⚠️ ERROR:localize is nil, check if 'Support.bundle' has the '\(filePath)' file.")
            return nil
        }

        guard let result = localize![string] else {
            return nil
        }
        return result
    }
    
    static func localize(_ string: String , _ arguments: [CVarArg] = []) -> String {

        if let result = self.localizeModel(string) {
            var resultStr = ""
            for item in result {
                resultStr.append(item.content)
            }
            return resultStr

        } else {
            return string
        }
    }
}

public extension String {

    ///
    var ls_localized: String {
        LocalizableManager.localize(self)
    }
    
    func ls_localized(_ arguments: [CVarArg]) -> String {
        let formStr = LocalizableManager.localize(self)
        
        return String.init(format: formStr, arguments)
    }
    
    func ls_localized_color(_ arguments: [CVarArg]) -> NSAttributedString {
        if let result = LocalizableManager.localizeModel(self) {
            var resultAttrM = NSMutableAttributedString()
            
            do {
                var pattern = "%" + "@"
                let regex = try NSRegularExpression(pattern: pattern)
                
                var patternPoint = 0
                
                for item in result {
                    let string = item.content
                    var range = NSRange(string.startIndex..<string.endIndex, in: string)
                    let matches = regex.matches(in: string, options: [], range: range)

                    var colorArguments : [CVarArg] = []
                    if matches.count > 0 {
                        colorArguments.append(contentsOf: arguments[patternPoint..<patternPoint + matches.count])
                        patternPoint += matches.count
                    }
                    
                    let colorStr = String.init(format: item.content, arguments: colorArguments)
                    resultAttrM = resultAttrM + colorStr.withTextColor(.ls_color(item.color))
                }
                return resultAttrM
            }
            catch {
                
            }
        }
        return NSAttributedString()
    }
}
