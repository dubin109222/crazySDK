//
//  CS_RankIndexView.swift
//  CrazySnake
//
//  Created by Lee on 13/06/2023.
//

import UIKit

class CS_RankIndexView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ index: Int?){
        
        guard let index = index  else {
            iconView.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = "-"
            return
        }
        if index <= 0 {
            iconView.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = "-"
            return
        }
        
        iconView.isHidden = false
        nameLabel.isHidden = true
        switch index {
        case 1:
            iconView.image = UIImage.ls_bundle("rank_icon_rank_1@2x")
        case 2:
            iconView.image = UIImage.ls_bundle("rank_icon_rank_2@2x")
        case 3:
            iconView.image = UIImage.ls_bundle("rank_icon_rank_3@2x")
        default:
            iconView.isHidden = true
            nameLabel.isHidden = false
            nameLabel.text = "\(index)"
        }
        
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#EEEEEE"), .ls_JostRomanFont(24))
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
}

//MARK: UI
extension CS_RankIndexView {
    
    private func setupView() {
        addSubview(iconView)
        addSubview(nameLabel)
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.center.equalTo(iconView)
        }
       
    }
}
