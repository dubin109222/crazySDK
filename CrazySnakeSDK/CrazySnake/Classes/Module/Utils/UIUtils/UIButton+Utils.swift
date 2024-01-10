//
//  UIButton+Utils.swift
//  Platform
//
//  Created by Lee on 23/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit


extension UIButton{
    class func createThemeButton() -> CS_TFButton {
        let button = CS_TFButton()
        button.layer.cornerRadius = 9
        button.layer.masksToBounds = true
        button.setBackgroundImage(UIImage.ls_image(.ls_theme()), for: .normal)
        button.titleLabel?.font = UIFont.ls_boldFont(17)
        button.setTitleColor(UIColor.ls_dark_2(), for: .normal)
        return button
    }
    
    class func createThemeButton(_ title:String) -> CS_TFButton {
        let button = CS_TFButton()
        button.layer.cornerRadius = 9
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.ls_boldFont(17)
        
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .selected)
        button.setTitle(title, for: .disabled)

        button.setTitleColor(.ls_dark_2(), for: .normal)
        button.setTitleColor(.ls_dark_2(), for: .selected)
        button.setTitleColor(.ls_gray(), for: .disabled)
        
        button.setBackgroundImage(.ls_image(.ls_theme()), for: .normal)
        button.setBackgroundImage(.ls_image(.ls_yellow()), for: .selected)
        button.setBackgroundImage(.ls_image(.ls_light()), for: .disabled)
        
        return button
    }
    
    class func purposeLayerButton(_ frame:CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.ls_cornerRadius(7)
        button.setBackgroundImage(UIImage.ls_bundle("common_bg_button_purpose@2x"), for: .normal)
        button.setBackgroundImage(UIImage.ls_image(.ls_text_gray(),viewSize: CGSize(width: frame.size.width, height: frame.size.height)), for: .disabled)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        return button
    }

}
