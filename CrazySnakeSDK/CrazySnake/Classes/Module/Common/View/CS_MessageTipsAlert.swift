//
//  CS_AirDropDetails.swift
//  CrazySnake
//
//  Created by BigB on 2023/7/11.
//
//  空投说明

import UIKit
import SnapKit
import HandyJSON

struct CS_MessageTipsAlertModel : HandyJSON{
    var title: String = ""
    var content: String = ""
}


class CS_MessageTipsAlert: CS_BaseAlert {
    
    var data : CS_MessageTipsAlertModel? {
        didSet {
            self.titleLabel.text = data?.title
            self.contentText.text = data?.content
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel.text = "Msg Tips"
        
        contentView.snp.remakeConstraints { make in
            make.left.equalTo(197)
            make.right.equalTo(-104)
            make.bottom.equalTo(-75.5)
            make.top.equalTo(80.5)
        }

        self.initSubViews()
        closeButton.isHidden = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var contentText: UITextView = {
        let contentText = UITextView()
        contentText.backgroundColor = .clear
        contentText.textColor = .ls_color("#999999")
        contentText.isEditable = false
        contentText.showsVerticalScrollIndicator = false
        return contentText
    }()

    func initSubViews()  {
        self.contentView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 366, height: 219))
        }
        
        let confirmBtn = UIButton(type: .custom)
        confirmBtn.setTitle("Confirm", for: .normal)
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.titleLabel?.font = .ls_JostRomanFont(16)
        confirmBtn.addTarget(self, action: #selector(clickCloseButton(_:)), for: .touchUpInside)
        confirmBtn.cornerRadius = 7
        
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.48, green: 0.34, blue: 0.88, alpha: 1).cgColor, UIColor(red: 0.56, green: 0.34, blue: 0.88, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = CGRect(origin: .zero, size: .init(width: 174, height: 44))
        confirmBtn.layer.insertSublayer(gradient1, at: 0)
        
        self.contentView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 174, height: 44))
            make.bottom.equalToSuperview().offset(-16.5)
        }
        
        
        self.contentView.addSubview(contentText)
        contentText.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.bottom.equalTo(confirmBtn.snp.top).offset(-22.5)
            make.top.equalTo(titleLabel.snp.bottom).offset(14.5)
        }
                
    }
}
