//
//  CS_SwapController.swift
//  CrazyWallet
//
//  Created by Lee on 28/06/2023.
//

import UIKit
import JXSegmentedView
import SnapKit

class CS_SwapController: CS_BaseController {
    
    var selectedIndex = 0

    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
        segment.titles = ["crazy_str_swap".ls_localized, "crazy_str_gascoin".ls_localized,"Game tokens".ls_localized]
//        segment.itemWidth = 100
        segment.itemSpacing = 20
        segment.isTitleColorGradientEnabled = true
        segment.isItemSpacingAverageEnabled = false
        segment.titleNormalColor = .ls_text_gray()
        segment.titleNormalFont = .ls_mediumFont(16)
        segment.titleSelectedColor = .ls_white()
        segment.titleSelectedFont = .ls_boldFont(16)
        return segment
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.delegate = self
        view.dataSource = segmentedDataSource
        view.defaultSelectedIndex = selectedIndex

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .normal
        indicator.indicatorColor = .ls_white()
        indicator.indicatorWidth = 30
        view.indicators = [indicator]
        view.listContainer = listContainerView
        return view
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        return view
    }()

    private func registerNotication(){
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletInfoChange(_:)), name: NotificationName.walletBalanceChanged, object: nil)
    }
    
    @objc private func notifyWalletInfoChange(_ notify: Notification) {
        updateData()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        CS_ContractTokenStake.shared
        updateData()
        registerNotication()
        
        navAmountView.isHidden = false
        navAmountView1.isHidden = false
        navAmountView2.isHidden = false



        // Do any additional setup after loading the view.
        if self.isLandscape() {
            navigationView.isHidden = false
            self.navigationView.titleLabel.text = "crazy_str_swap".ls_localized
            self.navigationView.backView.image = nil
        } else {
            navigationView.isHidden = true
        }
        self.backView.image = nil
        self.backView.backgroundColor = .ls_color("#171718")
        
        self.initSubViews()
        self.updateData()
    }
    
    func updateData(){
        
        navAmountView.iconView.image = TokenName.Snake.icon()
        navAmountView.amountLabel.text = Utils.formatAmount(TokenName.Snake.balance())
        navAmountView1.iconView.image = TokenName.GasCoin.icon()
        navAmountView1.amountLabel.text = Utils.formatAmount(TokenName.GasCoin.balance(),digits: 2)
        navAmountView2.iconView.image = TokenName.Diamond.icon()
        navAmountView2.amountLabel.text = Utils.formatAmount(TokenName.Diamond.balance(),digits: 2)

    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationView.isHidden = true

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    private func initSubViews() {
        
        self.view.addSubview(segmentedView)
        
        if self.isLandscape() {
            segmentedView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10 + kNavBarHeight)
                make.height.equalTo(36)
                make.left.right.equalTo(0)
            }
            
            let line = UIView()
            line.backgroundColor = .white.withAlphaComponent(0.1)
            self.view.addSubview(line)
            line.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
                make.top.equalTo(segmentedView.snp.bottom)
            }


        } else {
            segmentedView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10 + kStatusBarHeight)
                make.height.equalTo(36)
                make.left.right.equalTo(0)
            }
        }
        
        
        self.view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(segmentedView.snp.bottom).offset(10)
        }
        
        let historyBtn = UIButton(type: .custom)
        historyBtn.setImage(UIImage.ls_bundle("swap_history_order_icon@2x"), for: .normal)

        historyBtn.ls_addTarget(self, action: #selector(clickHistoryBtn(_:)))
        self.view.addSubview(historyBtn)
        historyBtn.snp.makeConstraints { make in
            make.centerY.equalTo(segmentedView)
            make.right.equalToSuperview().offset(-5)
            make.size.equalTo(44)
        }
    }
    
    @objc func clickHistoryBtn(_ sender : UIButton ) {
        self.navigationView.isHidden = false
        let historyOrderVc = CS_SwapOrderHistroyController()
//        self.navigationController?.pushViewController(historyOrderVc, animated: true)
//        let historyOrderVc = CS_WalletChooseAssetController()
        
        self.pushTo(historyOrderVc)
//        self.presentVC(historyOrderVc)
    }
}

extension CS_SwapController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}

extension CS_SwapController: JXSegmentedListContainerViewDataSource {
    public func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            let vc = CS_SwapDetailInfoController()
            return vc
        case 1:
            let vc = CS_SwapGascoinListController()
            vc.style = .gasCoin
            return vc
        case 2:
            let vc = CS_SwapGascoinListController()
            vc.style = .gameTokens
            return vc
        default:
            let vc = CS_WalletTokenListController()
            return vc
        }
    }
}


