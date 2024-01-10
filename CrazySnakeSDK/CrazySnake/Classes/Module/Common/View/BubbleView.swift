//
//  BubbleView.swift
//  CrazySnake
//
//  Created by BigB on 2023/11/15.
//

import UIKit

class BubbleView: UIView {

    var direction: BubbleDirection = .up // 上下左右四个方向选择

    override func draw(_ rect: CGRect) {
        
        
        var newRect = rect
        switch direction {
        case .up:
            newRect = .init(origin: .init(x: 0, y: 5), size: .init(width: rect.size.width, height: rect.size.height - 5))
        case .down:
            newRect = .init(origin: .init(x: 0, y: 0), size: .init(width: rect.size.width, height: rect.size.height - 5))
        case .left:
            newRect = .init(origin: .init(x: 5, y: 0), size: .init(width: rect.size.width - 5, height: rect.size.height))
        case .right:
            newRect = .init(origin: .init(x: 0, y: 0), size: .init(width: rect.size.width - 5, height: rect.size.height))
        }
        
        let path = UIBezierPath(roundedRect: newRect, cornerRadius: 10.0)


        switch direction {
        case .up:
            drawUpBubble(path: path)
        case .down:
            drawDownBubble(path: path)
        case .left:
            drawLeftBubble(path: path)
        case .right:
            drawRightBubble(path: path)
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.ls_color("#232335").cgColor
        self.layer.addSublayer(shapeLayer)
    }

    func drawUpBubble(path: UIBezierPath) {
        let width = bounds.width
        let height = bounds.height

        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width / 2 - 7, y: 5))
        path.addLine(to: CGPoint(x: width / 2 + 7, y: 5))
        path.close()

    }

    func drawDownBubble(path: UIBezierPath) {
        let width = bounds.width
        let height = bounds.height

        path.move(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: width / 2 - 7, y: height - 5))
        path.addLine(to: CGPoint(x: width / 2 + 7, y: height - 5))
        path.close()
    }

    func drawLeftBubble(path: UIBezierPath) {
        let width = bounds.width
        let height = bounds.height
        
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addLine(to: CGPoint(x: 5, y: height / 2 - 7))
        path.addLine(to: CGPoint(x: 5, y: height / 2 + 7))
        path.close()
    }

    func drawRightBubble(path: UIBezierPath) {
        let width = bounds.width
        let height = bounds.height
        
        path.move(to: CGPoint(x: width, y: height / 2))
        path.addLine(to: CGPoint(x: width - 5, y: height / 2 - 7))
        path.addLine(to: CGPoint(x: width - 5, y: height / 2 + 7))
        path.close()
    }
}

enum BubbleDirection {
    case up
    case down
    case left
    case right
}
