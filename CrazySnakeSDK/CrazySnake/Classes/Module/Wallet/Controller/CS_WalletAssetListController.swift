//
//  CS_WalletAssetListController.swift
//  CrazyWallet
//
//  Created by Lee on 30/06/2023.
//

import UIKit
import JXSegmentedView

typealias CS_ChooseTokenBlock = (TokenName) -> Void

class CS_WalletAssetListController: CS_BaseEmptyController {

    var chooseTokenAction: CS_ChooseTokenBlock?
    var tokenList: [TokenName] = [.USDT,.Snake]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.rowHeight = 51
        view.register(WalletTokenCell.self, forCellReuseIdentifier: NSStringFromClass(WalletTokenCell.self))
        view.backgroundColor = .ls_color("#171718")
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return view
    }()
   
}

//MARK: TableView
extension CS_WalletAssetListController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokenList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(WalletTokenCell.self)) as! WalletTokenCell
        let token = tokenList[indexPath.row]
        cell.setData(token,index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let token = tokenList[indexPath.row]
        chooseTokenAction?(token)
    }

}

//MARK: UI
extension CS_WalletAssetListController {
    
    private func setupView() {
        
        navigationView.isHidden = true
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
        }
        
    }
}

extension CS_WalletAssetListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

