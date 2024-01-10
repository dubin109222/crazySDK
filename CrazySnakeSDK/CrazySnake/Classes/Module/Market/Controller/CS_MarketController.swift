//
//  CS_MarketController.swift
//  CrazySnake
//
//  Created by Lee on 23/04/2023.
//

import UIKit
import SwiftyJSON
import JXSegmentedView

class CS_MarketController: CS_BaseController {
    
    public var filterStr : String? 
    
    var currentChooseData: [CS_MarketChooseTitleCell.CellData]? {
        didSet {
            chooseFilterBtn.isHidden = (currentChooseData?.isEmpty) ?? true
        }
    }
    
    var currentViewController : CS_ChooseConditionAlertDataSource? {
        didSet {
            self.currentChooseData = self.currentViewController?.chooseData
        }
    }
    
    var currentIndexPath : [IndexPath]? {
        didSet {
            // 更新到集合上
            if let currentVc = self.currentViewController as? CS_BaseEmptyController {
                let tag = currentVc.tag
                self.setIndexPath[tag] = currentIndexPath ?? []
                
                if tag == 0
                || tag == 1 {
                    // NFT市场
                    var quality : String?
                    var sex:    String?
                    var classStr: String?
                    for item in currentIndexPath ?? [] {
                        if let dataModel = self.currentChooseData?[item.section] {
                            let titleValue = dataModel.title
                            switch titleValue {
                            case "Quality":
                                quality = dataModel.list?[item.row].ID
                            case "Gender":
                                sex = dataModel.list?[item.row].ID
                            case "NFT Sets":
                                classStr = dataModel.list?[item.row].ID
                            default:
                                debugPrint("不存在的key")
                            }
                        }
                    }
                    if let vc = currentVc as? CS_ChooseConditionAlertDataSource {
                        
                        var dic: [String : String] = [:]
                        dic["quality"] = quality
                        dic["sex"] = sex
                        dic["class"] = classStr
                        do {
                            let jsonData = try JSONEncoder().encode(dic)
                            if let jsonString = String(data: jsonData, encoding: .utf8) {
                                currentVc.filterStr = jsonString
                                print(" filterStr : \(jsonString)")
                                vc.requestList()

                            }
                        } catch {
                            print("转换为 JSON 字符串时出错: \(error)")
                        }
                    }
                }
            }
        }
    }
    var setIndexPath : [[IndexPath]] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        CS_AccountManager.shared.loadConfigNameDesc()
        loadBalance()
        registerNotication()
        
        // 初始化
        for _ in listContainerLeftViewControllers {
            self.setIndexPath.append([])
        }
        for _ in listContainerRightViewControllers {
            self.setIndexPath.append([])
        }
        
