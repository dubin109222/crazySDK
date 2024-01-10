//
//  UIFont+Extension.swift
//  ActiveProject
//
//  Created by Lee on 2018/8/14.
//  Copyright © 2018年 7moor. All rights reserved.
//

import UIKit

extension UIFont {
    /// （Regular）
    ///
    /// - Parameter size:
    class func ls_font(_ size:CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    /// Medium（Medium）
    ///
    /// - Parameter size:
    class func ls_mediumFont(_ size:CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Medium", size: size) ?? UIFont.boldSystemFont(ofSize:size)
    }
    
    /// Semibold（PingFangSC-Semibold）
    ///
    /// - Parameter size:
    class func ls_boldFont(_ size:CGFloat) -> UIFont {
        return UIFont.init(name: "PingFangSC-Semibold", size: size) ?? UIFont.boldSystemFont(ofSize:size)
    }
    
    /// Luckiest Guy
    ///
    /// - Parameter size:
    class func ls_numFont(_ size:CGFloat) -> UIFont {
        return UIFont.init(name: "Luckiest Guy", size: size) ?? UIFont.boldSystemFont(ofSize:size)
    }
    
    /// JostRoman-Bold
    ///
    /// - Parameter size:
    class func ls_JostRomanFont(_ size:CGFloat) -> UIFont {
        return UIFont.init(name: "JostRoman-Bold", size: size) ?? UIFont.boldSystemFont(ofSize:size)
    }
    
    /// JostRoman-Bold
    ///
    /// - Parameter size:
    class func ls_JostRomanRegularFont(_ size:CGFloat) -> UIFont {
        return UIFont.init(name: "JostRoman-Regular", size: size) ?? UIFont.boldSystemFont(ofSize:size)
    }

    
}
