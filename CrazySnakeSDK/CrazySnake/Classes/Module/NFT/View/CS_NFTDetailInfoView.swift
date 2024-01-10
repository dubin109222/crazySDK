//
//  CS_NFTDetailInfoView.swift
//  CrazySnake
//
//  Created by Lee on 03/04/2023.
//

import UIKit
import SwiftyAttributes

class CS_NFTDetailInfoView: UIView {

    var model: CS_NFTDataModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ model: CS_NFTDataModel?) {
        self.model = model
        powerView.amountLabel.text = "\(Int(model?.total_power ?? 0) )"
        powerView.amountLabel.textColor = model?.quality.color()
        powerView.iconView.image = model?.quality.iconPower()
        
        starView.amountLabel.textColor = model?.quality.color()
        starView.amountLabel.text = "\(model?.level_evolve ?? 0)"
        starView.setIcon(model?.quality.color(), image: model?.evolve?.current_level?.iconImage())
        starView.starView.showRightStar(model?.evolve?.current_level?.num ?? 0, color: model?.quality.color(), image: model?.evolve?.current_level?.iconImage())
        
        incubateView.amountLabel.attributedText = "\(model?.incubation_current_times ?? 0)".withTextColor(model?.quality.color() ?? .ls_white())+"/\(model?.incubation_max_times ?? 7)".attributedString
        incubateView.iconView.image = model?.quality.iconIncubate()
        setView.amountLabel.text = model?.nft_class.cs_configName()
    }

    lazy var powerView: CS_NFTDetailInfoItemView = {
        let view = CS_NFTDetailInfoItemView()
        view.titleLabel.text = "Hash Power"
        return view
    }()
    
    lazy var starView: CS_NFTDetailInfoStarView = {
        let view = CS_NFTDetailInfoStarView()
        view.titleLabel.text = "crazy_str_nft_upgrade_stage".ls_localized
        return view
    }()
        
    lazy var incubateView: CS_NFTDetailInfoItemView = {
        let view = CS_NFTDetailInfoItemView()
        view.titleLabel.text = "crazy_str_nft_Incubation_times".ls_localized
        return view
    }()
    
    lazy var setView: CS_NFTDetailInfoItemView = {
        let view = CS_NFTDetailInfoItemView()
        view.titleLabel.text = "Set ID"
        view.amountLabel.text = ""
//        view.amountLabel.textColor = model?.quality.color()
        view.iconView.image = UIImage.ls_bundle("nft_icon_set_icon@2x")
        return view
    }()
    
    lazy var lineView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("nft_icon_detail_line@2x")
        return view
    }()
    
    lazy var supportGamesLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#EDDEFF"), .ls_JostRomanFont(12))
        label.text = "crazy_str_support_games".ls_localized
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.rowHeight = 30
        view.register(CS_NFTDetailSupportGamesCell.self, forCellReuseIdentifier: NSStringFromClass(CS_NFTDetailSupportGamesCell.self))
        return view
    }()
}

//MARK: TableView
extension CS_NFTDetailInfoView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.support_games.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_NFTDetailSupportGamesCell.self)) as! CS_NFTDetailSupportGamesCell
        let model = model?.support_games[indexPath.row]
        cell.nameLabel.text = model
        return cell
    }
    
}

//MARK: UI
extension CS_NFTDetailInfoView {
    
    private func setupView() {
        addSubview(powerView)
        addSubview(starView)
        addSubview(incubateView)
        addSubview(setView)
        addSubview(lineView)
        addSubview(supportGamesLabel)
        addSubview(tableView)
        
        powerView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(28)
            make.top.equalTo(self).offset(18)
            make.width.equalTo(self).multipliedBy(0.6)
            make.height.equalTo(16)
        }
        
        starView.snp.makeConstraints { make in
            make.left.width.height.equalTo(powerView)
            make.top.equalTo(self).offset(18+32)
        }
        
        incubateView.snp.makeConstraints { make in
            make.left.width.height.equalTo(powerView)
            make.top.equalTo(self).offset(18+32*2)
        }
        
        setView.snp.makeConstraints { make in
            make.left.width.height.equalTo(powerView)
            make.top.equalTo(self).offset(18+32*3)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.equalTo(powerView.snp.right).offset(16)
            make.top.equalTo(powerView)
            make.bottom.equalTo(setView)
            make.width.equalTo(1)
        }
        
        supportGamesLabel.snp.makeConstraints { make in
            make.left.equalTo(lineView.snp.right)
            make.right.equalTo(0)
            make.top.equalTo(lineView)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(supportGamesLabel)
            make.top.equalTo(supportGamesLabel.snp.bottom).offset(8)
            make.bottom.equalTo(lineView)
        }
    }
}


class CS_NFTDetailSupportGamesCell: UITableViewCell {
    
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
   
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()
}

//MARK: UI
extension CS_NFTDetailSupportGamesCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
