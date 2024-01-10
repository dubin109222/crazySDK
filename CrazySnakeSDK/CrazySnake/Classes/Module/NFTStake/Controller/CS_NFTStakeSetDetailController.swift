//
//  CS_NFTStakeSetDetailController.swift
//  CrazySnake
//
//  Created by Lee on 27/03/2023.
//

import UIKit
import SwiftyAttributes

class CS_NFTStakeSetDetailController: CS_BaseAlertController {

    var detailModel: CS_NFTStakeNFTModel?
    var unstakeSuccess: CS_NoParasBlock?
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CS_NFTStakeCell.itemSizeSetItem()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.backgroundColor = .ls_dark_2()
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.register(CS_NFTStakeCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_NFTStakeCell.self))
        return view
    }()
    
    lazy var totlePowerView: CS_NFTStakeInfoItemView = {
        let view = CS_NFTStakeInfoItemView()
        view.titleLabel.text = "Staking Earnings"
        view.amountLabel.text = Utils.formatAmount(detailModel?.reward)
        view.amountLabel.textColor = .ls_color("#46F490")
        return view
    }()
    
    lazy var amountView: CS_NFTStakeInfoItemView = {
        let view = CS_NFTStakeInfoItemView()
        view.titleLabel.text = "Initial Hash power"
        view.amountLabel.text = "\(detailModel?.powerInit ?? 0)"
        return view
    }()
    
    lazy var myPowerView: CS_NFTStakeInfoItemView = {
        let view = CS_NFTStakeInfoItemView()
        view.titleLabel.text = "Set Hash Power Bonus"
        view.amountLabel.text = "\(detailModel?.powerBonus ?? 0)"
        view.amountLabel.textColor = .ls_color("#FFB37C")
        return view
    }()
    
    lazy var bonusView: CS_NFTStakeInfoItemView = {
        let view = CS_NFTStakeInfoItemView()
        view.titleLabel.text = "Total Hash Power"
        view.amountLabel.text = "\(detailModel?.power ?? 0)"
        view.amountLabel.textColor = .ls_color("#AC7CFF")
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        let time = Date.ls_intervalToDateStr(detailModel?.create ?? 0 ,format: "yyyy~MM~dd HH:mm:ss")
        label.attributedText = "Start time".attributedString + "  \(time)".withTextColor(.ls_white())
        return label
    }()
    
    lazy var claimButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 164, height: 40))
        button.addTarget(self, action: #selector(clickClaimButton(_:)), for: .touchUpInside)
        button.setTitle("Un stakes", for: .normal)
        return button
    }()
}

extension CS_NFTStakeSetDetailController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell: CS_NFTStakeCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTStakeCell.self), for: indexPath) as! CS_NFTStakeCell
        let model = detailModel?.nfts[indexPath.row]
        cell.setGroupItemData(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailModel?.nfts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK: action
extension CS_NFTStakeSetDetailController {
    @objc private func clickClaimButton(_ sender: UIButton) {
        guard let model = detailModel else { return }
        unstakeSet(model)
    }
}

//MARK: request
extension CS_NFTStakeSetDetailController {
    
    func unstakeSet(_ model: CS_NFTStakeNFTModel){
        
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["stakingid"] = model.id
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.nftUnstakeSet(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.unstakeSuccess?()
                weakSelf?.dismiss(animated: false)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}

extension CS_NFTStakeSetDetailController {
    func setupView(){
        titleLabel.text = "crazy_str_nft_sets".ls_localized
        contentView.backgroundColor = .ls_dark_3()
                
        contentView.addSubview(collectionView)
        contentView.addSubview(totlePowerView)
        contentView.addSubview(amountView)
        contentView.addSubview(myPowerView)
        contentView.addSubview(bonusView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(claimButton)
        
        contentView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(24))
            make.top.equalTo(29)
            make.right.equalTo(-CS_ms(24))
            make.bottom.equalTo(-30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(44)
            make.height.equalTo(152)
        }
        
        totlePowerView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView).multipliedBy(0.25)
            make.width.equalTo(contentView).multipliedBy(146/643.0)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView).offset(-68)
        }
        
        amountView.snp.makeConstraints { make in
            make.width.height.bottom.equalTo(totlePowerView)
            make.centerX.equalTo(contentView).multipliedBy(0.75)
        }
        
        myPowerView.snp.makeConstraints { make in
            make.width.height.bottom.equalTo(totlePowerView)
            make.centerX.equalTo(contentView).multipliedBy(1.25)
        }
        
        bonusView.snp.makeConstraints { make in
            make.width.height.bottom.equalTo(totlePowerView)
            make.centerX.equalTo(contentView).multipliedBy(1.75)
        }
        
        
        claimButton.snp.makeConstraints { make in
            make.top.equalTo(totlePowerView.snp.bottom).offset(17)
            make.right.equalTo(contentView).offset(-16)
            make.width.equalTo(164)
            make.height.equalTo(40)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(claimButton)
        }
        
    }
}
