//
//  CS_WalletBackUpTipsView.swift
//  CrazyWallet
//
//  Created by Lee on 30/06/2023.
//

import UIKit

class CS_WalletBackUpTipsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_boldFont(24))
        label.text = "Backup reminder"
        return label
    }()
    
    lazy var writeItem: CS_WalletBackUpItemView = {
        let view = CS_WalletBackUpItemView()
        view.iconView.image = .ls_named("wallet_icon_tips_correct@2x")
        view.titleLabel.text = "Write down on a paper".ls_localized
        return view
    }()
    
    lazy var copyItem: CS_WalletBackUpItemView = {
        let view = CS_WalletBackUpItemView()
        view.iconView.image = .ls_named("wallet_icon_tips_wrong@2x")
        view.titleLabel.text = "Don't copy and paste".ls_localized
        return view
    }()
    
    lazy var screenshotItem: CS_WalletBackUpItemView = {
        let view = CS_WalletBackUpItemView()
        view.iconView.image = .ls_named("wallet_icon_tips_wrong@2x")
        view.titleLabel.text = "Don't screenshot".ls_localized
        return view
    }()
}

//MARK: UI
extension CS_WalletBackUpTipsView {
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(writeItem)
        addSubview(copyItem)
        addSubview(screenshotItem)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
        }
        
        writeItem.snp.makeConstraints { make in
            make.centerX.equalTo(self).multipliedBy(0.5)
            make.top.equalTo(40)
            make.width.equalTo(CS_kScreenW*0.3)
            make.height.equalTo(16)
        }
        
        copyItem.snp.makeConstraints { make in
            make.top.width.height.equalTo(writeItem)
            make.centerX.equalTo(self).multipliedBy(1)
        }
        
        screenshotItem.snp.makeConstraints { make in
            make.top.width.height.equalTo(writeItem)
            make.centerX.equalTo(self).multipliedBy(1.5)
        }
    }
}


class CS_WalletBackUpItemView: UIView {

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
        label.ls_set(.ls_color("#CCCCCC"), .ls_mediumFont(12))
        return label
    }()

}

//MARK: UI
extension CS_WalletBackUpItemView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.right.equalTo(titleLabel.snp.left).offset(-7)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(16)
        }
    }
}
