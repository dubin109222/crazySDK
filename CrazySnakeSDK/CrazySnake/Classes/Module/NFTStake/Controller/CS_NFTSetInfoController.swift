//
//  CS_NFTSetInfoController.swift
//  CrazySnake
//
//  Created by Lee on 31/05/2023.
//

import UIKit
import SwiftyAttributes

class CS_NFTSetInfoController: CS_BaseEmptyController {

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var dataSource = [CS_NFTSetInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        walletAddress = "0xa2d0648f9c66bdaf9372eeadbe64d8694d87f402"
        setupView()
        // Do any additional setup after loading the view.
        emptyStyle = .loading
        requestList()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CS_NFTSetInfoCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(CS_NFTSetInfoCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_NFTSetInfoCell.self))
        view.backgroundColor = .clear
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 40, right: 0)
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.requestList()
        }
        return view
    }()
    
    lazy var tipsBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#000000",alpha: 0.8)
        view.ls_cornerRadius(5)
        return view
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_light(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.attributedText = "crazy_html_when_nft_set_directions".ls_localized_color([])
        return label
    }()
    
    lazy var tipsIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_nav_tips@2x")
        return view
    }()
    
}

extension CS_NFTSetInfoController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_NFTSetInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_NFTSetInfoCell.self), for: indexPath) as! CS_NFTSetInfoCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemData = dataSource[indexPath.row]
        let vc = CS_MarketController()
        vc.filterStr = itemData.set_class
        CrazyPlatform.pushTo(vc)

    }
    
}

//MARK: action
extension CS_NFTSetInfoController {
    func requestList(_ scrollToTop: Bool = false) {
        
        guard let address = walletAddress else {
            emptyStyle = .empty
            collectionView.reloadData()
            return
        }
        weak var weakSelf = self
        CSNetworkManager.shared.getNFTSetInfoList(address) { resp in
            weakSelf?.collectionView.ls_compeletLoading(false)
            if resp.status == .success {
                weakSelf?.dataSource.removeAll()
                weakSelf?.dataSource.append(contentsOf: resp.data)
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            weakSelf?.collectionView.ls_compeletLoading(true, hasMore: false)
            weakSelf?.collectionView.reloadData()
        }
    }
}

extension CS_NFTSetInfoController {
    func setupView(){
        navigationView.isHidden = false
        navigationView.titleLabel.text = "crazy_str_nft_stake_nft_set".ls_localized
        view.addSubview(collectionView)
        view.addSubview(tipsBackView)
        view.addSubview(tipsLabel)
        view.addSubview(tipsIcon)
        
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(642)
            make.top.equalTo(navigationView.snp.bottom)
            make.bottom.equalTo(backView.snp.bottom)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15)
        }
        
        tipsIcon.snp.makeConstraints { make in
            make.right.equalTo(tipsLabel.snp.left).offset(-8)
            make.centerY.equalTo(tipsLabel)
        }
        
        tipsBackView.snp.makeConstraints { make in
            make.left.equalTo(tipsIcon.snp.left).offset(-10)
            make.right.equalTo(tipsLabel).offset(24)
            make.top.equalTo(tipsLabel).offset(-10)
            make.bottom.equalTo(tipsLabel).offset(7)
        }
        
    }
}
