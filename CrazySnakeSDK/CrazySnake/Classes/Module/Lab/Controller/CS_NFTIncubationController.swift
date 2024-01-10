//
//  CS_NFTIncubationController.swift
//  CrazySnake
//
//  Created by Lee on 02/03/2023.
//

import UIKit
import JXSegmentedView
import HandyJSON

class CS_NFTIncubationController: CS_BaseEmptyController {

    var propChangeAction: NFTPropBlock?
    
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var prop: CS_NFTPropModel?
    var incubateDetail: CS_NFTIncubaDetail?
    
    lazy var mockData: [CS_NFTDataModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTDataModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "lab.incubation") as? [CS_NFTDataModel] {
                return model
            }
        }
        return []
    }()
    
    lazy var propMockData: [CS_NFTPropModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTPropModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "lab.item_incubation") as? [CS_NFTPropModel] {
                return model
            }
        }
        return []
    }()


    var isMock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        GuideMaskManager.checkGuideState(.nft_incubation) { isFinish in
            self.isMock = !isFinish
            self.requestIncubationInfo()
            self.requestMyFeedsList()
            self.emptyStyle = .loading
            
            if self.isMock {
                self.guideStepOne()
            }
        }


    }
    

    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2(0.8)
        view.ls_cornerRadius(15)
        return view
    }()
    
    lazy var nftFatherView: CS_NFTIncubationSelectNFTView = {
        let view = CS_NFTIncubationSelectNFTView(frame: CGRect(x: 0, y: 0, width: 106, height: 120))
        view.backgroundColor = .ls_dark_3()
        view.ls_addCornerRadius(topLeft: 15, topRight: 10, bottomRight: 21, bottomLeft: 10)
        weak var weakSelf = self
        view.clickAddAction = {
            let vc = CS_NFTChooseNFTController()
            vc.isFemale = false
            weakSelf?.present(vc, animated: false)
            vc.chooseNFTAction = { model in
                weakSelf?.nftFatherView.setData(model)
            }
        }
        return view
    }()
    
    lazy var nftMotherView: CS_NFTIncubationSelectNFTView = {
        let view = CS_NFTIncubationSelectNFTView(frame: CGRect(x: 0, y: 0, width: 106, height: 120))
        view.backgroundColor = .ls_dark_3()
        view.ls_addCornerRadius(topLeft: 15, topRight: 10, bottomRight: 21, bottomLeft: 10)
        view.titleLabel.setImage(UIImage.ls_bundle( "nft_gender_female@2x"), for: .normal)
        weak var weakSelf = self
        view.clickAddAction = {
            let vc = CS_NFTChooseNFTController()
            vc.isFemale = true
            weakSelf?.present(vc, animated: false)
            vc.chooseNFTAction = { model in
                weakSelf?.nftMotherView.setData(model)
            }
        }
        return view
    }()
    
    lazy var incubatorView: CS_NFTIncubationSelectIncubatorView = {
        let view = CS_NFTIncubationSelectIncubatorView()
        weak var weakSelf = self
        view.clickAddAction = {
            weakSelf?.clickIncubator()
        }
        return view
    }()
    
    lazy var tipsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickTipsButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("icon_tips_black@2x"), for: .normal)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 369, height: 40))
        button.addTarget(self, action: #selector(clickConfirmAction(_:)), for: .touchUpInside)
        button.ls_cornerRadius(7)
        button.ls_addColorLayerPurpose()
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_incubator".ls_localized, for: .normal)
        return button
    }()

    lazy var detailView: CS_NFTIncubateDetailView = {
        let view = CS_NFTIncubateDetailView()
        view.isHidden = true
        weak var weakSelf = self
        view.propChangeAction = { model in
            weakSelf?.propChangeAction?(model)
        }
        view.withdrawSuccessBlock = { model in
            let alert = CS_NFTIncubateSuccessAlert()
            alert.setData(model)
            alert.show()
            alert.didDismissBlock = {
                weakSelf?.detailView.isHidden = true
                weakSelf?.tipsButton.isHidden = false
                weakSelf?.incubatorView.setData(nil)
                weakSelf?.nftFatherView.setData(nil)
                weakSelf?.nftMotherView.setData(nil)
                weakSelf?.requestMyFeedsList()
                
            }
            alert.clickMoreAction = {
                let vc = CSMyNFTController()
                weakSelf?.pushTo(vc)
            }
        }
        return view
    }()

}

