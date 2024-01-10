//
//  CS_NFTLabLevelUpAlert.swift
//  CrazySnake
//
//  Created by Lee on 01/03/2023.
//

import UIKit

class CS_NFTLabLevelUpAlert: CS_NFTLabBaseAlert {

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
        hashView.oldLabel.text = "\(oldNft.power)"
        hashView.nowLabel.text = "\(nft.power)"
        levelView.oldLabel.text = "\(oldNft.level)"
        levelView.nowLabel.text = "\(nft.level)"
    }

    lazy var lengthView: CS_NFTLabAlertLevelItemView = {
        let view = CS_NFTLabAlertLevelItemView()
        view.nameLabel.text = "Base length"
        return view
    }()
    
    lazy var killsView: CS_NFTLabAlertLevelItemView = {
        let view = CS_NFTLabAlertLevelItemView()
        view.nameLabel.text = "Absorbed from kills"
        return view
    }()
    
    lazy var hashView: CS_NFTLabAlertLevelItemView = {
        let view = CS_NFTLabAlertLevelItemView()
        view.nameLabel.text = "Hash"
        return view
    }()
    
    lazy var levelView: CS_NFTLabAlertLevelItemView = {
        let view = CS_NFTLabAlertLevelItemView()
        view.nameLabel.text = "Level"
        return view
    }()
}

//MARK: UI
extension CS_NFTLabLevelUpAlert {
    
    private func setupView() {
        titleLabel.text = "Upgrade!"
        contentView.backgroundColor = .clear
        backView.addSubview(hashView)
        backView.addSubview(levelView)
        
        hashView.snp.makeConstraints { make in
            make.top.equalTo(lineLeftView.snp.bottom).offset(20)
            make.right.equalTo(backView.snp.centerX).offset(-5)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        levelView.snp.makeConstraints { make in
            make.top.width.height.equalTo(hashView)
            make.left.equalTo(backView.snp.centerX).offset(5)
        }
    }
}
