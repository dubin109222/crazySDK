//
//  CS_MarketChooseCell.swift
//  CrazySnake
//
//  Created by BigB on 2023/7/13.
//

import Foundation
import UIKit
import SnapKit

class CS_MarketChooseCell: UICollectionViewCell {
    
    var data: CS_NameDescribeModel? {
        didSet {
            self.contentLb.text = data?.name
            self.icon.image = data?.icon
            
            if data?.icon != nil {
                self.icon.snp.updateConstraints { make in
                    make.size.equalTo(24)
                }
            } else {
                self.icon.snp.updateConstraints { make in
                    make.size.equalTo(0)
                }
            }
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initSubViews()
        
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.ls_color("#7B6F86").cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        self.backgroundColor = isSelected ? .ls_color("#392F54") : .clear
        self.borderWidth = isSelected ? 0 : 1
        self.contentLb.textColor = isSelected ? .white : .ls_color("#7B6F86")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var icon: UIImageView = {
        let icon = UIImageView()
        
        return icon
    }()
    
    var contentLb: UILabel = {
        let contentLb = UILabel()
        contentLb.font = .ls_JostRomanFont(12)
        contentLb.numberOfLines = 1
        contentLb.textAlignment = .center
        return contentLb
    }()
    
    private func initSubViews() {
        self.contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.size.equalTo(0)
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
        }
        
        self.contentView.addSubview(contentLb)
        contentLb.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right)
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
    }
}
