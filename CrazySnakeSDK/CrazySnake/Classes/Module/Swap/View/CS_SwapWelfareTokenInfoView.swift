//
//  CS_SwapWelfareTokenInfoView.swift
//  CrazySnake
//
//  Created by Lee on 15/05/2023.
//

import UIKit

class CS_SwapWelfareTokenInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: CS_SwapWelfareItem?) {
        iconView.image = data?.token?.icon()
        tokenLabel.text = data?.token?.name() ?? ""
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#F8F8F8",alpha: 0.09)
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var bottomBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#3A3A3A")
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
//        view.image = TokenName.Snake.icon()
        return view
    }()
    
    lazy var tokenLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#CCCCCC"), .ls_JostRomanFont(12))
        label.textAlignment = .center
//        label.text = TokenName.Snake.name()
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        return label
    }()
    
}

//MARK: UI
extension CS_SwapWelfareTokenInfoView {
    
    fileprivate func setupView() {
        backgroundColor = .clear
        addSubview(backView)
        backView.addSubview(bottomBackView)
        backView.addSubview(iconView)
        backView.addSubview(amountLabel)
        backView.addSubview(tokenLabel)
        
        
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomBackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        tokenLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(2)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.centerY.equalTo(bottomBackView)
        }
    }
}
