//
//  CS_GamesMineRecordController.swift
//  CrazySnake
//
//  Created by Lee on 18/05/2023.
//

import UIKit

class CS_GamesMineRecordController: CS_BaseAlertController {

    private var page = 1
    private var dataSource = [CS_MineHistoryModel]()
    private var dataModel: CS_MineHistoryDataModel?
    
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
    
    lazy var myBetLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_my_bet".ls_localized
        return label
    }()
    
    lazy var blueLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_bet_bonus".ls_localized
        return label
    }()
    
    lazy var randomLabel: UILabel = {
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
        view.rowHeight = 65
        view.register(CS_GameMyRecordCell.self, forCellReuseIdentifier: NSStringFromClass(CS_GameMyRecordCell.self))
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
    
    lazy var cliamButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 180, height: 40))
        button.addTarget(self, action: #selector(clickClaimAllButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_claim_all".ls_localized, for: .normal)
        button.isEnabled = false
        return button
    }()
}

//MARK: action
extension CS_GamesMineRecordController {
    @objc private func clickClaimAllButton(_ sender: UIButton) {
        guard let list = dataModel?.claimable_round_ids else { return }
        clickClaim(idList: list)
    }
    
    func clickClaim(idList:[Int]){
        
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.game_fight.first?.contract_address else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sign"] = sign
        para["nonce"] = nonce
        LSHUD.showLoading()

        CSNetworkManager.shared.claimAllDiamond(para) { resp in
            LSHUD.hide()
            LSHUD.showSuccess(resp.message)
            self.page = 1
            self.requstList()
        }
    }
}

//MARK: contract
extension CS_GamesMineRecordController {
    func estimateGasClaim(_ address: String, contract: String, idList:[Int]){
        let encodeData = CS_ContractGame.shared.encodeDataClaim(idList: idList)
        let para = CS_ContractGame.getEstimateClaim(idList: idList)
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "Claim".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.claim(contract: contract,funcHash: encodeData ?? "")
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func claim(contract: String, funcHash: String){
        LSHUD.showLoading()
        weak var weakSelf = self
        CS_ContractGame.shared.claim(funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
                LSHUD.showSuccess(resp.message)
                CS_AccountManager.shared.loadTokenBlance()
                weakSelf?.page = 1
                weakSelf?.requstList()
            } else {
                LSHUD.showInfo(resp.message)
            }
        }
    }
}


//MARK: TableView
extension CS_GamesMineRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_GameMyRecordCell.self)) as! CS_GameMyRecordCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        weak var weakSelf = self
        cell.clickClaimAction = {
            let list = [model.round_id]
            weakSelf?.clickClaim(idList: list)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: request
extension CS_GamesMineRecordController {
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
        CSNetworkManager.shared.getMineGameHistoryList(para) { resp in
            LSHUD.hide()
            var hasMore = false
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                weakSelf?.dataModel = resp.data
                let enable = resp.data?.claimable_round_ids.count ?? 0 > 0
                weakSelf?.cliamButton.isEnabled = enable
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
extension CS_GamesMineRecordController {
    
    private func setupView() {
        
        contentView.backgroundColor = .ls_dark_3()
        contentView.addSubview(luckLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(myBetLabel)
        contentView.addSubview(blueLabel)
        contentView.addSubview(randomLabel)
        contentView.addSubview(tableView)
        view.addSubview(cliamButton)
        
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
        
        myBetLabel.snp.makeConstraints { make in
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
        
        cliamButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView.snp.bottom)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
    }
}
