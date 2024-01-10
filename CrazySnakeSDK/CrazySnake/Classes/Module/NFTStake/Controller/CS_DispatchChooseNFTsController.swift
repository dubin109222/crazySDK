//
//  CS_DispatchChooseNFTsController.swift
//  CrazySnake
//
//  Created by BigB on 2023/9/26.
//

import UIKit

class CS_DispatchChooseNFTsController: CS_BaseEmptyController {

    var nftStakeSuccss: CS_NoParasBlock?
    
    public var data: NFT_DisPatch_Team? {
        didSet {
            nftQuantifyValueLb.text = "\(data?.dispatch_cond?.min_num ?? 0) - \(data?.dispatch_cond?.max_num ?? 0)"
            miniPowerValueLb.text = "\(data?.dispatch_cond?.min_power ?? 0)"
        }
    }

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var page = 1
    private var quality = 0
    private var isLoading = false
    private var hasMore = false
    private var dataSource = [CS_NFTDataModel]()
    private var selectedModel: CS_NFTDataModel?
    private var selectList: [CS_NFTDataModel] = [] {
        didSet {
            
            let totalValue = self.selectList.compactMap{$0.power}.reduce(0, +)
            if selectList.count >= (data?.dispatch_cond?.min_num ?? 0) && totalValue >= (self.data?.dispatch_cond?.min_power ?? 0) {
                stakeButton.isEnabled = true
            } else {
                stakeButton.isEnabled = false
            }
            selectValueLb.text = "\(selectList.count)"
            var totalPower = 0
            for item in selectList {
                totalPower += item.power
            }
            selectPowerValueLb.text = "\(totalPower)"
            quality = data?.dispatch_cond?.quality?.first ?? 0
            
            let value = (data?.power_scale ?? []).first(where: {$0.first == selectList.count})?.last ?? 0
            extraLb.text = "+\(value)"

        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        quality = data?.dispatch_cond?.quality?.first ?? 0

        emptyStyle = .loading
        setupView()
        requestNFTList()
        
        nftQuantifyValueLb.text = "\(data?.dispatch_cond?.min_num ?? 0) - \(data?.dispatch_cond?.max_num ?? 0)"
        miniPowerValueLb.text = "\(data?.dispatch_cond?.min_power ?? 0)"

    }
    

    let nftQuantifyValueLb = UILabel()
    let miniPowerValueLb = UILabel()
    let selectValueLb = UILabel()
    let selectPowerValueLb = UILabel()
    
    let extraLb = UILabel()
    
    lazy var topView: UIView = {
        let topView = UIView()
        
        let nftQuantifyLb = UILabel()
        nftQuantifyLb.text = "NFT Quantify needed"
        nftQuantifyLb.textColor = .ls_color("#999999")
        nftQuantifyLb.font = .ls_JostRomanRegularFont(12)
        
        topView.addSubview(nftQuantifyLb)
        nftQuantifyLb.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.centerX.equalToSuperview().multipliedBy(0.33)
            make.height.equalTo(12)
        }
        
        nftQuantifyValueLb.text = "0"
        nftQuantifyValueLb.textColor = .ls_color("#FEFEFE")
        nftQuantifyValueLb.font = .ls_JostRomanRegularFont(16)
        
        topView.addSubview(nftQuantifyValueLb)
        nftQuantifyValueLb.snp.makeConstraints { make in
            make.centerX.equalTo(nftQuantifyLb)
            make.top.equalTo(nftQuantifyLb.snp.bottom).offset(8)
        }
        
        let miniPowerLb = UILabel()
        miniPowerLb.text = "Minimum power"
        miniPowerLb.textColor = .ls_color("#999999")
        miniPowerLb.font = .ls_JostRomanRegularFont(12)
        
        topView.addSubview(miniPowerLb)
        miniPowerLb.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.centerX.equalToSuperview().multipliedBy(0.66)
            make.height.equalTo(12)
        }
        
        miniPowerValueLb.text = "0"
        miniPowerValueLb.textColor = .ls_color("#FEFEFE")
        miniPowerValueLb.font = .ls_JostRomanRegularFont(16)
        
        topView.addSubview(miniPowerValueLb)
        miniPowerValueLb.snp.makeConstraints { make in
            make.centerX.equalTo(miniPowerLb)
            make.top.equalTo(miniPowerLb.snp.bottom).offset(8)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .ls_color(r: 63, g: 63, b: 63)
        topView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(1)
        }
        
        let selectLb = UILabel()
        selectLb.text = "Selected NFT quantity"
        selectLb.textColor = .ls_color("#999999")
        selectLb.font = .ls_JostRomanRegularFont(12)
        
