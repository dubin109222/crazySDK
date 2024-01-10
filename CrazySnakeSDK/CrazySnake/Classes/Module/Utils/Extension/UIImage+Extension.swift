//
//  UIImage+Extension.swift
//  ActiveProject
//
//  Created by Lee on 2018/8/17.
//  Copyright © 2018年 7moor. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func ls_named(_ named: String?) -> UIImage? {
        guard let named = named else { return nil }
        guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return nil }
        let bundle = Bundle.init(path: bundlePath)
        let imageStr = bundle?.path(forResource: "image/crazySlither\(named)", ofType: "png")
        guard let imageStr = imageStr else { return nil }
        return UIImage(named: imageStr)
    }
    
    class func ls_bundle(_ named: String?) -> UIImage? {
        guard let named = named else { return nil }
        guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return nil }
        let bundle = Bundle.init(path: bundlePath)
        let imageStr = bundle?.path(forResource: "image/crazySlither\(named)", ofType: "png")
        guard let imageStr = imageStr else { return nil }
        return UIImage(named: imageStr)
    }
    
    class func ls_bundleImageJpg(named: String?) -> UIImage? {
        guard let named = named else { return nil }
        guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return nil }
        let bundle = Bundle.init(path: bundlePath)
        let imageStr = bundle?.path(forResource: "image/crazySlither\(named)", ofType: "jpg")
        guard let imageStr = imageStr else { return nil }
        return UIImage(named: imageStr)
    }
    
    class func ls_image(_ color: UIColor, viewSize: CGSize = CGSize(width: 4, height: 4)) -> UIImage{
        let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
    
    func ls_crop(_ rect: CGRect) -> UIImage? {
        var newRect = rect
        newRect.origin.x *= scale
        newRect.origin.y *= scale
        newRect.size.width *= scale
        newRect.size.height *= scale
        guard let imageRef = self.cgImage?.cropping(to: newRect) else { return nil }
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
    
    func ls_resize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
 
    func ls_scaleToFitAtCenter(size: CGSize) -> UIImage? {
        let scaleW_H = size.width / size.height
        let selfScaleW_H = self.size.width / self.size.height
        
        if selfScaleW_H > scaleW_H {
            let w = self.size.height * scaleW_H
            let h = self.size.height
            let x = (self.size.width - w) / 2.0
            let y: CGFloat = 0
            return self.ls_crop(CGRect(x: x, y: y, width: w, height: h))?.ls_resize(size)
        } else {
            let w = self.size.width
            let h = self.size.width / scaleW_H
            let x: CGFloat = 0
            let y = (self.size.height - h) / 2.0
            return self.ls_crop(CGRect(x: x, y: y, width: w, height: h))?.ls_resize(size)
        }
    }
    
    func ls_toData() -> Data? {
        var data = self.pngData()
        if (data == nil) || data?.count == 0 {
            data = self.jpegData(compressionQuality: 1.0)
        }
        return data
    }
}
