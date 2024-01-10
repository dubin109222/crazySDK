//
//  CS_NFTChooseNFTController.swift
//  CrazySnake
//
//  Created by Lee on 03/03/2023.
//

import UIKit
import HandyJSON

class CS_NFTChooseNFTController: CS_BaseAlertController {
    
    var chooseNFTAction: NFTDataBlock?
    
    var mockNext : ((Bool) -> ())?
    var isMock = false
    
    var isFemale = false
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
            if let model = JSONDeserializer<CS_NFTDataModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "lab.incubation") as? [CS_NFTDataModel] {
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
        layout.itemSize = CS_NFTLabNftCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(CS_NFTLabNftCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self))
        view.backgroundColor = .ls_dark_3()
        view.contentInset = UIEdgeInsets(top: 6, left: 12, bottom: 0, right: 12)
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requestMyNFTList()
        }
//        view.ls_addFooter {
//            weakSelf?.page += 1
//            weakSelf?.requestMyNFTList()
//        }
//        view.mj_footer.isHidden = true
        return view
    }()
    
}

extension CS_NFTChooseNFTController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTLabNftCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self), for: indexPath) as! CS_NFTLabNftCell
        let model = isMock ? mockData[indexPath.row] : dataSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isMock ? mockData.count : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        chooseNFTAction?(model)
        self.dismiss(animated: false)
    }
    
}

extension CS_NFTChooseNFTController {
    func guideStepOne() {
        weak var weakSelf = self

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let mockItem = self.collectionView
            let maskRect = mockItem.convert(mockItem.bounds, to: nil)
            
            GuideMaskView.show (tipsText: "Click to select NFT.",
                                currentStep: "3",
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


//MARK: request
extension CS_NFTChooseNFTController {
    func requestMyNFTList() {
        
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
//        para["status"] = "\(-1)"
//        para["quality"] = "\(quality)"
//        para["page"] = "\(page)"
//        para["page_size"] = "20"
        para["sex"] = isFemale ? "\(2)" : "\(1)"
        CSNetworkManager.shared.getIncubateNFTList(para) { resp in
            
//            var hasMore = false
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
            weakSelf?.collectionView.ls_compeletLoading(weakSelf?.page == 1, hasMore: false)
//            weakSelf?.collectionView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 < 5
            weakSelf?.collectionView.reloadData()
//            weakSelf?.updateLayout()
        }
    }
}


//MARK: UI
extension CS_NFTChooseNFTController {
    
    private func setupView() {
        titleLabel.text = "crazy_str_nft_choose_nft".ls_localized
        titleColor = .ls_white()
        emptyDescription = "crazy_str_empty_nfg_hint".ls_localized
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(44)
        }
    }
}
