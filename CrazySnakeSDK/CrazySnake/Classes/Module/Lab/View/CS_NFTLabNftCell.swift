//
//  CS_NFTLabNftCell.swift
//  CrazySnake
//
//  Created by Lee on 06/03/2023.
//

import UIKit

class CS_NFTLabNftCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTDataModel?, selectedItem: CS_NFTDataModel? = nil) {
        guard let model = model else { return }
        titleLabel.isHidden = true
        if model.id == selectedItem?.id {
            titleLabel.isHidden = false
        }
        selectedBack.isHidden = titleLabel.isHidden
        let url = URL.init(string: model.image)
        iconView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
    }
    
    func setData(_ model: CS_NFTDataModel?, selectedList: [CS_NFTDataModel]) {
        guard let model = model else { return }
        
        amountButton.isHidden = false
        titleLabel.isHidden = true
        for selectedItem in selectedList {
            if model.id == selectedItem.id {
                titleLabel.isHidden = false
                break
            }
        }
        selectedBack.isHidden = titleLabel.isHidden
        let url = URL.init(string: model.image)
        iconView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        amountLabel.text = "\(model.essences)"
    }
    
    func setNFTStakeData(_ model: CS_NFTDataModel?, selectedList: [CS_NFTDataModel]) {
        guard let model = model else { return }
        
        titleLabel.isHidden = true
        for selectedItem in selectedList {
            if model.id == selectedItem.id {
                titleLabel.isHidden = false
                break
            }
        }
        let url = URL.init(string: model.image)
        iconView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
    }
    
    lazy var selectedBack: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_bg_nft_item@2x")
        view.isHidden = true
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_select".ls_localized, for: .normal)
        button.setBackgroundImage(UIImage.ls_bundle("nft_bg_selected_nft@2x"), for: .normal)
        return button
    }()
    
    lazy var amountButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 94, height: 28))
        button.isUserInteractionEnabled = false
        button.setBackgroundImage(UIImage.ls_bundle("nft_bg_selected_nft@2x"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var amountIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("nft_icon_essence_advance@2x")
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#EE7E3B"), .ls_JostRomanFont(16))
        label.text = "100"
        return label
    }()
    
}

//MARK: open
extension CS_NFTLabNftCell {
    
    class func itemSize() -> CGSize {
        return CGSize(width: 106, height: 119)
    }
    
    class func itemSizeNFTStake() -> CGSize {
        return CGSize(width: 144, height: 152)
    }
}

//MARK: UI
extension CS_NFTLabNftCell {
    
    fileprivate func setupView() {
        contentView.addSubview(selectedBack)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountButton)
        amountButton.addSubview(amountIcon)
        amountButton.addSubview(amountLabel)
        
        selectedBack.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.left.top.equalTo(selectedBack).offset(4)
            make.right.bottom.equalTo(selectedBack).offset(-4)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        amountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(94)
            make.height.equalTo(28)
        }
        
        amountIcon.snp.makeConstraints { make in
            make.centerY.equalTo(amountButton)
            make.left.equalTo(amountButton).offset(18)
            make.width.equalTo(19)
            make.height.equalTo(22)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountButton)
            make.left.equalTo(amountButton).offset(40)
            
        }
    }
}
