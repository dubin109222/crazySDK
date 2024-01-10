//
//  CS_WalletNftCell.swift
//  CrazySnake
//
//  Created by Lee on 31/05/2023.
//

import UIKit

class CS_WalletNftCell: UICollectionViewCell {
    
    var nftModel: CS_NFTDataModel?
    var clickDepositAction: CS_NoParasBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTDataModel?) {
        nftModel = model
        guard let model = model else { return }
        let url = URL.init(string: model.image)
        coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        chainIcon.isHidden = model.is_chain != 1
        if model.status == .deposit_confirming {
            depositButton.setBackgroundImage(UIImage.ls_bundle("nft_icon_bg_confirming@2x"), for: .normal)
            depositButton.setTitle("crazy_str_confirming".ls_localized, for: .normal)
        } else {
            depositButton.setBackgroundImage(UIImage.ls_bundle("nft_icon_bg_list_nft@2x"), for: .normal)
            depositButton.setTitle("crazy_str_deposit".ls_localized, for: .normal)
        }
    }

    lazy var coverView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 106, height: 119))
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var chainIcon: UIImageView = {
        let view = UIImageView()
        view.image = .ls_named("nft_icon_on_chain@2x")
        view.isHidden = true
        return view
    }()
    
    lazy var depositButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 87, height: 32))
        button.addTarget(self, action: #selector(clickDepositButton(_:)), for: .touchUpInside)
        button.setBackgroundImage(UIImage.ls_bundle("nft_icon_bg_list_nft@2x"), for: .normal)
        button.setTitle("crazy_str_deposit".ls_localized, for: .normal)
        button.titleLabel?.font = .ls_JostRomanFont(12)
        return button
    }()
}

//MARK: action
extension CS_WalletNftCell {
    @objc private func clickDepositButton(_ sender: UIButton) {
        if nftModel?.status == .deposit_confirming {
            return
        }
        clickDepositAction?()
    }
}


//MARK: open
extension CS_WalletNftCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: 144, height: 202)
    }
}

//MARK: UI
extension CS_WalletNftCell {
    
    fileprivate func setupView() {
        contentView.addSubview(coverView)
        contentView.addSubview(chainIcon)
        contentView.addSubview(depositButton)
        
        coverView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(14)
            make.width.equalTo(144)
            make.height.equalTo(152)
        }
        
        chainIcon.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(60)
            make.height.equalTo(23)
        }
        
        depositButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(0)
            make.width.equalTo(87)
            make.height.equalTo(32)
        }
    }
}
