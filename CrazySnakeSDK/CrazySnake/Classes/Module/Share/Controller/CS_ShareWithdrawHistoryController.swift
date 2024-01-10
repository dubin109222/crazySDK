//
//  CS_ShareWithdrawHistoryController.swift
//  CrazySnake
//
//  Created by Lee on 08/08/2023.
//

import UIKit

class CS_ShareWithdrawHistoryController: CS_BaseAlertController {

    private var page = 1
    private var dataSource = [CS_ShareWithdrawHistoryModel]()

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
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_date_of_withdraw".ls_localized
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_withdraw_amount".ls_localized
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
        view.register(CS_ShareWithdrawHistoryCell.self, forCellReuseIdentifier: NSStringFromClass(CS_ShareWithdrawHistoryCell.self))
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
extension CS_ShareWithdrawHistoryController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_ShareWithdrawHistoryCell.self)) as! CS_ShareWithdrawHistoryCell
        let model = dataSource[indexPath.row]
        cell.setData(model, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: request
extension CS_ShareWithdrawHistoryController {
    func requstList(){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            tableView.reloadData()
            return
        }
        weak var weakSelf = self
       
        CSNetworkManager.shared.getShareWithdrawHistory("\(address)", page: "\(page)", size: "20") { resp in
            LSHUD.hide()
            var hasMore = false
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                weakSelf?.dataSource.append(contentsOf: resp.data)
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            if resp.data.count > 0 {
                hasMore = true
            }
            weakSelf?.tableView.ls_compeletLoading(weakSelf?.page == 1, hasMore: hasMore)
            weakSelf?.tableView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 < 6
            weakSelf?.tableView.reloadData()
        }
    }
}


//MARK: UI
extension CS_ShareWithdrawHistoryController {
    
    private func setupView() {
        
        titleLabel.text = "crazy_str_withdraw_history".ls_localized
        titleLabel.font = .ls_JostRomanFont(16)
        contentView.backgroundColor = .ls_dark_3()
        contentView.addSubview(sectionBackView)
        sectionBackView.addSubview(dateLabel)
        sectionBackView.addSubview(amountLabel)
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
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sectionBackView)
            make.centerX.equalTo(contentView).multipliedBy(0.35)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(1)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.65)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(sectionBackView.snp.bottom)
        }
    }
}
