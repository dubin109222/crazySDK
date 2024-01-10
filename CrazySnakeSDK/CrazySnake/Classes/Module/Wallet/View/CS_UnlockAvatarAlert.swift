//
//  CS_UnlockAvatarAlert.swift
//  CrazySnake
//
//  Created by Lee on 16/06/2023.
//

import UIKit

class CS_UnlockAvatarAlert: CS_BaseAlert {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showWith(_ model: CS_UserAvatarModel) {
        let url = URL.init(string: model.image)
        iconView.kf.setImage(with: url, placeholder: UIImage.ls_placeHeader())
        infoLabel.text = "Need \(model.unlock_cyt) CYT to unlock this item"
        show()
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 90, height: 34))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_confirm".ls_localized, for: .normal)
        return button
    }()
    
    lazy var infoLabel: UILabel = {
        let view = UILabel()
        view.font = .ls_JostRomanFont(12)
        view.textColor = .ls_white()
        view.textAlignment = .center
        return view
    }()

}

//MARK: function
extension CS_UnlockAvatarAlert {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        dismissSelf()
    }
}

extension CS_UnlockAvatarAlert {
    
    private func setupView() {
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_dark_3()
        closeButton.isHidden = false
        
        contentView.addSubview(iconView)
        contentView.addSubview(infoLabel)
        contentView.addSubview(confirmButton)
        
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(275)
            make.height.equalTo(195)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(18)
            make.width.height.equalTo(60)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(106)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(-10)
            make.width.equalTo(90)
            make.height.equalTo(34)
        }
        
    }
    
}



