//
//  CS_MarketNFTSetDetailController.swift
//  CrazySnake
//
//  Created by Lee on 15/06/2023.
//

import UIKit

class CS_MarketNFTSetDetailController: CS_BaseEmptyController {
    
    var model: CS_MarketModel?
    /// 0: 自己-上架；1:自己-取消上架；2:他人-购买
    var actionStatus = 2
    
    let account = CS_AccountManager.shared.accountInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setData()
    }
    
    func setData() {
        guard let model = model else { return }
        
        if model.isSelf() {
            if model.status == 1 {
                actionStatus = 1
                priceView.isHidden = false
                priceView.priceLabel.text = "\(model.price)"
                confirmButton.setBackgroundImage(nil, for: .normal)
                confirmButton.backgroundColor = .ls_color("#E16A56")
                confirmButton.setTitle("crazy_str_sell_remove_offer".ls_localized, for: .normal)
            }
        } else {
            actionStatus = 2
            priceView.isHidden = false
            priceView.priceLabel.text = "\(model.price)"
            confirmButton.setTitle("crazy_str_buy".ls_localized, for: .normal)
        }
        var power = 0
        for item in model.nftSetsDetail {
            power += item.total_power
        }
        powerLabel.text = "\(power)"
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = ProfileNFTCollectionCell.itemSize()
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: CS_kScreenW-2*CS_ms(24), height: 1000), collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(ProfileNFTCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(ProfileNFTCollectionCell.self))
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var powerView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(6)
        view.ls_border(color: .ls_color("#7E56E1"))
        view.backgroundColor = .ls_color("#322E3D",alpha: 0.6)
        return view
    }()
    
    lazy var powerTitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#EEEEEE"), .ls_font(11))
        label.textAlignment = .center
        label.text = "crazy_str_total_hash_power".ls_localized
        return label
    }()
    
    lazy var powerLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_boldFont(16))
        label.textAlignment = .center
        return label
    }()
    
    lazy var priceView: CS_MarketNFTPriceView = {
        let view = CS_MarketNFTPriceView()
        view.isHidden = true
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 233, height: 40))
        button.setTitle("crazy_str_place_offer".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        return button
    }()
}

//MARK: action
extension CS_MarketNFTSetDetailController {
    
    @objc private func clickConfirmButton(_ sender: UIButton) {
        switch actionStatus {
        case 1:
            removeOffer()
        case 2:
            requestBuyGasPrice()
        default:
            break
        }
    }
    
    func removeOffer(){
        guard let address = account?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: account?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sku_id"] = model?.sku_id
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.marketStopSell(para) { resp in
            LSHUD.hide()
            if resp.status == .success, resp.data?.success == 1 {
                NotificationCenter.default.post(name: NotificationName.CS_MarketRemoveOffer, object: weakSelf?.model)
                weakSelf?.pop()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    
    func requestBuyGasPrice() {
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        let para = CS_ContractTransfer.getEstimateMarketBuyPara(to: address, amount: "10",notSnake: true)
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "crazy_str_buy".ls_localized
                vc.gasPrice = resp.data
                vc.para = para
                vc.showGasCoinInsufficientAlert = false
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    CS_AccountManager.shared.accountInfo?.verifyPassword { password in
                        self.buy(password ?? "")
                    }
                }
            }
        }
    }
    
    func buy(_ pay_password: String){
        guard Double(CS_MarketManager.shared.diamondBalance) ?? 0 > Double(model?.price ?? "0") ?? 0 else {
            LSHUD.showError("Insufficient balance".ls_localized)
            return
        }
        guard let address = account?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: account?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sku_id"] = model?.sku_id
        para["num"] = "1"
        para["pay_password"] = pay_password
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.marketBuy(para) { resp in
            LSHUD.hide()
            if resp.status == .success, resp.data?.success == 1 {
                NotificationCenter.default.post(name: NotificationName.CS_MarketBuyItem, object: weakSelf?.model)
                weakSelf?.pop()
                LSHUD.showSuccess("ok")
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
}

extension CS_MarketNFTSetDetailController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProfileNFTCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ProfileNFTCollectionCell.self), for: indexPath) as! ProfileNFTCollectionCell
        let model = model?.nftSetsDetail[indexPath.row]
        cell.setData(model)
        cell.newIcon.isHidden = true
        cell.statusButton.isHidden = true
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.nftSetsDetail.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = model?.nftSetsDetail[indexPath.row]
        let vc = CS_NFTNFTDetailController()
        vc.model = model
        present(vc, animated: false)
    }

}

//MARK: contract
extension CS_MarketNFTSetDetailController {
    func estimateGasApprove(){
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_address else {
            return
        }
        let para = CS_ContractNFT.estimateApprovePara(to: contract)
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "crazy_str_buy".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.pop()
                vc.clickConfirmAction = {
//                    weakSelf?.buy()
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
}



//MARK: UI
extension CS_MarketNFTSetDetailController {
    
    private func setupView() {
        navigationView.backView.image = nil
        navigationView.backView.backgroundColor = .clear
        navigationView.titleLabel.text = "crazy_str_check_details".ls_localized
        backView.image = UIImage.ls_bundle("market_bg_page@2x")
        view.addSubview(collectionView)
        view.addSubview(powerView)
        powerView.addSubview(powerTitleLabel)
        powerView.addSubview(powerLabel)
        view.addSubview(priceView)
        view.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(-20)
            make.right.equalTo(-CS_ms(24))
            make.width.equalTo(233)
            make.height.equalTo(40)
        }
        
        priceView.snp.makeConstraints { make in
            make.right.equalTo(confirmButton.snp.left).offset(-24)
            make.centerY.equalTo(confirmButton)
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
        
        powerView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(24))
            make.bottom.equalTo(0)
            make.height.equalTo(70)
            make.width.equalTo(120)
        }
        
        powerTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(12)
        }
        
        powerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(20)
            make.bottom.equalTo(confirmButton.snp.top).offset(-12)
            make.left.equalTo(CS_ms(24))
            make.right.equalTo(-CS_ms(24))
        }
    }
}
