//
//  CS_ShareWithdrawController.swift
//  CrazySnake
//
//  Created by Lee on 08/05/2023.
//

import UIKit
import JXSegmentedView

class CS_ShareWithdrawController: CS_BaseEmptyController {

    var data: CS_ShareDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emptyStyle = .loading
        setupView()
        loadData()
    }
    

    lazy var tableView: UITableView = {
        let view = UITableView(frame: view.bounds, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.register(CS_ShareWithdrawBalanceCell.self, forCellReuseIdentifier: NSStringFromClass(CS_ShareWithdrawBalanceCell.self))
        view.register(CS_ShareWithdrawCell.self, forCellReuseIdentifier: NSStringFromClass(CS_ShareWithdrawCell.self))
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.ls_addHeader(false) {
            self.loadData()
        }
        return view
    }()

}

//MARK: requst
extension CS_ShareWithdrawController {
    func loadData() {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        CSNetworkManager.shared.getSharePageData(address) { resp in
            weakSelf?.tableView.ls_compeletLoading(true)
            if resp.status == .success {
                self.data = resp.data
                self.tableView.reloadData()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func estaimatedGas(_ item: CS_ShareWithdrawItemModel) {
        debugPrint(data?.balance?.cash.ls_doubleValue)
        
        guard item.cash.ls_doubleValue <= data?.balance?.cash.ls_doubleValue ?? 0 else {
            LSHUD.showInfo("crazy_str_balance_not_enough".ls_localized)
            return
        }
        
        guard let token = data?.withdraw?.tokens.first else { return }
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.shareWithdrawGasPrice(token.name, amount: item.cash, wallet: address) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_ShareWithdrawGasAlertController()
                vc.showTitle = "crazy_str_swap".ls_localized
                vc.gasPrice = resp.data
                vc.token = token.name
                vc.amount = item.cash
                vc.address = address
                vc.showGasCoinInsufficientAlert = true
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.withdraw(item)
                }
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func withdraw(_ item: CS_ShareWithdrawItemModel) {
        

        guard let token = data?.withdraw?.tokens.first else { return }
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["token_name"] = token.name
        para["cash_amount"] = item.cash
        para["sign"] = sign
        para["nonce"] = nonce
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.shareWithdraw(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.loadData()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}

//MARK: TableView
extension CS_ShareWithdrawController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_ShareWithdrawBalanceCell.self)) as! CS_ShareWithdrawBalanceCell
            cell.setData(data)
            cell.clickHistoryAction = {
                let vc = CS_ShareWithdrawHistoryController()
                self.present(vc, animated: false)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_ShareWithdrawCell.self)) as! CS_ShareWithdrawCell
            cell.setData(data?.withdraw)
            cell.clickWithdrawAction = { item in
                self.estaimatedGas(item)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 260
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CS_ShareTableHeaderView()
        switch section {
        case 0:
            view.titleLabel.text = "crazy_str_withdraw_as".ls_localized
        case 1:
            view.titleLabel.text = "crazy_str_withdraw_as".ls_localized
        default:
            view.titleLabel.text = ""
        }
        return view
    }
    
}

extension CS_ShareWithdrawController {
    func setupView(){
        navigationView.isHidden = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.left.equalTo(CS_ms(24))
            make.right.equalTo(-CS_ms(24))
        }
        
    }
}



extension CS_ShareWithdrawController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

