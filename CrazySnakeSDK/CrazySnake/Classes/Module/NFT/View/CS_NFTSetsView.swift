//
//  CS_NFTSetsView.swift
//  CrazySnake
//
//  Created by Lee on 25/07/2023.
//

import UIKit

class CS_NFTSetsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_MarketModel?) {
        guard let model = model, model.item_type == 3 else { return }
        amountView.image = .ls_named("nft_icon_sets_amount_\(model.nftSetsDetail.count)")
        if let nft = model.nftSetsDetail.first {
            let url = URL.init(string: nft.background_image)
            coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
            let urlIcon = URL.init(string: nft.profile_image)
            profileIcon.kf.setImage(with: urlIcon , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
            var power = 0
            var qualities = [CS_NFTQuality]()
            for item in model.nftSetsDetail {
                power += item.total_power
                qualities.append(item.quality)
            }
            qualitiesView.setData(qualities)
            powerView.iconView.image = nft.quality.iconPower()
            powerView.titleLabel.text = "\(power)"
            powerView.titleLabel.textColor = nft.qualityColor()
        }
    }
    
    func setDataInventorySets(_ model: CS_NFTSetInfoModel?) {
        guard let model = model else { return }
        
        qualitiesView.setData(model.qualities)
        amountView.image = .ls_named("nft_icon_sets_amount_\(model.qualities.count)")
        let url = URL.init(string: model.background_image)
        coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        let urlIcon = URL.init(string: model.profile_image)
        profileIcon.kf.setImage(with: urlIcon , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        powerView.isHidden = true
    }
    
    func setStakeData(_ model: CS_NFTStakeNFTModel?) {
        guard let model = model, model.group else { return }
        amountView.image = .ls_named("nft_icon_sets_amount_\(model.nfts.count)")
        if let nft = model.nfts.last {
            let url = URL.init(string: model.background_image)
            coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
            let urlIcon = URL.init(string: model.profile_image)
            profileIcon.kf.setImage(with: urlIcon , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
            var qualities = [CS_NFTQuality]()
            for item in model.nfts {
                qualities.insert(item.quality, at: 0)
            }
            qualitiesView.setData(qualities)
            powerView.iconView.image = nft.quality.iconPower()
            powerView.titleLabel.text = "\(model.power)"
            powerView.titleLabel.textColor = nft.quality.color()
        }
    }
    
    func setStakeSuitableItemData(_ model: CS_NFTStakeSuitableItemModel?) {
        guard let model = model else { return }
        
        qualitiesView.setData(model.qualities)
        amountView.image = .ls_named("nft_icon_sets_amount_\(model.qualities.count)")
        let url = URL.init(string: model.background_image)
        coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        let urlIcon = URL.init(string: model.profile_image)
        profileIcon.kf.setImage(with: urlIcon , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        powerView.isHidden = true
    }
    
    func setData(_ model: CS_NFTSetInfoModel?) {
        guard let model = model else { return }
        
        qualitiesView.setData(model.qualities)
        amountView.image = .ls_named("nft_icon_sets_amount_\(model.qualities.count)")
        let url = URL.init(string: model.background_image)
        coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        let urlIcon = URL.init(string: model.profile_image)
        profileIcon.kf.setImage(with: urlIcon , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        powerView.isHidden = true
    }
    
    lazy var coverView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 95, height: 106))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var profileIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var qualitiesView: CS_NFTSetsQualitiesView = {
        let view = CS_NFTSetsQualitiesView()
        return view
    }()
    
    lazy var amountView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var powerView: CS_NFTPowerView = {
        let button = CS_NFTPowerView()
        button.ls_cornerRadius(7)
        button.backgroundColor = .ls_black(0.4)
        button.iconView.contentMode = .scaleAspectFill
        return button
    }()

}

//MARK: UI
extension CS_NFTSetsView {
    
    private func setupView() {
        addSubview(coverView)
        addSubview(qualitiesView)
        addSubview(amountView)
        addSubview(profileIcon)
        addSubview(powerView)
        
        coverView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        amountView.snp.makeConstraints { make in
            make.top.equalTo(8.5)
            make.right.equalTo(coverView).multipliedBy(0.85)
            make.width.equalTo(12)
            make.height.equalTo(14)
        }
        
        qualitiesView.snp.makeConstraints { make in
            make.centerY.equalTo(amountView)
            make.right.equalTo(amountView.snp.left).offset(-4)
            make.height.width.equalTo(14)
        }
        
        profileIcon.snp.makeConstraints { make in
            make.centerX.equalTo(coverView)
            make.centerY.equalTo(coverView).multipliedBy(0.9)
            make.width.equalTo(coverView).multipliedBy(0.5)
            make.height.equalTo(coverView).multipliedBy(0.5)
        }
        
        powerView.snp.makeConstraints { make in
            make.centerX.equalTo(coverView)
            make.bottom.equalTo(coverView).multipliedBy(0.85)
            make.width.equalTo(48)
            make.height.equalTo(14)
        }
        
    }
}
