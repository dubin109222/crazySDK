//
//  CS_WalletGameAssetsController.swift
//  CrazySnake
//
//  Created by Lee on 26/07/2023.
//

import UIKit
import JXSegmentedView

class CS_WalletGameAssetsController: CS_BaseEmptyController {

    var tokenList: [TokenName] = [.Diamond]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDefaultData()
        setupView()
        registerNotication()
    }
    
    func setupDefaultData(){
        switch CSSDKManager.shared.gameId {
        case 1:
            tokenList = [.Diamond]
        case 2:
            tokenList = [.Diamond2]
        default:
            tokenList = [.Diamond]
        }
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.rowHeight = 51
        view.register(WalletTokenCell.self, forCellReuseIdentifier: NSStringFromClass(WalletTokenCell.self))
        view.backgroundColor = UIColor.ls_color("#171718")
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return view
    }()
   
}

//MARK: notification
extension CS_WalletGameAssetsController {
    private func registerNotication(){
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletChange(_:)), name: NotificationName.walletChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletInfoChange(_:)), name: NotificationName.walletBalanceChanged, object: nil)
    }
    
    @objc private func notifyWalletChange(_ notify: Notification) {
        tableView.reloadData()
    }
    
    @objc private func notifyWalletInfoChange(_ notify: Notification) {
        tableView.reloadData()
    }
}

//MARK: TableView
extension CS_WalletGameAssetsController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokenList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(WalletTokenCell.self)) as! WalletTokenCell
        let token = tokenList[indexPath.row]
        cell.setData(token,index: indexPath)
        return cell
    }

}

//MARK: UI
extension CS_WalletGameAssetsController {
    
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

extension CS_WalletGameAssetsController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

