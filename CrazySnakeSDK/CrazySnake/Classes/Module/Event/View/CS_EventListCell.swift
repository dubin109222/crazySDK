//
//  CS_EventListCell.swift
//  CrazySnake
//
//  Created by Lee on 04/04/2023.
//

import UIKit

class CS_EventListCell: UITableViewCell {

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
    
    func setData(_ model: CS_EventListItemModel, current: CS_EventListItemModel?) {
        titleLabel.text = model.name
        
        if model.id == current?.id {
            backView.backgroundColor = .ls_color("#E7D7FF")
            titleLabel.textColor = .ls_color("#2D223A")
        } else {
            backView.backgroundColor = .ls_color("#342E42")
            titleLabel.textColor = .ls_white()
        }
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(3)
        view.backgroundColor = .ls_color("#342E42")
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()
}

//MARK: UI
extension CS_EventListCell {
    
    private func setupView() {
        backgroundColor = .ls_dark_3()
        contentView.addSubview(backView)
        backView.addSubview(titleLabel)
        
        backView.snp.makeConstraints { make in
            make.left.equalTo(-CS_kSafeAreaHeight)
            make.right.equalTo(-6)
            make.top.equalTo(5)
            make.bottom.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backView)
            make.left.equalTo(backView).offset(6)
            make.right.equalTo(backView).offset(-6)
        }
    }
}
