//
//  CS_StakeUnlockSoltController.swift
//  CrazySnake
//
//  Created by Lee on 27/03/2023.
//

import UIKit
import SwiftyAttributes

class CS_StakeUnlockSoltController: CS_BaseAlertController {
    
    var unlockSuccess: CS_NoParasBlock?
    var stakeInfo:CS_NFTStakeInfoModel?
    private var cardInfo: CS_NFTPropModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        requestMyFeedsList()
    }
    
    lazy var soltIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("200304@2x")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.attributedText = "Unlock solt with Solt card ".attributedString + "x\(stakeInfo?.nextSlotCostCards ?? 0)".withTextColor(.ls_green()) + " ?".attributedString
        return label
    }()

    lazy var claimButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 164, height: 40))
        button.addTarget(self, action: #selector(clickClaimButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_confirm".ls_localized, for: .normal)
        return button
    }()

    lazy var balanceIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("200304@2x")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .right
        label.text = "Balance:"
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#AC7CFF"), .ls_JostRomanFont(16))
        return label
    }()
}

//MARK: action
extension CS_StakeUnlockSoltController {
    @objc private func clickClaimButton(_ sender: UIButton) {
        guard let model = stakeInfo else { return }
        guard model.nextSlotCostCards <= cardInfo?.num ?? 0 else {
            LSHUD.showInfo("Solt card not enough")
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["use_num"] = "\(model.nextSlotCostCards)"
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.nftStakeUseSoltCards(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.unlockSuccess?()
                weakSelf?.dismiss(animated: false)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}

//MARK: request
extension CS_StakeUnlockSoltController {
    func requestMyFeedsList() {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sub_type"] = "\(6)"
        CSNetworkManager.shared.getMybackpackList(para) { resp in
            if resp.status == .success {
                if let list = resp.data?.list {
                    weakSelf?.handleFeedsData(list)
                }
            }
        }
    }
    
    func handleFeedsData(_ list: [CS_NFTPropModel]) {
        for item in list {
            switch item.props_type {
            case .cardSlot:
                cardInfo = item
                amountLabel.text = "\(cardInfo?.num ?? 0)"
            default: break
            }
        }
    }
}


extension CS_StakeUnlockSoltController {
    func setupView(){
        titleLabel.text = ""
        contentView.backgroundColor = .ls_dark_3()
        
        view.addSubview(soltIcon)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(claimButton)
        view.addSubview(balanceLabel)
        view.addSubview(balanceIcon)
        view.addSubview(amountLabel)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
        
        soltIcon.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView.snp.top)
            make.width.equalTo(128)
            make.height.equalTo(256)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
        
        claimButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(-16)
            make.width.equalTo(164)
            make.height.equalTo(40)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(40)
            make.right.equalTo(contentView.snp.centerX)
        }
        
        balanceIcon.snp.makeConstraints { make in
            make.left.equalTo(balanceLabel.snp.right).offset(4)
            make.centerY.equalTo(balanceLabel)
            make.width.equalTo(16)
            make.height.equalTo(24)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(balanceIcon.snp.right).offset(4)
            make.centerY.equalTo(balanceLabel)
        }
    }
}
