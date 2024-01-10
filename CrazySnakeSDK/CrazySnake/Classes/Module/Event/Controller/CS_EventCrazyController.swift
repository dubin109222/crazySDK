//
//  CS_EventCrazyController.swift
//  CrazySnake
//
//  Created by Lee on 04/04/2023.
//

import UIKit
import HandyJSON
import JXSegmentedView

class CS_EventCrazyController: CS_BaseEmptyController {

    var eventTimeUpdate: CS_StringBlock?
    
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var dataSource = [CS_EventListItemModel]()
    
    var isMock = false
    lazy var mockData: [CS_EventListItemModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_EventListItemModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "event.event") as? [CS_EventListItemModel] {
                return model
            }
            
        }
        return []
    }()
    
    private var selectedModel: CS_EventListItemModel? {
        didSet {
            // FIXME: 只需要结束时间吧，安卓是是这样的
            let time = "crazy_str_end_time".ls_localized([""]) + (selectedModel?.end_time ?? "")
            //            let time = "crazy_str_end_time".ls_localized([""]) + (selectedModel?.start_time ?? "") + " ~ " + (selectedModel?.end_time ?? "")

//            let time = "crazy_str_end_time".ls_localized + ":" + (selectedModel?.start_time ?? "") + " ~ " + (selectedModel?.end_time ?? "")
            eventTimeUpdate?(time)
        }
    }
    
    private var detailSource = [CS_EventDetailModel]()
    lazy var mockDetailData: [CS_EventDetailModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_EventDetailModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "event.list") as? [CS_EventDetailModel] {
                return model
            }
            
        }
        return []
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        GuideMaskManager.checkGuideState(.event) { isFinish in
            self.isMock = !isFinish
            self.requestList()
            self.emptyStyle = .loading
            
            if self.isMock {
                self.collectionView.reloadData()
                self.tableView.reloadData()
                self.guideStepOne()
            }
        }

    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.rowHeight = 50
        view.register(CS_EventListCell.self, forCellReuseIdentifier: NSStringFromClass(CS_EventListCell.self))
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 20
//        layout.minimumInteritemSpacing = 20
        layout.itemSize = CS_EventDetailCell.itemSize()
//        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(CS_EventDetailCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_EventDetailCell.self))
        view.backgroundColor = .clear
//        view.contentInset = UIEdgeInsets(top: 6, left: 12, bottom: 0, right: 12)
//        weak var weakSelf = self
//        view.ls_addHeader(false) {
//            weakSelf?.requestDetail()
//        }

        return view
    }()

}

//MARK: TableView
extension CS_EventCrazyController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isMock ? mockData.count : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_EventListCell.self)) as! CS_EventListCell
        let model = isMock ? mockData[indexPath.row] : dataSource[indexPath.row]
        cell.setData(model, current: selectedModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if model.id != selectedModel?.id {
            selectedModel? = model
            LSHUD.showLoading()
            self.tableView.reloadData()
            
            
            requestDetail()
        }
    }
    
}

extension CS_EventCrazyController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_EventDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_EventDetailCell.self), for: indexPath) as! CS_EventDetailCell
        let model = isMock ? mockDetailData[indexPath.row] : detailSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isMock ? mockDetailData.count : detailSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = detailSource[indexPath.row]
        
        guard model.status == 1 else {
            return
        }
        
        let vc = CS_EventBuyController()
        vc.eventId = selectedModel?.id ?? ""
        vc.model = model
        present(vc, animated: false)
        weak var weakSelf = self
        vc.buySuccess = {
            weakSelf?.requestDetail()
        }
    }
    
}


extension CS_EventCrazyController {
    func guideStepOne() {
        if self.isMock == true {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 0, section: 0)) as? CS_EventDetailCell {
                    let maskRect = cell.priceButton.convert(cell.priceButton.bounds, to: nil)
                    
                    GuideMaskView.show (tipsText: "Select the treasure chest to purchase.",
                                        currentStep: "1",
                                        totalStep: "1",
                                        maskRect: maskRect,
                                        textWidthDefault: 223,
                                        direction: .left){
                        weakSelf?.guideStepEnd()
                        
                    } skipHandle: {
                        weakSelf?.guideStepEnd()
                    }
                }
            }
        }
    }
    
    func guideStepEnd() {
        GuideMaskManager.saveGuideState(.event)
        self.isMock = false
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
}


//MARK: request
extension CS_EventCrazyController {
    func requestList() {
        
        weak var weakSelf = self
        CSNetworkManager.shared.getEventList { resp in
            
            if resp.status == .success {
                weakSelf?.dataSource.removeAll()
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
                    weakSelf?.handleListData()
                }
                
            } else {
                weakSelf?.emptyStyle = .error
            }
            if weakSelf?.isMock == false {
                weakSelf?.tableView.reloadData()
            }
        }
    }
    
    func handleListData(){
        if selectedModel == nil {
            selectedModel = dataSource.first
            requestDetail()
        }
    }
    
    func requestDetail(){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            emptyStyle = .empty
            if self.isMock == false {
                collectionView.reloadData()
            }
            return
        }
        guard let model = selectedModel else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["id"] = "\(model.id)"
        CSNetworkManager.shared.getEventDetail(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.detailSource.removeAll()
                weakSelf?.detailSource.append(contentsOf: resp.data)
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            
            if weakSelf?.isMock == false {
                weakSelf?.collectionView.reloadData()
            }
        }
    }
}

extension CS_EventCrazyController {
    func setupView(){
        navigationView.isHidden = true
        
        view.addSubview(tableView)
        view.addSubview(collectionView)
        
        tableView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(169)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(tableView.snp.right).offset(16)
            make.right.equalTo(-32)
            make.top.bottom.equalTo(0)
        }
    }
}

extension CS_EventCrazyController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

