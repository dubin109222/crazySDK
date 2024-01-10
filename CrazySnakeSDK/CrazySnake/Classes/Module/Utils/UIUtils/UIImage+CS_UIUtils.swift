//
//  UIImage+CS_UIUtils.swift
//  CrazySnake
//
//  Created by Lee on 10/03/2023.
//

import UIKit

extension UIImage{
    
    class func ls_placeHolder() -> UIImage? {
        return UIImage.ls_bundle( "icon_loading_data@2x")
    }
    
    
    
    class func ls_placeHeader() -> UIImage? {
        return UIImage.ls_bundle( "common_default_head_icon@2x")
    }
    
}
