//
//  CS_StakeController.swift
//  CrazySnake
//
//  Created by Lee on 17/03/2023.
//

import UIKit
import JXSegmentedView

class CS_StakeController: CS_BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        registerNotication()
        updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        CS_NewFeatureAlert.showPage(.stakeToken)
    }
    
    func updateData(){
        
        navAmountView.iconView.image = TokenName.Snake.icon()
        navAmountView.amountLabel.text = Utils.formatAmount(TokenName.Snake.balance())
        navAmountView1.iconView.image = TokenName.GasCoin.icon()
        navAmountView1.amountLabel.text = Utils.formatAmount(TokenName.GasCoin.balance(),digits: 2)
    }

    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
        segment.titles = ["crazy_str_token_stake".ls_localized, "crazy_str_my_token_stake".ls_localized]
        segment.isItemSpacingAverageEnabled = false
        segment.itemWidth = 100
        segment.isTitleColorGradientEnabled = true
        segment.titleNormalColor = .ls_text_gray()
        segment.titleNormalFont = .ls_JostRomanFont(12)
        segment.titleSelectedColor = .ls_purpose_01()
        segment.titleSelectedFont = .ls_JostRomanFont(16)
        return segment
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.delegate = self
        view.dataSource = segmentedDataSource
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        indicator.indicatorColor = .ls_purpose_01()
        indicator.indicatorWidth = 18
        view.indicators = [indicator]
        view.listContainer = listContainerView
        return view
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        return view
    }()
}

//MARK: notification
extension CS_StakeController {
    private func registerNotication(){
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletInfoChange(_:)), name: NotificationName.walletBalanceChanged, object: nil)
    }
    
    @objc private func notifyWalletInfoChange(_ notify: Notification) {
        updateData()
    }
}

extension CS_StakeController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}

//MARK: action
extension CS_StakeController {
    override func clickRightButton() {
        CS_HelpCenterAlert.showTokenStake()
    }
}


extension CS_StakeController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            let vc = CS_StakeTokenController()
            return vc
        case 1:
            let vc = CS_StakeMyStakeController()
            return vc
        default:
            let vc = CS_StakeTokenController()
            return vc
        }
        
    }
}


extension CS_StakeController {
    func setupView(){
        navigationView.titleLabel.text = "crazy_str_stake".ls_localized
        topBackView.isHidden = false
        topBackView.addSubview(segmentedView)
        view.addSubview(listContainerView)
        rightButton.isHidden = false
        navAmountView.isHidden = false
        navAmountView1.isHidden = false
        
        segmentedView.snp.makeConstraints { make in
            make.width.equalTo(CS_kScreenW)
            make.height.equalTo(36)
            make.top.equalTo(0)
        }
        
        listContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(topBackView.snp.bottom).offset(0)
        }
    }
}
