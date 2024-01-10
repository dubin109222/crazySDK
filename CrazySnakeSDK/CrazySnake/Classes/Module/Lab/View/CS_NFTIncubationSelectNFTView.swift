//
//  CS_NFTIncubationSelectNFTView.swift
//  CrazySnake
//
//  Created by Lee on 02/03/2023.
//

import UIKit

class CS_NFTIncubationSelectNFTView: UIView {

    var clickAddAction: CS_NoParasBlock?
    var selectedModel: CS_NFTDataModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTDataModel?) {
        selectedModel = model
        if let model = model {
            let url = URL.init(string: model.image)
            addButton.kf.setImage(with: url, for: .normal)
            titleLabel.isHidden = true
        } else {
            addButton.setImage(nil, for: .normal)
            titleLabel.isHidden = true
        }
    }

    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_lab_add@2x")
        return view
    }()
    
    lazy var titleLabel: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitleColor(.ls_text_gray(), for: .normal)
        button.setTitle("crazy_str_nft".ls_localized, for: .normal)
        button.setImage(UIImage.ls_bundle( "nft_gender_male@2x"), for: .normal)
        button.ls_layout(.imageLeft, padding: 6)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickAddButton(_:)), for: .touchUpInside)
        return button
    }()

}

//MARK: action
extension CS_NFTIncubationSelectNFTView {
    
    @objc private func clickAddButton(_ sender: UIButton) {
        clickAddAction?()
    }
    
}

//MARK: UI
extension CS_NFTIncubationSelectNFTView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(addButton)
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(18)
            make.width.equalTo(100)
            make.height.equalTo(14)
        }
        
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
