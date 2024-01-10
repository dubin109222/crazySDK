//
//  CS_WalletBackupButton.swift
//  CrazySnake
//
//  Created by Lee on 14/08/2023.
//

import UIKit

class CS_WalletBackupButton: UIButton {

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
    
    func setIsBackup(_ backup: Bool, showBorder: Bool = false) {
        if backup {
            nameLabel.textColor = .ls_color("#61C979")
            iconView.tintColor = .ls_color("#61C979")
            self.ls_border(color: .ls_color("#61C979"))
        } else {
            nameLabel.textColor = .ls_color("#FF8948")
            iconView.tintColor = .ls_color("#FF8948")
            self.ls_border(color: .ls_color("#FB8646"))
        }
        
        if showBorder == false {
            self.ls_border(color: .clear)
        }
        
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = .ls_named("icon_wallet_backup_tips")?.withRenderingMode(.alwaysTemplate)
        
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#FF8948"), .ls_font(10))
        label.text = "crazy_str_backup".ls_localized
        return label
    }()
    
    lazy var coverButton: UIButton = {
        let button = UIButton()
        return button
    }()
}

//MARK: UI
extension CS_WalletBackupButton {
    
    private func setupView() {
        
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(coverButton)
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(7)
            make.centerY.equalToSuperview()
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(3)
            make.centerY.equalToSuperview()
        }
        
        coverButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

