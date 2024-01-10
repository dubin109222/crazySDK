//
//  CSMyNFTController.swift
//  CrazySnake
//
//  Created by Lee on 27/02/2023.
//

import UIKit
import JXSegmentedView

class CSMyNFTController: CS_BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        CS_AccountManager.shared.loadConfigNameDesc()
    }
    
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
        segment.titles = ["crazy_str_nft_list".ls_localized,"crazy_str_backpack".ls_localized]
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

extension CSMyNFTController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}

extension CSMyNFTController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            let vc = CS_NFTListController()
            return vc
        case 1:
            let vc = CS_NFTBackpackController()
            return vc
        default:
            let vc = CS_NFTListController()
            return vc
        }
        
    }
}


extension CSMyNFTController {
    func setupView(){
        navigationView.titleLabel.text = "crazy_str_my_nft".ls_localized
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
