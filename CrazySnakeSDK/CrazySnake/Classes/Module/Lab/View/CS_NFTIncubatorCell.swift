//
//  CS_NFTIncubatorCell.swift
//  CrazySnake
//
//  Created by Lee on 06/03/2023.
//

import UIKit

class CS_NFTIncubatorCell: UICollectionViewCell {
    
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
    
    lazy var backView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("lab_incubation_bg_indicator@2x")
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .right
        return label
    }()
}

//MARK: open
extension CS_NFTIncubatorCell {
    
    class func itemSize() -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

//MARK: UI
extension CS_NFTIncubatorCell {
    
    fileprivate func setupView() {
        contentView.addSubview(backView)
        contentView.addSubview(iconView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(titleLabel)
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.width.equalTo(80)
            make.height.equalTo(73)
            make.centerX.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalTo(backView)
            make.width.equalTo(60)
            make.height.equalTo(53)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.right.equalTo(backView)
            make.bottom.equalTo(backView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(16)
            make.left.equalTo(6)
            make.right.equalTo(-6)
        }
    }
}
