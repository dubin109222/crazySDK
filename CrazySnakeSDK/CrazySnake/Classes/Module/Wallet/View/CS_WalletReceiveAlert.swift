//
//  CS_WalletReceiveAlert.swift
//  CrazyWallet
//
//  Created by Lee on 29/06/2023.
//

import UIKit

class CS_WalletReceiveAlert: CS_BaseAlert {

    var address = CS_AccountManager.shared.accountInfo?.wallet_address ?? ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
        QRCodeUtil.setQRCodeToImageView(codeView, nil, address)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var chainIcon: UIImageView = {
        let view = UIImageView()
        view.image = .ls_named("icon_chain_polygon@2x")
        return view
    }()
    
    lazy var networkLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_mediumFont(12))
        label.text = "Network"
        return label
    }()
    
    lazy var chainLab: UILabel = {
        let lab = UILabel()
        lab.font = .ls_mediumFont(12)
        lab.textColor = .ls_white()
        lab.textAlignment = .center
        lab.text = Config.chain.name
        return lab
    }()
    
    lazy var codeView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.ls_cornerRadius(6)
        return view
    }()

    lazy var addressButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickCopy), for: .touchUpInside)
        button.titleLabel?.font = UIFont.ls_font(12)
        button.setTitleColor(.ls_text_gray(), for: .normal)
        button.setTitle(address, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        return button
    }()

    lazy var copyButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickCopy), for: .touchUpInside)
        button.setImage(.ls_named("icon_wallet_copy"), for: .normal)
        return button
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_font(12))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "The current network is \(Config.chain.name), don't use any other networks to send to this address"
        return label
    }()
}

//MARK: function
extension CS_WalletReceiveAlert {
    
    @objc private func clickCopy(){
        UIPasteboard.general.string = address
        LSHUD.showSuccess("crazy_str_copied".ls_localized)
    }

}

extension CS_WalletReceiveAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_color("#171718")
        contentView.ls_cornerRadius(20)
        closeButton.isHidden = false
        contentView.addSubview(chainIcon)
        contentView.addSubview(networkLabel)
        contentView.addSubview(chainLab)
        contentView.addSubview(codeView)
        contentView.addSubview(addressButton)
        contentView.addSubview(copyButton)
        contentView.addSubview(tipsLabel)
        
        
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(294)
            make.height.equalTo(320)
        }
        
        chainIcon.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.centerX).offset(-12)
            make.top.equalTo(20)
            make.width.height.equalTo(34)
        }
        
        networkLabel.snp.makeConstraints { make in
            make.top.equalTo(chainIcon)
            make.left.equalTo(chainIcon.snp.right).offset(6)
        }
        
        chainLab.snp.makeConstraints { make in
            make.bottom.equalTo(chainIcon)
            make.left.equalTo(networkLabel)
        }
        
        codeView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(72)
            make.width.height.equalTo(142)
        }
        
        addressButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(codeView.snp.bottom).offset(13)
            make.width.equalTo(180)
            
        }
        
        copyButton.snp.makeConstraints { (make) in
            make.right.equalTo(addressButton).offset(-12)
            make.bottom.equalTo(addressButton).offset(5)
            make.width.height.equalTo(24)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.equalTo(28)
            make.right.equalTo(-22)
            make.bottom.equalTo(-20)
        }
    }
}



