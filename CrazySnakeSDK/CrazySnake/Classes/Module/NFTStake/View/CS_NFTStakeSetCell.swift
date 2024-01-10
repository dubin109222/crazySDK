//
//  CS_NFTStakeSetCell.swift
//  CrazySnake
//
//  Created by Lee on 15/03/2023.
//

import UIKit

class CS_NFTStakeSetCell: UICollectionViewCell {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataMore(){
        coverView.isHidden = false
        setsView.isHidden = true
        coverView.image = .ls_bundle("nft_stake_bg_set_more@2x")
        selectButton.setTitle("crazy_str_view_more_details".ls_localized, for: .normal)
    }
    
    func setData(_ model: CS_NFTStakeSuitableItemModel?) {
        guard var model = model else { return }
        coverView.isHidden = true
        setsView.isHidden = false
        var qualities = [CS_NFTQuality]()
        for item in model.qualitiesList.enumerated() {
            if item.element == 1 {
                if let quality = CS_NFTQuality(rawValue: item.offset+1) {
                    qualities.insert(quality, at: 0)
                }
            }
        }
        model.qualities = qualities
        setsView.setStakeSuitableItemData(model)
        selectButton.setTitle("crazy_str_select".ls_localized, for: .normal)
    }

    lazy var coverView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 106, height: 119))
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var setsView: CS_NFTSetsView = {
        let view = CS_NFTSetsView(frame: CGRect(x: 0, y: 0, width: 106, height: 119))
        return view
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 100, height: 24))
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = .ls_JostRomanFont(12)
        button.setTitle("crazy_str_select".ls_localized, for: .normal)
        return button
    }()
}

//MARK: open
extension CS_NFTStakeSetCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: 144, height: 152)
    }
}

//MARK: UI
extension CS_NFTStakeSetCell {
    
    fileprivate func setupView() {
        contentView.addSubview(coverView)
        contentView.addSubview(setsView)
        contentView.addSubview(selectButton)
        
        coverView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-16)
        }
        
        setsView.snp.makeConstraints { make in
            make.edges.equalTo(coverView)
        }
        
        selectButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(24)
        }
    }
}
