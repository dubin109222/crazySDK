//
//  CS_WalletChooseAssetController.swift
//  CrazyWallet
//
//  Created by Lee on 30/06/2023.
//

import UIKit
import JXSegmentedView

class CS_WalletChooseAssetController: CS_WalletPresentController {

    var chooseTokenAction: CS_ChooseTokenBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segment = JXSegmentedTitleDataSource()
        segment.titles = ["All", Config.chain.name]
        segment.isItemSpacingAverageEnabled = false
        segment.itemWidth = 64
        segment.isTitleColorGradientEnabled = true
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
}

extension CS_WalletChooseAssetController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}

extension CS_WalletChooseAssetController: JXSegmentedListContainerViewDataSource {
    public func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        switch index {
        case 0:
            let vc = CS_WalletAssetListController()
            weak var weakSelf = self
            vc.chooseTokenAction = { token in
                weakSelf?.chooseToken(token)
            }
            return vc
        case 1:
            let vc = CS_WalletAssetListController()
            weak var weakSelf = self
            vc.chooseTokenAction = { token in
                weakSelf?.chooseToken(token)
            }
            return vc
        default:
            let vc = CS_WalletAssetListController()
            return vc
        }
    }
    
    func chooseToken(_ token: TokenName) {
        weak var weakSelf = self
        dismiss(animated: true) {
            weakSelf?.chooseTokenAction?(token)
        }
    }
}

//MARK: UI
extension CS_WalletChooseAssetController {
    
    private func setupView() {
        navigationView.titleLabel.text = "Choose asset".ls_localized
        view.addSubview(segmentedView)
        view.addSubview(listContainerView)
        
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom).offset(10)
            make.height.equalTo(36)
            make.left.equalTo(CS_ms(32))
            make.right.equalTo(-CS_ms(32))
        }
        
        listContainerView.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.left.equalTo(CS_ms(32))
            make.right.equalTo(-CS_ms(32))
            make.top.equalTo(segmentedView.snp.bottom).offset(10)
        }
    }
}
