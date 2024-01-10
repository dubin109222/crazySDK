//
//  CS_WalletMnemonicController.swift
//  Platform
//
//  Created by Lee on 17/09/2021.
//

import UIKit
//import WalletCore

class CS_WalletMnemonicController: CS_WalletBaseController {

    var mnemonic = ""
    var accountInfo: AccountModel?
    
    private var dataSource = [MnemonicWordModel]()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        createMnemonicWords()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    lazy var reminderView: CS_WalletBackUpTipsView = {
        let view = CS_WalletBackUpTipsView()
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = MnemonicCollectCell.itemSize()
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.register(MnemonicCollectCell.self, forCellWithReuseIdentifier: NSStringFromClass(MnemonicCollectCell.self))
        return view
    }()
    
    lazy var verifyButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 168, height: 50))
        button.setTitle("Verify later".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickVerifyButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 168, height: 50))
        button.setTitle("crazy_str_confirm_right_now".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        return button
    }()
}

extension CS_WalletMnemonicController{
    private func createMnemonicWords() {
        
        let mnemonic = Mnemonic.create()
        
        self.mnemonic = mnemonic
        dataSource.append(contentsOf: MnemonicWordModel.mneonicListFrom(mnemonic))
        
        collectionView.reloadData()
    }
    
    @objc func handleSceenShot() {
//        tipsAlert.show()
    }
    
}

extension CS_WalletMnemonicController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MnemonicCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(MnemonicCollectCell.self), for: indexPath) as! MnemonicCollectCell
        let model = dataSource[indexPath.row]
        cell.indexLabel.text = "\(model.index)"
        cell.wordLabel.text = model.word
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}

//MARK: action
extension CS_WalletMnemonicController {
    
    @objc private func clickVerifyButton(_ sender: UIButton) {
        
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, coin: .ethereum)
        let wAccount = wallet.generateAccount()
       
        
        let account = AccountModel()
        account.mnemonic_word = mnemonic
        account.private_key = wAccount.rawPrivateKey
        let address = wAccount.address
        account.wallet_address = address
        LSHUD.hide()
        account.save()
        
        if CSSDKManager.shared.walletLoginType == 0 {
            CSSDKManager.shared.walletLoginType = 2
        }
        
        CS_AccountManager.shared.accountInfo = account
        
        UserDefaults.standard.setValue(account.id, forKey: CacheKey.lastSelectedAccountId)
//        UIViewController.current()?.navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: NotificationName.importMenmonicWalletSuccess, object: nil)
    }
    
    @objc func clickConfirmButton(_ sender: UIButton) {
        let vc = CS_VerifyMnemonicController()
        vc.isNewWallet = true
        vc.mnemonic = mnemonic
        pushTo(vc)
    }
}

extension CS_WalletMnemonicController {
 
    fileprivate func setupView() {
        navigationView.titleLabel.text = "crazy_str_my_wallet".ls_localized
       
        view.addSubview(reminderView)
        view.addSubview(collectionView)
        view.addSubview(verifyButton)
        view.addSubview(confirmButton)
        
        reminderView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(navigationView.snp.bottom).offset(5)
            make.right.equalTo(0)
            make.height.equalTo(59)
        }
         
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(32))
            make.right.equalTo(-CS_ms(32))
            make.top.equalTo(reminderView.snp.bottom).offset(30)
            make.height.equalTo(140)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(-14)
            make.left.equalTo(view.snp.centerX).offset(5)
            make.width.equalTo(168)
            make.height.equalTo(50)
        }
        
        verifyButton.snp.makeConstraints { make in
            make.bottom.width.height.equalTo(confirmButton)
            make.right.equalTo(confirmButton.snp.left).offset(-10)
        }
    }
}
