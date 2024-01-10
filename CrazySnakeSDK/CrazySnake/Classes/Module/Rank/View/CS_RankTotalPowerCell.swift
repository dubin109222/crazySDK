//
//  CS_RankTotalPowerCell.swift
//  CrazySnake
//
//  Created by Lee on 13/06/2023.
//

import UIKit

class CS_RankTotalPowerCell: UITableViewCell {
    
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
    
    lazy var rankView: CS_RankTotalPowerView = {
        let view = CS_RankTotalPowerView()
        return view
    }()
}

//MARK: UI
extension CS_RankTotalPowerCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(rankView)
        
        rankView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(0)
        }
    }
}
    
class CS_RankTotalPowerView: UIView {
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
        numberView.nameLabel.text = "\(model.nums)"
        hashView.nameLabel.text = model.total_power
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
    
    lazy var numberView: CS_RankItemView = {
        let view = CS_RankItemView()
        view.iconView.image = UIImage.ls_bundle("rank_icon_number_nft@2x")
        return view
    }()
    
    lazy var hashView: CS_RankItemView = {
        let view = CS_RankItemView()
        view.iconView.image = UIImage.ls_bundle("rank_icon_hash_power@2x")
        return view
    }()

}

//MARK: UI
extension CS_RankTotalPowerView {
    
    private func setupView() {
        addSubview(backView)
        addSubview(rankView)
        addSubview(userView)
        addSubview(numberView)
        addSubview(hashView)
        
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
            make.centerX.equalTo(self).multipliedBy(0.75)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(106)
        }
        
        numberView.snp.makeConstraints { make in
            make.centerX.equalTo(self).multipliedBy(1.25)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(90)
        }
        
        hashView.snp.makeConstraints { make in
            make.centerX.equalTo(self).multipliedBy(1.75)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(100)
        }
    }
}
