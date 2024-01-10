//
//  CS_NFTStakeChooseSetController.swift
//  CrazySnake
//
//  Created by Lee on 15/03/2023.
//

import UIKit
import HandyJSON

class CS_NFTStakeChooseSetController: CS_BaseAlertController {
    
    var suitableItem: CS_NFTStakeSuitableItemModel?
    var nftStakeSuccss: CS_NoParasBlock?
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var page = 1
    private var dataSource = [CS_NFTDataModel]()
    private var selectedList = [CS_NFTDataModel]()
    lazy var mockData: [CS_NFTDataModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTDataModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "nft_stake.sets.set_list") as? [CS_NFTDataModel] {
                return model
            }
        }
        return []
    }()
    var isMock = false


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emptyStyle = .loading
        setupView()
        requestMyNFTList()
        guideStepOne()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CS_NFTLabNftCell.itemSizeNFTStake()
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: CS_kScreenW-2*CS_ms(24), height: 1000), collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(CS_NFTLabNftCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self))
        view.backgroundColor = .ls_dark_2()
        view.contentInset = UIEdgeInsets(top: 6, left: 12, bottom: 0, right: 12)
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
    
    lazy var stakeButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 233, height: 40))
        button.addTarget(self, action: #selector(clickStakeButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_stake".ls_localized, for: .normal)
        return button
    }()
    
    var mockNextHandle: ((Bool) -> ())? = nil
    
}

extension CS_NFTStakeChooseSetController {
    func guideStepOne() {
        if self.isMock {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                let cell = self.stakeButton
                let maskRect = cell.convert(cell.bounds, to: nil)
                
                GuideMaskView.show (tipsText: "Select NFTs within NFT set.",
                                    currentStep: "7",
                                    totalStep: "10",
                                    maskRect: maskRect,
                                    textWidthDefault: 223,
                                    direction: .down){
                    weakSelf?.isMock = false
                    weakSelf?.mockNextHandle?(false)
                    weakSelf?.dismiss(animated: false)
                } skipHandle: {
                    weakSelf?.isMock = false
                    weakSelf?.mockNextHandle?(true)
                    weakSelf?.dismiss(animated: false)
                }
            }
            

        }
    }
}

extension CS_NFTStakeChooseSetController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTLabNftCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self), for: indexPath) as! CS_NFTLabNftCell
        let model = isMock ? mockData[indexPath.row] : dataSource[indexPath.row]
        cell.setNFTStakeData(model, selectedList: selectedList)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isMock ? mockData.count : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        var isExsit = false
        var index = 0
        for item in selectedList.enumerated() {
            if model.quality == item.element.quality {
                isExsit = true
                index = item.offset
                break
            }
        }
        if isExsit {
            selectedList.remove(at: index)
        }
        selectedList.append(model)
        self.collectionView.reloadData()
    }
    
}


//MARK: request
extension CS_NFTStakeChooseSetController {
    func requestMyNFTList() {
        guard let model = suitableItem else { return }
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["status"] = "\(0)"
        para["class"] = "\(model.group_class)"
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
            weakSelf?.collectionView.ls_compeletLoading(weakSelf?.page == 1, hasMore: hasMore)
            weakSelf?.collectionView.mj_footer.isHidden = weakSelf?.dataSource.count ?? 0 < 5
            weakSelf?.collectionView.reloadData()
        }
    }
}

//MARK: action
extension CS_NFTStakeChooseSetController {
    @objc private func clickStakeButton(_ sender: UIButton) {
        
        guard selectedList.count > 2 else {
            LSHUD.showInfo("Minimum of 3 NFTs to stake")
            return
        }
        var nftids = [String]()
        for item in selectedList {
            nftids.append(item.token_id)
        }
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["nftids"] = nftids
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.nftStakeSet(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.nftStakeSuccss?()
                weakSelf?.dismiss(animated: false)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}


//MARK: UI
extension CS_NFTStakeChooseSetController {
    
    private func setupView() {
        titleLabel.text = "crazy_str_nft_choose_nft".ls_localized
        
        contentView.backgroundColor = .ls_dark_3()
        contentView.addSubview(collectionView)
        view.addSubview(stakeButton)
        
        contentView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(24))
            make.right.equalTo(-CS_ms(24))
            make.top.equalTo(47)
            make.bottom.equalTo(-102)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(44)
        }
        
        stakeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-21)
            make.width.equalTo(233)
            make.height.equalTo(40)
        }
        
        collectionView.ls_addCorner([.bottomLeft,.bottomRight], cornerRadius: 15)
    }
}