        if let filterStr = self.filterStr {
            var listIndex = 0
            for item in self.listContainerLeftViewControllers {
                var section = 0
                if let valueList = item as? CS_ChooseConditionAlertDataSource {
                    for subItem in valueList.chooseData ?? [] {
                        if let row = subItem.list?.firstIndex(where: {$0.ID == filterStr}) {
                            self.setIndexPath[listIndex].append(IndexPath.init(row: row, section: section))
                            break;
                        }
                        section += 1
                    }
                }
                listIndex += 1
            }
        }
        
        
        self.currentViewController = self.listContainerLeftViewControllers.first as? any CS_ChooseConditionAlertDataSource
        if let vc = self.currentViewController as? CS_BaseEmptyController {
            var dic: [String : String] = [:]
            
            dic["class"] = self.filterStr
            do {
                let jsonData = try JSONEncoder().encode(dic)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    vc.filterStr = jsonString
                    print(" filterStr : \(jsonString)")
                    self.currentViewController?.requestList()
                }
            } catch {
                print("转换为 JSON 字符串时出错: \(error)")
            }
        }
    }
    
    lazy var segementBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#A7A4F3",alpha: 0.1)
        view.ls_cornerRadius(17)
        return view
    }()
    
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
        segment.titles = ["crazy_str_nft".ls_localized,"crazy_str_nft_sets".ls_localized,"crazy_str_props".ls_localized]
        segment.isItemSpacingAverageEnabled = false
        segment.itemWidth = 60
        segment.isTitleColorGradientEnabled = true
        segment.titleNormalColor = .ls_text_gray()
        segment.titleNormalFont = .ls_JostRomanFont(12)
        segment.titleSelectedColor = .ls_purpose_01()
        segment.titleSelectedFont = .ls_JostRomanFont(16)
        return segment
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.delegate = self
        view.dataSource = segmentedDataSource
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        indicator.indicatorColor = .ls_purpose_01()
        indicator.indicatorWidth = 18
        view.indicators = [indicator]
        view.listContainer = listContainerView
        return view
    }()
    
    lazy var segmentedDataSourceBack: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
        segment.titles = ["crazy_str_nft".ls_localized,"crazy_str_nft_sets".ls_localized,"crazy_str_props".ls_localized]
        segment.isItemSpacingAverageEnabled = false
        segment.itemWidth = 60
        segment.isTitleColorGradientEnabled = true
        segment.titleNormalColor = .ls_text_gray()
        segment.titleNormalFont = .ls_JostRomanFont(12)
        segment.titleSelectedColor = .ls_text_gray()
        segment.titleSelectedFont = .ls_JostRomanFont(12)
        return segment
    }()
    
    lazy var segmentedViewBack: JXSegmentedView = {
        let view = JXSegmentedView()
        view.delegate = self
        view.dataSource = segmentedDataSourceBack
        view.isHidden = true
        return view
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        return view
    }()
    
    lazy var segmentedDataSourceRight: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
        segment.titles = ["crazy_str_market_selling".ls_localized,
                          "crazy_str_inventory".ls_localized,
                          "crazy_str_set_sale".ls_localized,
                          "crazy_str_order_history".ls_localized]
        segment.isItemSpacingAverageEnabled = false
        segment.itemWidth = 60
        segment.isTitleColorGradientEnabled = true
        segment.titleNormalColor = .ls_text_gray()
        segment.titleNormalFont = .ls_JostRomanFont(12)
        segment.titleSelectedColor = .ls_purpose_01()
        segment.titleSelectedFont = .ls_JostRomanFont(16)
        return segment
    }()
    
    lazy var segmentedViewRight: JXSegmentedView = {
        let view = JXSegmentedView()
        view.delegate = self
        view.dataSource = segmentedDataSourceRight
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        indicator.indicatorColor = .ls_purpose_01()
        indicator.indicatorWidth = 18
        view.indicators = [indicator]
        view.listContainer = listContainerViewRight
        view.isHidden = true
        return view
    }()
    
    lazy var segmentedDataSourceRightBack: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
        segment.titles = ["crazy_str_market_selling".ls_localized,
                          "crazy_str_inventory".ls_localized,
                          "crazy_str_set_sale".ls_localized,
                          "crazy_str_order_history".ls_localized]
        segment.isItemSpacingAverageEnabled = false
        segment.itemWidth = 60
        segment.isTitleColorGradientEnabled = true
        segment.titleNormalColor = .ls_text_gray()
        segment.titleNormalFont = .ls_JostRomanFont(12)
        segment.titleSelectedColor = .ls_text_gray()
        segment.titleSelectedFont = .ls_JostRomanFont(12)
        return segment
    }()
    
    lazy var segmentedViewRightBack: JXSegmentedView = {
        let view = JXSegmentedView()
        view.delegate = self
        view.dataSource = segmentedDataSourceRightBack
        return view
    }()
    
    lazy var listContainerViewRight: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        view.isHidden = true
        return view
    }()
    
    lazy var listContainerLeftViewControllers: [JXSegmentedListContainerViewListDelegate] = {
        let vc1 = CS_MarketNFTController()
        vc1.tag = 0
        vc1.isMock = true
        weak var weakSelf = self
        vc1.mockToInventoryHandle = {
            weakSelf?.segmentedViewRight.defaultSelectedIndex = 1
            weakSelf?.listContainerViewRight.defaultSelectedIndex = 1
            weakSelf?.segmentedViewRight.selectItemAt(index: 1)
            weakSelf?.listContainerViewRight.didClickSelectedItem(at: 1)
            weakSelf?.segmentedViewRight.reloadData()
            weakSelf?.listContainerViewRight.reloadData()
            
            weakSelf?.segmentedViewRightBack.isHidden = true
            weakSelf?.segmentedViewRight.isHidden = false
            weakSelf?.segmentedViewBack.isHidden = false
            weakSelf?.segmentedView.isHidden = true
            weakSelf?.listContainerView.isHidden =  true
            weakSelf?.listContainerViewRight.isHidden = false

        }
        
        let vc2 = CS_MarketNFTSetsController()
        vc2.tag = 1

        let vc3 = CS_MarketPropsController()
        vc3.tag = 2

        
        
        return [
            vc1,vc2,vc3
        ]
    }()
    lazy var listContainerRightViewControllers: [JXSegmentedListContainerViewListDelegate] = {
        
        let vc1 = CS_MarketSellingController()
        vc1.tag = 3
        
        let vc2 = CS_MarketInventoryController()
        vc2.tag = 4
        weak var weakSelf = self
        vc2.mockNextHandle = { isSkip in
            weakSelf?.segmentedView.defaultSelectedIndex = 0
            weakSelf?.listContainerView.defaultSelectedIndex = 0
            weakSelf?.segmentedView.selectItemAt(index: 0)
            weakSelf?.listContainerView.didClickSelectedItem(at: 0)
            weakSelf?.segmentedView.reloadData()
            weakSelf?.listContainerView.reloadData()
            
            weakSelf?.segmentedViewRightBack.isHidden = false
            weakSelf?.segmentedViewRight.isHidden = true
            weakSelf?.segmentedViewBack.isHidden = true
            weakSelf?.segmentedView.isHidden = false
            weakSelf?.listContainerView.isHidden =  false
            weakSelf?.listContainerViewRight.isHidden = true


        }

        let vc3 = CS_MarketMySetsController()
        vc3.tag = 5

        let vc4 = CS_MarketHistoryController()
        vc3.tag = 6


        return [
            vc1,vc2,vc3,vc4
        ]
    }()

    let chooseFilterBtn = UIButton(type: .custom)

}


