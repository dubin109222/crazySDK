//
//  CS_LabUpgradeAlert.swift
//  CrazySnake
//
//  Created by Lee on 30/08/2023.
//

import UIKit

class CS_LabUpgradeAlert: CS_BaseAlert {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showWith(_ amount: Int) {
        amountLabel.text = "x \(amount)"
        show()
    }
    
    lazy var backIconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "icon_NFTLab_alert_upgrade_back_icon")
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = .ls_bundle("nft_icon_essence_advance@2x")
        return view
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_boldFont(16))
        label.textAlignment = .center
        label.text = "crazy_str_congratulations".ls_localized
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_mediumFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_upgrade_orb".ls_localized
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#17F179"), .ls_boldFont(16))
        label.textAlignment = .center
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 150, height: 44))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_receive".ls_localized, for: .normal)
        return button
    }()
}

//MARK: action
extension CS_LabUpgradeAlert {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        dismissSelf()
    }
}


//MARK: UI
extension CS_LabUpgradeAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.8)
        contentView.isHidden = true
        backView.addSubview(topLabel)
        backView.addSubview(backIconView)
        backView.addSubview(iconView)
        backView.addSubview(nameLabel)
        backView.addSubview(amountLabel)
        backView.addSubview(confirmButton)
        
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(104)
        }
        
        backIconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).offset(28)
            make.width.equalTo(68)
            make.height.equalTo(68)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalTo(backIconView)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(backIconView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(amountLabel.snp.bottom).offset(28)
            make.width.equalTo(150)
            make.height.equalTo(44)
        }
    }
}
