//
//  UIView+Extension.swift
//  ActiveProject
//
//  Created by Lee on 2018/8/14.
//  Copyright © 2018年 7moor. All rights reserved.
//

import UIKit

extension NSObject {
    // 获取设备方向
    func getCurrentDeviceOrientation() -> UIInterfaceOrientation {
          if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
              return windowScene.interfaceOrientation
          }
          return .unknown
      }
    
    func isLandscape() -> Bool {
        if self.getCurrentDeviceOrientation() == .landscapeLeft
            || self.getCurrentDeviceOrientation() == .landscapeRight {
            return true
        }
        return false
    }
}

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.masksToBounds = (newValue > 0)
            layer.cornerRadius = newValue
        }
    }

    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return layer.borderUIColor
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    
        
    func ls_border(color: UIColor,width: CGFloat = 1){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func ls_cornerRadius(_ corner: CGFloat){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = corner
    }
    
    func ls_addCorner(_ roundingCorners: UIRectCorner, cornerRadius: CGFloat) {
        let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        layer.mask = cornerLayer
    }
    
    func ls_addCornerRadius(topLeft: CGFloat, topRight: CGFloat, bottomRight: CGFloat, bottomLeft: CGFloat) {
        
        let path1 = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.width/2.0, height: bounds.height/2.0), byRoundingCorners: .topLeft, cornerRadii: CGSize(width: topLeft, height: topLeft))
        let path2 = UIBezierPath(roundedRect: CGRect(x: bounds.width/2.0, y: 0, width: bounds.width/2.0, height: bounds.height/2.0), byRoundingCorners: .topRight, cornerRadii: CGSize(width: topRight, height: topRight))
        let path3 = UIBezierPath(roundedRect: CGRect(x: bounds.width/2.0, y: bounds.height/2.0, width: bounds.width/2.0, height: bounds.height/2.0), byRoundingCorners: .bottomRight, cornerRadii: CGSize(width: bottomRight, height: bottomRight))
        let path4 = UIBezierPath(roundedRect: CGRect(x: 0, y: bounds.height/2.0, width: bounds.width/2.0, height: bounds.height/2.0), byRoundingCorners: .bottomLeft, cornerRadii: CGSize(width: bottomLeft, height: bottomLeft))
        path1.append(path2)
        path1.append(path3)
        path1.append(path4)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path1.cgPath
        layer.mask = cornerLayer
    }
    

    
