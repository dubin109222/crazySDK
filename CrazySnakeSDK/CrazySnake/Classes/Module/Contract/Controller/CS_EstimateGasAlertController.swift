//
//  CS_EstimateGasAlertController.swift
//  CrazySnake
//
//  Created by Lee on 24/05/2023.
//

import UIKit

class CS_EstimateGasAlertController: CS_BaseAlertController {
    
    var clickConfirmAction: CS_NoParasBlock?

    var showTitle = ""
    var gasPrice: CS_EstimateGasPriceModel?
    var contractAddress: String?
    var para: [String:Any]?
    var showGasCoinInsufficientAlert = true
    var showGwei = true

    lazy var helpBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(.ls_bundle("_gwei_help@2x"), for: .normal)
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickHelpBtn)))
        return btn
    }()
    
    @objc func clickHelpBtn() {
        let maskView = UIView()
        self.view.addSubview(maskView)
        maskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickRemoveMaskView)))
        
        let bgView = UIView()
        bgView.backgroundColor = .ls_color("#232335")
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        bgView.addGestureRecognizer(UITapGestureRecognizer())
        maskView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 304, height: 150))
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(100)
        }
        
        let label = UILabel()
        label.text = "Current Gwei Index: "
        label.font = .ls_JostRomanFont(12)
        label.textColor = .ls_color("#999999")
        label.numberOfLines = 0
        bgView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.equalTo(20)
        }
        
        let gweiValueLb = UILabel()
        gweiValueLb.font = .ls_JostRomanFont(16)
        gweiValueLb.text = "\(gasPrice?.current_gwei ?? 0)"
        switch gasPrice?.current_gwei ?? 0 {
        case 0...100 :
            gweiValueLb.textColor = .ls_color("#9BFF87")
        case 100...300 :
            gweiValueLb.textColor = .ls_color("#FFE187")
        default :
            gweiValueLb.textColor = .ls_color("#FF8787")
        }
        bgView.addSubview(gweiValueLb)
        gweiValueLb.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(10)
            make.right.lessThanOrEqualTo(-20)
            make.centerY.equalTo(label)
        }

        // tips
        let tips1 = CS_GweiGasAlertController.createTipsLb(imgName: "_gwei_low_icon@2x", tips: "Low transaction costs < ", value: "100", valueColor: "#9BFF87")
        let tips2 = CS_GweiGasAlertController.createTipsLb(imgName: "_gwei_medium_icon@2x", tips: "Medium cost transactions < ", value: "300", valueColor: "#FFE187")
        let tips3 = CS_GweiGasAlertController.createTipsLb(imgName: "_gwei_high_icon@2x", tips: "High cost transactions > ", value: "300", valueColor: "#FF8787")
        
        bgView.addSubview(tips1)
        bgView.addSubview(tips2)
        bgView.addSubview(tips3)

        tips1.snp.makeConstraints { make in
            make.top.equalTo(gweiValueLb.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        tips2.snp.makeConstraints { make in
            make.top.equalTo(tips1.snp.bottom).offset(10)
            make.left.right.equalTo(tips1)
        }
        tips3.snp.makeConstraints { make in
            make.top.equalTo(tips2.snp.bottom).offset(10)
            make.left.right.equalTo(tips1)
        }


    }
    
    @objc func clickRemoveMaskView(ges : UILongPressGestureRecognizer) {
        ges.view?.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setData()
    }
    
    func setData() {
        if let address = contractAddress {
            contractView.isHidden = false
            contractView.infoLabel.text = contractAddress
        } else {
            contractView.isHidden = true
        }
        // 暂时隐藏
//        if (gasPrice?.current_gwei ?? 0) > 300 {
//            helpBtn.isHidden = false
//        } else {
//            helpBtn.isHidden = true
//        }
        remainCoinView.infoLabel.text = Utils.formatAmount(gasPrice?.balance ?? "0", digits: 2)
        maxCoinView.infoLabel.text = gasPrice?.gas
    }
    
    lazy var gasContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#342B5D",alpha: 0.2)
        return view
    }()
    
    lazy var gasIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("contract_icon_gas@2x")
        return view
    }()
    
    lazy var gasLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(14))
        label.text = "crazy_str_estimated_fuel_cost".ls_localized
        return label
    }()
    
    lazy var maxCoinView: CS_ContractGasInfoView = {
        let view = CS_ContractGasInfoView()
        view.titleLabel.text = "crazy_str_max_coins_needed".ls_localized
//        view.infoLabel.text = gasPrice
        return view
    }()
    
    lazy var remainCoinView: CS_ContractGasInfoView = {
        let view = CS_ContractGasInfoView()
        view.titleLabel.text = "crazy_str_remaining".ls_localized
        return view
    }()
    
    lazy var contractView: CS_ContractGasInfoView = {
        let view = CS_ContractGasInfoView()
        view.titleLabel.textColor = .ls_white()
        view.titleLabel.font = .ls_JostRomanFont(14)
        view.titleLabel.text = "crazy_str_contract_address".ls_localized
        view.infoLabel.textColor = .ls_text_gray()
        view.infoLabel.font = .ls_JostRomanFont(12)
        view.infoLabel.numberOfLines = 0
        return view
    }()
    
    lazy var rejectButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 140, height: 40))
        button.ls_cornerRadius(7)
        button.ls_addColorLayer(.ls_color("#E3803E"), .ls_color("#E3803E"))
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.addTarget(self, action: #selector(clickRejectButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_refresh".ls_localized, for: .normal)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 140, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_confirm".ls_localized, for: .normal)
        return button
    }()
    
    func requestEstimateGas(){
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                if let gas = resp.data {
                    weakSelf?.gasPrice = gas
                    weakSelf?.setData()
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func requestGas() {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.nftStakeClaimGasPrice(address) { resp in
            LSHUD.hide()
            if resp.status == .success {
                if let gas = resp.data {
                    weakSelf?.gasPrice = gas
                    weakSelf?.setData()
                }
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }

}

//MARK: action
extension CS_EstimateGasAlertController {
    @objc private func clickRejectButton(_ sender: UIButton) {
        if let _ = para {
            requestEstimateGas()
        } else {
            requestGas()
        }
    }
    
    @objc private func clickConfirmButton(_ sender: UIButton) {
        dismiss(animated: false)
        
        if self.showTitle != "Approve" && showGasCoinInsufficientAlert {
            
            guard Double(gasPrice?.balance ?? "0") ?? 0 > Double(gasPrice?.gas ?? "0") ?? 0 else {
                dismiss(animated: false)
                let alert = CS_GasCoinInsufficientAlert()
                alert.show()
                return
            }
        }
        
        clickConfirmAction?()
    }
}

//MARK: UI
extension CS_EstimateGasAlertController {
    
    private func setupView() {
        titleLabel.text = showTitle
        contentView.backgroundColor = .ls_color("#201D27")
        contentView.addSubview(gasContentView)
        gasContentView.addSubview(gasIcon)
        gasContentView.addSubview(gasLabel)
        gasContentView.addSubview(maxCoinView)
        gasContentView.addSubview(remainCoinView)
        contentView.addSubview(contractView)
        contentView.addSubview(rejectButton)
        contentView.addSubview(confirmButton)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(334)
            make.height.equalTo(336)
        }
        
        gasContentView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView)
            make.top.equalTo(80)
            make.height.equalTo(120)
        }
        
        gasIcon.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(10)
            make.width.height.equalTo(12)
        }
        
        gasLabel.snp.makeConstraints { make in
            make.centerY.equalTo(gasIcon)
            make.left.equalTo(38)
        }
        
        maxCoinView.snp.makeConstraints { make in
            make.left.equalTo(gasIcon)
            make.top.equalTo(40)
            make.height.equalTo(40)
            make.width.equalTo(130)
        }
        
        remainCoinView.snp.makeConstraints { make in
            make.top.width.height.equalTo(maxCoinView)
            make.left.equalTo(gasContentView.snp.centerX).offset(20)
        }
        
        maxCoinView.addSubview(helpBtn)
        helpBtn.isHidden = true
        helpBtn.snp.makeConstraints { make in
            make.left.equalTo(maxCoinView.infoLabel.snp.right).offset(15)
            make.centerY.equalTo(maxCoinView.infoLabel)
            make.size.equalTo(30)
        }
        
        contractView.snp.makeConstraints { make in
            make.left.equalTo(gasIcon)
            make.right.equalTo(-20)
            make.top.equalTo(gasContentView.snp.bottom).offset(12)
            make.height.equalTo(60)
        }
        
        rejectButton.snp.makeConstraints { make in
            make.left.equalTo(gasIcon)
            make.bottom.equalTo(-12)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.width.height.equalTo(rejectButton)
            make.right.equalTo(contractView)
        }
        
        
        // gwei view
        if gasPrice?.is_gwei_high == true && self.showGwei{
            // 添加一层弹窗
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let vc = CS_GweiGasAlertController()
                vc.showTitle = "Gwei index too high".ls_localized
                vc.current_gwei = self.gasPrice?.current_gwei ?? 0
                self.present(vc, animated: true)
            }
        }
    }
}
