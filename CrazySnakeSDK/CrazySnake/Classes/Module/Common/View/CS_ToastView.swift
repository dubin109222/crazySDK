//
//  CS_ToastView.swift
//  Platform
//
//  Created by Lee on 24/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit

enum CS_ToastViewStyle {
    case normal
    case error
    case success
}

fileprivate let CS_ToastViewHeight = CS_kNavBarHeight

fileprivate var vCS_ToastView: CS_ToastView?

class CS_ToastView: UIView {

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: CS_kScreenW, height: CS_ToastViewHeight))
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: CS_kStatusBarHeight, width: CS_kScreenW, height: CS_ToastViewHeight-CS_kStatusBarHeight))
        return view
    }()
        
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_font(14))
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
}

//MARK: action
extension CS_ToastView {
    
    open class func showTitle(_ title: String?) {
        showTitle(title, style: .normal)
    }
    
    open class func showError(_ title: String?) {
        showTitle(title, style: .error)
    }
    
    open class func showSuccess(_ title: String?) {
        showTitle(title, style: .success)
    }
    
    open class func showTitle(_ title: String?, style: CS_ToastViewStyle) {
        guard (title != nil) else {
            return
        }
        
        let view = CS_ToastView()
        if vCS_ToastView != nil {
            vCS_ToastView?.removeFromSuperview()
        }
        vCS_ToastView = view
        view.showTitle(title, style: style)
    }

    open func showTitle(_ title: String?, style: CS_ToastViewStyle) {
        guard (title != nil) else {
            return
        }
        
        titleLabel.text = title
        switch style {
        case .normal:
            backgroundColor = UIColor.ls_gray()
        case .error:
            backgroundColor = UIColor.ls_red()
        case .success:
            backgroundColor = UIColor.ls_color("#16DD5A")
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3) {
            weakSelf?.alpha = 1.0
        } completion: { finished in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
               // code to execute
                weakSelf?.dismiss()
            })
        }

    }
    
    open class func dismiss(){
        if vCS_ToastView != nil {
            UIView.animate(withDuration: 0.3) {
                vCS_ToastView?.alpha = 0
            } completion: { finished in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                   // code to execute
                    vCS_ToastView?.removeFromSuperview()
                })
            }
        }
    }
    
    open func dismiss(){
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3) {
            weakSelf?.alpha = 0
        } completion: { finished in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
               // code to execute
                weakSelf?.removeFromSuperview()
            })
        }
    }
    
}


//MARK: UI
extension CS_ToastView {
    
    private func setupView() {
        self.alpha = 0
        addSubview(backView)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.centerY.equalTo(backView.snp.centerY)
        }
    }
}
