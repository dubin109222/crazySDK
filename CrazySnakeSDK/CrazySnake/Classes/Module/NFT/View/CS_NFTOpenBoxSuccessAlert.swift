//
//  CS_NFTOpenBoxSuccessAlert.swift
//  CrazySnake
//
//  Created by Lee on 29/03/2023.
//

import UIKit
import SwiftyAttributes

class CS_NFTOpenBoxSuccessAlert: CS_BaseAlert {

    var clickReceiveAction: CS_NoParasBlock?
    var model: CS_OpenBoxModel?{
        didSet{
            updateData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        updateData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(){
        guard let model = model else { return }
        if model.type == 1 {
            let url = URL.init(string: model.nft?.image ?? "")
            iconView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
            nameLabel.attributedText = "NFT  ".attributedString + (model.nft?.quality.name() ?? "").withTextColor(model.nft?.quality.color() ?? .ls_white()).withFont(.ls_JostRomanFont(12))
        } else {
            iconView.image = model.prop?.props_type.iconImage()
            nameLabel.text = model.prop?.props_type.disPlayName()
        }
    }
    
    lazy var toptitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(19))
        label.textAlignment = .center
        label.text = "crazy_str_congratulations".ls_localized
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .center
        label.ls_cornerRadius(12.5)
        label.backgroundColor = .ls_white(0.1)
        return label
    }()

    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 160, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_received".ls_localized, for: .normal)
        return button
    }()
}

//MARK: action
extension CS_NFTOpenBoxSuccessAlert {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        clickReceiveAction?()
        dismissSelf()
    }
}


//MARK: UI
extension CS_NFTOpenBoxSuccessAlert {
    
    private func setupView() {
        tapDismissEnable = false
        contentView.isHidden = true
        backView.backgroundColor = .ls_black(0.8)
        addSubview(toptitleLabel)
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(confirmButton)
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(176)
            make.height.equalTo(185)
        }
        
        toptitleLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(iconView.snp.top).offset(-6)
            make.centerX.equalToSuperview().offset(-30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(4)
            make.width.equalTo(142)
            make.height.equalTo(25)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
    }
}
