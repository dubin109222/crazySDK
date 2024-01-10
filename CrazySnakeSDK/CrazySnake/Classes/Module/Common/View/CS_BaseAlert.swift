//
//  CS_BaseAlert.swift
//  Platform
//
//  Created by Lee on 24/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit

fileprivate let LS_AnimationDuration = 0.1

class CS_BaseAlert: UIView {
    
    func dismissSelf() {
        UIView.animate(withDuration: LS_AnimationDuration) {
            self.backView.alpha = 0
        } completion: { finished in
            if let block = self.didDismissBlock {
                block()
            }
            self.removeFromSuperview()
        }

    }

    var tapDismissEnable = true
    
    var clickCloseBlock: CS_NoParasBlock?
    
    var didDismissBlock: CS_NoParasBlock?

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: CS_kScreenW, height: CS_kScreenH))
        _setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView(frame: bounds)
        view.backgroundColor = .clear
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
        view.backgroundColor = .ls_dark_3()
        view.isUserInteractionEnabled = true
        view.layer.shadowColor = UIColor(red: 0.83, green: 0.74, blue: 1, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 15;
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.ls_bundle( "icon_alert_close@2x"), for: .normal)
        button.addTarget(self, action: #selector(clickCloseButton(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(19))
        return label
    }()
}

//MARK: action
extension CS_BaseAlert {
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: LS_AnimationDuration) {
            self.backView.alpha = 1.0
            self.contentView.alpha = 1.0
        }
    }
    
    
    
    @objc private func tapBackViewGesture(_ gesture: UITapGestureRecognizer) {
        endEditing(true)
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
extension CS_BaseAlert {
    
    private func _setupView() {
        addSubview(backView)
        addSubview(contentView)
        addSubview(closeButton)
        contentView.addSubview(titleLabel)
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self).offset(-20)
            make.width.equalTo(224)
            make.height.equalTo(188)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(-1)
            make.right.equalTo(contentView.snp.right).offset(1)
            make.size.equalTo(CGSize(width: 46, height: 46))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.right.equalTo(-62)
            make.centerY.equalTo(closeButton)
        }
    }
}
