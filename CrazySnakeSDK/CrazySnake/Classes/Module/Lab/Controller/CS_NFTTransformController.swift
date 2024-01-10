//
//  CS_NFTTransformController.swift
//  CrazySnake
//
//  Created by Lee on 02/03/2023.
//

import UIKit
import JXSegmentedView

class CS_NFTTransformController: CS_BaseEmptyController {

    private var walletAddress = CS_AccountManager.shared.accountInfo?.wallet_address
    private var page = 1
    private var quality = 0
    private var dataSource = [CS_NFTDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        // Do any additional setup after loading the view.
        emptyStyle = .loading
        requestMyNFTList()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.itemSize = ProfileBoxCollectionCell.itemSize()
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.cornerRadius = 15
        view.register(ProfileNFTCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(ProfileNFTCollectionCell.self))
        view.backgroundColor = .ls_dark_3()
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requestMyNFTList()
        }
        view.ls_addFooter {
            weakSelf?.page += 1
            weakSelf?.requestMyNFTList()
        }
        view.mj_footer.isHidden = true
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 142, height: 159))
        view.ls_cornerRadius(10)
        view.ls_addCorner(.topLeft, cornerRadius: 20)
        view.ls_addCorner(.bottomRight, cornerRadius: 35)
//        view.backgroundColor = .ls_dark_4()
        view.image = UIImage.ls_bundle( "icon_nft_demo@2x")
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 234, height: 40))
        button.addTarget(self, action: #selector(clickConfirmAction(_:)), for: .touchUpInside)
        button.ls_cornerRadius(7)
        button.ls_addColorLayerPurpose()
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.setTitle("crazy_str_speed_up".ls_localized, for: .normal)
        button.setImage(UIImage.ls_bundle( "icon_nft_lab_level_up@2x"), for: .normal)
        button.ls_layout(.imageLeft,padding: 7)
        return button
    }()

    var isMock = false
}




extension CS_NFTTransformController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProfileNFTCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ProfileNFTCollectionCell.self), for: indexPath) as! ProfileNFTCollectionCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = MarketNFTController()
//        let model = dataSource[indexPath.row]
//        vc.nftId = model.token_id
//        UIViewController.current()?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CS_NFTTransformController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }

    func listDidAppear() {}

    func listDidDisappear() {}
}

//MARK: action
extension CS_NFTTransformController {
    @objc func clickConfirmAction(_ sender: UIButton) {
//        let alert = CS_NFTLabLevelUpAlert()
//        alert.show()
    }
}

//MARK: request
extension CS_NFTTransformController {
    func requestMyNFTList() {
    }
}

extension CS_NFTTransformController {
    func setupView(){
        navigationView.isHidden = true
        emptyTitle = "crazy_str_empty_nfg_hint".ls_localized
        backView.image = UIImage.ls_bundleImageJpg(named: "bg_image_no_title")
        view.addSubview(collectionView)
        view.addSubview(iconView)
        view.addSubview(confirmButton)
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo((CS_kIsSmallPhone ?  28 : 48)*CS_kRate)
            make.top.equalTo(10)
            make.width.equalTo(255)
            make.bottom.equalTo(-10)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(collectionView.snp.right).offset(14)
            make.top.equalTo(collectionView).offset(20)
            make.width.equalTo(142)
            make.height.equalTo(159)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalTo(-95)
            make.bottom.equalTo(-32)
            make.width.equalTo(234)
            make.height.equalTo(40)
        }
    }
    
    func updateLayout() {
        if dataSource.count == 0 {
            collectionView.snp.updateConstraints { make in
                make.width.equalTo(CS_kScreenW-2*28*CS_kRate)
            }
        } else {
            collectionView.snp.updateConstraints { make in
                make.width.equalTo(255)
            }
        }
    }
}


