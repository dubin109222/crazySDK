//
//  GuideMaskView.swift
//  CrazySnake
//
//  Created by BigB on 2023/11/15.
//

import Foundation
import SnapKit
import UIKit

class GuideMaskView: UIViewController {
    
    var bubbleView: BubbleView = BubbleView()
    var maskRect: CGRect? = nil

    var tipsText: String = ""
    var currentStep: String = "1"
    var totalStep: String = "1"
    var showSkip: Bool = true
    var nextHandle: (() -> ())? = nil
    var skipHandle: (() -> ())? = nil

    deinit {
        debugPrint("GuideMaskView deinit")
    }
    
    func createMaskView( contentRect: CGRect , 
                         maskRect: CGRect) -> CALayer {
        let path = UIBezierPath(rect: maskRect)
        
        // 创建一个 UIBezierPath 实例，表示整个视图的路径
        let rectPath = UIBezierPath(rect: contentRect)
        
        // 从整个视图的路径中减去挖空的矩形路径
        // reversing 创建一个反转的路径
        rectPath.append(path.reversing())

        // 创建一个 CAShapeLayer 作为 mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = rectPath.cgPath
        
        return maskLayer
    }


    public static func show (
        tipsText: String = "",
        currentStep: String = "1",
        totalStep: String = "1",
        showSkip: Bool = true,
        maskRect: CGRect? = nil,
        textWidthDefault: CGFloat = 185,
        textWidthSpace: CGFloat = 30,
        textHeightSpace: CGFloat = 70,
        direction: BubbleDirection = .up,
        superView: UIView? = nil,
        nextHandle: (() -> ())? = nil,
        skipHandle:(() -> ())? = nil )
    {
        // 文本框宽度默认185pt 30间距
        let textWidth: CGFloat = textWidthDefault + textWidthSpace
        // 根据文字内容计算文本框高度 70纵向间距
        let textHeight = tipsText.heightWithConstrainedWidth(width: textWidth - 30, font: UIFont.ls_JostRomanFont(12)) + textHeightSpace
        // 根据maskRect计算文本框位置,默认在maskRect下方
        
        var textX = 0.0
        var textY = 0.0
        switch direction {
        case .up:
            textX = (maskRect?.origin.x ?? 0) - textWidth / 2 + (maskRect?.size.width ?? 0) / 2
            textY = (maskRect?.origin.y ?? 0) + (maskRect?.size.height ?? 0) + 10
        case .left:
            textX = (maskRect?.origin.x ?? 0) + (maskRect?.size.width ?? 0) + 10
            textY = (maskRect?.origin.y ?? 0) - textHeight / 2 + (maskRect?.size.height ?? 0) / 2
        case .right:
            textX = (maskRect?.origin.x ?? 0) - textWidth - 10
            textY = (maskRect?.origin.y ?? 0) - textHeight / 2 + (maskRect?.size.height ?? 0) / 2
        case .down:
            textX = (maskRect?.origin.x ?? 0) - textWidth / 2 + (maskRect?.size.width ?? 0) / 2
            textY = (maskRect?.origin.y ?? 0) - textHeight - 10
        }
        
        
        let maskView = GuideMaskView()
        maskView.bubbleView.direction = direction
        maskView.tipsText = tipsText
        maskView.currentStep = currentStep
        maskView.totalStep = totalStep
        maskView.showSkip = showSkip
        maskView.nextHandle = nextHandle
        maskView.skipHandle = skipHandle
        maskView.view.backgroundColor = .ls_color("#0F0F1B",alpha: 0.7)
        maskView.view.frame = UIScreen.main.bounds
        maskView.bubbleView.frame = CGRect(x: textX, y: textY, width: textWidth, height: textHeight)
        
        if currentStep == totalStep {
            maskView.nextBtn.setTitle("I Know", for: .normal)
        }
        
        if superView != nil {
            superView?.addSubview(maskView.view)
        } else {
            UIViewController.current()?.view.addSubview(maskView.view)            
        }
        if let maskRect = maskRect {
            let maskLayout = maskView.createMaskView(contentRect: UIScreen.main.bounds, maskRect: maskRect)
            maskView.view.layer.mask = maskLayout
        }
        UIViewController.current()?.addChild(maskView)
    }

    
    
    lazy var tipsLb: UILabel = {
        let tipsLb = UILabel()
        tipsLb.font = .ls_JostRomanRegularFont(12)
        tipsLb.numberOfLines = 0
        tipsLb.textColor = .ls_color("#8989AE")
        return tipsLb
    }()

    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton()
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.setTitleColor(.ls_color("#FFFFFF"), for: .normal)
        nextBtn.titleLabel?.font = .ls_JostRomanRegularFont(12)
        nextBtn.addTarget(self, action: #selector(nextBtnClick(_:)), for: .touchUpInside)
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 6
        
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor.ls_color("#E988F9").cgColor, UIColor.ls_color("#5479F8").cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = CGRect(x: 0, y: 0, width: 60, height: 24)
        nextBtn.layer.insertSublayer(gradient1, at: 0)

        return nextBtn
    }()

    lazy var skipBtn: UIButton = {
        let skipBtn = UIButton()
        skipBtn.setTitle("Skip", for: .normal)
        skipBtn.setTitleColor(.ls_color("#FFFFFF"), for: .normal)
        skipBtn.titleLabel?.font = .ls_JostRomanRegularFont(12)
        skipBtn.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)

        return skipBtn
    }()

    lazy var currentStepLb: UILabel = {
        let currentStepLb = UILabel()
        currentStepLb.font = .ls_JostRomanRegularFont(12)
        currentStepLb.textColor = .ls_color("#FFFFFF")
        return currentStepLb
    }()

    lazy var totalStepLb: UILabel = {
        let totalStepLb = UILabel()
        totalStepLb.font = .ls_JostRomanRegularFont(12)
        totalStepLb.textColor = .ls_color("#8989AE")
        return totalStepLb
    }()

    @objc func nextBtnClick(_ sender: UIButton) {
        self.nextHandle?()
        self.view.removeFromSuperview()
        self.removeFromParent()
    }

    @objc func skipBtnClick() {
        self.skipHandle?()
        self.view.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.bubbleView)
                
        tipsLb.text = tipsText
        self.view.addSubview(tipsLb)
        self.view.addSubview(nextBtn)
        self.view.addSubview(skipBtn)
        self.view.addSubview(currentStepLb)
        self.view.addSubview(totalStepLb)
        
        
        tipsLb.snp.makeConstraints { make in
            make.top.equalTo(bubbleView).offset(18)
            make.left.equalTo(bubbleView).offset(15)
            make.right.equalTo(bubbleView).offset(-15)
        }

        currentStepLb.text = currentStep
        currentStepLb.snp.makeConstraints { (make) in
            make.left.equalTo(bubbleView).offset(15)
            make.bottom.equalTo(bubbleView).offset(-21)
        }

        totalStepLb.text = "/\(totalStep)"
        totalStepLb.snp.makeConstraints { (make) in
            make.left.equalTo(currentStepLb.snp.right)
            make.bottom.equalTo(bubbleView).offset(-21)
        }

        nextBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bubbleView).offset(-15)
            make.bottom.equalTo(bubbleView).offset(-15)
            make.size.equalTo(CGSize(width: 60, height: 24))
        }

        skipBtn.snp.makeConstraints { (make) in
            make.right.equalTo(nextBtn.snp.left).offset(-15)
            make.bottom.equalTo(bubbleView).offset(-15)
            make.size.equalTo(CGSize(width: 60, height: 24))
        }

        
    }
}