//    @discardableResult
//    func setGradient(colors: [UIColor], startPoint: CGPoint ,endPoint: CGPoint) -> CAGradientLayer {
//        func setGradient(_ layer: CAGradientLayer) {
//            self.layoutIfNeeded()
//            var colorArr = [CGColor]()
//            for color in colors {
//                colorArr.append(color.cgColor)
//            }
//            CATransaction.begin()
//            CATransaction.setDisableActions(true)
//            layer.frame = self.bounds
//            CATransaction.commit()
//
//            layer.colors = colorArr
//            layer.startPoint = startPoint
//            layer.endPoint = endPoint
//        }
//        var gradientLayerStr = "gradientLayerStr"
//        if let gradientLayer = objc_getAssociatedObject(self, &gradientLayerStr) as? CAGradientLayer {
//            setGradient(gradientLayer)
//            return gradientLayer
//        }else {
//            let gradientLayer = CAGradientLayer()
//            self.layer.insertSublayer(gradientLayer , at: 0)
//            setGradient(gradientLayer)
//            objc_setAssociatedObject(self, &gradientLayerStr, gradientLayer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            return gradientLayer
//        }
//    }
    
    @discardableResult
    func ls_addColorLayerPurpose() -> CAGradientLayer{
        ls_addColorLayer(.ls_color("#7A56E1"), .ls_color("#8E56E1"))
    }
    
    @discardableResult
    func ls_addColorLayer(_ begin:UIColor,_ end:UIColor,cornerRadius:CGFloat = 0) -> CAGradientLayer{
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [begin.cgColor, end.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = self.bounds
//        bgLayer.startPoint = CGPoint(x: 0.28, y: 0.28)
//        bgLayer.endPoint = CGPoint(x: 0.97, y: 0.58)
        bgLayer.startPoint = CGPoint(x: 0, y: 0)
        bgLayer.endPoint = CGPoint(x: 1, y: 1)
        bgLayer.cornerRadius = cornerRadius
        self.layer.insertSublayer(bgLayer, at: 0)
        return bgLayer
    }
    
    @discardableResult
    func ls_addColorLayer(begin:UIColor,middle:UIColor, end:UIColor,cornerRadius:CGFloat = 0) -> CAGradientLayer{
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [begin.cgColor,middle.cgColor, end.cgColor]
        bgLayer.locations = [0, 0.49, 1]
        bgLayer.frame = self.bounds
        bgLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        bgLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        bgLayer.startPoint = CGPoint(x: 0, y: 0)
//        bgLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.cornerRadius = cornerRadius
        self.layer.insertSublayer(bgLayer, at: 0)
        return bgLayer
    }

    func ls_addVerticalLayer(_ begin:UIColor,_ end:UIColor,cornerRadius:CGFloat = 0){
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [begin.cgColor, end.cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.frame = self.bounds
        bgLayer.startPoint = CGPoint(x: 0.45, y: 0)
        bgLayer.endPoint = CGPoint(x: 0.93, y: 0.93)
        self.layer.insertSublayer(bgLayer, at: 0)
    }
    
    func ls_drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1.5, lineLength: Int = 6, lineSpacing: Int = 4,isVertical: Bool = false) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: width/2, y: height/2)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 0
        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
                
        let path = CGMutablePath()
        
        if isVertical {
            ///起点
            path.move(to: CGPoint(x: 0, y: 0))
            ///纵向 Y = view 的height
            path.addLine(to: CGPoint(x: 0, y: frame.height))
        } else {
            ///起点
            path.move(to: CGPoint(x: 0, y: 0))
            
            ///终点
            ///  横向 y = 0
            //        path.addLine(to: CGPoint(x: 0, y: 0))
            ///纵向 Y = view 的height
            path.addLine(to: CGPoint(x: width, y: 0))
        }
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
}

//  设置边线颜色
extension CALayer {
        var borderUIColor: UIColor {
            get {
                return UIColor(cgColor: self.borderColor!)
            } set {
                self.borderColor = newValue.cgColor
            }
        }
}
/// MARK - UIView
extension UIView {
        
    public var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }
    
    public var top:CGFloat {
        get {
            return self.frame.origin.y
        }

        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }

    public var width:CGFloat {
       get {
           return self.frame.size.width
       }
       
       set(newWidth) {
           var frame = self.frame
           frame.size.width = newWidth
           self.frame = frame
       }
    }
       
    public var height:CGFloat {
       get {
           return self.frame.size.height
       }
       
       set(newHeight) {
           var frame = self.frame
           frame.size.height = newHeight
           self.frame = frame
       }
    }
       
    public var right:CGFloat {
        get {
            return self.left + self.width
        }
        
        set(newRight) {
            var frame = self.frame
            frame.origin.x = newRight - frame.width
            self.frame = frame
        }
    }

    public var bottom:CGFloat {
      get {
          return self.top + self.height
      }
        
        set(newBottom) {
            var frame = self.frame
            frame.origin.y = newBottom - frame.height
            self.frame = frame
        }
    }
      
      public var centerX:CGFloat {
          get {
              return self.center.x
          }
          
          set(newCenterX) {
              var center = self.center
              center.x = newCenterX
              self.center = center
          }
      }
      
      public var centerY:CGFloat {
          get {
              return self.center.y
          }
          
          set(newCenterY) {
              var center = self.center
              center.y = newCenterY
              self.center = center
          }
      }
      
}

