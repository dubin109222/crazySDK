//
//  SelectTokenAlert.swift
//  Platform
//
//  Created by Lee on 10/05/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit

class SelectTokenAlert: CS_BaseChooseAlert {

    var dataSource: [TokenName] = [.USDT,.Snake]
    typealias SelectTokenBlock = (TokenName) -> Void
    var selecedToken: SelectTokenBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.register(SelectTokenCell.self, forCellReuseIdentifier: NSStringFromClass(SelectTokenCell.self))
        view.backgroundColor = UIColor.clear
        return view
    }()
}

//MARK: TableView
extension SelectTokenAlert: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SelectTokenCell.self)) as! SelectTokenCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        dismissSelf()
        selecedToken?(model)
    }

}

//MARK: UI
extension SelectTokenAlert {
    
    private func setupView() {
        
        contentView.snp.remakeConstraints { make in
            make.top.equalTo(106)
            make.right.equalTo(-320)
            make.width.equalTo(171)
            make.height.equalTo(155)
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(30)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
}

class SelectTokenCell: UITableViewCell {
    
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
    
    func setData(_ model: TokenName?){
        guard let model = model else { return }
        nameLabel.text = model.rawValue
        iconView.image = model.icon()
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(12))
        label.textAlignment = .center
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()

}

//MARK: UI
extension SelectTokenCell {
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(iconView)
        
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(32)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconView.snp.right).offset(12)
        }
    }
}

