//
//  CS_NFTIncubationSelectIncubatorView.swift
//  CrazySnake
//
//  Created by Lee on 02/03/2023.
//

import UIKit

class CS_NFTIncubationSelectIncubatorView: UIView {
    
    var clickAddAction: CS_NoParasBlock?
    var selectedModel: CS_NFTPropModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTPropModel?) {
        selectedModel = model
        if let model = model {
            iconView.isHidden = true
            imageView.image = model.props_type.iconImage()
        } else {
            iconView.isHidden = false
            imageView.image = nil
        }
    }
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(10)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_lab_add@2x")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.text = "crazy_str_incubator".ls_localized
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickAddButton(_:)), for: .touchUpInside)
        return button
    }()

}

//MARK: action
extension CS_NFTIncubationSelectIncubatorView {
    
    @objc private func clickAddButton(_ sender: UIButton) {
        clickAddAction?()
    }
    
}


//MARK: UI
extension CS_NFTIncubationSelectIncubatorView {
    
    private func setupView() {
        addSubview(imageView)
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(addButton)
        
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(71)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalTo(imageView)
            make.width.height.equalTo(40)
        }
        
        addButton.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(9)
        }
    }
}