extension CS_NFTIncubationController {
    func guideStepOne() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let mockItem = self.nftFatherView
            let maskRect = mockItem.convert(mockItem.bounds, to: nil)
            
            weak var weakSelf = self
            
            
            GuideMaskView.show (tipsText: "Click to select NFT.",
                                currentStep: "1",
                                totalStep: "6",
                                maskRect: maskRect,
                                textWidthDefault: 223,
                                direction: .left){
                weakSelf?.guideStepTwo()
                
            } skipHandle: {
                weakSelf?.guideStepEnd()
            }
        }

    }
    func guideStepTwo() {
        let mockItem = nftMotherView
        let maskRect = mockItem.convert(mockItem.bounds, to: nil)

        weak var weakSelf = self
        GuideMaskView.show (tipsText: "Click to select NFT.",
                            currentStep: "2",
                            totalStep: "6",
                            maskRect: maskRect,
                            textWidthDefault: 223,
                            direction: .right){
            weakSelf?.guideStepThree()

        } skipHandle: {
            weakSelf?.guideStepEnd()
        }

    }
    func guideStepThree() {
        let vc = CS_NFTChooseNFTController()
        vc.isMock = true
        self.present(vc, animated: false)
        weak var weakSelf = self
        vc.mockNext = { isSkip in
            if isSkip {
                weakSelf?.guideStepEnd()
            } else {
                weakSelf?.guideStepFour()
            }
        }
    }
    func guideStepFour() {
        weak var weakSelf = self

        self.nftFatherView.setData(self.mockData.first)
        self.nftMotherView.setData(self.mockData[1])
        
        let mockItem = self.incubatorView
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        
            let maskRect = mockItem.convert(mockItem.bounds, to: nil)

            GuideMaskView.show(tipsText: "Click to select an incubator.",
                                currentStep: "4",
                                totalStep: "6",
                                maskRect: maskRect,
                                textWidthDefault: 223,
                                direction: .up){
                weakSelf?.guideStepFive()

            } skipHandle: {
                weakSelf?.guideStepEnd()
            }

        }

    }
    func guideStepFive() {
        let vc = CS_NFTChooseIncubatorController()
        vc.isMock = true
        present(vc, animated: false)
        weak var weakSelf = self
        vc.mockNext = { isSkip in
            if isSkip {
                weakSelf?.guideStepEnd()
            } else {
                weakSelf?.guideStepSix()
            }
        }

    }
    func guideStepSix() {
        self.incubatorView.setData(self.propMockData.first)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            let mockItem = self.confirmButton
            let maskRect = mockItem.convert(mockItem.bounds, to: nil)
            
            weak var weakSelf = self
            GuideMaskView.show (tipsText: "Click the button to incubation.",
                                currentStep: "6",
                                totalStep: "6",
                                maskRect: maskRect,
                                textWidthDefault: 223,
                                direction: .down){
                weakSelf?.guideStepEnd()
                
            } skipHandle: {
                weakSelf?.guideStepEnd()
            }
        }

    }
    func guideStepEnd() {
        GuideMaskManager.saveGuideState(.nft_incubation)
        self.isMock = false
        self.nftFatherView.setData(nil)
        self.nftMotherView.setData(nil)
        self.incubatorView.setData(nil)
        self.updatePage()
    }
}

//MARK: action
extension CS_NFTIncubationController {
    @objc private func clickTipsButton(_ sender: UIButton) {
        CS_HelpCenterAlert.showNFTIncubation()
    }
    
