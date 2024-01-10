//
//  CS_EventDetailCell.swift
//  CrazySnake
//
//  Created by Lee on 05/04/2023.
//

import UIKit
import SwiftyAttributes

class CS_EventDetailCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_EventDetailModel){
        leftAmountLabel.attributedText = "\(model.inventory-model.sold)".withTextColor(.ls_dark_3())+"/\(model.inventory)".attributedString
//        let url = URL.init(string: model.icon)
//        iconView.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        iconView.image = model.props_type.iconImage()
        offLabel.text = "\(model.discount)%\noff"
        nameLabel.text = model.props_type.disPlayName()
        availableAmountLabel.text = "\(model.can_buy_num)"
        let price = ("crazy_str_event_old_price".ls_localized(["\(model.origin_price)"])).withAttributes([
            .textColor(.ls_color("#C1B0F1")),
            .font(.ls_JostRomanFont(10)),
            .strikethroughStyle(.single)]) + "\n\(model.price)".attributedString
        priceButton.setImage(TokenName.Snake.icon(), for: .normal)
        priceButton.setAttributedTitle(price, for: .normal)
        priceButton.ls_layout(.imageLeft, padding: 5)
        soldOutView.isHidden = model.status == 1
        soldOutIcon.isHidden = model.status != 2
        cytView.isHidden = model.status != 0
        let cyt = model.buy_limit.first?.need_ticket_num ?? "-"
        cytLabel.attributedText = "\(cyt)".withFont(.ls_JostRomanFont(16)) + " CYT".attributedString
    }
    
    lazy var backView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("event_bg_detail_item@2x")
        return view
    }()
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(10))
        label.text = "crazy_str_amount_left".ls_localized
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var leftAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#8348E6"), .ls_JostRomanFont(16))
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var offView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("event_bg_detail_off@2x")
        return view
    }()
    
    lazy var offLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(10))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var availableView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("event_bg_detail_available@2x")
        return view
    }()
    
    lazy var availableLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(10))
        label.text = "crazy_str_available".ls_localized
        return label
    }()
    
    lazy var availableAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#8348E6"), .ls_JostRomanFont(16))
        label.textAlignment = .right
        return label
    }()
    
    lazy var priceButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 145, height: 34))
        button.ls_cornerRadius(5)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.isUserInteractionEnabled = false
        button.setImage(TokenName.Snake.icon(), for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.backgroundColor = .ls_color("#8E56E1")
        return button
    }()
    
    lazy var soldOutView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_black(0.5)
        view.ls_cornerRadius(5)
        view.isHidden = true
        return view
    }()
    
    lazy var soldOutIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("event_icon_detail_sold_out@2x")
        return view
    }()
    
    lazy var cytView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#8348E6")
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var cytLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()
    
    lazy var cytIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("event_icon_lock@2x")
        view.contentMode = .center
        view.backgroundColor = .ls_color("#9454FF")
        view.ls_cornerRadius(5)
        return view
    }()
}

//MARK: function
extension CS_EventDetailCell {
    class func itemSize() -> CGSize {
        return CGSize(width: 165, height: 206)
    }
}

//MARK: UI
extension CS_EventDetailCell {
    
    private func setupView() {
        contentView.addSubview(backView)
        backView.addSubview(leftLabel)
        backView.addSubview(leftAmountLabel)
        backView.addSubview(iconView)
        backView.addSubview(offView)
        backView.addSubview(offLabel)
        backView.addSubview(nameLabel)
        backView.addSubview(availableView)
        availableView.addSubview(availableLabel)
        availableView.addSubview(availableAmountLabel)
        backView.addSubview(priceButton)
        backView.addSubview(soldOutView)
        soldOutView.addSubview(soldOutIcon)
        soldOutView.addSubview(cytView)
        cytView.addSubview(cytLabel)
        cytView.addSubview(cytIcon)
        
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        leftLabel.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.top.equalTo(12)
        }
        
        leftAmountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(leftLabel)
            make.right.equalTo(-16)
            make.left.equalTo(backView.snp.centerX).offset(5)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(39)
            make.top.equalTo(38)
            make.width.equalTo(82)
            make.height.equalTo(73)
        }
        
        offView.snp.makeConstraints { make in
            make.right.equalTo(-7)
            make.top.equalTo(iconView)
            make.width.height.equalTo(34)
        }
        
        offLabel.snp.makeConstraints { make in
            make.center.equalTo(offView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(availableView.snp.top).offset(-4)
        }
        
        availableView.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.bottom.equalTo(priceButton.snp.top).offset(-5)
            make.width.equalTo(102)
            make.height.equalTo(21)
        }
        
        availableLabel.snp.makeConstraints { make in
            make.centerY.equalTo(availableView)
            make.left.equalTo(availableView).offset(10)
        }
        
        availableAmountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(availableView)
            make.right.equalTo(availableView).offset(-12)
        }
        
        priceButton.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.bottom.equalTo(-11)
            make.width.equalTo(145)
            make.height.equalTo(34)
        }
        
        soldOutView.snp.makeConstraints { make in
            make.left.equalTo(9)
            make.top.equalTo(7)
            make.right.equalTo(-10)
            make.bottom.equalTo(-11)
        }
        
        soldOutIcon.snp.makeConstraints { make in
            make.center.equalTo(soldOutView)
        }
        
        cytView.snp.makeConstraints { make in
            make.center.equalTo(soldOutView)
            make.width.equalTo(120)
            make.height.equalTo(34)
        }
        
        cytIcon.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(cytView)
            make.width.equalTo(34)
        }
        
        cytLabel.snp.makeConstraints { make in
            make.right.centerY.equalTo(cytView)
            make.left.equalTo(cytIcon.snp.right)
        }
    }
}
