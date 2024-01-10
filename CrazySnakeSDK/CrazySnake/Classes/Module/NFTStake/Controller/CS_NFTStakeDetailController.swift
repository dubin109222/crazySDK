//
//  CS_NFTStakeDetailController.swift
//  CrazySnake
//
//  Created by Lee on 16/03/2023.
//

import UIKit

class CS_NFTStakeDetailController: CS_BaseAlertController {
    
    var detailModel: CS_NFTStakeNFTModel?
    var unstakeSuccess: CS_NoParasBlock?
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    lazy var detailView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 274, height: 186))
        view.backgroundColor = .ls_dark_5()
        view.ls_addCorner([.bottomLeft,.bottomRight], cornerRadius: 10)
        return view
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "#\(detailModel?.nfts.first?.id ?? "")"
        return label
    }()
    
    lazy var coverView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 106, height: 119))
        view.contentMode = .scaleToFill
        if let model = detailModel {
            let url = URL.init(string: model.image)
            view.kf.setImage(with: url , placeholder: UIImage.ls_placeHolder(), options: nil , completionHandler: nil)
        }
        return view
    }()
    
    lazy var unstakeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickUnstakeButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("nft_icon_stake_unstake@2x"), for: .normal)
        return button
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(12))
        label.text = "Start time"
        return label
    }()
    
    lazy var timeDayLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.text = Date.ls_intervalToDateStr(detailModel?.create ?? 0 ,format: "yyyy~MM~dd")
        return label
    }()
    
    lazy var timeHourLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.text = Date.ls_intervalToDateStr(detailModel?.create ?? 0 ,format: "HH:mm:ss")
        return label
    }()
    
    lazy var powerLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(12))
        label.text = "Total Hash Power"
        return label
    }()
    
    lazy var powerAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#AC7CFF"), .ls_JostRomanFont(16))
        label.text = "\(detailModel?.power ?? 0)"
        return label
    }()
    
    lazy var earningsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(12))
        label.text = "Staking Earnings"
        return label
    }()
    
    lazy var earningsAmountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#46F490"), .ls_JostRomanFont(16))
        label.text = Utils.formatAmount(detailModel?.reward)
        return label
    }()


}

//MARK: action
extension CS_NFTStakeDetailController {
    @objc private func clickUnstakeButton(_ sender: UIButton) {
        guard let model = detailModel else { return }
        if model.group {
            unstakeSet(model)
        } else {
            unstakeSingle(model)
        }
    }
}

//MARK: request
extension CS_NFTStakeDetailController {
    func unstakeSingle(_ model: CS_NFTStakeNFTModel){
        
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
        CSNetworkManager.shared.nftSingleUnstake(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.unstakeSuccess?()
                weakSelf?.dismiss(animated: false)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
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


//MARK: UI
extension CS_NFTStakeDetailController {
    
    private func setupView() {
        titleLabel.text = detailModel?.group == true ? "Set NFT" : "crazy_str_nft_stake_single_nft".ls_localized
        contentView.backgroundColor = .ls_dark_2()
        contentView.layer.shadowRadius = 0
        contentView.ls_border(color: .ls_text_gray(0.4),width: 1)
        
        contentView.addSubview(detailView)
        detailView.addSubview(idLabel)
        detailView.addSubview(coverView)
        detailView.addSubview(unstakeButton)
        detailView.addSubview(timeLabel)
        detailView.addSubview(timeDayLabel)
        detailView.addSubview(timeHourLabel)
        detailView.addSubview(powerLabel)
        detailView.addSubview(powerAmountLabel)
        detailView.addSubview(earningsLabel)
        detailView.addSubview(earningsAmountLabel)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(274)
            make.height.equalTo(230)
        }
        
        detailView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(44)
        }
        
        coverView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(27)
            make.bottom.equalTo(contentView).offset(-38)
            make.width.equalTo(106)
            make.height.equalTo(119)
        }
        
        idLabel.snp.makeConstraints { make in
            make.centerX.equalTo(coverView)
            make.bottom.equalTo(coverView.snp.top).offset(-9)
        }
        
        unstakeButton.snp.makeConstraints { make in
            make.right.equalTo(coverView).offset(18)
            make.top.equalTo(coverView).offset(-18)
            make.width.height.equalTo(44)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(coverView.snp.right).offset(26)
            make.top.equalTo(detailView).offset(14)
        }
        
        timeDayLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel)
            make.top.equalTo(detailView).offset(33)
        }
        
        timeHourLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel)
            make.top.equalTo(detailView).offset(46)
        }
        
        powerLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel)
            make.top.equalTo(detailView).offset(75)
        }
        
        powerAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel)
            make.top.equalTo(detailView).offset(95)
        }
        
        earningsLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel)
            make.top.equalTo(detailView).offset(127)
        }
        
        earningsAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel)
            make.top.equalTo(detailView).offset(149)
        }
    }
}
