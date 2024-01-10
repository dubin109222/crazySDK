//
//  CS_GamesRankController.swift
//  CrazySnake
//
//  Created by Lee on 18/05/2023.
//

import UIKit

class CS_GamesRankController: CS_BaseAlertController {

    var personRank: CS_GameRankModel?
    private var dataSource = [CS_GameRankModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emptyStyle = .loading
        setupView()
        requstList()
    }
    
    lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_rank".ls_localized
        return label
    }()
    
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_biggest_winner".ls_localized
        return label
    }()
    
    lazy var betLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_bet_bonus".ls_localized
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 0)
        view.separatorStyle = .none
        view.rowHeight = 65
        view.register(CS_GameRankCell.self, forCellReuseIdentifier: NSStringFromClass(CS_GameRankCell.self))
        view.backgroundColor = .clear
        view.ls_cornerRadius(15)
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.requstList()
        }
        return view
    }()
    
    lazy var rankView: CS_GameRankView = {
        let view = CS_GameRankView()
        view.backView.backgroundColor = .ls_dark_3()
        view.isHidden = true
        return view
    }()
}

//MARK: TableView
extension CS_GamesRankController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_GameRankCell.self)) as! CS_GameRankCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: request
extension CS_GamesRankController {
    func requstList(){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            tableView.reloadData()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        CSNetworkManager.shared.getRankList(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                
                weakSelf?.personRank = resp.data?.personal
                weakSelf?.rankView.isHidden = false
                weakSelf?.rankView.setData(weakSelf?.personRank)
                weakSelf?.dataSource.removeAll()
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
                }
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            
            weakSelf?.tableView.ls_compeletLoading(true, hasMore: false)
            weakSelf?.tableView.reloadData()
        }
    }
}


//MARK: UI
extension CS_GamesRankController {
    
    private func setupView() {
        
        contentView.backgroundColor = .ls_dark_3()
        contentView.addSubview(rankLabel)
        contentView.addSubview(userLabel)
        contentView.addSubview(betLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(rankView)
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(462)
            make.top.equalTo(35)
            make.bottom.equalTo(-35)
        }
        
        rankLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(0.2)
            make.top.equalTo(12)
        }
        
        userLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(0.8)
            make.centerY.equalTo(rankLabel)
        }
        
        betLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(1.5)
            make.centerY.equalTo(rankLabel)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(41)
            make.bottom.equalTo(contentView).offset(-65)
        }
        
        rankView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(65)
        }
    }
}
