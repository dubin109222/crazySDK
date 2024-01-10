//
//  CS_NFTLabEvolutionAlert.swift
//  CrazySnake
//
//  Created by Lee on 08/03/2023.
//

import UIKit

class CS_NFTLabEvolutionAlert: CS_NFTLabBaseAlert {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLevelUpData(_ oldNft: CS_NFTDataModel?, nft: CS_NFTDataModel?) {
        guard let oldNft = oldNft else { return }
        guard let nft = nft else { return }

        let url = URL.init(string: nft.image)
        iconView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        iconView.contentMode = .scaleAspectFill
        hashView.oldLabel.text = "\(oldNft.evolve?.current_level?.power ?? 0)"
        hashView.nowLabel.text = "\(oldNft.evolve?.next_level?.power ?? 0)"
        levelView.oldStarView.showRightStar(oldNft.evolve?.current_level?.num ?? 0, color: oldNft.qualityColor(),image: oldNft.evolve?.current_level?.iconImage())
        levelView.nowStarView.showStar(oldNft.evolve?.next_level?.num ?? 0, color: oldNft.qualityColor(),image: oldNft.evolve?.next_level?.iconImage())
    }

    
    lazy var hashView: CS_NFTLabAlertLevelItemView = {
        let view = CS_NFTLabAlertLevelItemView()
        view.nameLabel.text = "crazy_str_nft_hash_bonus".ls_localized
        return view
    }()
    
    lazy var levelView: CS_NFTLabAlertLevelStarView = {
        let view = CS_NFTLabAlertLevelStarView()
        view.nameLabel.text = "crazy_str_nft_upgrade_stage".ls_localized
        return view
    }()
}

//MARK: UI
extension CS_NFTLabEvolutionAlert {
    
    private func setupView() {
        titleLabel.text = "crazy_str_upgrade".ls_localized
        contentView.image = nil
        contentView.backgroundColor = .clear
        
        backView.addSubview(hashView)
        backView.addSubview(levelView)
        
        levelView.snp.makeConstraints { make in
            make.top.equalTo(lineLeftView.snp.bottom).offset(20)
            make.right.equalTo(backView.snp.centerX).offset(0)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        hashView.snp.makeConstraints { make in
            make.top.height.equalTo(levelView)
            make.left.equalTo(backView.snp.centerX).offset(5)
            make.width.equalTo(140)
        }
        
    }
}
