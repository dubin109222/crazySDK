//
//  UIColor+Extension.swift
//  ActiveProject
//
//  Created by Lee on 2018/8/14.
//  Copyright © 2018年 7moor. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// RGB color 
    static func ls_rgba(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    /// RGB color
    static func ls_color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    

    class func ls_color(_ hexValue: Int,alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(hexValue & 0xFF)) / 255.0,
                       alpha: alpha)
    }
    

    class func ls_color(_ hexValue: String,alpha: CGFloat = 1.0) -> UIColor {
        
        var cString = hexValue.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            
            return UIColor.red
            
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
}

extension UIColor {
    
    static func ls_theme(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#8DE4C3", alpha: alpha)
    }
    
    static func ls_superBlue(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#E5EDFC", alpha: alpha)
    }
    
    static func ls_lightBlue(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#D5E3FB", alpha: alpha)
    }
    
    /// #A3FFAC
    static func ls_blue(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#A3FFAC", alpha: alpha)
    }
    
    /// #FF4C29
    static func ls_red(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#FF4C29", alpha: alpha)
    }
    
    /// #64D393
    static func ls_green(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#64D393", alpha: alpha)
    }
    
    static func ls_yellow(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#E7F061", alpha: alpha)
    }
    
    static func ls_pink(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#F3C9B1", alpha: alpha)
    }
    
    /// #7A56E1
    static func ls_purpose(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#7A56E1", alpha: alpha)
    }
    
    /// #C7A6FF
    static func ls_purpose_01(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#C7A6FF", alpha: alpha)
    }
    
    /// #000000
    static func ls_black(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#000000", alpha: alpha)
    }
    
    /// #222222
    static func ls_dark_2(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#222222", alpha: alpha)
    }
    
    
    /// #333333
    static func ls_dark_3(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#333333", alpha: alpha)
    }
    
    /// #444444
    static func ls_dark_4(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#444444", alpha: alpha)
    }
    
    /// #555555
    static func ls_dark_5(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#555555", alpha: alpha)
    }
    
    /// #666666
    static func ls_dark(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#666666", alpha: alpha)
    }
    
    static func ls_gray(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#AAAAAA", alpha: alpha)
    }
    
    /// #CCCCCC
    static func ls_text_gray(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#CCCCCC", alpha: alpha)
    }
    
    /// #DEDEDE
    static func ls_light(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#DEDEDE", alpha: alpha)
    }
    
    /// #F8F8FA
    static func ls_superLight(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#F8F8FA", alpha: alpha)
    }
    
    /// #FFFFFF
    static func ls_white(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#FFFFFF", alpha: alpha)
    }
    
    /// #999999
    static func ls_text_light(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#999999", alpha: alpha)
    }
    
    static func ls_text_blue(_ alpha: CGFloat = 1.0) -> UIColor {
        return ls_color("#6778C3", alpha: alpha)
    }
}
