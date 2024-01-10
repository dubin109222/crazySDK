//
//  CS_EventController.swift
//  CrazySnake
//
//  Created by Lee on 04/04/2023.
//

import UIKit
import JXSegmentedView

class CS_EventController: CS_BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        updateData()
        registerNotication()
        CS_AccountManager.shared.loadTokenBlance()
        CS_AccountManager.shared.loadConfigNameDesc()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateData(){
        
        navAmountView.iconView.image = TokenName.Snake.icon()
        navAmountView.amountLabel.text = Utils.formatAmount(TokenName.Snake.balance())
        navAmountView1.iconView.image = TokenName.GasCoin.icon()
        navAmountView1.amountLabel.text = Utils.formatAmount(TokenName.GasCoin.balance(),digits: 2)
        navAmountView2.iconView.image = TokenName.CYT.icon()
        navAmountView2.amountLabel.text = Utils.formatAmount(TokenName.CYT.balance(),digits: 2)
    }

    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
//        "Gascoin"
        segment.titles = ["crazy_str_crazy_offers".ls_localized]
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
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#CCADFF"), .ls_JostRomanFont(12))
        label.textAlignment = .right
        return label
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickRecordButton(_:)), for: .touchUpInside)
        button.setImage(UIImage.ls_bundle("event_icon_record@2x"), for: .normal)
        return button
    }()
}

//MARK: action
extension CS_EventController {
    @objc private func clickRecordButton(_ sender: UIButton) {
        let vc = CS_EventRecordController()
        present(vc, animated: false)
    }
    
    override func clickRightButton() {
        CS_HelpCenterAlert.showEvent()
    }
}


//MARK: notification
extension CS_EventController {
    private func registerNotication(){
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletInfoChange(_:)), name: NotificationName.walletBalanceChanged, object: nil)
    }
    
    @objc private func notifyWalletInfoChange(_ notify: Notification) {
        updateData()
    }
}

extension CS_EventController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}

extension CS_EventController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            let vc = CS_EventCrazyController()
            weak var weakSelf = self
            vc.eventTimeUpdate = { time in
                weakSelf?.timeLabel.text = time
            }
            return vc
        default:
            let vc = CS_EventCrazyController()
            return vc
        }
    }
}

extension CS_EventController {
    func setupView(){
        navigationView.titleLabel.text = "crazy_str_event".ls_localized
        rightButton.isHidden = false
        navAmountView.isHidden = false
        navAmountView1.isHidden = false
        navAmountView2.isHidden = false
        topBackView.isHidden = false
        topBackView.addSubview(segmentedView)
        topBackView.addSubview(timeLabel)
        topBackView.addSubview(recordButton)
        view.addSubview(listContainerView)
                
        segmentedView.snp.makeConstraints { make in
            make.width.equalTo(CS_kScreenW)
            make.height.equalTo(36)
            make.top.equalTo(0)
        }
        
        recordButton.snp.makeConstraints { make in
            make.right.equalTo(-26)
            make.centerY.equalTo(segmentedView)
            make.width.height.equalTo(32)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(segmentedView)
            make.right.equalTo(recordButton.snp.left).offset(-40)
        }
        
        listContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(topBackView.snp.bottom).offset(0)
        }
    }
}

