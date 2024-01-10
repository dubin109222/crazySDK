//
//  CS_CSNFTStakeAddCell.swift
//  CrazySnake
//
//  Created by Lee on 13/03/2023.
//

import UIKit

class CS_CSNFTStakeAddCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTStakeInfoModel?) {
        guard let model = model else { return }
        if model.slots > model.totalStakedNftCount {
            iconView.snp.remakeConstraints { make in
                make.centerX.equalTo(coverView)
                make.centerY.equalTo(coverView)
                make.width.height.equalTo(44)
            }
            tipsLabel.isHidden = true
            soltLabel.isHidden = true
            soltIcon.isHidden = true
            amountLabel.isHidden = true
        } else {
            iconView.snp.remakeConstraints { make in
                make.centerX.equalTo(coverView)
                make.centerY.equalTo(coverView).offset(-30)
                make.width.height.equalTo(44)
            }
            tipsLabel.isHidden = false
            soltLabel.isHidden = false
            soltIcon.isHidden = false
            amountLabel.isHidden = false
            
            amountLabel.text = "x\(model.nextSlotCostCards)"
        }
    }

    lazy var coverView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 144, height: 152))
//        view.borderColor = .ls_text_gray()
//        view.borderWidth = 1
//        view.ls_addCornerRadius(topLeft: 15, topRight: 10, bottomRight: 25, bottomLeft: 10)
        view.image = UIImage.ls_bundle( "nft_bg_nft_item@2x")
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("nft_lab_add@2x")
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(10))
        label.text = "crazy_str_to_unlock_slot_u_need".ls_localized
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    lazy var soltLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.text = "Slod card"
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    lazy var soltIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("200304@2x")
        view.isHidden = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.text = "x1"
        label.isHidden = true
        return label
    }()
}

//MARK: open
extension CS_CSNFTStakeAddCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: 144, height: 152)
    }
}

//MARK: UI
extension CS_CSNFTStakeAddCell {
    
    fileprivate func setupView() {
        contentView.addSubview(coverView)
        contentView.addSubview(iconView)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(soltLabel)
        contentView.addSubview(soltIcon)
        contentView.addSubview(amountLabel)
        
        coverView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(coverView)
            make.centerY.equalTo(coverView)
            make.width.height.equalTo(44)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(15)
        }
        
        soltLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-30)
            make.right.equalTo(coverView.snp.centerX).offset(4)
        }
        
        soltIcon.snp.makeConstraints { make in
            make.left.equalTo(soltLabel.snp.right).offset(8)
            make.centerY.equalTo(soltLabel)
            make.width.equalTo(16)
            make.height.equalTo(24)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(soltIcon.snp.right).offset(4)
            make.centerY.equalTo(soltLabel)
        }
    }
}
