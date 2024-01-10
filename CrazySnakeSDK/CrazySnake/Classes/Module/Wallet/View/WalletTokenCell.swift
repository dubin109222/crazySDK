//
//  WalletTokenCell.swift
//  Platform
//
//  Created by Lee on 29/04/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit

class WalletTokenCell: UITableViewCell {
    
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
    
    func setData(_ model: TokenName,index: IndexPath){
//        backView.isHidden = (index.row%2 != 0)
        iconView.image = model.icon()
        nameLabel.text = model.name()
        let token = CS_AccountManager.shared.coinTokenList.first(where: {$0.token == model})
        amountLabel.text = Utils.formatAmount(token?.balance ?? "0")
        gameLabel.text = token?.game_name
//        amountLabel.text = Utils.formatAmount(model.amount) + " \(model.name)"
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_color("#EEEEEE"), UIFont.ls_boldFont(14))
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(14))
        label.textAlignment = .right
        label.text = "-"
        return label
    }()
    
    lazy var gameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_color("#666666"), UIFont.ls_boldFont(14))
        return label
    }()

}

//MARK: UI
extension WalletTokenCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        contentView.addSubview(iconView)
        let vStack = UIStackView(arrangedSubviews: [nameLabel,gameLabel])
        vStack.axis = .vertical
        contentView.addSubview(vStack)

//        contentView.addSubview(nameLabel)
//        contentView.addSubview(gameLabel)
        contentView.addSubview(amountLabel)
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalToSuperview()
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
    
        iconView.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.left.equalTo(backView).offset(20)
            make.width.height.equalTo(31)
        }
        
        vStack.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.left.equalTo(iconView.snp.right).offset(16)
        }
//        nameLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(backView)
//            make.left.equalTo(iconView.snp.right).offset(16)
//        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.right.equalTo(backView).offset(-23)
        }
    }
}
