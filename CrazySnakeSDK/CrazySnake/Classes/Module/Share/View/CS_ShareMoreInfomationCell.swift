//
//  CS_ShareMoreInfomationCell.swift
//  CrazySnake
//
//  Created by Lee on 09/08/2023.
//

import UIKit
import SwiftyAttributes

class CS_ShareMoreInfomationCell: UITableViewCell {

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
    
    func setData(_ model: CS_ShareFriendModel?, index: Int){
        guard let model = model else { return }
        backView.backgroundColor = index%2 == 0 ? .ls_dark_3() : .ls_dark_2()
        addressLabel.text = model.wallet
        dayShared.amountLabel.text = model.daily?.cash
        dayDirect.amountLabel.text = model.daily?.cash_1
        dayIndirect.amountLabel.text = model.daily?.cash_2
        
        totalShared.amountLabel.text = model.total?.cash
        totalDirect.amountLabel.text = model.total?.cash_1
        totalIndirect.amountLabel.text = model.total?.cash_2
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_boldFont(10))
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    lazy var dayShared: CS_ShareInfomationItemView = {
        let view = CS_ShareInfomationItemView()
        view.infoLabel.text = "crazy_str_shared_today".ls_localized
        return view
    }()
    
    lazy var dayDirect: CS_ShareInfomationItemView = {
        let view = CS_ShareInfomationItemView()
        view.infoLabel.attributedText = "crazy_str_direct_share".ls_localized_color(["15"])
        return view
    }()
    
    lazy var dayIndirect: CS_ShareInfomationItemView = {
        let view = CS_ShareInfomationItemView()
        view.infoLabel.attributedText = "crazy_str_indirect_share".ls_localized_color(["5"])
        return view
    }()
    
    lazy var totalShared: CS_ShareInfomationItemView = {
        let view = CS_ShareInfomationItemView()
        view.infoLabel.text = "crazy_str_shared_total".ls_localized
        return view
    }()
    
    lazy var totalDirect: CS_ShareInfomationItemView = {
        let view = CS_ShareInfomationItemView()
        view.infoLabel.attributedText = "crazy_str_direct_share".ls_localized_color(["15"])
        return view
    }()
    
    lazy var totalIndirect: CS_ShareInfomationItemView = {
        let view = CS_ShareInfomationItemView()
        view.infoLabel.attributedText = "crazy_str_indirect_share".ls_localized_color(["5"])
        return view
    }()
     
}

//MARK: UI
extension CS_ShareMoreInfomationCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        contentView.addSubview(addressLabel)
        contentView.addSubview(dayShared)
        contentView.addSubview(dayDirect)
        contentView.addSubview(dayIndirect)
        contentView.addSubview(totalShared)
        contentView.addSubview(totalDirect)
        contentView.addSubview(totalIndirect)
        
        backView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(0.35)
            make.centerY.equalToSuperview()
            make.width.equalTo(kScreenW*0.2)
        }
        
        dayDirect.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(1)
            make.centerY.equalTo(backView)
            make.width.equalTo(kScreenW*0.18)
            make.height.equalTo(40)
        }
        
        dayShared.snp.makeConstraints { make in
            make.left.right.height.equalTo(dayDirect)
            make.top.equalTo(0)
        }
        
        dayIndirect.snp.makeConstraints { make in
            make.left.right.height.equalTo(dayDirect)
            make.bottom.equalTo(0)
        }
        
        totalDirect.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(contentView).multipliedBy(1.65)
            make.width.height.equalTo(dayDirect)
        }
        
        totalShared.snp.makeConstraints { make in
            make.left.right.height.equalTo(totalDirect)
            make.top.equalTo(0)
        }
        
        totalIndirect.snp.makeConstraints { make in
            make.left.right.height.equalTo(totalDirect)
            make.bottom.equalTo(0)
        }
    }
}

class CS_ShareInfomationItemView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_mediumFont(12))
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_mediumFont(12))
        label.textAlignment = .right
        return label
    }()
    
}

//MARK: UI
extension CS_ShareInfomationItemView {
    
    private func setupView() {
        
        addSubview(infoLabel)
        addSubview(amountLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(0)
        }
                
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(infoLabel)
            make.right.equalTo(0)
        }
    }
}

