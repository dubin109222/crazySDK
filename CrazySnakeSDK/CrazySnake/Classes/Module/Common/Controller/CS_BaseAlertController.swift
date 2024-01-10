//
//  CS_BaseAlertController.swift
//  CrazySnake
//
//  Created by Lee on 03/03/2023.
//

import UIKit

class CS_BaseAlertController: CS_BaseEmptyController {

    var tapDismissEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ls_setupView()
    }
    

    lazy var contentView: UIView = {
        let layerView = UIView()
        layerView.frame = CGRect(x: 78, y: 45, width: CS_kScreenW-78-42, height: CS_kScreenH-45-54)
        // shadowCode
        layerView.layer.shadowColor = UIColor(red: 0.83, green: 0.74, blue: 1, alpha: 1).cgColor
        layerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        layerView.layer.shadowOpacity = 1
        layerView.layer.shadowRadius = 10
        layerView.backgroundColor = .ls_color("#201D27")
        layerView.layer.cornerRadius = 15;
        return layerView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(19))
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.ls_bundle( "icon_alert_close@2x"), for: .normal)
        button.addTarget(self, action: #selector(clickCloseButton(_:)), for: .touchUpInside)
        return button
    }()
    

}


//MARK: action
extension CS_BaseAlertController {
    @objc private func clickCloseButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @objc private func tapBackViewGesture(_ gesture: UITapGestureRecognizer) {
        if tapDismissEnable {
            dismiss(animated: false)
        }
    }
    
    @objc private func swipeBackViewGesture(_ gesture: UISwipeGestureRecognizer) {
        if tapDismissEnable {
            dismiss(animated: false)
        }
    }
}

//MARK: UI
extension CS_BaseAlertController {
    
    private func ls_setupView() {
        
//        view.isUserInteractionEnabled = true
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapBackViewGesture(_:)))
//        view.addGestureRecognizer(tap)
//        
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBackViewGesture(_:)))
//        leftSwipe.direction = .left
//        view.addGestureRecognizer(leftSwipe)
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBackViewGesture(_:)))
//        rightSwipe.direction = .right
//        view.addGestureRecognizer(rightSwipe)
//        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBackViewGesture(_:)))
//        upSwipe.direction = .up
//        view.addGestureRecognizer(upSwipe)
//        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeBackViewGesture(_:)))
//        downSwipe.direction = .down
//        view.addGestureRecognizer(downSwipe)
        
        
        view.backgroundColor = .ls_black(0.8)
        navigationView.isHidden = true
        backView.image = nil
        backView.backgroundColor = .clear
        
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        
//        contentView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(490)
//            make.height.equalTo(250)
//        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(22)
            make.top.equalTo(contentView).offset(12)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(0)
            make.right.equalTo(contentView).offset(0)
            make.width.height.equalTo(44)
        }
    }
}

