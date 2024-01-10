//
//  CS_SendInfoAddressView.swift
//  CrazySnake
//
//  Created by Lee on 01/03/2023.
//

import UIKit

class CS_SendInfoAddressView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    lazy var historyButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 42))
        button.addTarget(self, action: #selector(clickRecordButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("wallet_icon_transfer_record@2x"), for: .normal)
        button.setTitle("crazy_str_history".ls_localized, for: .normal)
        button.titleLabel?.font = .ls_font(10)
        button.setTitleColor(.ls_white(), for: .normal)
        button.ls_layout(.imageTop)
        button.isHidden = true
        return button
    }()

}

//MARK: action
extension CS_SendInfoAddressView {
    @objc private func clickRecordButton(_ sender: UIButton) {
        let vc = CS_WalletTransferRecordController()
        UIViewController.current()?.present(vc, animated: false)
    }
}


//MARK: UI
extension CS_SendInfoAddressView {
    
    private func setupView() {
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(infoLabel)
        addSubview(historyButton)
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView).offset(-4)
            make.left.equalTo(iconView.snp.right).offset(12)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(iconView).offset(4)
            make.left.equalTo(titleLabel)
            make.right.equalTo(-16)
        }
        
        historyButton.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(42)
        }
    }
}
