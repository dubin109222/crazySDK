//
//  CS_StakeMyStakeController.swift
//  CrazySnake
//
//  Created by Lee on 24/05/2023.
//

import UIKit
import JXSegmentedView

class CS_StakeMyStakeController: CS_BaseEmptyController {

    private var page = 1
    private var dataSource = [CS_StakeTokenRecordModel]()

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
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_staked_amount".ls_localized
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_time".ls_localized
        return label
    }()
    
    lazy var receiveLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_receive_cyt_amount_".ls_localized
        return label
    }()
    
    lazy var stakingTimeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_staking_time".ls_localized
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
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
        view.rowHeight = 62
        view.register(CS_StakeTokenRecordCell.self, forCellReuseIdentifier: NSStringFromClass(CS_StakeTokenRecordCell.self))
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
extension CS_StakeMyStakeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_StakeTokenRecordCell.self)) as! CS_StakeTokenRecordCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        weak var weakSelf = self
        cell.clickClaimAction = {
//            weakSelf?.unstakeToken(model)
            weakSelf?.requestEstiateGas(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: contract
extension CS_StakeMyStakeController {
//    func swapEstimateGas(_ address: String, contract: String){
//        guard let amount = selectedModel?.need_snake else {
//            return
//        }
//        guard let to = CS_AccountManager.shared.basicConfig?.contract?.cash_box?.contract_address else {
//            return
//        }
//        let funcHash = CS_ContractTransfer.encodeDataTransferTokenSnake(to: to, amount: amount) ?? ""
//        let para = CS_ContractSwap.getEstimateSwapGasCoinPara(to: to, amount: amount, gasCoin: selectedModel?.gas_coin ?? "")
//        weak var weakSelf = self
//        LSHUD.showLoading()
//        
//        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
//            LSHUD.hide()
//            if resp.status == .success {
//                let vc = CS_EstimateGasAlertController()
//                vc.showTitle = "crazy_str_swap".ls_localized
//                vc.gasPrice = resp.data
//                vc.contractAddress = contract
//                vc.para = para
//                vc.showGasCoinInsufficientAlert = false
//                weakSelf?.present(vc, animated: false)
//                vc.clickConfirmAction = {
//                    CS_AccountManager.shared.verifyPassword {
//                        weakSelf?.swap(address, contract: to,amount: amount, funcHash: funcHash)
//                    }
//                }
//            } else if resp.status != .gas_limit {
//                LSHUD.showError(resp.message)
//            }
//        }
//    }
    
    func requestEstiateGas(_ model: CS_StakeTokenRecordModel) {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        let para = CS_ContractTokenStake.estimateGetGasStakeToken(amount: model.reward)
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "crazy_str_un_staking".ls_localized
                vc.gasPrice = resp.data
                vc.para = para
//                vc.showGasCoinInsufficientAlert = false
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
//                    CS_AccountManager.shared.accountInfo?.verifyPassword { password in
//                        self.buy(password ?? "")
//                    }
                    weakSelf?.unstakeToken(model)
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }

    
    func unstakeToken(_ model: CS_StakeTokenRecordModel){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["nonce"] = nonce
        para["sign"] = sign
        para["stakingid"] = model.stakingid
        
        LSHUD.showLoading()
        weak var weakSelf = self
        CSNetworkManager.shared.unstake(para) { resp in
            
            if resp.status == .success {
                CS_AccountManager.shared.loadTokenBlance()
                LSHUD.showLoading()
                weakSelf?.page = 1
                weakSelf?.requstList()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}


//MARK: request
extension CS_StakeMyStakeController {
    func requstList(){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        guard let token = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["pos"] = "\(page)"
        para["count"] = "20"
        CSNetworkManager.shared.getStakeRecordList(address, token: token,para: para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                if let list = resp.data?.tokens {
                    weakSelf?.dataSource.append(contentsOf: list)
                }
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            let hasMore = weakSelf?.dataSource.count ?? 0 < resp.data?.total ?? 0
            weakSelf?.tableView.ls_compeletLoading(weakSelf?.page == 1, hasMore: hasMore)
            weakSelf?.tableView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 == 0
            weakSelf?.tableView.reloadData()
        }
    }
}


//MARK: UI
extension CS_StakeMyStakeController {
    func setupView(){
        navigationView.isHidden = true
        titleColor = .ls_white()
        
        view.addSubview(contentView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(receiveLabel)
        contentView.addSubview(stakingTimeLabel)
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
        
        receiveLabel.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.centerX.equalTo(contentView).multipliedBy(1.1)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(receiveLabel)
            make.centerX.equalTo(contentView).multipliedBy(0.6)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(receiveLabel)
            make.centerX.equalTo(contentView).multipliedBy(0.2)
        }
        
        stakingTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(receiveLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.5)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(receiveLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.85)
        }
    }
}

extension CS_StakeMyStakeController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

