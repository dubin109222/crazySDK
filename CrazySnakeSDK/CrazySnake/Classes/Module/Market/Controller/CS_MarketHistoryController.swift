//
//  CS_MarketHistoryController.swift
//  CrazySnake
//
//  Created by Lee on 23/04/2023.
//

import UIKit
import JXSegmentedView

class CS_MarketHistoryController: CS_BaseEmptyController {

    private var page = 1
    private var dataSource = [CS_MarketHistoryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        emptyStyle = .loading
        setupView()
        requstList()
    }
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#342B5D",alpha: 0.3)
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_item".ls_localized
        return label
    }()
    
    lazy var payLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_from_to".ls_localized
        return label
    }()
    
    lazy var getLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_price".ls_localized
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_time".ls_localized
        return label
    }()

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.separatorStyle = .none
        view.rowHeight = 76
        view.register(CS_MarketHistoryCell.self, forCellReuseIdentifier: NSStringFromClass(CS_MarketHistoryCell.self))
        view.backgroundColor = .clear
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
extension CS_MarketHistoryController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_MarketHistoryCell.self)) as! CS_MarketHistoryCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

//MARK: request
extension CS_MarketHistoryController {
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
        CSNetworkManager.shared.getMarketHistoryList(para) { resp in
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
            weakSelf?.tableView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 < 3
            weakSelf?.tableView.reloadData()
        }
    }
}


//MARK: UI
extension CS_MarketHistoryController {
    func setupView(){
        navigationView.isHidden = true
        backView.image = nil
        backView.backgroundColor = .clear
        view.backgroundColor = .clear
        emptyDescription = "crazy_str_empty_nft_backpack_hint".ls_localized
        titleColor = .ls_white()
        
        view.addSubview(contentView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(payLabel)
        contentView.addSubview(getLabel)
        contentView.addSubview(statusLabel)
        view.addSubview(tableView)
        
        contentView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(18))
            make.top.equalTo(21)
            make.right.equalTo(-CS_ms(18))
            make.bottom.equalTo(-16)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(41)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.centerX.equalTo(contentView).multipliedBy(0.25)
        }
        
        payLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(0.75)
        }
        
        getLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.35)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.75)
        }
    }
}

extension CS_MarketHistoryController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}
