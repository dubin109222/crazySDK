//
//  CS_MarketChooseTitleCell.swift
//  CrazySnake
//
//  Created by BigB on 2023/7/13.
//

import UIKit

class CS_MarketChooseTitleCell: UICollectionReusableView {
    
    struct CellData {
        var title : String = ""
        var icon : UIImage?
        var list : [CS_NameDescribeModel]?
    }
    
    var data: CellData? {
        didSet {
            self.titleLb.text = data?.title
            if let icon = data?.icon {
                self.titleIcon.image = icon
                self.titleIcon.snp.updateConstraints { make in
                    make.size.equalTo(16)
                }
            } else {
                self.titleIcon.image = nil
                self.titleIcon.snp.updateConstraints { make in
                    make.size.equalTo(0)
                }
            }
        }
    }
     
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleIcon)
        titleIcon.snp.makeConstraints { make in
            make.size.equalTo(0)
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview()
        }
        
        self.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(titleIcon.snp.right).offset(4)
            make.centerY.equalToSuperview()
        }
        
        // 重置按钮
        resetBtn.isHidden = true
        resetBtn.setTitle("Reset", for: .normal)
        resetBtn.setTitleColor(.ls_color("#7C56E1"), for: .normal)
        resetBtn.titleLabel?.font = .ls_JostRomanFont(12)
        resetBtn.addTarget(self, action: #selector(clickResetBtn(_:)), for: .touchUpInside)
        self.addSubview(resetBtn)
        resetBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    let resetBtn = UIButton(type: .custom)

    
    var removeAllHandle : (() -> ())?
    
    @objc func clickResetBtn(_ sender : UIButton) {
        self.removeAllHandle?()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleIcon: UIImageView = {
        let titleIcon = UIImageView()
        return titleIcon
    }()
    
    lazy var titleLb: UILabel = {
        let titleLb = UILabel()
        titleLb.font = .ls_JostRomanFont(14)
        titleLb.textColor = UIColor.ls_color("#392F54")
        return titleLb
    }()
    
    
}