    func clickIncubator() {
        guard let fatherModel = nftFatherView.selectedModel, let motherModel = nftMotherView.selectedModel else {
            LSHUD.showInfo("Please select NFT~")
            return
        }
        
        let quality = fatherModel.quality.rawValue > motherModel.quality.rawValue ? fatherModel.quality.rawValue : motherModel.quality.rawValue
        
        let vc = CS_NFTChooseIncubatorController()
        vc.quality = quality
        present(vc, animated: false)
        weak var weakSelf = self
        vc.chooseAction = { model in
            weakSelf?.incubatorView.setData(model)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        CS_NewFeatureAlert.showPage(.labIncubation)
    }
    
    @objc func clickConfirmAction(_ sender: UIButton) {
        guard let _ = nftFatherView.selectedModel else {
            LSHUD.showInfo("Please choose")
            return
        }
        guard let _ = incubatorView.selectedModel else {
            LSHUD.showInfo("Please choose")
            return
        }
        guard let _ = nftMotherView.selectedModel else {
            LSHUD.showInfo("Please choose")
            return
        }
        startIncubation()
    }
}

//Mark: request
extension CS_NFTIncubationController {
    
    private func startIncubation() {
        guard let address = walletAddress else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["nonce"] = nonce
        para["sign"] = sign
        para["token_id_1"] = nftFatherView.selectedModel?.token_id
        para["token_id_2"] = nftMotherView.selectedModel?.token_id
        para["item_id"] = incubatorView.selectedModel?.item_id
        LSHUD.showLoading()
        CSNetworkManager.shared.startIncubate(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.incubateDetail = resp.data
                weakSelf?.updatePage()
                NotificationCenter.default.post(name: NotificationName.CS_NFTInfoChange, object: nil)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    private func requestIncubationInfo() {
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        LSHUD.showLoading()
        CSNetworkManager.shared.getIncubateDetail(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                weakSelf?.incubateDetail = resp.data
                weakSelf?.updatePage()
            }
        }
    }
    
    func updatePage() {
        if incubateDetail == nil || incubateDetail?.status == 0 || isMock {
            detailView.isHidden = true
            tipsButton.isHidden = false
        } else {
            detailView.isHidden = false
            tipsButton.isHidden = true
            detailView.setIncubateData(incubateDetail)
        }
    }
    
    func requestMyFeedsList() {
        
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["sub_type"] = "\(7)"
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
            case .feedIncudate:
                prop = item
                detailView.setPropData(item)
                propChangeAction?(prop)
            default: break
            }
        }
    }
}

extension CS_NFTIncubationController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

extension CS_NFTIncubationController {
    func setupView(){
        navigationView.isHidden = true
        backView.image = UIImage.ls_bundleImageJpg(named: "bg_image_no_title")
        
        view.addSubview(contentView)
        contentView.addSubview(nftFatherView)
        contentView.addSubview(incubatorView)
        contentView.addSubview(nftMotherView)
        contentView.addSubview(confirmButton)
        view.addSubview(tipsButton)
        view.addSubview(detailView)
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(32)
            make.width.equalTo(424)
            make.height.equalTo(215)
        }
        
        nftFatherView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(14)
            make.left.equalTo(contentView).offset(22)
            make.width.equalTo(106)
            make.height.equalTo(120)
        }
        
        incubatorView.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(nftFatherView)
            make.width.height.equalTo(nftFatherView)
        }
        
        nftMotherView.snp.makeConstraints { make in
            make.top.width.height.equalTo(nftFatherView)
            make.right.equalTo(contentView).offset(-22)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-18)
            make.width.equalTo(369)
            make.height.equalTo(40)
        }
        
        detailView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        tipsButton.snp.makeConstraints { make in
            make.top.equalTo(26)
            make.right.equalTo(-CS_ms(23))
        }
        view.setNeedsLayout()
    }
}
