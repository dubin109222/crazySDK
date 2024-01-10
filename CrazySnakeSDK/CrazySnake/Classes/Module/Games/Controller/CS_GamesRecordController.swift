//
//  CS_GamesRecordController.swift
//  CrazySnake
//
//  Created by Lee on 18/05/2023.
//

import UIKit

class CS_GamesRecordController: CS_BaseAlertController {

    private var page = 1
    private var dataSource = [CS_SessionInfoModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emptyStyle = .loading
        setupView()
        requstList()
    }
    
    lazy var luckLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_luck_team".ls_localized
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_time".ls_localized
        return label
    }()
    
    lazy var redLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_red_team".ls_localized
        return label
    }()
    
    lazy var blueLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_blue_team".ls_localized
        return label
    }()
    
    lazy var randomLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_random_value".ls_localized
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.separatorStyle = .none
        view.rowHeight = 65
        view.register(CS_GameRecordCell.self, forCellReuseIdentifier: NSStringFromClass(CS_GameRecordCell.self))
        view.backgroundColor = .clear
        view.ls_cornerRadius(15)
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requstList()
        }
        view.ls_addFooter {
            weakSelf?.page += 1
            weakSelf?.requstList()
        }
        view.mj_footer.isHidden = true
        return view
    }()
}

//MARK: TableView
extension CS_GamesRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_GameRecordCell.self)) as! CS_GameRecordCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: request
extension CS_GamesRecordController {
    func requstList(){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            tableView.reloadData()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["page"] = "\(page)"
        para["page_size"] = "20"
        CSNetworkManager.shared.getSessionHistoryList(para) { resp in
            LSHUD.hide()
            var hasMore = false
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
                }
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            if weakSelf?.dataSource.count ?? 0 < resp.data?.total ?? 0 {
                hasMore = true
            }
            weakSelf?.tableView.ls_compeletLoading(weakSelf?.page == 1, hasMore: hasMore)
            weakSelf?.tableView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 < 6
            weakSelf?.tableView.reloadData()
        }
    }
}


//MARK: UI
extension CS_GamesRecordController {
    
    private func setupView() {
        
        contentView.backgroundColor = .ls_dark_3()
        contentView.addSubview(luckLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(redLabel)
        contentView.addSubview(blueLabel)
        contentView.addSubview(randomLabel)
        contentView.addSubview(tableView)
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(630)
            make.top.equalTo(35)
            make.bottom.equalTo(-35)
        }
        
        luckLabel.snp.makeConstraints { make in
            make.left.equalTo(53)
            make.top.equalTo(12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(0.65)
            make.centerY.equalTo(luckLabel)
        }
        
        redLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(luckLabel)
        }
        
        blueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(1.3)
            make.centerY.equalTo(luckLabel)
        }
        
        randomLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(1.7)
            make.centerY.equalTo(luckLabel)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(41)
        }
    }
}
