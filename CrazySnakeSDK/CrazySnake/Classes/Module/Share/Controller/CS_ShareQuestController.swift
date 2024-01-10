//
//  CS_ShareQuestController.swift
//  CrazySnake
//
//  Created by Lee on 08/05/2023.
//

import UIKit
import JXSegmentedView

class CS_ShareQuestController: CS_BaseEmptyController {

    var data: CS_ShareDataModel?
    var clickInviteFriendsAction: CS_NoParasBlock?
    
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
        view.register(CS_QuestNewcomerCell.self, forCellReuseIdentifier: NSStringFromClass(CS_QuestNewcomerCell.self))
        view.register(CS_QuestMoreWayCell.self, forCellReuseIdentifier: NSStringFromClass(CS_QuestMoreWayCell.self))
        view.backgroundColor = .clear
        view.ls_addHeader(false) {
            self.loadData()
        }
        return view
    }()

}

//MARK: TableView
extension CS_ShareQuestController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return data?.reward?.daily.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_QuestNewcomerCell.self)) as! CS_QuestNewcomerCell
            cell.setData(data?.tasks)
            cell.clickClaimAction = { model in
                self.clickClaim(model)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_QuestMoreWayCell.self)) as! CS_QuestMoreWayCell
            let model = data?.reward?.daily[indexPath.row]
            cell.setData(model)
            cell.clickConfirmAction = {
                if indexPath.row == 2 {
                    self.clickInviteFriendsAction?()
                } else {
                    CrazyPlatform.backToGame()
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        } else {
            return 70
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CS_ShareTableHeaderView()
        switch section {
        case 0:
            view.titleLabel.text = "crazy_str_newcomer_benefits".ls_localized
            view.infoView.isHidden = false
            view.setData(data?.reward)
        case 1:
            view.titleLabel.text = "crazy_str_more_ways_to_get".ls_localized
            view.infoView.isHidden = true
        default:
            view.titleLabel.text = ""
        }
        return view
    }
    
}

//MARK: requst
extension CS_ShareQuestController {
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
    
    func clickClaim(_ model: CS_ShareTaskModel) {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sign"] = sign
        para["nonce"] = nonce
        LSHUD.showLoading()
        weak var weakSelf = self
        CSNetworkManager.shared.claimShareTastReward(address, taskId: model.id,para: para) { resp in
            LSHUD.hide()
            if resp.status == .success {
//                weakSelf?.changeToCliamed(model)
                weakSelf?.loadData()
            } else {
                LSHUD.showError(resp
                    .message)
            }
        }
    }
    
    func changeToCliamed(_ model: CS_ShareTaskModel){
        guard var data = data else { return }
        var task = model
        task.status = 2
        var index = -1
        for item in data.tasks.enumerated() {
            if item.element.id == model.id {
                index = item.offset
                break
            }
        }
        if index >= 0, let range = Range(NSRange(location: index, length: 1)) {
            data.tasks.replaceSubrange(range,with: [task])
            self.data = data
            tableView.reloadData()
        }
    }
}


extension CS_ShareQuestController {
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

extension CS_ShareQuestController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