//MARK: Notification
extension CS_MarketController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyBuyItem(_:)), name: NotificationName.CS_MarketBuyItem, object: nil)
    }
    
    
    @objc private func notifyBuyItem(_ notify: Notification) {
        loadBalance()
    }
}

extension CS_MarketController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if segmentedView == self.segmentedViewRightBack {
            self.segmentedViewRight.selectItemAt(index: index)
            self.segmentedViewRightBack.isHidden = true
            self.segmentedViewRight.isHidden = false
            self.segmentedViewBack.isHidden = false
            self.segmentedView.isHidden = true
            self.listContainerView.isHidden =  true
            self.listContainerViewRight.isHidden = false
        } else if segmentedView == self.segmentedViewBack {

            self.segmentedView.selectItemAt(index: index)
            self.segmentedViewRightBack.isHidden = false
            self.segmentedViewRight.isHidden = true
            self.segmentedViewBack.isHidden = true
            self.segmentedView.isHidden = false
            self.listContainerView.isHidden =  false
            self.listContainerViewRight.isHidden = true
        }
        
        else if segmentedView == self.segmentedView {
            self.currentViewController = self.listContainerLeftViewControllers[index] as? CS_ChooseConditionAlertDataSource

        } else if segmentedView == self.segmentedViewRight {
            self.currentViewController = self.listContainerRightViewControllers[index] as? CS_ChooseConditionAlertDataSource
        }
    }
}

extension CS_MarketController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if listContainerView == self.listContainerViewRight {
            return segmentedDataSourceRight.dataSource.count
        }
        return segmentedDataSource.dataSource.count
    }
    
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if listContainerView == self.listContainerViewRight {

            return self.listContainerRightViewControllers[index]
        } else {

            return self.listContainerLeftViewControllers[index]
        }
        
    }
}

//MARK: request
extension CS_MarketController {
    func loadBalance(){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        CSNetworkManager.shared.getDiamondBalance(para) { resp in
            if resp.status == .success {
                if let data = resp.data {
                    weakSelf?.navAmountView.iconView.image = UIImage.ls_bundle("icon_token_diamond@2x")
                    weakSelf?.navAmountView.amountLabel.text = data.balance
                    CS_MarketManager.shared.diamondBalance = data.balance
                }
            }
        }
    }
}


