//
//  CS_WalletBackupController.swift
//  Platform
//
//  Created by Lee on 01/05/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit

class CS_WalletBackupController: CS_WalletBaseController {
    
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
    
    lazy var copyButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: CS_kScreenW-64, height: 50))
        button.setTitle("Copy".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickCopyButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 310, height: 50))
        button.setTitle("Backup mnemonic".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        return button
    }()
}

extension CS_WalletBackupController{
    private func createMnemonicWords() {
        
        guard mnemonic.count > 0 else {
            CS_ToastView.showError("Mnemonic not correct".ls_localized)
            return
        }
        
        dataSource.append(contentsOf: MnemonicWordModel.mneonicListFrom(mnemonic))
        
        collectionView.reloadData()
    }
    
    @objc func handleSceenShot() {
//        tipsAlert.show()
    }
    
}

extension CS_WalletBackupController: UICollectionViewDelegate,UICollectionViewDataSource{
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
extension CS_WalletBackupController {
    
    @objc private func clickCopyButton(_ sender: UIButton) {
        UIPasteboard.general.string = mnemonic
        LSHUD.showSuccess("crazy_str_copied".ls_localized)
    }
    
    @objc func clickConfirmButton(_ sender: UIButton) {
        let vc = CS_VerifyMnemonicController()
        vc.isNewWallet = false
        vc.mnemonic = mnemonic
        vc.accountInfo = accountInfo
        pushTo(vc)
    }
}

extension CS_WalletBackupController {
    
    fileprivate func setupView() {
        navigationView.titleLabel.text = "crazy_str_my_wallet".ls_localized
       
        view.addSubview(reminderView)
        view.addSubview(collectionView)
//        view.addSubview(copyButton)
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
            make.bottom.equalTo(-24)
            make.centerX.equalToSuperview()
            make.width.equalTo(310)
            make.height.equalTo(50)
        }
        
//        copyButton.snp.makeConstraints { make in
//            make.left.width.height.equalTo(confirmButton)
//            make.bottom.equalTo(confirmButton.snp.top).offset(-16)
//        }
    }
}
