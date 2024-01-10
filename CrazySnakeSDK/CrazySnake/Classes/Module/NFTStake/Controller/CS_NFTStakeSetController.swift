//
//  CS_NFTStakeSetController.swift
//  CrazySnake
//
//  Created by Lee on 14/03/2023.
//

import UIKit
import SwiftyAttributes
import HandyJSON

class CS_NFTStakeSetController: CS_BaseEmptyController {

    var nftStakeSuccss: CS_NoParasBlock?
    
    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var dataSource = [CS_NFTStakeSuitableItemModel]()
    
    lazy var mockData: [CS_NFTStakeSuitableItemModel] = {
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Support", ofType: "bundle") else { return [] }
            let bundle = Bundle.init(path: bundlePath)
            let imageStr = bundle?.path(forResource: "guide", ofType: "json")

            
            let jsonStr = try? String.init(contentsOfFile: imageStr ?? "", encoding: .utf8)
            if let model = JSONDeserializer<CS_NFTStakeSuitableItemModel>.deserializeModelArrayFrom(json: jsonStr,designatedPath: "nft_stake.sets.list") as? [CS_NFTStakeSuitableItemModel] {
                return model
            }
        }
        return []
    }()
    var isMock = false

    override func viewDidLoad() {
        super.viewDidLoad()

        emptyStyle = .loading
        setupView()
        requestNFTList()
    }
    
    lazy var contentBackView: UIView = {
        let view = UIView()
        view.ls_cornerRadius(15)
        view.backgroundColor = .ls_dark_3()
        return view
    }()
    
    lazy var selectedLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_JostRomanFont(19))
        label.attributedText = "Choose NFT Set ".attributedString + "(Quick select)".withTextColor(.ls_purpose())
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CS_NFTStakeSetCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 10, left: 14, bottom: 0, right: 14)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.register(CS_NFTStakeSetCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_NFTStakeSetCell.self))
        view.backgroundColor = .ls_color("#252525")
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_dark(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_nft_stake_set_desc".ls_localized
        return label
    }()
    
    var mockNextHandle : ((Bool) -> ())? = nil
}

extension CS_NFTStakeSetController {
    func guideStepOne() {
        if self.isMock == true {
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let cell = weakSelf?.collectionView.cellForItem(at: .init(row: 0, section: 0)) {
                    let maskRect = cell.convert(cell.bounds, to: nil)
                    
                    GuideMaskView.show (tipsText: "select NFT set.",
                                        currentStep: "6",
                                        totalStep: "10",
                                        maskRect: maskRect,
                                        textWidthDefault: 223,
                                        direction: .left){
                        weakSelf?.guideStepTwo()
                    } skipHandle: {
                        weakSelf?.mockNextHandle?(true)
                        weakSelf?.pop(true)
                    }
                }
            }
        }
    }
    
    func guideStepTwo() {
        let vc = CS_NFTStakeChooseSetController()
        vc.isMock = true
        present(vc, animated: false)
        weak var weakSelf = self
        vc.mockNextHandle  = { isSkip in
            weakSelf?.mockNextHandle?(isSkip)
            weakSelf?.pop()
        }


    }
}

extension CS_NFTStakeSetController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTStakeSetCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTStakeSetCell.self), for: indexPath) as! CS_NFTStakeSetCell
        if isMock {
            if indexPath.row < mockData.count {
                let model : CS_NFTStakeSuitableItemModel = mockData[indexPath.row]
                cell.setData(model)
            } else {
                cell.setDataMore()
            }

        } else {
            if indexPath.row < dataSource.count {
                let model : CS_NFTStakeSuitableItemModel = dataSource[indexPath.row]
                cell.setData(model)
            } else {
                cell.setDataMore()
            }

        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isMock ? (mockData.count + 1) : (dataSource.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= dataSource.count {
            let vc = CS_NFTSetInfoController()
            pushTo(vc)
            return
        }
        let model = dataSource[indexPath.row]
        let vc = CS_NFTStakeChooseSetController()
        vc.suitableItem = model
        present(vc, animated: false)
        weak var weakSelf = self
        vc.nftStakeSuccss = {
            weakSelf?.nftStakeSuccss?()
            weakSelf?.pop()
        }
    }

}

//MARK: request
extension CS_NFTStakeSetController {
    func requestNFTList() {
        guard let address = walletAddress else { return }
        weak var weakSelf = self
        CSNetworkManager.shared.getStakeSuitable(address) { resp in
            if resp.status == .success {
                weakSelf?.dataSource.removeAll()
                weakSelf?.dataSource.append(contentsOf: resp.data)
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            weakSelf?.collectionView.reloadData()
            weakSelf?.guideStepOne()
        }
    }
}


//MARK: action
extension CS_NFTStakeSetController {
    
}


//MARK: UI
extension CS_NFTStakeSetController {
    
    private func setupView() {
        navigationView.titleLabel.text = "crazy_str_nft_stake".ls_localized
        emptyImageName = "icon_empty_nft@2x"
        titleColor = .ls_white()
        emptyDescription = "crazy_str_empty_nfg_hint".ls_localized
        view.addSubview(contentBackView)
        view.addSubview(selectedLabel)
        contentBackView.addSubview(collectionView)
        view.addSubview(infoLabel)
        
        contentBackView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(20))
            make.right.equalTo(-CS_ms(12))
            make.top.equalTo(navigationView.snp.bottom).offset(CS_RH(33))
//            make.height.equalTo(285)
            make.bottom.equalTo(view).offset(-48)
        }
        
        selectedLabel.snp.makeConstraints { make in
            make.left.equalTo(contentBackView).offset(22)
            make.top.equalTo(contentBackView).offset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentBackView)
            make.top.equalTo(contentBackView).offset(44)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-24)
        }
    }
}
