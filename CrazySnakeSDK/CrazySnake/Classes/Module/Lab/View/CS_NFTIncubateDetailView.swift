//
//  CS_NFTIncubateDetailView.swift
//  CrazySnake
//
//  Created by Lee on 09/03/2023.
//

import UIKit
import SwiftyAttributes

class CS_NFTIncubateDetailView: UIView {
    
    var propChangeAction: NFTPropBlock?
    var withdrawSuccessBlock: NFTDataBlock?
    
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    var detailModel: CS_NFTIncubaDetail?
    var propModel: CS_NFTPropModel?
    var leftTime = 0
    var countDownTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIncubateData(_ model: CS_NFTIncubaDetail?) {
        detailModel = model
        guard let model = model else { return }
        
        if model.status == 1 {
            setDataIncubating(model)
        } else if model.status == 3 {
            setDataIncubateEnd(model)
        }
    }
    
    func setDataIncubateEnd(_ model: CS_NFTIncubaDetail){
        endTitleLabel.isHidden = false
        endTimeLabel.isHidden = false
        openButton.isHidden = false
        progressView.isHidden = true
        timeLabel.isHidden = true
        timeTipsLabel.isHidden = true
        amountInputView.isHidden = true
        speedUpButton.isHidden = true
        
        timeIcon.image = UIImage.ls_bundle("nft_icon_incubate_complete@2x")
        titleLabel.text = "crazy_str_nft_incubation_completed".ls_localized
        infoLabel.text = "crazy_str_congratulations_successful_incubation__".ls_localized
        
        let totle = Int(model.end_time - model.start_time - model.speedup)
        let time = timeFormat(totle)
        endTimeLabel.attributedText = "crazy_str_nft_incubation_time_spent".ls_localized.attributedString + "    \(time)".withAttributes([.font(.ls_JostRomanFont(16)),.textColor(.ls_color("#46F490"))])
    }
    
    func setDataIncubating(_ model: CS_NFTIncubaDetail){
        endTitleLabel.isHidden = true
        endTimeLabel.isHidden = true
        openButton.isHidden = true
        progressView.isHidden = false
        timeLabel.isHidden = false
        timeTipsLabel.isHidden = false
        amountInputView.isHidden = false
        speedUpButton.isHidden = false
        
        setPropData(propModel)
        progressView.setData(model)
        let need = model.end_time - Date().timeIntervalSince1970 - model.speedup
        leftTime = Int(need)
        
        timeLabel.text = timeFormat(leftTime)
        startCountDown()
    }
    
    func startCountDown(){
        guard countDownTimer == nil else { return }
        weak var weakSelf = self
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if weakSelf?.leftTime == 0 {
                timer.invalidate()
                weakSelf?.detailModel?.status = 3
                weakSelf?.setIncubateData(weakSelf?.detailModel)
            } else {
                weakSelf?.leftTime -= 1
                weakSelf?.timeLabel.text = weakSelf?.timeFormat(weakSelf?.leftTime ?? 0)
            }
        })
    }
    
    func timeFormat(_ need: Int) -> String{
        guard need > 0 else {
            return "unkown"
        }
        let hourSecond = 60*60
        let minuteSecond = 60
        let hour = need/hourSecond
        let hourLeft = need%hourSecond
        let minute = hourLeft/minuteSecond
        let second = hourLeft%minuteSecond
        
        if hour > 0 {
            return "\(hour)H:\(minute)M:\(second)S"
        } else if minute > 0 {
            return "\(minute)M:\(second)S"
        } else {
            return "\(second)S"
        }
    }
    
    func setPropData(_ feed: CS_NFTPropModel?) {
        propModel = feed
        guard let feed = feed else { return }
        guard let model = detailModel else { return }
        let need = model.end_time - Date().timeIntervalSince1970 - model.speedup
        let needHour =  maxHour(Int(need))
        let max = needHour > feed.num ? feed.num : needHour
        amountInputView.resetData(max: max, current: 0)
    }
    
    func maxHour(_ need: Int) -> Int{
        guard need > 0 else {
            return 0
        }
        let hourSecond = 60*60
        let minuteSecond = 60
        let hour = need/hourSecond
        
        return hour+1
    }
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var leftBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2()
        return view
    }()
    
    lazy var nftIconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_icon_incubate_nft@2x")
        return view
    }()
    
    lazy var timeIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_icon_incubating_time@2x")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.text = "crazy_str_incubating__".ls_localized
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.numberOfLines = 2
        label.text = "crazy_str_when_incubating_crazy".ls_localized
        return label
    }()

    lazy var incubatingView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var progressView: CS_NFTIncubateProgressView = {
        let view = CS_NFTIncubateProgressView()
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#46F490"), .ls_JostRomanFont(16))
        label.textAlignment = .right
//        label.text = "07H : 22M : 23S"
        return label
    }()
    
    lazy var timeTipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .right
        label.attributedText = "1 Hourglass = ".attributedString + "-1".withTextColor(.ls_color("#EE7E3B")) + " Hour".attributedString
        return label
    }()
    
    lazy var amountInputView: CS_AmountInputView = {
        let view = CS_AmountInputView()
        weak var weakSelf = self
        view.amountChange = { amount in
            let totle = amount*(weakSelf?.propModel?.extend_params?.value ?? 0)
            weakSelf?.progressView.updateExperience(totle)
        }
        return view
    }()
    
    lazy var speedUpButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 144, height: 40))
        button.addTarget(self, action: #selector(clickConfirmAction(_:)), for: .touchUpInside)
        button.ls_cornerRadius(7)
        button.ls_addColorLayerPurpose()
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_speed_up".ls_localized, for: .normal)
        return button
    }()
    
    lazy var endTitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_nft_incubation_end_time".ls_localized
        return label
    }()
    
    lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_nft_incubation_time_spent".ls_localized
        
        return label
    }()
    
    lazy var openButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 369*CS_kRate, height: 40))
        button.addTarget(self, action: #selector(clickOpenButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_nft_open".ls_localized, for: .normal)
        return button
    }()
}

