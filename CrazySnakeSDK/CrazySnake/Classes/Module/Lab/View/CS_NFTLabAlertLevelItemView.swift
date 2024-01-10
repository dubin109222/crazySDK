//
//  CS_NFTLabAlertLevelItemView.swift
//  CrazySnake
//
//  Created by Lee on 01/03/2023.
//

import UIKit

class CS_NFTLabAlertLevelItemView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var oldLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .right
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "icon_NFTLab_alert_arrow@2x")
        return view
    }()
    
    lazy var nowLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#7DF958"), .ls_JostRomanFont(16))
        label.textAlignment = .left
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(0.5), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()

}

//MARK: UI
extension CS_NFTLabAlertLevelItemView {
    
    private func setupView() {
        
        addSubview(oldLabel)
        addSubview(iconView)
        addSubview(nowLabel)
        addSubview(nameLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
            make.width.height.equalTo(18)
        }
        
        oldLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.right.equalTo(iconView.snp.left).offset(-4)
        }
        
        nowLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(4)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(8)
        }
    }
}


class CS_NFTLabAlertLevelStarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var oldStarView: CS_NFTStarView = {
        let label = CS_NFTStarView()
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "icon_NFTLab_alert_arrow@2x")
        return view
    }()
    
    lazy var nowStarView: CS_NFTStarView = {
        let label = CS_NFTStarView()
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(0.5), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()

}

//MARK: UI
extension CS_NFTLabAlertLevelStarView {
    
    private func setupView() {
        
        addSubview(oldStarView)
        addSubview(iconView)
        addSubview(nowStarView)
        addSubview(nameLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
            make.width.height.equalTo(18)
        }
        
        oldStarView.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.right.equalTo(iconView.snp.left).offset(-4)
            make.width.equalTo(94)
            make.height.equalTo(12)
        }
        
        nowStarView.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(4)
            make.width.equalTo(94)
            make.height.equalTo(12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(8)
        }
    }
}
