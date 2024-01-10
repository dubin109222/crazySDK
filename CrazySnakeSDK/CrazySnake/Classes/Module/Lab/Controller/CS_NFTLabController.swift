//
//  CS_NFTLabController.swift
//  CrazySnake
//
//  Created by Lee on 28/02/2023.
//

import UIKit
import JXSegmentedView

typealias NFTDataBlock = (CS_NFTDataModel?) -> Void
typealias NFTPropBlock = (CS_NFTPropModel?) -> Void

class CS_NFTLabController: CS_BaseController {
    
    private var primaryFeed: CS_NFTPropModel?
    private var intermadiateFeed: CS_NFTPropModel?
    private var seniorFeed: CS_NFTPropModel?
    private var essenceEvolution: CS_NFTPropModel?
    private var feedIncubate: CS_NFTPropModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
//        ,"Transform"
        segment.titles = [
            "crazy_str_nft_level_up".ls_localized,
            "crazy_str_nft_upgrade".ls_localized,
            "crazy_str_nft_recycle".ls_localized,
            "crazy_str_nft_incubation".ls_localized
        ]
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

extension CS_NFTLabController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        switch index {
        case 0:
            navAmountView.isHidden = false
            navAmountView1.isHidden = false
            navAmountView2.isHidden = false
            navAmountView2.iconView.image = UIImage.ls_bundle( "nft_icon_feed_primary@2x")
            navAmountView2.amountLabel.text = "\(primaryFeed?.num ?? 0)"
            navAmountView1.iconView.image = UIImage.ls_bundle( "nft_icon_feed_intermadiate@2x")
            navAmountView1.amountLabel.text = "\(intermadiateFeed?.num ?? 0)"
            navAmountView.iconView.image = UIImage.ls_bundle( "nft_icon_feed_senior@2x")
            navAmountView.amountLabel.text = "\(seniorFeed?.num ?? 0)"
        case 1:
            navAmountView.isHidden = false
            navAmountView1.isHidden = true
            navAmountView2.isHidden = true
            navAmountView.iconView.image = UIImage.ls_bundle( "nft_icon_essence_advance@2x")
            navAmountView.amountLabel.text = "\(essenceEvolution?.num ?? 0)"
        case 2:
            navAmountView.isHidden = false
            navAmountView1.isHidden = true
            navAmountView2.isHidden = true
            navAmountView.iconView.image = UIImage.ls_bundle( "nft_icon_essence_advance@2x")
            navAmountView.amountLabel.text = "\(essenceEvolution?.num ?? 0)"
//        case 3:
//            navAmountView.isHidden = true
        case 3:
            navAmountView.isHidden = false
            navAmountView1.isHidden = true
            navAmountView2.isHidden = true
            navAmountView.iconView.image = UIImage.ls_bundle( "nft_icon_incubate_feed@2x")
            navAmountView.amountLabel.text = "\(feedIncubate?.num ?? 0)"
        default:
            navAmountView.isHidden = true
            navAmountView1.isHidden = true
            navAmountView2.isHidden = true
        }
    }
}

extension CS_NFTLabController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        weak var weakSelf = self
        switch index {
        case 0:
            let vc = CS_NFTLevelUpController()
            vc.propChangeAction = { (primary,intermadiate,senior) in
                weakSelf?.primaryFeed = primary
                weakSelf?.intermadiateFeed = intermadiate
                weakSelf?.seniorFeed = senior
                weakSelf?.navAmountView2.iconView.image = UIImage.ls_bundle( "nft_icon_feed_primary@2x")
                weakSelf?.navAmountView2.amountLabel.text = "\(weakSelf?.primaryFeed?.num ?? 0)"
                weakSelf?.navAmountView1.iconView.image = UIImage.ls_bundle( "nft_icon_feed_intermadiate@2x")
                weakSelf?.navAmountView1.amountLabel.text = "\(weakSelf?.intermadiateFeed?.num ?? 0)"
                weakSelf?.navAmountView.iconView.image = UIImage.ls_bundle( "nft_icon_feed_senior@2x")
                weakSelf?.navAmountView.amountLabel.text = "\(weakSelf?.seniorFeed?.num ?? 0)"
            }
            return vc
        case 1:
            let vc = CS_NFTEvolutionController()
            vc.propChangeAction = { model in
                weakSelf?.essenceEvolution = model
                weakSelf?.navAmountView.amountLabel.text = "\(model?.num ?? 0)"
            }
            return vc
        case 2:
            let vc = CS_NFTRecycleController()
            vc.propChangeAction = { model in
                weakSelf?.essenceEvolution = model
                weakSelf?.navAmountView.amountLabel.text = "\(model?.num ?? 0)"
            }
            return vc
//        case 3:
//            let vc = CS_NFTTransformController()
//            return vc
        case 3:
            let vc = CS_NFTIncubationController()
            vc.propChangeAction = { model in
                weakSelf?.feedIncubate = model
                weakSelf?.navAmountView.amountLabel.text = "\(model?.num ?? 0)"
            }
            return vc
        default:
            let vc = CS_NFTLevelUpController()
            return vc
        }
        
    }
}

extension CS_NFTLabController {
    func setupView(){
        navigationView.titleLabel.text = "crazy_str_nft_lab".ls_localized
        topBackView.isHidden = false
        topBackView.addSubview(segmentedView)
        navAmountView.isHidden = false
        navAmountView1.isHidden = false
        navAmountView2.isHidden = false
        view.addSubview(listContainerView)
        
        navAmountView.snp.updateConstraints { make in
            make.width.equalTo(120)
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
