//
//  CS_BaseChooseAlert.swift
//  Platform
//
//  Created by Lee on 04/05/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit

fileprivate let LS_AnimationDuration = 0.1

class CS_BaseChooseAlert: UIView {

    var tapDismissEnable = true
    
    var clickCloseBlock: CS_NoParasBlock?
    
    var didDismissBlock: CS_NoParasBlock?

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: CS_kScreenW, height: CS_kScreenH))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView(frame: bounds)
        view.backgroundColor = UIColor.clear
        view.alpha = 0
        view.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapBackViewGesture(_:)))
        view.addGestureRecognizer(tap)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBackViewGesture(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBackViewGesture(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBackViewGesture(_:)))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBackViewGesture(_:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        
        return view
    }()
    
    lazy var contentView: UIImageView = {
        let view = UIImageView()
//        view.image = UIImage.ls_bundle( "bg_choose_alert")
        view.backgroundColor = .ls_dark_2(0.8)
        view.cornerRadius = 15
        view.isUserInteractionEnabled = true
        return view
    }()
}

//MARK: action
extension CS_BaseChooseAlert {
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: LS_AnimationDuration) {
            self.backView.alpha = 1.0
            self.contentView.alpha = 1.0
        }
    }
    
    func dismissSelf() {
        if let block = self.didDismissBlock {
            block()
        }
        self.removeFromSuperview()

    }
    
    
    @objc private func tapBackViewGesture(_ gesture: UITapGestureRecognizer) {
        if tapDismissEnable {
            clickCloseBlock?()
            dismissSelf()
        }
    }
    
    @objc private func swipeBackViewGesture(_ gesture: UISwipeGestureRecognizer) {
        if tapDismissEnable {
            clickCloseBlock?()
            dismissSelf()
        }
    }
    
    @objc func clickCloseButton(_ sender: UIButton) {
        clickCloseBlock?()
        dismissSelf()
    }
}


//MARK: UI
extension CS_BaseChooseAlert {
    
    private func setupView() {
        addSubview(backView)
        addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self).offset(-20)
            make.width.equalTo(224)
            make.height.equalTo(188)
        }
    }
}
