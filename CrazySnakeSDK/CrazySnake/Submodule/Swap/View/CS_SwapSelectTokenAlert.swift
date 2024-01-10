//
//  CS_SwapSelectTokenAlert.swift
//  CrazySnake
//
//  Created by Lee on 16/03/2023.
//

import UIKit
import SnapKit

class CS_SwapSelectTokenAlert: CS_BaseChooseAlert {

    var dataSource: [TokenName] = []
    typealias SelectTokenBlock = (TokenName) -> Void
    var selecedToken: SelectTokenBlock?
    
    var deselected: [TokenName] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let hasUsdt = CS_AccountManager.shared.coinTokenList.first(where: {$0.token == .USDT}) {
            self.dataSource.append(hasUsdt.token ?? .USDT)
        }
        
        for item in CS_AccountManager.shared.basicConfig?.contract?.current_token ?? [] {
            self.dataSource.append(item.token_name)
        }
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(_ closure: (_ make: ConstraintMaker) -> Void) {
        contentView.snp.remakeConstraints(closure)
        tableView.reloadData()
        show()
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
extension CS_SwapSelectTokenAlert: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SelectTokenCell.self)) as! SelectTokenCell
        let model = dataSource[indexPath.row]
        cell.setData(model)        
//        cell.isUserInteractionEnabled = !self.deselected.contains(where: {$0 == model})
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
extension CS_SwapSelectTokenAlert {
    
    private func setupView() {
        contentView.backgroundColor = .gray
        contentView.snp.remakeConstraints { make in
            make.top.equalTo(200)
            make.right.equalTo(-65)
            make.width.equalTo(140)
            make.height.equalTo(80)
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
        }
    }
}
