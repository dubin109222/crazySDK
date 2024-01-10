//
//  CS_VerifyMnemonicController.swift
//  Platform
//
//  Created by Lee on 23/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit
//import WalletCore

class CS_VerifyMnemonicController: CS_WalletBaseController {
    var isNewWallet = false
    var mnemonic = ""
    var accountInfo: AccountModel?
    
    var mnemonicWordsList = [MnemonicWordModel]()
    var verifyList = [MnemonicVerifyModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mnemonicWordsList = MnemonicWordModel.mneonicListFrom(mnemonic)
        verifyList.append(MnemonicVerifyModel(dataSource[dataSource[0].index-1]))
        verifyList.append(MnemonicVerifyModel(dataSource[dataSource[2].index-1]))
        verifyList.append(MnemonicVerifyModel(dataSource[dataSource[5].index-1]))
        setupView()
    }
    
    lazy var dataSource: [MnemonicWordModel] = {
        var list = [MnemonicWordModel]()
        var arrShuffle: Array<MnemonicWordModel> = mnemonicWordsList.shuffle()
        for (index, var element) in arrShuffle.enumerated() {
            element.verifyDisplayIndex = index
            arrShuffle[index] = element
        }
        
        list.append(contentsOf: arrShuffle)
        return list
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(UIColor.ls_white(), UIFont.ls_boldFont(24))
        label.text = "Backup reminder"
        label.textAlignment = .center
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#CCCCCC"), UIFont.ls_mediumFont(12))
        label.text = "Please choose the correct mnemonic";
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CS_WalletMnemonivVerifyCell.itemSize()
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.register(CS_WalletMnemonivVerifyCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_WalletMnemonivVerifyCell.self))
        view.isScrollEnabled = false
        return view
    }()
    
    private lazy var sourceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = MnemonicCollectCell.itemSize()
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.register(MnemonicVerifyCollectCell.self, forCellWithReuseIdentifier: NSStringFromClass(MnemonicVerifyCollectCell.self))
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 310, height: 50))
        button.setTitle("crazy_str_complete_verify".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        return button
    }()
}

//MARK: action
extension CS_VerifyMnemonicController {
    
    @objc func clickConfirmButton(_ sender: UIButton) {
        var complete = true
        for item in verifyList {
            if item.selected == nil || item.selected?.word != item.mnemonic?.word {
                complete = false
                break
            }
        }
        
        if complete {
            if isNewWallet {
                createNewAccount()
            } else {
                accountInfo?.backupStatus = "1"
                accountInfo?.updateRealm()
                NotificationCenter.default.post(name: NotificationName.walletChanged, object: nil)
                popTo(CS_WalletController.self)
            }
        } else {
            LSHUD.showError("crazy_str_tip_error".ls_localized)
        }
    }
    
    func createNewAccount() {
        
        // 使用web3swift 创建钱包地址
        
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .ethereum)
        let wAccount = wallet.generateAccount()
        
        let account = AccountModel()
        account.mnemonic_word = mnemonic
        account.private_key = wAccount.rawPrivateKey
        let address = wAccount.address
        account.wallet_address = address
        account.backupStatus = "1"
        LSHUD.hide()
        account.save()
        CS_AccountManager.shared.accountInfo = account
        
        UserDefaults.standard.setValue(account.id, forKey: CacheKey.lastSelectedAccountId)
        popTo(CS_WalletController.self)
        NotificationCenter.default.post(name: NotificationName.importMenmonicWalletSuccess, object: nil)
    }

}


extension CS_VerifyMnemonicController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            
            let cell: CS_WalletMnemonivVerifyCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_WalletMnemonivVerifyCell.self), for: indexPath) as! CS_WalletMnemonivVerifyCell
            
            let model = verifyList[indexPath.row]
            cell.setVerifyData(model)
            
            return cell
        } else {
            let cell: MnemonicVerifyCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MnemonicVerifyCollectCell.self), for: indexPath) as! MnemonicVerifyCollectCell
            let model = dataSource[indexPath.row]
            cell.wordLabel.text = model.word
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return verifyList.count
        } else {
            return dataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let model = verifyList[indexPath.row]
            if model.selected != nil {
                model.selected = nil
            }
            self.collectionView.reloadData()
        } else {
            let indexModel = dataSource[indexPath.row]
            for item in verifyList {
                if item.selected == nil {
                    item.selected = indexModel
                    break
                }
            }
            self.collectionView.reloadData()
        }
    }
}

extension CS_VerifyMnemonicController {
 
    fileprivate func setupView() {
        navigationView.titleLabel.text = "crazy_str_backup".ls_localized
       
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(collectionView)
        view.addSubview(sourceCollectionView)
        view.addSubview(completeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(5)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(CS_WalletMnemonivVerifyCell.itemSize().width*3+20)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            make.height.equalTo(62)
        }
        
        sourceCollectionView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(32))
            make.right.equalTo(-CS_ms(32))
            make.top.equalTo(collectionView.snp.bottom).offset(15)
            make.height.equalTo(124)
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(310)
            make.bottom.equalTo(-14)
            make.height.equalTo(50)
        }
    }
}