        topView.addSubview(selectLb)
        selectLb.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.centerX.equalToSuperview().multipliedBy(1.33)
            make.height.equalTo(12)
        }
        
        selectValueLb.text = "0"
        selectValueLb.textColor = .ls_color("#FEFEFE")
        selectValueLb.font = .ls_JostRomanRegularFont(16)
        
        topView.addSubview(selectValueLb)
        selectValueLb.snp.makeConstraints { make in
            make.centerX.equalTo(selectLb)
            make.top.equalTo(selectLb.snp.bottom).offset(8)
        }
        extraLb.text = "+0"
        extraLb.textColor = .ls_color("#46F490")
        extraLb.font = .ls_JostRomanRegularFont(16)
        topView.addSubview(extraLb)
        extraLb.snp.makeConstraints { make in
            make.left.equalTo(selectValueLb.snp.right).offset(4)
            make.centerY.equalTo(selectValueLb)
        }
        
        let extraTipLb = UILabel()
        extraTipLb.text = "Extra Hash"
        extraTipLb.textColor = .ls_color("#FEFEFE")
        extraTipLb.font = .ls_JostRomanRegularFont(16)
        topView.addSubview(extraTipLb)
        extraTipLb.snp.makeConstraints { make in
            make.left.equalTo(extraLb.snp.right).offset(4)
            make.centerY.equalTo(selectValueLb)
        }

        


        let selectPowerLb = UILabel()
        selectPowerLb.text = "Selected power"
        selectPowerLb.textColor = .ls_color("#999999")
        selectPowerLb.font = .ls_JostRomanRegularFont(12)
        
        topView.addSubview(selectPowerLb)
        selectPowerLb.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.centerX.equalToSuperview().multipliedBy(1.66)
            make.height.equalTo(12)
        }
        
        selectPowerValueLb.text = "0"
        selectPowerValueLb.textColor = .ls_color("#FEFEFE")
        selectPowerValueLb.font = .ls_JostRomanRegularFont(16)
        
        topView.addSubview(selectPowerValueLb)
        selectPowerValueLb.snp.makeConstraints { make in
            make.centerX.equalTo(selectPowerLb)
            make.top.equalTo(selectPowerLb.snp.bottom).offset(8)
        }
        
        
        
        
        
        return topView
    }()
    
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
        button.setTitle("Go Adventure".ls_localized, for: .normal)
        button.isEnabled = false
        return button
    }()

}

extension CS_DispatchChooseNFTsController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTLabNftCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTLabNftCell.self), for: indexPath) as! CS_NFTLabNftCell
        let model = dataSource[indexPath.row]
        let selectModel: CS_NFTDataModel? = selectList.first(where: {$0.id == dataSource[indexPath.row].id})
        cell.setData(model,selectedItem: selectModel)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        
        if selectList.contains(where: {$0.id == dataSource[indexPath.row].id}) {
            selectList.removeAll(where: {$0.id == dataSource[indexPath.row].id})
        } else {
            if selectList.count >= (data?.dispatch_cond?.max_num ?? 0) {
                return
            }
            selectList.append(dataSource[indexPath.row])
        }
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
extension CS_DispatchChooseNFTsController {
    func requestNFTList() {
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["status"] = "\(0)"
        para["quality"] = "\(quality)"
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
        }
    }
}


//MARK: action
extension CS_DispatchChooseNFTsController {
    @objc private func clickStakeButton(_ sender: UIButton) {
        
        guard selectList.count != 0 else { return }
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["team_id"] = "\(self.data?.id ?? 0)"
        para["nonce"] = nonce
        para["sign"] = sign
        
        let list = self.selectList.map({return $0.token_id})
        
        para["nfts"] = list
        
        LSHUD.showLoading()

        CSNetworkManager.shared.nftDispatch(para) { resp in
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
extension CS_DispatchChooseNFTsController {
    
    private func setupView() {
        
        topView.backgroundColor = .ls_color("#2B2B2B")
        topView.layer.cornerRadius = 15
        topView.layer.masksToBounds = true
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(50)
            make.top.equalTo(navigationView.snp.bottom).offset(5)
        }
        
        navigationView.titleLabel.text = "Choose NFTs".ls_localized
        emptyImageName = "icon_empty_nft@2x"
        emptyDescription = "crazy_str_empty_nfg_hint".ls_localized
        view.addSubview(collectionView)
        view.addSubview(stakeButton)
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(30))
            make.right.equalTo(-CS_ms(30))
            make.bottom.equalTo(0)
            make.top.equalTo(topView.snp.bottom).offset(10)
        }
        
        stakeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-CS_RH(10))
            make.width.equalTo(233)
            make.height.equalTo(40)
        }
    }
}
