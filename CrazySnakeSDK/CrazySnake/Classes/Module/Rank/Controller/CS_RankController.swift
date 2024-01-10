//
//  CS_RankController.swift
//  CrazySnake
//
//  Created by Lee on 12/06/2023.
//

import UIKit
import JXSegmentedView

class CS_RankController: CS_BaseController {

    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(12))
        label.textAlignment = .right
        label.text = "crazy_str_daily_reset_time".ls_localized
        return label
    }()

    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
//        "Gascoin"
        segment.titles = ["crazy_str_total_power_rank".ls_localized,"crazy_str_nft_power_rank".ls_localized,"crazy_str_stake_token".ls_localized,"crazy_str_stake_nft".ls_localized]
        segment.isItemSpacingAverageEnabled = false
        segment.itemWidth = 120
        segment.isTitleColorGradientEnabled = true
        segment.titleNormalColor = .ls_text_gray()
        segment.titleNormalFont = .ls_JostRomanFont(12)
        segment.titleSelectedColor = .ls_purpose_01()
        segment.titleSelectedFont = .ls_JostRomanFont(16)
        return segment
    }()
    
    
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.defaultSelectedIndex = selectedIndex
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

extension CS_RankController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}

extension CS_RankController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            let vc = CS_RankTotalPowerController()
            return vc
        case 1:
            let vc = CS_RankNFTPowerController()
            return vc
        case 2:
            let vc = CS_RankStakeTokenController()
            return vc
        case 3:
            let vc = CS_RankStakeNFTController()
            return vc
        default:
            let vc = CS_RankTotalPowerController()
            return vc
        }
    }
}

extension CS_RankController {
    func setupView(){
        navigationView.titleLabel.text = "crazy_str_rank".ls_localized
        topBackView.isHidden = false
        topBackView.addSubview(segmentedView)
        navigationView.addSubview(timeLabel)
        view.addSubview(listContainerView)
              
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(navigationView.titleLabel)
            make.right.equalTo(-32)
        }
        
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

