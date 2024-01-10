//
//  CS_NFTSetsQualitiesView.swift
//  CrazySnake
//
//  Created by Lee on 25/07/2023.
//

import UIKit

class CS_NFTSetsQualitiesView: UIView {
    var qualityWidth = 14.0
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setData(_ qualities:[CS_NFTQuality]){
        subviews.forEach { $0.removeFromSuperview() }
        let borderView = UIView(frame: CGRect(x: 0, y: 0, width: qualityWidth, height: qualityWidth))
        borderView.backgroundColor = .ls_dark_2()
        borderView.ls_cornerRadius(qualityWidth/2.0)
        addSubview(borderView)
        
        let outerView = CS_NFTSetsQualitiesColorView(frame: CGRect(x: 1, y: 1, width: qualityWidth-2, height: qualityWidth-2), qualities: qualities)
        outerView.qualityWidth = qualityWidth - 2
        outerView.backgroundColor = qualities.first?.qualityColor()
        outerView.ls_cornerRadius((qualityWidth-2)/2.0)
        addSubview(outerView)
//        outerView.setData(qualities)
        
        let cornerView = UIView(frame: CGRect(x: 4, y: 4, width: qualityWidth-8, height: qualityWidth-8))
        cornerView.backgroundColor = .ls_dark_2()
        cornerView.ls_cornerRadius((qualityWidth-8)/2.0)
        addSubview(cornerView)
        
        let innerView = UIView(frame: CGRect(x: 5, y: 5, width: qualityWidth-10, height: qualityWidth-10))
        innerView.backgroundColor = qualities.first?.qualityColor()
        innerView.ls_cornerRadius((qualityWidth-10)/2.0)
        addSubview(innerView)
    }
}

class CS_NFTSetsQualitiesColorView: UIView {
    
    var qualityWidth = 9.0
    var qualities:[CS_NFTQuality] = []
    
    init(frame: CGRect, qualities:[CS_NFTQuality]) {
        self.qualities = qualities
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard qualities.count > 0 else {
            return
        }
        //1.获取上下文
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        let center = CGPoint(x: qualityWidth/2.0, y: qualityWidth/2.0)
        
        let radius = qualityWidth/2.0;
        var startA = Double.pi;
        var angle = 0.0;
        var endA = Double.pi;
        let number = 1.0/Double(qualities.count)
        
        for item in qualities {
            //2.拼接路径
            startA = endA;
            angle = number * .pi * 2;
            endA = startA + angle;
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startA, endAngle: endA, clockwise: true)
            path.addLine(to: center)
            item.qualityColor().set()
            //3.把路径添加到上下文
            ctx.addPath(path.cgPath)
            //4.渲染
            ctx.fillPath()
        }

        
    }
    
//    func setData(_ qualities:[CS_NFTQuality]){
//        guard qualities.count > 0 else {
//            return
//        }
//        //1.获取上下文
//        guard let ctx = UIGraphicsGetCurrentContext() else {
//            return
//        }
//        let center = CGPoint(x: qualityWidth/2.0, y: qualityWidth/2.0)
//
//        let radius = qualityWidth/2.0;
//        var startA = 0.0;
//        var angle = 0.0;
//        var endA = 0.0;
//        let number = 1.0/Double(qualities.count)
//
//        for item in qualities {
//            //2.拼接路径
//            startA = endA;
//            angle = number * .pi * 2;
//            endA = startA + angle;
//            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startA, endAngle: endA, clockwise: true)
//            path.addLine(to: center)
//            item.color().set()
//            //3.把路径添加到上下文
//            ctx.addPath(path.cgPath)
//            //4.渲染
//            ctx.fillPath()
//        }
//
//
//    }
    
}

