//
//  CS_RankItemView.swift
//  CrazySnake
//
//  Created by Lee on 13/06/2023.
//

import UIKit

class CS_RankItemView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#DEEEFF"), .ls_JostRomanFont(14))
        return label
    }()
}

//MARK: UI
extension CS_RankItemView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(nameLabel)
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(4)
            make.width.height.equalTo(32)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(10)
        }
       
    }
}
