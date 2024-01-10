//
//  MnemonicVerifyCollectCell.swift
//  Platform
//
//  Created by Lee on 23/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit

class MnemonicVerifyCollectCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        wordLabel.text = nil
        super.prepareForReuse()
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        
//        let att = super.preferredLayoutAttributesFitting(layoutAttributes);
//        
//        let string = wordLabel.text
//        
//        if let string = string {
//            
//            let newWidth = string.ls_width(UIFont.ls_font(14), maxHeight: 18) + 26
//            att.size.width = newWidth;
//        }
//        att.size.height = 34
//        
//        return att;
//    }
    
    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(12))
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.borderColor = UIColor.ls_white()
        label.borderWidth = 0.5
        return label
    }()
}

//MARK: UI
extension MnemonicVerifyCollectCell {
    
    fileprivate func setupView() {
        backgroundColor = .clear
        contentView.addSubview(wordLabel)
        
        wordLabel.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(0);
            make.right.equalToSuperview().offset(0);
            make.bottom.equalToSuperview().offset(0);
            make.top.equalToSuperview().offset(0);
        }
    }
}
