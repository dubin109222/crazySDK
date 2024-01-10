//
//  CS_WalletItemView.swift
//  CrazyWallet
//
//  Created by Lee on 28/06/2023.
//

import UIKit

class CS_WalletItemView: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        coverButton.addTarget(target, action: action, for: controlEvents)
    }
    
    func setData(_ image: UIImage?, name: String?) {
        iconView.image = image
        nameLabel.text = name
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#252428")
        view.cornerRadius = 17
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#8E8E8E"), .ls_font(12))
        label.textAlignment = .center
        return label
    }()
    
    lazy var coverButton: UIButton = {
        let button = UIButton()
        return button
    }()
}

//MARK: UI
extension CS_WalletItemView {
    
    private func setupView() {
        
        addSubview(backView)
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(coverButton)

        backView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
            make.width.equalTo(68)
            make.height.equalTo(34)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backView)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backView.snp.bottom).offset(5)
        }
        
        coverButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
