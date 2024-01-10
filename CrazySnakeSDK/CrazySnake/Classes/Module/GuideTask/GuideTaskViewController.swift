//
//  GuideTaskViewController.swift
//  CrazySnake
//
//  Created by BigB on 2023/11/15.
//

import Foundation
import UIKit
import SnapKit

class GuideTaskMainCell: UITableViewCell {
    
    var model: TaskModule? {
        didSet {
            titleLabel.text = model?.module_name
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ls_JostRomanFont(14)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var selectedImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.frame = CGRectMake(0, 0, 129, 45)
        imgView.image = .ls_bundle("_guide_main_select_cell@2x")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        self.contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        self.selectedImgView.isHidden = true
        
        
        self.contentView.insertSubview(selectedImgView, belowSubview: titleLabel)
        self.selectedImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
        
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectedImgView.isHidden = !selected
        self.titleLabel.textColor = selected ? .ls_color("#28283C") : .ls_color("#E8E4D7")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GuideTaskSubCell: UITableViewCell {
    
    lazy var tipsLb: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Award"
        label.font = UIFont.ls_JostRomanFont(11)
        label.textColor = UIColor.ls_color("#8989AE")
        return label
    }()
    
    lazy var doneBtn: UIButton = {
        let doneBtn: UIButton = UIButton(type: .custom)
        doneBtn.setBackgroundImage(UIImage.ls_bundle("_btn_pur_bg@2x"), for: .normal)
        doneBtn.addTarget(self, action: #selector(clickDoneBtn), for: .touchUpInside)
        doneBtn.setTitle("Claim", for: .normal)
        doneBtn.titleLabel?.font = .boldSystemFont(ofSize: 12)
        return doneBtn
    }()
    
    var doneHandle: ((String) -> ())? = nil
    
    @objc func clickDoneBtn() {
        self.doneHandle?(model?.task_status ?? "")
    }
    
    var model: TaskItem? {
        didSet {
            let languageModel = CS_AccountManager.shared.languageList.first(where: {$0.ID == model?.task_type && $0.type == "6"})
            
            titleLabel.text = String.init(format: (languageModel?.name?.replacingOccurrences(of: "%s", with: "%@") ?? ""), arguments: (model?.split_num ?? []))

            descLabel.text  = languageModel?.desc
            
            if model?.task_status == "0" { //
                doneBtn.setBackgroundImage(UIImage.ls_bundle("_btn_origin_bg@2x"), for: .normal)
                doneBtn.setTitle("To complete", for: .normal)
            } else if model?.task_status == "1" {
                doneBtn.setBackgroundImage(UIImage.ls_bundle("_btn_pur_bg@2x"), for: .normal)
                doneBtn.setTitle("Claim", for: .normal)
            } else {
                doneBtn.setBackgroundImage(UIImage.ls_bundle("_btn_pur_bg@2x"), for: .normal)
                doneBtn.setTitle("Done", for: .normal)
            }

            var scale = 1.0
            if (model?.reward.count ?? 0) >= 3 {
                scale = 1.0
            } else if (model?.reward.count ?? 0) == 2 {
                scale = 0.6667
            } else {
                scale = 0.3333
            }
            self.collectionView.snp.updateConstraints { make in
                make.width.equalTo(150 * scale)
            }
            self.collectionView.reloadData()
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ls_JostRomanFont(14)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.ls_JostRomanFont(11)
        label.textColor = UIColor.ls_color("#8989AE")
        return label
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RewardItemCell.self, forCellWithReuseIdentifier: "RewardItemCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .clear
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            make.height.equalTo(32)
        }
        
        let descBgView = UIView()
        descBgView.backgroundColor = .ls_color("#2D2D46")
        descBgView.layer.cornerRadius = 5
        descBgView.layer.masksToBounds = true
        contentView.addSubview(descBgView)
        descBgView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(94)
        }
        descBgView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(23)
            make.right.equalTo(-183)
            make.top.equalTo(10)
            make.bottom.equalTo(-12)
        }
        
        descBgView.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 111, height: 30.5))
            make.top.equalToSuperview().offset(57)
            make.right.equalToSuperview().offset(-20)
        }

        descBgView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerX.equalTo(doneBtn)
        }
        

        
        contentView.addSubview(tipsLb)
        tipsLb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-60)
            make.centerY.equalTo(titleLabel)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class GuideTaskViewController: CS_BaseController {


    
    // 左侧主列表
    lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
//        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GuideTaskMainCell.self, forCellReuseIdentifier: "GuideTaskMainCell")
        
        return tableView
    }()

    // 右侧子列表
    lazy var subTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .ls_color("#28283C")
        tableView.register(GuideTaskSubCell.self, forCellReuseIdentifier: "GuideTaskSubCell")
        return tableView
    }()

    // 数据源
    var dataSource: [TaskModule] = []
    
    private func loadData() {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        
        var para :[String:Any] = [:]
        para["wallet_address"] = address

        CSNetworkManager.shared.getNoviceTask(para) { (list: [TaskModule]) in
            
            self.dataSource = list
            
            self.mainTableView.reloadData()
            DispatchQueue.main.async {
                self.mainTableView.selectRow(at: .init(row: 0, section: 0), animated: true, scrollPosition: .none)
                self.subTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        
        CS_AccountManager.shared.loadTokenBlance()
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        CSNetworkManager.shared.getNoviceTask(para) { (list: [TaskModule]) in
            
            self.dataSource = list
            self.subTableView.reloadData()
            
        }

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func registerNotication(){
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletInfoChange(_:)), name: NotificationName.walletBalanceChanged, object: nil)
    }

    @objc private func notifyWalletInfoChange(_ notify: Notification) {
        updateData()
    }

    func updateData(){
        
        navAmountView.isHidden = false
        navAmountView1.isHidden = false
        navAmountView2.isHidden = false
        navAmountView.iconView.image = TokenName.Snake.icon()
        navAmountView.amountLabel.text = Utils.formatAmount(TokenName.Snake.balance())
        navAmountView1.iconView.image = TokenName.GasCoin.icon()
        navAmountView1.amountLabel.text = Utils.formatAmount(TokenName.GasCoin.balance(),digits: 2)
        navAmountView2.iconView.image = TokenName.Diamond.icon()
        navAmountView2.amountLabel.text = Utils.formatAmount(TokenName.Diamond.balance(),digits: 2)

    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNotication()
        self.updateData()

        self.navigationView.titleLabel.text = "Task List"
        
        self.backView.image = nil
        self.backView.backgroundColor = .ls_color("#191927")
        
        self.navigationView.backgroundColor = .ls_color("#4E668B",alpha: 0.2)

        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(CS_ms(30))
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavBarHeight + 10)
            make.width.equalTo(129)
        }
        let mainTableBg = UIImageView()
        mainTableBg.image = .ls_bundle("_guide_task_mainTable_bg@2x")
        self.view.insertSubview(mainTableBg, belowSubview: mainTableView)
        mainTableBg.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(mainTableView)
            make.top.equalTo(mainTableView).offset(-10)
        }
        


        self.view.addSubview(subTableView)
        subTableView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(kNavBarHeight)
            make.left.equalTo(mainTableView.snp.right)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.loadData()
        
        self.checkGuideStatus()
        
    }
    
    // 检查新手引导是否完成
    private func checkGuideStatus() {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["ck_key"] = "guide_task_list"
        
        CSNetworkManager.shared.checkAnimation(para) { [self] (model: AnimationModel) in
            if model.data == false {
                let maskView = UIView()
                maskView.backgroundColor = .ls_color("#0F0F1B",alpha: 0.7)
                maskView.addGestureRecognizer(UITapGestureRecognizer())
                maskView.frame = self.view.bounds
                self.view.addSubview(maskView)
                
                
                let iconView = UIImageView()
                iconView.image = .ls_bundle("_guide_task_image@2x")
                maskView.addSubview(iconView)
                iconView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview().offset(-(340)/2)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(111)
                }
                
                let tipsLbBg = UIScrollView()
                tipsLbBg.backgroundColor = .ls_color("#232335")
                tipsLbBg.layer.masksToBounds = true
                tipsLbBg.layer.cornerRadius = 20
                maskView.addSubview(tipsLbBg)
                tipsLbBg.snp.makeConstraints { make in
                    make.left.equalTo(iconView.snp.right).offset(3)
                    make.width.equalTo(340)
                    make.height.equalTo(150)
                    make.centerY.equalTo(iconView)
                }
                
                let nextBtn = UIButton()
                nextBtn.setTitle("I Know", for: .normal)
                nextBtn.setTitleColor(.ls_color("#FFFFFF"), for: .normal)
                nextBtn.titleLabel?.font = .ls_JostRomanRegularFont(12)
                nextBtn.addTarget(self, action: #selector(nextBtnClick(_:)), for: .touchUpInside)
                nextBtn.layer.masksToBounds = true
                nextBtn.layer.cornerRadius = 6
                
                let gradient1 = CAGradientLayer()
                gradient1.colors = [UIColor.ls_color("#E988F9").cgColor, UIColor.ls_color("#5479F8").cgColor]
                gradient1.locations = [0, 1]
                gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradient1.frame = CGRect(x: 0, y: 0, width: 60, height: 24)
                nextBtn.layer.insertSublayer(gradient1, at: 0)

                tipsLbBg.addSubview(nextBtn)
                nextBtn.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-30)
                    make.bottom.equalToSuperview().offset(-16)
                    make.size.equalTo(CGSize(width: 60, height: 24))
                }

                let tipsLb = UILabel()
                tipsLb.numberOfLines = 0
                tipsLb.font = .ls_JostRomanFont(12)
                tipsLb.text = "This is a beginner\'s guide. Please complete these tasks according to the guide, and you will receive generous rewards."
                tipsLb.textColor = .ls_color("#8989AE")
                tipsLbBg.addSubview(tipsLb)
                tipsLb.snp.makeConstraints { make in
                    make.width.equalTo(282)
                    make.top.equalToSuperview().offset(28)
                    make.left.equalToSuperview().offset(29)
                    make.right.equalToSuperview().offset(-29)
                    make.bottom.equalTo(nextBtn.snp.top).offset(-4)
                }

//                GuideMaskView.show (tipsText: "This is a beginner\'s guide. Please complete these tasks according to the guide, and you will receive generous rewards.",
//                                                  currentStep: "2",
//                                                  totalStep: "2",
//                                                  maskRect: CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0)){
//                    CSNetworkManager.shared.saveAnimation(para) { (resp: AnimationModel) in
//                        
//                    }
//
//                } skipHandle: {
//                    CSNetworkManager.shared.saveAnimation(para) { (resp: AnimationModel) in
//                        
//                    }
//                }
            }
        }
        
    }
    
    @objc func nextBtnClick(_ sender: UIButton) {
        
        sender.superview?.superview?.removeFromSuperview()
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }

        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["ck_key"] = "guide_task_list"

        CSNetworkManager.shared.saveAnimation(para) { (resp: AnimationModel) in
            
        }

    }

}

