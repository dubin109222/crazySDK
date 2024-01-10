//
//  CS_NFTStakeCell.swift
//  CrazySnake
//
//  Created by Lee on 13/03/2023.
//

import UIKit

class CS_NFTStakeCell: UICollectionViewCell {
    
    var clickUnstakeAction: CS_NoParasBlock?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTStakeNFTModel?) {
        guard let model = model else { return }
        
        coverView.isHidden = model.group
        setsView.isHidden = !model.group
        if model.group {
            setsView.setStakeData(model)
        } else {
            let url = URL.init(string: model.image)
            coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        }
    }
    
    func setGroupItemData(_ model: CS_NFTStakeGroupItemModel?) {
        guard let model = model else { return }
        let url = URL.init(string: model.image)
        coverView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        
        setsView.isHidden = true
        unstakeButton.isHidden = true
    }

    lazy var coverView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 106, height: 119))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var setsView: CS_NFTSetsView = {
        let view = CS_NFTSetsView()
        view.isHidden = true
        return view
    }()
    
    public lazy var unstakeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickUnstakeButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("nft_icon_stake_unstake@2x"), for: .normal)
        return button
    }()
}

//MARK: open
extension CS_NFTStakeCell {
    
    public class func itemSize() -> CGSize {
        return CGSize(width: 144, height: 152)
    }
    
    public class func itemSizeSetItem() -> CGSize {
        return CGSize(width: 107, height: 123)
    }
}

//MARK: action
extension CS_NFTStakeCell {
    @objc private func clickUnstakeButton(_ sender: UIButton) {
        clickUnstakeAction?()
    }
}


//MARK: UI
extension CS_NFTStakeCell {
    
    fileprivate func setupView() {
        contentView.addSubview(setsView)
        contentView.addSubview(coverView)
        contentView.addSubview(unstakeButton)
        
        setsView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        coverView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        unstakeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(-18)
            make.width.height.equalTo(44)
        }
    }
}
