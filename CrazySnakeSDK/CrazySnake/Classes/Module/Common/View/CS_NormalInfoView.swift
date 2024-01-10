//
//  CS_NormalInfoView.swift
//  CrazySnake
//
//  Created by Lee on 15/05/2023.
//

import UIKit

class CS_NormalInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_white()
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_JostRomanFont(16))
        return label
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        return view
    }()
}

//MARK: UI
extension CS_NormalInfoView {
    
    private func setupView() {
        backgroundColor = .ls_color("#ABABAB",alpha: 0.6)
        ls_cornerRadius(5)
        
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(contentView)
        
        backView.snp.makeConstraints { make in
            make.left.top.equalTo(5)
            make.right.bottom.equalTo(-5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(2)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(backView)
            make.top.equalTo(backView).offset(24)
        }
    }
}
