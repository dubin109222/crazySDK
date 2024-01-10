//
//  CS_ShareWithdrawItemCell.swift
//  CrazySnake
//
//  Created by Lee on 15/05/2023.
//

import UIKit

class CS_ShareWithdrawItemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_color("#F8F8F8")
        return view
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    lazy var cornerIconView: UIImageView = {
        let view = UIImageView()
        view.image = .ls_named("share_icon_corner_cover@2x")
        view.isHidden = true
        return view
    }()
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = .ls_named("icon_token_land@2x")
        return view
    }()
    
    lazy var shadowView: UIImageView = {
        let view = UIImageView()
        view.image = .ls_named("share_icon_shadow@2x")
        return view
    }()
    
    lazy var cashLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.text = "crazy_str_cash_value".ls_localized
        return label
    }()
    
    lazy var cashAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_boldFont(19))
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(10))
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
}

//MARK: data
extension CS_ShareWithdrawItemCell {
    func setData(_ data: CS_ShareWithdrawItemModel?, selected: CS_ShareWithdrawItemModel?) {
        guard let data = data else { return }
        cashAmountLabel.text = data.cash
        infoLabel.text = data.describe
        
        if data.cash == selected?.cash {
            cornerIconView.isHidden = false
            infoView.backgroundColor = .ls_color("#453B59")
        } else {
            cornerIconView.isHidden = true
            infoView.backgroundColor = .ls_dark_3()
        }
        
    }
}


//MARK: open
extension CS_ShareWithdrawItemCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: 146, height: 100)
    }
}

//MARK: UI
extension CS_ShareWithdrawItemCell {
    
    fileprivate func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(infoView)
        backView.addSubview(cornerIconView)
        infoView.addSubview(shadowView)
        infoView.addSubview(tokenIcon)
        infoView.addSubview(cashLabel)
        infoView.addSubview(cashAmountLabel)
        infoView.addSubview(infoLabel)
        
        backView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.left.top.equalTo(2)
            make.right.bottom.equalTo(-2)
        }
        
        cornerIconView.snp.makeConstraints { make in
            make.top.right.equalTo(0)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(10)
            make.width.equalTo(42)
            make.height.equalTo(42)
        }
        
        shadowView.snp.makeConstraints { make in
            make.centerX.equalTo(tokenIcon)
            make.top.equalTo(tokenIcon.snp.bottom).offset(-6)
        }
        
        cashLabel.snp.makeConstraints { make in
            make.left.equalTo(tokenIcon.snp.right).offset(10)
            make.bottom.equalTo(shadowView.snp.bottom).offset(0)
        }
        
        cashAmountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(cashLabel).offset(0)
            make.bottom.equalTo(cashLabel.snp.top).offset(0)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(cashLabel.snp.bottom).offset(10)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
    }
}
