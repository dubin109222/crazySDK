//
//  CS_WalletTransferRecordController.swift
//  CrazySnake
//
//  Created by Lee on 23/05/2023.
//

import UIKit

class CS_WalletTransferRecordController: CS_BaseAlertController {
    
    private var page = 1
    private var dataSource = [CS_WalletRecordModel]()

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
        label.text = "crazy_str_time".ls_localized
        return label
    }()
    
    lazy var payLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_transfer_to".ls_localized
        return label
    }()
    
    lazy var getLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_amount".ls_localized
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_status".ls_localized
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
        view.register(CS_WalletTransferRecordCell.self, forCellReuseIdentifier: NSStringFromClass(CS_WalletTransferRecordCell.self))
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
extension CS_WalletTransferRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_WalletTransferRecordCell.self)) as! CS_WalletTransferRecordCell
        let model = dataSource[indexPath.row]
        cell.setData(model, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: request
extension CS_WalletTransferRecordController {
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
        CSNetworkManager.shared.getWalletHistoryList(para) { resp in
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
extension CS_WalletTransferRecordController {
    
    private func setupView() {
        
        titleLabel.text = "crazy_str_transfer_records".ls_localized
        titleLabel.font = .ls_JostRomanFont(16)
        contentView.backgroundColor = .ls_dark_3()
        contentView.addSubview(sectionBackView)
        sectionBackView.addSubview(dateLabel)
        sectionBackView.addSubview(payLabel)
        sectionBackView.addSubview(getLabel)
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
            make.centerX.equalTo(contentView).multipliedBy(0.25)
        }
        
        payLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(0.75)
        }
        
        getLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.25)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.75)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(sectionBackView.snp.bottom)
        }
    }
}
