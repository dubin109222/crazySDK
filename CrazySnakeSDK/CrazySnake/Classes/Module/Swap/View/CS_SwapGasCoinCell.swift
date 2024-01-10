//
//  CS_SwapGasCoinCell.swift
//  CrazySnake
//
//  Created by Lee on 28/03/2023.
//

import UIKit

class CS_SwapGasCoinCell: UICollectionViewCell {
    
    var clickConfirmAction: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_SwapGasCoinModel, index: Int) {
        iconView.image = UIImage.ls_bundle("swap_icon_gascoin_\(index+1)@2x")
        amountLabel.text = model.gas_coin
        priceLabel.text = model.need_snake
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_white()
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var bottomBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2()
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("swap_icon_gascoin_3@2x")
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_JostRomanFont(19))
        label.textAlignment = .center
        return label
    }()
    
    lazy var gasCoinLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = TokenName.GasCoin.name()
        return label
    }()
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = TokenName.Snake.icon()
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        return label
    }()
    
    lazy var tokenLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(10))
//        label.text = TokenName.Snake.name()
        label.text = "Snake Token"
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 130, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_confirm_swap".ls_localized, for: .normal)
        return button
    }()
}

//MARK: function
extension CS_SwapGasCoinCell {
    class func itemSize() -> CGSize {
        return CGSize(width: 185, height: 272)
    }
}


//MARK: action
extension CS_SwapGasCoinCell {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        clickConfirmAction?()
    }
}


//MARK: UI
extension CS_SwapGasCoinCell {
    
    fileprivate func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(bottomBackView)
        contentView.addSubview(iconView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(gasCoinLabel)
        contentView.addSubview(tokenIcon)
        contentView.addSubview(priceLabel)
        contentView.addSubview(tokenLabel)
        contentView.addSubview(confirmButton)
        
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomBackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(backView.snp.centerY)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backView).multipliedBy(0.35)
            make.width.equalTo(82)
            make.height.equalTo(70)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(4)
        }
        
        gasCoinLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(amountLabel.snp.bottom).offset(0)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.left.equalTo(47)
            make.centerY.equalTo(backView).multipliedBy(1.4)
            make.width.height.equalTo(24)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(74)
            make.top.equalTo(tokenIcon).offset(-4)
        }
        
        tokenLabel.snp.makeConstraints { make in
            make.left.equalTo(74)
            make.bottom.equalTo(tokenIcon).offset(4)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-12)
            make.width.equalTo(130)
            make.height.equalTo(40)
        }
    }
}
