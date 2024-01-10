//
//  CS_StakeRecordInfoView.swift
//  CrazySnake
//
//  Created by Lee on 17/03/2023.
//

import UIKit

class CS_StakeRecordInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#CDA4FF"), .ls_JostRomanFont(16))
        label.textAlignment = .center
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()
}

//MARK: UI
extension CS_StakeRecordInfoView {
    
    private func setupView() {
        
        backgroundColor = .ls_color("#362B60")
        ls_cornerRadius(15)
        
        addSubview(amountLabel)
        addSubview(nameLabel)
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-4)
        }
    }
}
