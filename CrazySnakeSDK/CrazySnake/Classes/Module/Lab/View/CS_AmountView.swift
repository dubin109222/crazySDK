//
//  CS_AmountView.swift
//  CrazySnake
//
//  Created by Lee on 08/03/2023.
//

import UIKit

class CS_AmountView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2(0.3)
        view.ls_cornerRadius(10)
        view.ls_border(color: .ls_white(0.2), width: 2)
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        return label
    }()

}

//MARK: UI
extension CS_AmountView {
    
    private func setupView() {
        
        addSubview(backView)
        addSubview(iconView)
        addSubview(amountLabel)
        
        backView.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.left.equalTo(4)
            make.height.equalTo(20)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(26)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(6)
            make.centerY.equalTo(backView)
            make.right.equalTo(backView).offset(-12)
        }
        
    }
}
