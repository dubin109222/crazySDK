//
//  CS_NFTStateDispatchCongratulations.swift
//  CrazySnake
//
//  Created by BigB on 2023/10/23.
//

import Foundation
import SwiftyAttributes
import UIKit

class CS_NFTStateDispatchCongratulations : CS_BaseAlert {
    var clickReceiveAction: CS_NoParasBlock?
    var getValue: String?{
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
        valueLb.text = getValue
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
        view.image = .ls_bundle("_dispathch_get_bg@2x")
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(11))
        label.text = "Dispatch Reward Value"
        return label
    }()
    
    lazy var valueLb: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#E7785E"), .ls_JostRomanFont(16))
        label.text = "0"
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
extension CS_NFTStateDispatchCongratulations {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        clickReceiveAction?()
        dismissSelf()
    }
}


//MARK: UI
extension CS_NFTStateDispatchCongratulations {
    
    private func setupView() {
        tapDismissEnable = false
        contentView.isHidden = true
        backView.backgroundColor = .ls_black(0.8)
        addSubview(toptitleLabel)
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(valueLb)
        addSubview(confirmButton)
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(550)
            make.height.equalTo(50)
        }
        
        toptitleLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(iconView.snp.top).offset(-14)
            make.centerX.equalTo(iconView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.top).offset(4)
        }
        

        valueLb.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.centerX.equalTo(nameLabel).offset(14)
        }
        
        let valueIcon = UIImageView.init(image: .ls_bundle("nft_dispatch_walk_value@2x"))
        addSubview(valueIcon)
        
        valueIcon.snp.makeConstraints { make in
            make.right.equalTo(valueLb.snp.left).offset(-5)
            make.centerY.equalTo(valueLb)
            make.size.equalTo(14)
        }
        
        
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(33)
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
    }
}
