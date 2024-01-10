//
//  CS_RankNFTPowerCell.swift
//  CrazySnake
//
//  Created by Lee on 15/06/2023.
//

import UIKit

class CS_RankNFTPowerCell: UITableViewCell {

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
    
    func setData(_ model: CS_RankTotalPowerModel?, index: Int){
        rankView.setData(model, index: index)
    }
    
    lazy var rankView: CS_RankNFTPowerView = {
        let view = CS_RankNFTPowerView()
        return view
    }()
}

//MARK: UI
extension CS_RankNFTPowerCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(rankView)
        
        rankView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(0)
        }
    }
}

class CS_RankNFTPowerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_RankTotalPowerModel?, index: Int){
        guard let model = model else { return }
        backView.backgroundColor = index%2 == 0 ? .ls_dark_2() : .ls_dark_3()
        rankView.setData(model.rank)
        userView.setData(model)
        numberView.qulityIcon.image = model.quality.icon()
        numberView.nameLabel.text = model.total_power
    }

    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    lazy var rankView: CS_RankIndexView = {
        let view = CS_RankIndexView()
        return view
    }()
    
    lazy var userView: CS_RankUserView = {
        let view = CS_RankUserView()
        return view
    }()
    
    lazy var numberView: CS_RankNFTHashView = {
        let view = CS_RankNFTHashView()
        view.iconView.image = UIImage.ls_bundle("rank_icon_hash_power@2x")
        return view
    }()
    
}

//MARK: UI
extension CS_RankNFTPowerView {
    
    private func setupView() {
        addSubview(backView)
        addSubview(rankView)
        addSubview(userView)
        addSubview(numberView)
        
        backView.snp.makeConstraints { make in
            make.left.equalTo(-10)
            make.right.equalTo(10)
            make.top.bottom.equalTo(0)
        }
        
        rankView.snp.makeConstraints { make in
            make.centerX.equalTo(self).multipliedBy(0.25)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        userView.snp.makeConstraints { make in
            make.centerX.equalTo(self).multipliedBy(0.8)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(106)
        }
        
        numberView.snp.makeConstraints { make in
            make.centerX.equalTo(self).multipliedBy(1.6)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(90)
        }
        
    }
}

class CS_RankNFTHashView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var qulityIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#DEEEFF"), .ls_JostRomanFont(14))
        return label
    }()
}

//MARK: UI
extension CS_RankNFTHashView {
    
    private func setupView() {
        addSubview(qulityIcon)
        addSubview(iconView)
        addSubview(nameLabel)
        
        qulityIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(2)
            make.width.height.equalTo(32)
        }
        
        iconView.snp.makeConstraints { make in
            make.right.bottom.equalTo(qulityIcon).offset(4)
            make.width.height.equalTo(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(qulityIcon)
            make.left.equalTo(iconView.snp.right).offset(10)
        }
       
    }
}