extension GuideTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == mainTableView {
            return dataSource.count
        } else {
            if dataSource.count == 0 {
                return 0
            }
            let index = mainTableView.indexPathForSelectedRow?.row ?? 0
            return dataSource[index].module_list.count
        }
    }
    
    /**
     TASK_ID_LEVEL_UP( id: 101, desc: "H %NFT"'),
     TASK_ID_UPGRADE( id: 102, desc: " # (GNFT"),
     TASK_ID_RECYCLE ( id: 103, desc: "ONFT"),
     TASK ID INCUBATION ( id: 104,
     TASK_ID_SWAP( id: 201, desc: "55-/token #U"),
     TASK_ ID_SWAP_CLAIM ( id: 202,
     TASK_ID_MARKET_SELL ( id: 301,
     TASK_ID_MARKET_SHOP id: 302,
     TASK_ID_TOKEN_STAKE( id: 401, desc:"65475#"),
     TASK_ID_TOKEN_STAKE_CLAIM( id: 402,
     TASK_ID_NFT_STAKE( id: 501,
     TASK_ID_NFT_SETS_STAKE( id: 502,
     TASK_ID_EVENT( id: 601,
     TASK_ID_ NFT_LIST ( id: 701, desc: "5%Th EGENFT"),
     TASK_ID_WALLT_NFT ( id: 702, desc: " TEENFT") ;
     */
    func jumpTaskController(_ tag: String) {
        var jumpValue = ""
        
        switch tag {
        case "101": // 升级nft
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_NFT_LAB_UPGRADE
        case "102": // 进化nft
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_NFT_LAB_UPGRADE
        case "103": // 回收nft
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_NFT_LAB_CONVERSION
        case "104": // 孵化nft
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_NFT_LAB_INCUBATION
        case "201": // 参与一次token兑换u
            jumpValue = CrazyPlatform.Crazy_METHODS_TYPE_TO_SWAP
        case "202": // 领取一次审核到期的u
            jumpValue = CrazyPlatform.Crazy_METHODS_TYPE_TO_SWAP
        case "301": // 在市场里上架nft或物品
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_MARKET
        case "302": // 在市场里购买nft或物品
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_MARKET
        case "401": // 参与单币质押
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_TOKEN_STAKE
        case "402": // 累计获取10CYT
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_TOKEN_STAKE
        case "501": // 参与nft质押
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_NFT_STAKE
        case "502": // 参与nft组质押
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_NFT_STAKE
        case "601": // 购买event里任意的物品
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_EVENTS
        case "701": // 成功上链nft
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_MY_NFT
        case "702": // 下链nft
            jumpValue = CrazyPlatform.CRAZY_METHODS_TYPE_TO_WALLET_NFT
        default:
            jumpValue = ""
        }
        
        if jumpValue == "" {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        CrazyPlatform.startSyncMethods(jumpValue)
    }



    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuideTaskMainCell", for: indexPath) as! GuideTaskMainCell
            cell.selectionStyle = .none
            cell.model = dataSource[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuideTaskSubCell", for: indexPath) as! GuideTaskSubCell
            cell.selectionStyle = .none
            weak var weakSelf = self
            let index = mainTableView.indexPathForSelectedRow?.row ?? 0
            let newModel = dataSource[index].module_list[indexPath.row]
            newModel.convertData()
            cell.model = newModel

            cell.doneHandle = { status in
                if status == "0" {
                    weakSelf?.jumpTaskController(newModel.task_type ?? "")
                    
                } else if status == "1" {
                    guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
                        return
                    }
                    CSNetworkManager.shared.rewardNoviceTask(
                        [
                            "task_id": "\(newModel.id)",
                            "wallet_address": address
                        ]) { (response : BlankContent) in
                        
                            
                            let alert = CS_VoucherGetAlert()
                            
                            if newModel.newReward.count == 1 {
                                let rewardModel = newModel.newReward.first
                                alert.model = .init(reward_type: rewardModel?.reward_type ?? "", reward_num: rewardModel?.reward_num ?? "", prop_id: rewardModel?.reward_id ?? "",reward_img: "")
                            } else {
                                alert.list = newModel.newReward.map({ item in
                                    ListRewardItem.init(reward_type: item.reward_type, reward_num: item.reward_num , prop_id:item.reward_id ,reward_img: "")
                                })
                            }
                            alert.updateData()
                            alert.show()

                            
                            CS_AccountManager.shared.loadTokenBlance()
                            var para :[String:Any] = [:]
                            para["wallet_address"] = address
                            CSNetworkManager.shared.getNoviceTask(para) { (list: [TaskModule]) in
                                
                                self.dataSource = list
                                self.subTableView.reloadData()
                                
                            }

                    }
                } else {
                    LSHUD.showInfo("You have already received the reward")
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == mainTableView {
            self.subTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class RewardItemCell: UICollectionViewCell {
    
    lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var numLb: UILabel = {
        let label = UILabel()
        label.font = UIFont.ls_JostRomanFont(10)
        label.textColor = UIColor.white
        label.shadowColor = .black
        label.shadowOffset = .init(width: 1, height: 1)
        return label
    }()
    
    var model: NewTaskRewardItem? = nil {
        didSet {
            if model?.reward_type == "reward_gascoin" {
                imgView.image = .ls_bundle("icon_token_gascoin@2x")
            } else {
                imgView.image = CS_NFTPropsType(rawValue: model?.reward_id ?? "")?.iconImage()
            }
            numLb.text = model?.reward_num
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imgView)
        contentView.addSubview(numLb)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        numLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GuideTaskSubCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardItemCell", for: indexPath) as! RewardItemCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.model = self.model?.newReward[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.reward.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(38, 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
