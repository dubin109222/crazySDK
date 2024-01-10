//
//  LanguageModel.swift
//  CrazySnake
//
//  Created by Lee on 05/12/2022.
//

import UIKit


enum LanguageType: Int {
    case English = 1
    case German = 2
    case Portugal = 3
    case Fanti = 4
    case Spanish = 5
    case Thai = 6
    case Indonesian = 7
    case Vietnamese = 8
    case French = 9
    case Italy = 10
    case Japan = 11
    case Korea = 12
    case Chinese = 13
    
    func local() -> String {
        var icon = "en"
        switch self {
        case .Italy:
            icon = "it"
        case .Fanti:
            icon = "zh"
//            icon = "tw"
        case .English:
            icon = "en"
        case .Chinese:
            icon = "zh"
        case .Portugal:
            icon = "pt"
        case .Korea:
            icon = "ko"
        case .Japan:
            icon = "ja"
        case .Spanish:
            icon = "es"
        case .Thai:
            icon = "th"
        case .Indonesian:
            icon = "in"
        case .French:
            icon = "fr"
        case .German:
            icon = "de"
        case .Vietnamese:
            icon = "vi"
        default:
            icon = "en"
        }
        return icon
    }
}