//MARK: action
extension CS_NFTIncubateDetailView {
    @objc func clickConfirmAction(_ sender: UIButton) {
        guard amountInputView.currentNum > 0 else {
            LSHUD.showInfo("Please input speed up number.")
            return
        }
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["id"] = detailModel?.id
        para["speed_num"] = amountInputView.currentNum
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.incubateSpeedUp(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.handleSpeedUpData(resp.data)
            }
        }
    }
    
    func handleSpeedUpData(_ model: CS_NFTIncubaDetail?) {
        
        propModel?.num -= amountInputView.currentNum
        
        propChangeAction?(propModel)
        
        detailModel = model
        setIncubateData(model)
        setPropData(propModel)
    }
    
    @objc private func clickOpenButton(_ sender: UIButton) {
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["id"] = detailModel?.id
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.incubateWithdraw(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.withdrawSuccessBlock?(resp.data)
            } else {
                LSHUD.showError(resp.message)
            }
        }
        
    }
}


//MARK: UI
extension CS_NFTIncubateDetailView {
    
    private func setupView() {
        addSubview(backView)
        backView.addSubview(leftBackView)
        addSubview(nftIconView)
        addSubview(timeIcon)
        addSubview(titleLabel)
        addSubview(infoLabel)
        addSubview(progressView)
        addSubview(timeLabel)
        addSubview(timeTipsLabel)
        addSubview(amountInputView)
        addSubview(speedUpButton)
        addSubview(endTitleLabel)
        addSubview(endTimeLabel)
        addSubview(openButton)
        
        backView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(55))
            make.right.equalTo(-CS_ms(25,padding: 80))
            make.top.equalTo(20)
            make.bottom.equalTo(-35)
        }
        
        leftBackView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(backView)
            make.width.equalTo(176*CS_kRate)
        }
        
        nftIconView.snp.makeConstraints { make in
            make.centerX.equalTo(leftBackView)
            make.centerY.equalTo(leftBackView)
            make.width.equalTo(142)
            make.height.equalTo(177)
        }
        
        timeIcon.snp.makeConstraints { make in
            make.left.equalTo(leftBackView.snp.right).offset(26)
            make.top.equalTo(backView).offset(18)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(timeIcon.snp.right).offset(11)
            make.centerY.equalTo(timeIcon)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(timeIcon)
            make.top.equalTo(timeIcon.snp.bottom).offset(7)
            make.right.equalTo(backView).offset(-CS_ms(26))
        }
        
        amountInputView.snp.makeConstraints { make in
            make.left.right.equalTo(progressView)
            make.bottom.equalTo(backView).offset(-40)
            make.height.equalTo(40)
        }
        
        speedUpButton.snp.makeConstraints { make in
            make.right.equalTo(timeLabel)
            make.centerY.equalTo(amountInputView)
            make.width.equalTo(144)
            make.height.equalTo(40)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.equalTo(timeIcon)
            make.bottom.equalTo(amountInputView.snp.top).offset(-30*CS_kRate)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.right.equalTo(backView).offset(-CS_ms(20))
            make.top.equalTo(progressView)
        }
        
        timeTipsLabel.snp.makeConstraints { make in
            make.right.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
        }
        
        openButton.snp.makeConstraints { make in
            make.centerX.equalTo(infoLabel)
            make.bottom.equalTo(backView).offset(-20)
            make.width.equalTo(CS_ms(369,padding: 40))
            make.height.equalTo(40)
        }
        
        endTimeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(openButton)
            make.bottom.equalTo(openButton.snp.top).offset(-22)
        }
        
        endTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(openButton)
            make.bottom.equalTo(openButton.snp.top).offset(-52)
        }
    }
}
