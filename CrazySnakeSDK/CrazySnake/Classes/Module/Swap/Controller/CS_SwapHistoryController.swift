//
//  CS_SwapHistoryController.swift
//  CrazySnake
//
//  Created by Lee on 26/03/2023.
//

import UIKit
import JXSegmentedView

class CS_SwapHistoryController: CS_BaseEmptyController {
    
    private var page = 1
    private var dataSource = [CS_SwapHistoryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        emptyStyle = .loading
        setupView()
        requstList()
    }
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2(0.8)
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_data_of_swap".ls_localized
        return label
    }()
    
    lazy var payLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_pay_pay".ls_localized
        return label
    }()
    
    lazy var getLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_get_get".ls_localized
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
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
        view.register(CS_SwapHistoryCell.self, forCellReuseIdentifier: NSStringFromClass(CS_SwapHistoryCell.self))
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
extension CS_SwapHistoryController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_SwapHistoryCell.self)) as! CS_SwapHistoryCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        weak var weakSelf = self
        cell.clickWithdrawAction = {
            weakSelf?.estimateGasWithdraw(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        
        if model.progress_type == 1 {
            let alert = CS_SwapProgress3Alert()
            alert.setData(model)
            alert.show()
        } else if model.progress_type == 2 {
            let alert = CS_SwapProgress5Alert()
            alert.setData(model)
            alert.show()
        }
    }
    
}

//MARK: contract
extension CS_SwapHistoryController {
    func estimateGasWithdraw(_ history: CS_SwapHistoryModel){
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper?.contract_address else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        guard let encodeData = CS_ContractSwap.shared.encodeDataWithdraw(sid: history.sid)  else { return }
        let para = CS_ContractSwap.getEstimateSwapWithdrawPara(sid: history.sid, id: history.id)

//        para["internal"] = "1"
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "crazy_str_withdraw".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.withdraw(history, funcHash: encodeData)
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func withdraw(_ history: CS_SwapHistoryModel, funcHash: String){
        weak var weakSelf = self
        LSHUD.showLoading()
        CS_ContractSwap.shared.swapWithdraw(id: history.id, amount: history.amount_out, funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
//                var model = weakSelf?.dataSource.first(where: {$0.id == history.id})
//                model?.status = 1
//                weakSelf?.tableView.reloadData()
                weakSelf?.page = 1
                LSHUD.showLoading()
                weakSelf?.requstList()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}


//MARK: request
extension CS_SwapHistoryController {
    func requstList(){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            tableView.reloadData()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["status"] = "\(-1)"
        para["page"] = "\(page)"
        para["page_size"] = "20"
        CSNetworkManager.shared.getSwapHistoryList(para) { resp in
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
extension CS_SwapHistoryController {
    func setupView(){
        navigationView.isHidden = true
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
            make.centerX.equalTo(contentView).multipliedBy(1.25)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.75)
        }
    }
}

extension CS_SwapHistoryController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

