//
//  CS_NFTPowerView.swift
//  CrazySnake
//
//  Created by Lee on 25/07/2023.
//

import UIKit

class CS_NFTPowerView: UIView {

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
        label.ls_set(.ls_text_light(), .ls_boldFont(10))
        return label
    }()
    
}

//MARK: UI
extension CS_NFTPowerView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(8)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left).offset(-1)
            make.width.height.equalTo(12)
        }
    }
}
