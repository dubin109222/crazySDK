//
//  CS_HomeSocialCell.swift
//  CrazySnake
//
//  Created by Lee on 10/04/2023.
//

import UIKit

class CS_HomeSocialCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func itemSize() -> CGSize {
        return CGSize(width: 160, height: 105)
    }
    
    func setData(_ model: CS_HomeSocialModel){
        iconView.image = UIImage.ls_bundle(model.icon)
        titleLabel.text = model.title
    }
    
    lazy var backView: UIView = {
        let layerView = UIView()
        layerView.frame = CGRect(x: 0, y: 0, width: 140, height: 91)
        layerView.layer.shadowColor = UIColor(red: 0.83, green: 0.74, blue: 1, alpha: 1).cgColor
        layerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        layerView.layer.shadowOpacity = 1
        layerView.layer.shadowRadius = 5
        layerView.backgroundColor = .ls_color("#201D27")
        layerView.layer.cornerRadius = 15;
        return layerView
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(21))
        label.textAlignment = .center
        return label
    }()
}

//MARK: UI
extension CS_HomeSocialCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(91)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.top.equalTo(backView).offset(16)
            make.width.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.top.equalTo(iconView.snp.bottom).offset(8)
        }
    }
}
