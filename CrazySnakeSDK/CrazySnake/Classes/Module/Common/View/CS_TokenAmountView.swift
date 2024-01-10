//
//  CS_TokenAmountView.swift
//  CrazySnake
//
//  Created by Lee on 17/07/2023.
//

import UIKit

class CS_TokenAmountView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tokenButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_font(12)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setImage(TokenName.Snake.icon(), for: .normal)
        button.setTitle(TokenName.Snake.rawValue, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.ls_layout(.imageLeft,padding: 6)
        return button
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#46F490"), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()
    
}

//MARK: UI
extension CS_TokenAmountView {
    
    private func setupView() {
        addSubview(tokenButton)
        addSubview(amountLabel)
        
        tokenButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.centerY).offset(1.5)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(tokenButton.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
    }
}
