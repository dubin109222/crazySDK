//
//  CS_NFTLabBaseAlert.swift
//  CrazySnake
//
//  Created by Lee on 01/03/2023.
//

import UIKit

class CS_NFTLabBaseAlert: CS_BaseAlert {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backIconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "icon_NFTLab_alert_back_icon@2x")
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
//        view.image = UIImage.ls_bundle( "icon_empty_data")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var lineLeftView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "icon_NFTLab_alert_line_left@2x")
        return view
    }()
    
    lazy var lineRightView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "icon_NFTLab_alert_line_right@2x")
        return view
    }()

}

//MARK: UI
extension CS_NFTLabBaseAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.8)
        backView.addSubview(backIconView)
        backView.addSubview(iconView)
        backView.addSubview(lineLeftView)
        backView.addSubview(lineRightView)
        bringSubviewToFront(titleLabel)
        
        backIconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(36)
            make.width.equalTo(250)
            make.height.equalTo(242)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalTo(backIconView)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        lineLeftView.snp.makeConstraints { make in
            make.top.equalTo(backIconView).offset(187)
            make.right.equalTo(backIconView.snp.centerX).offset(-66)
            make.width.equalTo(100)
            make.height.equalTo(13)
        }
        
        lineRightView.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(lineLeftView)
            make.left.equalTo(backIconView.snp.centerX).offset(66)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.centerX.equalTo(backIconView)
            make.centerY.equalTo(lineLeftView)
        }
        
    }
}
