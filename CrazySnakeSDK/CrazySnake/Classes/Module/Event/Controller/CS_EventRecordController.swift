//
//  CS_EventRecordController.swift
//  CrazySnake
//
//  Created by Lee on 10/06/2023.
//

import UIKit

class CS_EventRecordController: CS_BaseAlertController {

    private var page = 1
    private var dataSource = [CS_EventRecordModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        emptyStyle = .loading
        setupView()
        requstList()
    }
    
    lazy var sectionBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2()
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_buy_item".ls_localized
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_buy_amount".ls_localized
        return label
    }()
    
    lazy var payLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_spend".ls_localized
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_purchase_time".ls_localized
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_current_status".ls_localized
        return label
    }()

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.separatorStyle = .none
        view.rowHeight = 50
        view.register(CS_EventRecordCell.self, forCellReuseIdentifier: NSStringFromClass(CS_EventRecordCell.self))
        view.backgroundColor = .ls_dark_3()
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
extension CS_EventRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_EventRecordCell.self)) as! CS_EventRecordCell
        let model = dataSource[indexPath.row]
        cell.setData(model, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: request
extension CS_EventRecordController {
    func requstList(){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            tableView.reloadData()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["page"] = "\(page)"
        para["page_size"] = "20"
        CSNetworkManager.shared.getEventHistoryList(para) { resp in
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
extension CS_EventRecordController {
    
    private func setupView() {
        
        titleLabel.text = "crazy_str_purchase_history".ls_localized
        titleLabel.font = .ls_JostRomanFont(16)
        contentView.backgroundColor = .ls_dark_3()
        contentView.addSubview(sectionBackView)
        sectionBackView.addSubview(nameLabel)
        sectionBackView.addSubview(amountLabel)
        sectionBackView.addSubview(payLabel)
        sectionBackView.addSubview(timeLabel)
        sectionBackView.addSubview(statusLabel)
        contentView.addSubview(tableView)
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(630)
            make.top.equalTo(60)
            make.bottom.equalTo(-60)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(contentView).offset(22)
            make.top.equalTo(contentView).offset(4)
        }
        
        sectionBackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.equalTo(35)
            make.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sectionBackView)
            make.centerX.equalTo(contentView).multipliedBy(0.2)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.centerX.equalTo(contentView).multipliedBy(0.6)
        }
        
        payLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.centerX.equalTo(contentView)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.4)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.8)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(sectionBackView.snp.bottom)
        }
    }
}
