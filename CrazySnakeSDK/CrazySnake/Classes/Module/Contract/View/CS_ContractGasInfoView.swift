//
//  CS_ContractGasInfoView.swift
//  CrazySnake
//
//  Created by Lee on 20/03/2023.
//

import UIKit

class CS_ContractGasInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#AB73FF"), .ls_JostRomanFont(16))
        return label
    }()
}

//MARK: UI
extension CS_ContractGasInfoView {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(infoLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(-26)
            make.top.equalTo(20)
        }
    }
}
