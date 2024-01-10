//
//  ProfileBoxCollectionCell.swift
//  Platform
//
//  Created by Lee on 20/05/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileBoxCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTPropModel?) {
        guard let model = model else { return }
//        let url = URL.init(string: model.icon)
//        iconView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        iconView.image = model.props_type.iconImage()
        amountLabel.text = "x \(model.num)"
        titleLabel.text = model.props_type.disPlayName()
    }
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 144, height: 152))
        view.backgroundColor = .ls_dark_2()
        view.ls_addCornerRadius(topLeft: 15, topRight: 10, bottomRight: 20, bottomLeft: 10)
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var iconShadow: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 86, height: 9))
        view.backgroundColor = .ls_black()
        view.ls_cornerRadius(28)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        label.textAlignment = .right
        return label
    }()
}

//MARK: open
extension ProfileBoxCollectionCell {
    
    class func itemSize() -> CGSize {
        return CGSize(width: 144, height: 152)
    }
}

//MARK: UI
extension ProfileBoxCollectionCell {
    
    fileprivate func setupView() {
        contentView.addSubview(backView)
        contentView.addSubview(iconShadow)
        contentView.addSubview(iconView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(titleLabel)
        
        backView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.width.equalTo(97)
            make.height.equalTo(83)
            make.centerX.equalToSuperview()
        }
        
        iconShadow.snp.makeConstraints { make in
            make.centerX.equalTo(iconView).offset(-16)
            make.bottom.equalTo(iconView).offset(6)
            make.width.equalTo(86)
            make.height.equalTo(9)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.right.equalTo(iconView)
            make.centerY.equalTo(iconView.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-12)
            make.left.equalTo(2)
            make.right.equalTo(-2)
        }
    }
}