extension CS_MarketController {
    func setupView(){
        navigationView.backView.image = nil
        navigationView.backView.backgroundColor = .clear
        navigationView.titleLabel.text = "crazy_str_market".ls_localized
        backView.image = UIImage.ls_bundle("market_bg_page@2x")
        navAmountView.isHidden = false
        topBackView.isHidden = false
        topBackView.addSubview(segementBackView)
        topBackView.addSubview(segmentedView)
        topBackView.addSubview(segmentedViewBack)
        topBackView.addSubview(segmentedViewRight)
        topBackView.addSubview(segmentedViewRightBack)
        topBackView.backgroundColor = .ls_color("#A7A4F3",alpha: 0.1)
        view.addSubview(listContainerView)
        view.addSubview(listContainerViewRight)
        
        navAmountView.snp.updateConstraints { make in
            make.width.equalTo(100)
        }
        
        segementBackView.snp.makeConstraints { make in
            make.left.equalTo(-20)
            make.top.bottom.equalTo(topBackView)
            make.width.equalTo(360)
        }
        
        segmentedView.snp.makeConstraints { make in
            make.width.equalTo(CS_kScreenW*0.5)
            make.height.equalTo(36)
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
        
        segmentedViewBack.snp.makeConstraints { make in
            make.edges.equalTo(segmentedView)
        }
        
        segmentedViewRight.snp.makeConstraints { make in
            make.width.equalTo(CS_kScreenW*0.4)
            make.height.equalTo(36)
            make.top.equalTo(0)
            make.right.equalTo(0).offset(-CS_kScreenW*0.1)
        }
        
        chooseFilterBtn.setImage(UIImage.ls_bundle("market_icon_filter@2x"), for: .normal)
        chooseFilterBtn.addTarget(self, action: #selector(clickChooseFilterBtn(_:)), for: .touchUpInside)
        topBackView.addSubview(chooseFilterBtn)
        chooseFilterBtn.snp.makeConstraints { make in
            make.width.equalTo(CS_kScreenW*0.1)
            make.height.equalTo(36)
            make.top.equalTo(0)
            make.right.equalTo(0)
        }
        
        segmentedViewRightBack.snp.makeConstraints { make in
            make.edges.equalTo(segmentedViewRight)
        }
        
        listContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(topBackView.snp.bottom).offset(0)
        }
        
        listContainerViewRight.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(topBackView.snp.bottom).offset(0)
        }
    }
    
    @objc func clickChooseFilterBtn(_ sender : UIButton) {
        if let currentVc = self.currentViewController as? CS_BaseEmptyController {
            self.currentIndexPath = self.setIndexPath[currentVc.tag]
        }
        
        let view = CS_ChooseConditionAlert()
        view.indexPaths = self.currentIndexPath
        view.data = self.currentChooseData
        view.show()
        weak var weakSelf = self
        view.selectedHandle = { indexPaths in
            weakSelf?.currentIndexPath = indexPaths
        }
    }
}


extension CS_MarketNFTController : CS_ChooseConditionAlertDataSource {
    
    var chooseData: [CS_MarketChooseTitleCell.CellData]? {
        var list: [CS_MarketChooseTitleCell.CellData] = []
        if let language = CS_AccountManager.shared.nameDescList.first(where: {$0.language == CSSDKManager.shared.language.local()}) {
            list.append(.init(title: "Quality", list: language.data.filter({$0.type == 1})))
            list.append(.init(title: "Gender", list: [
                CS_NameDescribeModel(ID:"1",name: "Male",icon: UIImage.ls_bundle("market_man_icon@2x")),
                CS_NameDescribeModel(ID:"2",name: "Female",icon: UIImage.ls_bundle("market_woman_icon@2x")),
            ]))
            list.append(.init(title: "NFT Sets", list: language.data.filter({$0.type == 2})))

        }
        return list
    }
}
extension CS_MarketNFTSetsController : CS_ChooseConditionAlertDataSource {
    var chooseData: [CS_MarketChooseTitleCell.CellData]? {
        var list: [CS_MarketChooseTitleCell.CellData] = []
        if let language = CS_AccountManager.shared.nameDescList.first(where: {$0.language == CSSDKManager.shared.language.local()}) {
            list.append(.init(title: "NFT Sets", list: language.data.filter({$0.type == 2})))
        } else {
            return nil
        }
        return list
    }
}

extension CS_MarketSellingController : CS_ChooseConditionAlertDataSource {
    var chooseData: [CS_MarketChooseTitleCell.CellData]? {
        let list: [CS_MarketChooseTitleCell.CellData] = [
            .init(title: "Type", list: [
                CS_NameDescribeModel(name: "NFT"),
                CS_NameDescribeModel(name: "Incubatin"),
                CS_NameDescribeModel(name: "Slot card"),
                CS_NameDescribeModel(name: "Carzy Box"),
                CS_NameDescribeModel(name: "NFT Sets"),
            ])
        ]
        return list
    }
}
extension CS_MarketInventoryController : CS_ChooseConditionAlertDataSource {
    var chooseData: [CS_MarketChooseTitleCell.CellData]? {
        let list: [CS_MarketChooseTitleCell.CellData] = [
            .init(title: "Type", list: [
                CS_NameDescribeModel(name: "NFT"),
                CS_NameDescribeModel(name: "Incubatin"),
                CS_NameDescribeModel(name: "Slot card"),
                CS_NameDescribeModel(name: "Carzy Box"),
                CS_NameDescribeModel(name: "NFT Sets"),
            ])
        ]
        return list
    }
}
