//
//  CS_NFTChooseIncubatorController.swift
//  CrazySnake
//
//  Created by Lee on 03/03/2023.
//

import UIKit
import HandyJSON

class CS_NFTChooseIncubatorController: CS_BaseAlertController {
    
    typealias NFTIncubatorBlock = (CS_NFTPropModel) -> Void
    var chooseAction: NFTIncubatorBlock?
    var quality = 0
    
    var isMock = false
    var mockNext : ((Bool) -> ())?

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var page = 1
    private var dataSource = [CS_NFTPropModel]()
    lazy var mockData: [CS_NFTPropModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTPropModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "lab.item_incubation") as? [CS_NFTPropModel] {
                return model
            }
        }
        return []
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        if isMock {
            self.collectionView.reloadData()
            self.guideStepOne()
        } else {
            requestMyNFTList()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CS_NFTIncubatorCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(CS_NFTIncubatorCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_NFTIncubatorCell.self))
        view.contentInset = UIEdgeInsets(top: 6, left: 12, bottom: 0, right: 12)
        view.backgroundColor = .ls_dark_3()
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requestMyNFTList()
        }
        return view
    }()
    
}

extension CS_NFTChooseIncubatorController {
    func guideStepOne() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            let mockItem = self.collectionView
            let maskRect = mockItem.convert(mockItem.bounds, to: nil)
            
            weak var weakSelf = self
            GuideMaskView.show (tipsText: "Click to select an incubator.",
                                currentStep: "5",
                                totalStep: "6",
                                maskRect: maskRect,
                                textWidthDefault: 223,
                                direction: .down){
                weakSelf?.mockNext?(false)
                weakSelf?.dismiss(animated: false)
            } skipHandle: {
                weakSelf?.mockNext?(true)
                weakSelf?.dismiss(animated: false)
            }
        }
    }
}


extension CS_NFTChooseIncubatorController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTIncubatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTIncubatorCell.self), for: indexPath) as! CS_NFTIncubatorCell
        let model = isMock ? mockData[indexPath.row] : dataSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isMock ? mockData.count : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        chooseAction?(model)
        self.dismiss(animated: false)
    }
    
}


//MARK: request
extension CS_NFTChooseIncubatorController {
    func requestMyNFTList() {
        
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sub_type"] = "\(2)"
        para["quality"] = "\(quality)"
//        para["page"] = "\(page)"
//        para["page_size"] = "20"
        CSNetworkManager.shared.getMybackpackList(para) { resp in
            weakSelf?.collectionView.ls_compeletLoading(false)
            var hasMore = false
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
//                    if list.count > 0 {
//                        hasMore = true
//                    }
                }
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            weakSelf?.collectionView.ls_compeletLoading(weakSelf?.page == 1, hasMore: hasMore)
//            weakSelf?.collectionView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 < 5
            weakSelf?.collectionView.reloadData()
        }
    }
}


//MARK: UI
extension CS_NFTChooseIncubatorController {
    
    private func setupView() {
        titleLabel.text = "Choose Incubator"
        emptyImageName = "icon_empty_data"
        titleColor = .ls_white()
        emptyDescription = "Inventory is empty"
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(44)
        }
    }
}
