//
//  UIButton+Extension.swift
//  ActivitiesAlbum
//
//  Created by Lee on 2018/10/22.
//  Copyright © 2018年 7moor. All rights reserved.
//

import UIKit



extension UIButton{
    
    enum LayoutStyle:UInt8 {
        case imageTop
        case imageBottom
        case imageLeft
        case imageRight
    }
    

    func ls_layout(_ style: LayoutStyle, padding: CGFloat = 2.0){
        self.contentMode = .center

        let imageWith = self.imageView?.frame.size.width ?? 0.0
        let imageHeight = self.imageView?.frame.size.height ?? 0.0
        let labelWidth = self.titleLabel?.intrinsicContentSize.width ?? 0.0
        let labelHeight = self.titleLabel?.intrinsicContentSize.height ?? 0.0
        
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        switch style {
        case .imageTop:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-padding/2.0, left: 0, bottom: 0, right: -labelWidth);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith, bottom: -imageHeight-padding/2.0, right: 0);
        case .imageBottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-padding/2.0, right: -labelWidth);
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-padding/2.0, left: -imageWith, bottom: 0, right: 0);
        case .imageLeft:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -padding/2.0, bottom: 0, right: padding/2.0);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: padding/2.0, bottom: 0, right: -padding/2.0);
        case .imageRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+padding/2.0, bottom: 0, right: -(labelWidth+padding/2.0));
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWith+padding/2.0), bottom: 0, right: imageWith+padding/2.0);
        }
        
        
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
        
    }
    

//    func ls_border(color: UIColor,width: CGFloat = 0.5){
//        self.layer.borderWidth = width
//        self.layer.borderColor = color.cgColor
//    }
    

//    func ls_addColorLayer(_ begin:UIColor,_ end:UIColor){
//        let bgLayer = CAGradientLayer()
//        bgLayer.colors = [begin.cgColor, end.cgColor]
//        bgLayer.locations = [0, 1]
//        bgLayer.frame = self.bounds
//        bgLayer.startPoint = CGPoint(x: 0.97, y: 0.58)
//        bgLayer.endPoint = CGPoint(x: 0.28, y: 0.28)
//        self.layer.insertSublayer(bgLayer, at: 0)
//    }
    
    func ls_addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event = UIControl.Event.touchUpInside) {
        self.addTarget(target, action: action, for: controlEvents)
    }
    
    func ls_set(text: String, color: UIColor, font: UIFont){
        self.setTitle(text, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
    }
    
    func ls_set(text: String, color: UIColor, font: UIFont, bgColor: UIColor,_ target: Any?, action: Selector, for controlEvents: UIControl.Event = UIControl.Event.touchUpInside){
        self.setTitle(text, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = bgColor
        self.addTarget(target, action: action, for: controlEvents)
    }
    
    func ls_animationCodeBtn(second: Int, done:@escaping ()->()){
        if second != 0 {
            let title = "(\(second)s)"
            self.setTitle(title, for: .normal)
            self.isEnabled = false
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+1) {
                DispatchQueue.main.async {
                    self.ls_animationCodeBtn(second: second - 1, done: done)
                }
            }
        }else{
            self.isEnabled = true
            self.setTitle("obtain code", for: .normal)
            done()
        }
    }
    
    func ls_addShadowAndCorner(color: UIColor,_ shadowColor: UIColor, corner: CGFloat, size: CGSize, radius: CGFloat){
        self.layer.cornerRadius = corner
        self.layer.backgroundColor = color.cgColor
        self.layer.shadowOffset = size
        self.layer.shadowRadius = radius
        self.layer.cornerRadius = corner
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.masksToBounds = false
    }
    
}

