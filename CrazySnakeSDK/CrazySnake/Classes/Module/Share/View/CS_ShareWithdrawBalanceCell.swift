//
//  CS_ShareWithdrawBalanceCell.swift
//  CrazySnake
//
//  Created by Lee on 08/08/2023.
//

import UIKit

class CS_ShareWithdrawBalanceCell: UITableViewCell {

    var clickHistoryAction: CS_NoParasBlock?
    
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
    
    lazy var tokenBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#ABABAB",alpha: 0.6)
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_color("#F8F8F8")
        return view
    }()
    
    lazy var infoView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_color("#453B59")
        return view
    }()
    
    lazy var cornerIconView: UIImageView = {
        let view = UIImageView()
        view.image = .ls_named("share_icon_corner_cover@2x")
        return view
    }()
    
    lazy var tokenIcon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var shadowView: UIImageView = {
        let view = UIImageView()
        view.image = .ls_named("share_icon_shadow@2x")
        return view
    }()
    
    lazy var tokenLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_boldFont(16))
        label.textAlignment = .center
        return label
    }()

    lazy var balanceBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#333333")
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var balanceTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#F8F8F8")
        return view
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark_3(), .ls_font(14))
        label.text = "crazy_str_balance".ls_localized
        return label
    }()
    
    lazy var cashLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(10))
        label.text = "crazy_str_cash_value".ls_localized
        return label
    }()
    
    lazy var cashAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#D8CAFF"), .ls_boldFont(16))
        return label
    }()
    
    lazy var historyButton: UIButton = {
        let button = UIButton(frame: CGRectMake(0, 0, 40, 54))
        button.addTarget(self, action: #selector(clickHistoryButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("share_icon_withdraw_history@2x"), for: .normal)
        button.titleLabel?.font = .ls_font(12)
        button.setTitle("crazy_str_history".ls_localized, for: .normal)
        button.setTitleColor(.ls_white(), for: .normal)
        button.ls_layout(.imageTop, padding: 3)
        return button
    }()
}

//MARK: data
extension CS_ShareWithdrawBalanceCell {
    func setData(_ data: CS_ShareDataModel?) {
        guard let data = data else { return }
        cashAmountLabel.text = data.balance?.cash
        if let token = data.withdraw?.tokens.first {
            tokenIcon.image = token.tokenName.icon()
            tokenLabel.text = token.name
        }
    }
}


//MARK: action
extension CS_ShareWithdrawBalanceCell {
    @objc private func clickHistoryButton(_ sender: UIButton) {
        clickHistoryAction?()
    }
}


//MARK: UI
extension CS_ShareWithdrawBalanceCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(tokenBackView)
        tokenBackView.addSubview(backView)
        backView.addSubview(infoView)
        backView.addSubview(cornerIconView)
        infoView.addSubview(shadowView)
        infoView.addSubview(tokenIcon)
        infoView.addSubview(tokenLabel)
        contentView.addSubview(balanceBackView)
        balanceBackView.addSubview(balanceTopView)
        balanceTopView.addSubview(balanceLabel)
        balanceBackView.addSubview(cashLabel)
        balanceBackView.addSubview(cashAmountLabel)
        balanceBackView.addSubview(historyButton)
        
        tokenBackView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(118)
            make.height.equalTo(98)
        }
        
        backView.snp.makeConstraints { make in
            make.left.top.equalTo(4)
            make.right.bottom.equalTo(-4)
        }
        
        infoView.snp.makeConstraints { make in
            make.left.top.equalTo(2)
            make.right.bottom.equalTo(-2)
        }
        
        cornerIconView.snp.makeConstraints { make in
            make.top.right.equalTo(0)
        }
        
        tokenIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(8)
            make.width.height.equalTo(43)
        }
        
        shadowView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tokenIcon.snp.bottom).offset(-2)
        }
        
        tokenLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-4)
        }
        
        balanceBackView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(tokenBackView.snp.right).offset(40)
            make.width.equalTo(160)
            make.height.equalTo(92)
        }
        
        balanceTopView.snp.makeConstraints { make in
            make.left.top.right.equalTo(balanceBackView)
            make.height.equalTo(24)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        cashLabel.snp.makeConstraints { make in
            make.left.equalTo(balanceLabel)
            make.top.equalTo(34)
        }
        
        cashAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(balanceLabel)
            make.bottom.equalTo(-12)
        }
        
        historyButton.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.bottom.equalTo(-10)
            make.width.equalTo(40)
            make.height.equalTo(50)
        }
        
    }
}
