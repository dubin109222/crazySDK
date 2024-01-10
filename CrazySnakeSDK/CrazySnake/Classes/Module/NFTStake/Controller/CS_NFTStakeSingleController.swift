//
//  CS_NFTStakeSingleController.swift
//  CrazySnake
//
//  Created by Lee on 14/03/2023.
//

import UIKit
import HandyJSON

class CS_NFTStakeSingleController: CS_BaseEmptyController {
    
    var nftStakeSuccss: CS_NoParasBlock?
    
    var mockNext: ((Bool) -> ())? = nil
    
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var page = 1
    private var quality = 0
    private var isLoading = false
    private var hasMore = false
    private var dataSource = [CS_NFTDataModel]()
    lazy var mockData: [CS_NFTDataModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTDataModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "nft_stake.nfts") as? [CS_NFTDataModel] {
                return model
            }
        }
        return []
    }()
    private var selectedModel: CS_NFTDataModel?

    var isMock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emptyStyle = .loading
        setupView()
        requestNFTList()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.itemSize = CS_NFTLabNftCell.itemSizeNFTStake()
//        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.register(CS_NFTLabNftCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self))
        view.backgroundColor = .clear
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requestNFTList()
        }
        view.ls_addFooter {
            weakSelf?.page += 1
            weakSelf?.requestNFTList()
        }
        view.mj_footer.isHidden = true
        return view
    }()

    lazy var stakeButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 233, height: 40))
        button.addTarget(self, action: #selector(clickStakeButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_stake".ls_localized, for: .normal)
        return button
    }()
}

extension CS_NFTStakeSingleController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTLabNftCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self), for: indexPath) as! CS_NFTLabNftCell
        var model : CS_NFTDataModel
        if isMock {
            model = mockData[indexPath.row]
        } else {
            model = dataSource[indexPath.row]
        }
        cell.setData(model,selectedItem: selectedModel)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMock {
            return mockData.count
        }
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectedModel = dataSource[indexPath.row]
        self.collectionView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard hasMore else {
//            return
//        }
//        guard isLoading == false else {
//            return
//        }
//        if scrollView.contentSize.width - scrollView.width - 200 < scrollView.contentOffset.x {
//            LSLog("loadingMore")
//            page += 1
//            requestNFTList()
//        }
    }
}

//MARK: request
extension CS_NFTStakeSingleController {
    func requestNFTList() {
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["status"] = "\(0)"
//        para["quality"] = "\(quality)"
        para["page"] = "\(page)"
        para["page_size"] = "20"
        CSNetworkManager.shared.getMyNFTList(para) { resp in
            
            var hasMore = false
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
                }
                hasMore = weakSelf?.dataSource.count ?? 0 < resp.data?.total ?? 0
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            weakSelf?.hasMore = hasMore
            weakSelf?.collectionView.ls_compeletLoading(weakSelf?.page == 1, hasMore: hasMore)
            weakSelf?.collectionView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 == 0
            weakSelf?.collectionView.reloadData()
            weakSelf?.guideStepOne()
        }
    }
}

extension CS_NFTStakeSingleController {
    func guideStepOne() {
        if self.isMock == true {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 0, section: 0)) {
                    let maskRect = cell.convert(cell.bounds, to: nil)
                    
                    GuideMaskView.show (tipsText: "Select single NFT.",
                                        currentStep: "3",
                                        totalStep: "10",
                                        maskRect: maskRect,
                                        textWidthDefault: 223,
                                        direction: .left){
                        weakSelf?.guideStepTwo()
                    } skipHandle: {
                        weakSelf?.mockNext?(true)
                        weakSelf?.pop(true)
                    }
                }
            }
        }
    }
    
    func guideStepTwo() {
         let cell = stakeButton
        weak var weakSelf = self

            let maskRect = cell.convert(cell.bounds, to: nil)
            
            GuideMaskView.show (tipsText: "Click the button to confirm stake.",
                                currentStep: "4",
                                totalStep: "10",
                                maskRect: maskRect,
                                textWidthDefault: 223,
                                direction: .down){
                weakSelf?.mockNext?(false)
                weakSelf?.pop(true)
            } skipHandle: {
                weakSelf?.mockNext?(true)
                weakSelf?.pop(true)
            }
        

    }
}


//MARK: action
extension CS_NFTStakeSingleController {
    @objc private func clickStakeButton(_ sender: UIButton) {
        
        guard selectedModel != nil else { return }
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["nftid"] = selectedModel?.token_id
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.nftSingleStake(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.nftStakeSuccss?()
                weakSelf?.pop()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}


//MARK: UI
extension CS_NFTStakeSingleController {
    
    private func setupView() {
        navigationView.titleLabel.text = "crazy_str_choose_single_nft".ls_localized
        emptyImageName = "icon_empty_nft@2x"
        emptyDescription = "crazy_str_empty_nfg_hint".ls_localized
        view.addSubview(collectionView)
        view.addSubview(stakeButton)
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(30))
            make.right.equalTo(-CS_ms(30))
            make.bottom.equalTo(0)
            make.top.equalTo(navigationView.snp.bottom).offset(0)
        }
        
        stakeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-CS_RH(21))
            make.width.equalTo(233)
            make.height.equalTo(40)
        }
    }
}
