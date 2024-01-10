//
//  CS_RankNFTPowerController.swift
//  CrazySnake
//
//  Created by Lee on 12/06/2023.
//

import UIKit
import JXSegmentedView

class CS_RankNFTPowerController: CS_BaseEmptyController {

    private var page = 1
    private var dataSource = [CS_RankTotalPowerModel]()
    var selectedModel: CS_RankTotalPowerModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        emptyStyle = .loading
        setupView()
        requstList()
    }
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(5)
        view.backgroundColor = .ls_color("#ABABAB", alpha: 0.6)
        return view
    }()
    
    lazy var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2(0.8)
        view.ls_cornerRadius(8)
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.textAlignment = .center
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var userBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#3A3A3A")
        view.ls_cornerRadius(8)
        return view
    }()
    
    lazy var userView: CS_RankUserView = {
        let view = CS_RankUserView()
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2(0.8)
        view.ls_cornerRadius(8)
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_rank".ls_localized
        return label
    }()
    
    lazy var payLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_player".ls_localized
        return label
    }()
    
    lazy var getLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(14))
        label.textAlignment = .center
        label.text = "crazy_str_nft_hash_power".ls_localized
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
        view.register(CS_RankNFTPowerCell.self, forCellReuseIdentifier: NSStringFromClass(CS_RankNFTPowerCell.self))
        view.backgroundColor = .ls_dark_3()
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requstList()
        }
        return view
    }()
    
    lazy var rankView: CS_RankNFTPowerView = {
        let view = CS_RankNFTPowerView()
        view.backView.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(10)
        view.ls_border(color: .ls_white())
        view.isHidden = true
        return view
    }()
}

//MARK: TableView
extension CS_RankNFTPowerController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_RankNFTPowerCell.self)) as! CS_RankNFTPowerCell
        let model = dataSource[indexPath.row]
        cell.setData(model, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        selectedModel = model
        changeSelectedData(model)
    }
}

//MARK: action
extension CS_RankNFTPowerController {
    func changeSelectedData(_ model: CS_RankTotalPowerModel?){
        guard let model = model else { return }
        nameLabel.text = "#\(model.token_id)"
        userView.setData(model)
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["token_id"] = model.token_id
        
        CSNetworkManager.shared.getNFTDetail(para) { resp in
            if let nft = resp.data {
                let url = URL.init(string: nft.image)
                    weakSelf?.iconView.kf.setImage(with: url, placeholder: UIImage.ls_placeHolder())
            }
        }
        
        
    }
}


//MARK: request
extension CS_RankNFTPowerController {
    func requstList(){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            tableView.reloadData()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["type"] = "\(2)"
        para["page"] = "\(page)"
        para["page_size"] = "20"
        CSNetworkManager.shared.getNFTRankList(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
                    if weakSelf?.selectedModel == nil {
                        weakSelf?.selectedModel = list.first
                        weakSelf?.changeSelectedData(list.first)
                    }
                }
                weakSelf?.rankView.setData(resp.data?.person, index: 0)
                weakSelf?.rankView.isHidden = false
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            weakSelf?.tableView.ls_compeletLoading(true, hasMore: false)
            weakSelf?.tableView.reloadData()
        }
    }
}


//MARK: UI
extension CS_RankNFTPowerController {
    func setupView(){
        navigationView.isHidden = true
        titleColor = .ls_white()
        
        view.addSubview(shadowView)
        view.addSubview(leftView)
        leftView.addSubview(nameLabel)
        leftView.addSubview(iconView)
        leftView.addSubview(userBackView)
        leftView.addSubview(userView)
        view.addSubview(contentView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(payLabel)
        contentView.addSubview(getLabel)
        view.addSubview(tableView)
        view.addSubview(rankView)
        
        shadowView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(13))
            make.top.equalTo(16)
            make.right.equalTo(-CS_ms(13))
            make.bottom.equalTo(-11)
        }
        
        leftView.snp.makeConstraints { make in
            make.left.top.equalTo(shadowView).offset(5)
            make.left.bottom.equalTo(shadowView).offset(-5)
            make.width.equalTo(174)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(leftView)
            make.top.equalTo(12)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(leftView)
            make.top.equalTo(45)
            make.width.equalTo(144)
            make.height.equalTo(152)
        }
        
        userBackView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(leftView)
            make.height.equalTo(60)
        }
        
        userView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.height.equalTo(userBackView)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.equalTo(leftView.snp.right).offset(7)
            make.top.equalTo(21)
            make.right.equalTo(-CS_ms(18))
            make.bottom.equalTo(-16)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(41)
        }
        
        rankView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(51)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.centerX.equalTo(contentView).multipliedBy(0.25)
        }
        
        payLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(0.8)
        }
        
        getLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.centerX.equalTo(contentView).multipliedBy(1.6)
        }
    }
}

extension CS_RankNFTPowerController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

