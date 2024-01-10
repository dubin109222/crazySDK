//
//  CS_NFTListController.swift
//  CrazySnake
//
//  Created by Lee on 06/03/2023.
//

import UIKit
import JXSegmentedView
import HandyJSON

class CS_NFTListController: CS_BaseEmptyController {

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var page = 1
    private var quality = 0
    private var dataSource = [CS_NFTDataModel]()
    lazy var mockData: [CS_NFTDataModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTDataModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "my_nft") as? [CS_NFTDataModel] {
                return model
            }
        }
        return []
    }()
    
    var isMock = false
    override func viewDidLoad() {
        super.viewDidLoad()
//        walletAddress = "0xa2d0648f9c66bdaf9372eeadbe64d8694d87f402"
        setupView()

        GuideMaskManager.checkGuideState(.nft_list) { isFinish in
            self.isMock = !isFinish
            self.requestMyNFTList()
            self.emptyStyle = .loading
            
            if self.isMock {
                self.collectionView.reloadData()
                self.guideStepOne()
            }
        }
        registerNotication()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = ProfileNFTCollectionCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(ProfileNFTCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(ProfileNFTCollectionCell.self))
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 10, left: 18, bottom: 0, right: 0)
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requestMyNFTList()
        }
        view.ls_addFooter {
            weakSelf?.page += 1
            weakSelf?.requestMyNFTList()
        }
        view.mj_footer.isHidden = true
        return view
    }()
}


//MARK: Notification
extension CS_NFTListController {
    
    func registerNotication() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyOpenBoxSuccess(_:)), name: NotificationName.CS_OpenBoxSuccess, object: nil)
    }
    
    @objc private func notifyOpenBoxSuccess(_ notify: Notification) {
        page = 1
        requestMyNFTList()
    }
}

extension CS_NFTListController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProfileNFTCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ProfileNFTCollectionCell.self), for: indexPath) as! ProfileNFTCollectionCell
        let model = isMock ? mockData[indexPath.row] : dataSource[indexPath.row]
        cell.setData(model)
        cell.clickNewIconAction = {
//            self.changeToUnNew(model)
//            self.requedtDetail(model)
        }
        return cell
    }
    
    func changeToUnNew(_ nft: CS_NFTDataModel){
        var model = nft
        model.is_new = false
        var index = -1
        for item in dataSource.enumerated() {
            if item.element.id == model.id {
                index = item.offset
                break
            }
        }
        if index >= 0, let range = Range(NSRange(location: index, length: 1)) {
            dataSource.replaceSubrange(range,with: [model])
            collectionView.reloadData()
        }
    }
    
    func requedtDetail(_ model: CS_NFTDataModel){
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["token_id"] = model.token_id
        CSNetworkManager.shared.getNFTDetail(para) { resp in
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isMock ? mockData.count : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let vc = CS_NFTNFTDetailController()
        vc.model = model
        present(vc, animated: false)
        weak var weakSelf = self
        vc.sendSuccess = {
            weakSelf?.page = 1
            weakSelf?.requestMyNFTList(true)
        }
        vc.transferOutSuccess = {
            weakSelf?.page = 1
            weakSelf?.requestMyNFTList(true)
        }
        vc.loadDetailSuccess = {
            if model.is_new == true {
                weakSelf?.changeToUnNew(model)
//                weakSelf?.page = 1
//                weakSelf?.requestMyNFTList(true)
            }
        }
    }
    
}

//MARK: action
extension CS_NFTListController {
    func requestMyNFTList(_ scrollToTop: Bool = false) {
        
        guard let address = walletAddress else {
            emptyStyle = .empty
            if self.isMock == false {
                collectionView.reloadData()
            }
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["status"] = "\(-1)"
        para["quality"] = "\(quality)"
        para["page"] = "\(page)"
        para["page_size"] = "20"
        para["order"] = "5"
        CSNetworkManager.shared.getMyNFTList(para) { resp in
            weakSelf?.collectionView.ls_compeletLoading(false)
            var hasMore = false
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
                    if list.count > 0 {
                        hasMore = true
                    }
                }
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            weakSelf?.collectionView.ls_compeletLoading(weakSelf?.page == 1, hasMore: hasMore)
            weakSelf?.collectionView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 < 5
            if weakSelf?.isMock == false {
                weakSelf?.collectionView.reloadData()
            }
            if scrollToTop {
                weakSelf?.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
}

extension CS_NFTListController {
    func guideStepOne() {
        if self.isMock == true {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 0, section: 0)) {
                    let maskRect = cell.convert(cell.bounds, to: nil)
                    
                    GuideMaskView.show (tipsText: "NFT details can be viewed.",
                                        currentStep: "1",
                                        totalStep: "3",
                                        maskRect: maskRect,
                                        textWidthDefault: 223,
                                        direction: .up){
                        weakSelf?.guideStepTwo()
                        
                    } skipHandle: {
                        weakSelf?.guideStepEnd()
                    }
                }
            }
        }
    }
    
    func guideStepTwo() {
        let model = mockData[0]
        let vc = CS_NFTNFTDetailController()
        vc.isMock = true
        vc.model = model
        weak var weakSelf = self
        vc.guideNextHandle = {
            weakSelf?.guideStepEnd()
        }
        present(vc, animated: false)

    }
    
    func guideStepEnd() {
        GuideMaskManager.saveGuideState(.nft_list)
        self.isMock = false
        self.collectionView.reloadData()
    }

}

extension CS_NFTListController {
    func setupView(){
        navigationView.isHidden = true
        backView.image = UIImage.ls_bundleImageJpg(named: "bg_image_no_title")
        emptyDescription = "crazy_str_empty_nft_list".ls_localized
        view.addSubview(collectionView)

        
        collectionView.snp.makeConstraints { make in
            make.left.bottom.equalTo(CS_ms(20))
            make.right.bottom.equalTo(-CS_ms(20))
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
}

extension CS_NFTListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}
