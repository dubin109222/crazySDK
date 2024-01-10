//
//  CS_MarketChooseSetsController.swift
//  CrazySnake
//
//  Created by Lee on 15/06/2023.
//

import UIKit

class CS_MarketChooseSetsController: CS_BaseAlertController {

    var setsInfo: CS_NFTSetInfoModel?
    var nftStakeSuccss: CS_NoParasBlock?
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var page = 1
    private var dataSource = [CS_NFTDataModel]()
    private var selectedList = [CS_NFTDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emptyStyle = .loading
        setupView()
        requestMyNFTList()
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
    
    lazy var priceInputView: CS_MarketNFTPriceInputView = {
        let view = CS_MarketNFTPriceInputView()
        view.backgroundColor = .ls_color("#7A56E1", alpha: 0.3)
        return view
    }()
    
    lazy var stakeButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 233, height: 40))
        button.addTarget(self, action: #selector(clickStakeButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_place_offer".ls_localized, for: .normal)
        return button
    }()
    
}

extension CS_MarketChooseSetsController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTLabNftCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self), for: indexPath) as! CS_NFTLabNftCell
        let model = dataSource[indexPath.row]
        cell.setNFTStakeData(model, selectedList: selectedList)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
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
extension CS_MarketChooseSetsController {
    func requestMyNFTList() {
        guard let model = setsInfo else { return }
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["status"] = "\(0)"
        para["class"] = "\(model.set_class)"
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
extension CS_MarketChooseSetsController {
    @objc private func clickStakeButton(_ sender: UIButton) {
        
        guard selectedList.count > 2 else {
            LSHUD.showInfo("Minimum of 3 NFTs to sell")
            return
        }
        
        guard let price = priceInputView.inputField.text, Int(price) ?? 0 > 0 else {
            return
        }
        
        weak var weakSelf = self
        CS_AccountManager.shared.verifyPassword {
            weakSelf?.placeOffer()
        }
    }
    
    func placeOffer(){
        guard let price = priceInputView.inputField.text, Int(price) ?? 0 > 0 else {
            return
        }
        
        var nftids = ""
        for item in selectedList {
            if nftids.count == 0 {
                nftids = item.token_id
            } else {
                nftids = nftids + "|\(item.token_id)"
            }
        }
        
        let account = CS_AccountManager.shared.accountInfo
        guard let address = account?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: account?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["item_type"] = "3"
        para["item_id"] = nftids
        para["price"] = price
        para["amount"] = "1"
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.marketStartSell(para) { resp in
            LSHUD.hide()
            if resp.status == .success, resp.data?.success == 1 {
                NotificationCenter.default.post(name: NotificationName.CS_MarketPlaceOffer, object: nil)
                weakSelf?.dismiss(animated: false)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
}


//MARK: UI
extension CS_MarketChooseSetsController {
    
    private func setupView() {
        titleLabel.text = "crazy_str_nft_choose_nft".ls_localized
        
        contentView.backgroundColor = .ls_dark_3()
        contentView.addSubview(collectionView)
        view.addSubview(priceInputView)
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
            make.bottom.equalTo(-21)
            make.centerX.equalTo(contentView).offset(150)
            make.width.equalTo(233)
            make.height.equalTo(40)
        }
        
        priceInputView.snp.makeConstraints { make in
            make.centerY.equalTo(stakeButton)
            make.right.equalTo(stakeButton.snp.left).offset(-64)
            make.width.equalTo(260)
            make.height.equalTo(40)
        }
        
        collectionView.ls_addCorner([.bottomLeft,.bottomRight], cornerRadius: 15)
    }
}
