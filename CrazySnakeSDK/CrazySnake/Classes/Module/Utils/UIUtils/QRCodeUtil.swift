//
//  QRCodeUtil.swift
//  Platform
//
//  Created by Bob on 2021/9/24.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit

class QRCodeUtil {
    static func setQRCodeToImageView(_ imageView: UIImageView?, _ centerImg: UIImage?, _ url: String?) {
        if imageView == nil || url == nil {
            return
        }
        
        // 创建二维码滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 恢复滤镜默认设置
        filter?.setDefaults()
        
        // 设置滤镜输入数据
        let data = url!.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        
        // 设置二维码的纠错率
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        
        // 从二维码滤镜里面, 获取结果图片
        let image = filter?.outputImage
        
        // 生成一个高清图片
        let transform = CGAffineTransform.init(scaleX: 20, y: 20)
        guard let image = image?.transformed(by: transform) else {
            imageView?.image = nil
            return
        }
        
        // 图片处理
        var resultImage = UIImage(ciImage: image)
        
        // 设置二维码中心显示的小图标
        let center = centerImg ?? UIImage(named: "icon_app")
        resultImage = getClearImage(sourceImage: resultImage, center: center)
        // 显示图片
        imageView?.image = resultImage
    }
    
    // 使图片放大也可以清晰
    static func getClearImage(sourceImage: UIImage, center: UIImage?) -> UIImage {
        
        let size = sourceImage.size
        // 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        // 绘制大图片
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        if let center = center {
            // 绘制二维码中心小图片
            let width: CGFloat = 120
            let height: CGFloat = 120
            let x: CGFloat = (size.width - width) * 0.5
            let y: CGFloat = (size.height - height) * 0.5
            center.draw(in: CGRect(x: x, y: y, width: width, height: height))
        }
        
        // 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
 
        return resultImage!
    }
}

