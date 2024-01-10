//
//  NavigationView.swift
//  constellation
//
//  Created by Lee on 2020/4/28.
//  Copyright © 2020 Constellation. All rights reserved.
//

import UIKit
import SnapKit

enum CS_NavigationViewStyle: Int {
    
    case defalut = 0
    
    case normal = 1
    
    case present = 2
}

class CS_NavigationView: UIView {
    
    var style : CS_NavigationViewStyle = .defalut
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var backView: UIImageView = {
      let view = UIImageView()
      view.backgroundColor = UIColor.clear
      return view
    }()


    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        let img = UIImage.ls_bundle( "icon_back")
        let backImg = img?.withRenderingMode(.alwaysOriginal)
        button.setImage(backImg, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.ls_font(15)
        button.setTitleColor(UIColor.ls_dark_2(), for: .normal)
        return button
    }()

    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.contentMode = .right
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = UIFont.ls_font(15)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor.ls_blue(), for: .normal)
        button.isHidden = true
        return button
    }()

    lazy var titleImageView: UIImageView = {
        let label = UIImageView()
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#FFFFFF"), .ls_JostRomanFont(19))
        return label
    }()

    lazy var seperateLine: UIView = {
        let view = UIView()
        return view
    }()
    
}

extension CS_NavigationView{
    func changeStyle(_ style: CS_NavigationViewStyle){
        self.style = style
        switch style {
        case .defalut:
            
            self.leftButton.setImage(UIImage.ls_bundle( "icon_back"), for: .normal)
            self.backView.backgroundColor = UIColor.ls_dark_2()
        case .normal:
            
            self.leftButton.setImage(UIImage.ls_bundle( "icon_back"), for: .normal)
            self.backView.image = UIImage.ls_bundle("bg_nav_normal")
            var frame : CGRect = self.frame
            frame.size.height = 44
            self.frame = frame
        case .present:
            self.leftButton.setImage(UIImage.ls_bundle( "icon_back"), for: .normal)
            self.backView.backgroundColor = UIColor.ls_white()
            
            var frame : CGRect = self.frame
            frame.size.height =  56
            self.frame = frame
        }
        
    }
}

fileprivate extension CS_NavigationView{
    func setupView(){
        self.addSubview(backView)
        self.addSubview(leftButton)
        addSubview(titleLabel)
        self.addSubview(titleImageView)
        self.addSubview(rightButton)
        
        backView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }

        leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(-14)
            make.bottom.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        titleImageView.snp.makeConstraints { (make) in
            make.left.equalTo(leftButton.snp.right).offset(0)
            make.centerY.equalTo(leftButton)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(leftButton.snp.right).offset(0)
            make.centerY.equalTo(leftButton)
        }
    }
}
