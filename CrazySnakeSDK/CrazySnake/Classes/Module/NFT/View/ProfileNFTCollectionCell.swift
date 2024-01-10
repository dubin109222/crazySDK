//
//  ProfileNFTCollectionCell.swift
//  Platform
//
//  Created by Lee on 30/06/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit

class ProfileNFTCollectionCell: UICollectionViewCell {
    
    var clickNewIconAction: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTDataModel?) {
        guard let model = model else { return }
        let url = URL.init(string: model.image)
        coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        statusButton.isHidden = model.status == .freedom
        statusButton.setTitle(model.status.dispalyName(), for: .normal)
        newIcon.isHidden = !model.is_new
    }

    lazy var coverView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 106, height: 119))
//        view.image = UIImage(named: "icon_market_box")
//        view.backgroundColor = .ls_dark_2()
        view.contentMode = .scaleToFill
//        view.ls_addCornerRadius(topLeft: 15, topRight: 10, bottomRight: 25, bottomLeft: 10)
        return view
    }()
    
    lazy var newIcon: UIButton = {
        let view = UIButton()
        view.setImage(UIImage.ls_bundle("nft_icon_new@2x"), for: .normal)
        view.isHidden = true
        view.addTarget(self, action: #selector(clickNewIconButton(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var statusButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 124, height: 28))
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_color("#FFFCD6"), for: .normal)
        button.setBackgroundImage(UIImage.ls_bundle("nft_bg_selected_nft@2x"), for: .normal)
//        button.ls_addColorLayer(begin: .ls_color("#231531",alpha: 0), middle: .ls_color("#231531",alpha: 0.98), end: .ls_color("#231531",alpha: 0),cornerRadius: 2)
        return button
    }()
}

//MARK: action
extension ProfileNFTCollectionCell {
    @objc private func clickNewIconButton(_ sender: UIButton) {
        clickNewIconAction?()
    }
}


//MARK: open
extension ProfileNFTCollectionCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: 144, height: 152)
    }
}

//MARK: UI
extension ProfileNFTCollectionCell {
    
    fileprivate func setupView() {
        
        contentView.addSubview(coverView)
        contentView.addSubview(statusButton)
        contentView.addSubview(newIcon)
        
        coverView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        newIcon.snp.makeConstraints { make in
            make.top.left.equalTo(-6)
        }
        
        statusButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(124)
            make.height.equalTo(28)
        }
    }
}
