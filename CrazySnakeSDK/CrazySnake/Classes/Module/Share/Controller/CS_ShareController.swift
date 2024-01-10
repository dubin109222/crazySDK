//
//  CS_ShareController.swift
//  CrazySnake
//
//  Created by Lee on 08/05/2023.
//

import UIKit
import JXSegmentedView

class CS_ShareController: CS_BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
//        "Gascoin"
        segment.titles = ["crazy_str_play_2_earn".ls_localized,"crazy_str_quest".ls_localized,"Withdraw".ls_localized]
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

extension CS_ShareController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}

extension CS_ShareController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            let vc = CS_SharePlay2EarnController()
            weak var weakSelf = self
            vc.clickEarnMoreAction = {
                weakSelf?.segmentedView.selectItemAt(index: 1)
            }
            vc.clickWithdrawAction = {
                weakSelf?.segmentedView.selectItemAt(index: 2)
            }
            return vc
        case 1:
            let vc = CS_ShareQuestController()
            vc.clickInviteFriendsAction = {
                self.segmentedView.selectItemAt(index: 0)
            }
            return vc
        case 2:
            let vc = CS_ShareWithdrawController()
            return vc
        default:
            let vc = CS_SharePlay2EarnController()
            return vc
        }
    }
}

//MARK: action
extension CS_ShareController {
    
    override func clickRightButton() {
        CS_HelpCenterAlert.showShareTips()
    }
    
}

extension CS_ShareController {
    func setupView(){
        navigationView.titleLabel.text = "crazy_str_play_2_earn".ls_localized
        rightButton.isHidden = false
        topBackView.isHidden = false
        topBackView.addSubview(segmentedView)
        view.addSubview(listContainerView)
                
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

