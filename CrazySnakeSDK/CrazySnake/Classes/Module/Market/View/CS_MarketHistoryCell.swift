//
//  CS_MarketHistoryCell.swift
//  CrazySnake
//
//  Created by Lee on 26/04/2023.
//

import UIKit
import Kingfisher

class CS_MarketHistoryCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ model: CS_MarketHistoryModel){
        if model.seller?.isSelf() == true {
            backView.backgroundColor = .ls_color("#49294C",alpha: 0.6)
            actionLabel.textColor = .ls_color("#FE9681")
            actionLabel.text = "crazy_str_sold".ls_localized
        } else {
            backView.backgroundColor = .ls_color("#34294C",alpha: 0.6)
            actionLabel.textColor = .ls_color("#9381FE")
            actionLabel.text = "crazy_str_bought".ls_localized
        }
        
        if model.item_type == 2 {
            let prop = CS_NFTPropsType(rawValue: model.item_id) ?? .unkown
            nameLabel.text = prop.disPlayName()
        } else if model.item_type == 3 {
            nameLabel.text = "crazy_str_nft_sets".ls_localized
        } else {
            nameLabel.text =  "#\(model.item_id)"
        }
        fromLabel.text = model.seller?.wallet_address
        toLabel.text = model.buyer?.wallet_address
        if let url = URL.init(string: model.seller?.avatar_image ?? "") {
            fromIcon.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        } else {
            fromIcon.image = nil
        }

        if let url = URL.init(string: model.buyer?.avatar_image ?? "") {
            toIcon.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        } else {
            toIcon.image = nil
        }

        priceLabel.text = model.price
        feeAmountLabel.text = model.fee
        
        if let time = TimeInterval(model.trade_time) {
            timeLabel.text = Date.ls_intervalToDateStr(time, format: "yyyy/MM/dd\nHH:mm:ss")+"(UTC)"
        } else {
            timeLabel.text = "--"
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#34294C",alpha: 0.6)
        view.ls_cornerRadius(12)
        return view
    }()
    
    lazy var actionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 54, height: 20))
        label.textAlignment = .center
        label.backgroundColor = .ls_white(0.05)
        label.ls_set(.ls_color("#9381FE"), .ls_JostRomanFont(10))
        label.text = "Bought"
        label.ls_addCorner([.topRight,.bottomRight], cornerRadius: 10)
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Crazy Box"
        return label
    }()
    
    lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(10))
//        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    lazy var fromIcon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    lazy var toLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(10))
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    lazy var toIcon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_token_diamond@2x")
        return view
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .center
        label.text = "10"
        return label
    }()
    
    lazy var feeView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_white(0.05)
        view.ls_cornerRadius(8)
        return view
    }()
    
    lazy var feeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(10))
        label.text = "Fee".ls_localized
        return label
    }()
    
    lazy var feeIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_token_diamond@2x")
        return view
    }()
    
    lazy var feeAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#FF997E"), .ls_JostRomanFont(12))
        label.textAlignment = .right
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}

//MARK: UI
extension CS_MarketHistoryCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(actionLabel)
        backView.addSubview(nameLabel)
        backView.addSubview(fromLabel)
        backView.addSubview(toLabel)
        backView.addSubview(fromIcon)
        backView.addSubview(toIcon)
        backView.addSubview(tokenIcon)
        backView.addSubview(priceLabel)
        backView.addSubview(feeView)
        feeView.addSubview(feeLabel)
        feeView.addSubview(feeIcon)
        feeView.addSubview(feeAmountLabel)
        backView.addSubview(timeLabel)
        
        backView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        actionLabel.snp.makeConstraints { make in
            make.left.top.equalTo(backView)
            make.width.equalTo(54)
            make.height.equalTo(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(0.25)
            make.centerY.equalTo(backView)
            make.width.equalTo(contentView).multipliedBy(0.2)
        }
        
        
        fromLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(contentView.snp.centerX).multipliedBy(0.75).offset(-10)
            make.width.equalTo(80)
        }
        fromIcon.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(fromLabel.snp.left).offset(-10)
            make.size.equalTo(30)
        }

        
        toIcon.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(fromLabel.snp.right).offset(20)
            make.size.equalTo(30)
        }
        

        toLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(toIcon.snp.right).offset(10)
            make.width.equalTo(fromLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).multipliedBy(1.32)
            make.top.equalTo(12)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.right.equalTo(priceLabel.snp.left).offset(-7)
            make.centerY.equalTo(priceLabel)
            make.width.height.equalTo(22)
        }
        
        feeView.snp.makeConstraints { make in
            make.centerX.equalTo(priceLabel.snp.left)
            make.bottom.equalTo(backView).offset(-9)
            make.width.equalTo(80)
            make.height.equalTo(16)
        }
        
        feeLabel.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.centerY.equalTo(feeView)
        }
        
        feeAmountLabel.snp.makeConstraints { make in
            make.right.equalTo(-8)
            make.centerY.equalTo(feeView)
        }
        
        feeIcon.snp.makeConstraints { make in
            make.centerY.equalTo(feeView)
            make.right.equalTo(feeAmountLabel.snp.left).offset(-4)
            make.width.height.equalTo(12)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(1.75)
            make.centerY.equalTo(backView)
        }
    }
}
