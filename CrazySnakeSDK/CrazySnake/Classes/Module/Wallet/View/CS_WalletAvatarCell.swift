//
//  CS_WalletAvatarCell.swift
//  CrazySnake
//
//  Created by Lee on 16/06/2023.
//

import UIKit

class CS_WalletAvatarCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_UserAvatarModel, selectedUrl: String?){
        var isSelected = model.image == selectedUrl
        iconSelected.isHidden = !isSelected
        let url = URL.init(string: model.image)
        iconView.kf.setImage(with: url, placeholder: UIImage.ls_placeHeader())
        soldOutView.isHidden = model.status == 1
        soldOutIcon.isHidden = model.status == 1
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var iconSelected: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("wallet_icon_selected@2x")
        view.isHidden = true
        return view
    }()
   
    lazy var soldOutView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_black(0.5)
        view.ls_cornerRadius(5)
        view.isHidden = true
        return view
    }()
    
    lazy var soldOutIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("wallet_icon_lock@2x")
        return view
    }()
}

//MARK: function
extension CS_WalletAvatarCell {
    class func itemSize() -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

//MARK: UI
extension CS_WalletAvatarCell {
    
    private func setupView() {
        contentView.addSubview(iconSelected)
        contentView.addSubview(iconView)
        contentView.addSubview(soldOutView)
        contentView.addSubview(soldOutIcon)
        
        iconSelected.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.left.top.equalTo(4)
            make.right.bottom.equalTo(-4)
        }
        
        soldOutView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        soldOutIcon.snp.makeConstraints { make in
            make.center.equalTo(soldOutView)
        }
    }
}
