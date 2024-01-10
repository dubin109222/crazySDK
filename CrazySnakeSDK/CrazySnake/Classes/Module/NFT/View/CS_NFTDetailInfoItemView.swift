//
//  CS_NFTDetailInfoItemView.swift
//  CrazySnake
//
//  Created by Lee on 13/03/2023.
//

import UIKit

class CS_NFTDetailInfoItemView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .right
        return label
    }()

}

//MARK: UI
extension CS_NFTDetailInfoItemView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(amountLabel)
        
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(28)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(0)
        }
    }
}


class CS_NFTDetailInfoStarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIcon(_ color: UIColor?, image: UIImage?) {
        let icon = image?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = color
        iconView.image = icon
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var starView: CS_NFTStarView = {
        let view = CS_NFTStarView()
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .right
        return label
    }()

}

//MARK: UI
extension CS_NFTDetailInfoStarView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(starView)
        addSubview(amountLabel)
        
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(28)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(0)
        }
        
        starView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(amountLabel.snp.left).offset(-4)
            make.width.equalTo(96)
            make.height.equalTo(14)
        }
    }
}
