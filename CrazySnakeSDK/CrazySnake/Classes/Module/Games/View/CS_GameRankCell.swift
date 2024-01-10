//
//  CS_GameRankCell.swift
//  CrazySnake
//
//  Created by Lee on 18/05/2023.
//

import UIKit

class CS_GameRankCell: UITableViewCell {

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
    
    func setData(_ model: CS_GameRankModel?) {
        rankView.setData(model)
    }

    lazy var rankView: CS_GameRankView = {
        let view = CS_GameRankView()
        return view
    }()
}

//MARK: UI
extension CS_GameRankCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(rankView)
        
        rankView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

class CS_GameRankView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_GameRankModel?) {
        guard let model = model else { return }
        switch model.rank {
        case 1:
            rankLabel.textColor = .ls_color("#FFF439")
        case 2:
            rankLabel.textColor = .ls_color("#947FFF")
        case 3:
            rankLabel.textColor = .ls_color("#FF8656")
        default:
            rankLabel.textColor = .ls_white()
        }
        if model.rank > 0 {
            rankLabel.text = "\(model.rank)"
        } else {
            rankLabel.text = "-"
        }
        nameLabel.text = model.user?.name
        addressLabel.text = model.user?.wallet_address
        amountLabel.text = model.total_amount
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2()
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(19))
        label.textAlignment = .center
        return label
    }()
    
    lazy var userIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("common_default_head_icon@2x")
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(19))
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        view.image = TokenName.Diamond.icon()
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#FFF439"), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "-"
        return label
    }()
    
}

//MARK: UI
extension CS_GameRankView {
    
    private func setupView() {
        addSubview(backView)
        backView.addSubview(rankLabel)
        backView.addSubview(userIcon)
        backView.addSubview(nameLabel)
        backView.addSubview(addressLabel)
        backView.addSubview(tokenIcon)
        backView.addSubview(amountLabel)
        
        backView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(0)
            make.bottom.equalTo(-5)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.centerX.equalTo(self).multipliedBy(0.2)
        }
        
        userIcon.snp.makeConstraints { make in
            make.left.equalTo(96)
            make.centerY.equalTo(backView)
            make.width.height.equalTo(34)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(userIcon.snp.right).offset(12)
            make.top.equalTo(userIcon).offset(-5)
            make.width.equalTo(140)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(userIcon).offset(5)
            make.width.equalTo(140)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.centerX.equalTo(self).multipliedBy(1.5)
            make.top.equalTo(11)
            make.width.height.equalTo(24)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(tokenIcon)
            make.top.equalTo(tokenIcon.snp.bottom).offset(2)
        }
    }
}
