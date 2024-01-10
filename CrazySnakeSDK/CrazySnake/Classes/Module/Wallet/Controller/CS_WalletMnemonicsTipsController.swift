//
//  CS_WalletMnemonicController.swift
//  Platform
//
//  Created by Lee on 17/09/2021.
//

import UIKit
//import WalletCore
import SnapKit


class CS_WalletMnemonicsTipsCell: UICollectionViewCell {
    struct CellModel {
        var icon: String
        var name: String
        var des: String
    }
    
    var data: CellModel? = nil {
        didSet {
            icon.image = UIImage.ls_bundle(data?.icon)
            nameLb.text = data?.name
            desLb.text = data?.des
        }
    }
    
    var icon: UIImageView = UIImageView()
    var nameLb: UILabel = UILabel()
    var desLb: UILabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLb.numberOfLines = 0
        nameLb.textColor = UIColor.ls_color("#FFFFFF")
        nameLb.font = .ls_JostRomanFont(16)

        desLb.numberOfLines = 0
        desLb.textColor = UIColor.ls_color("#999999")
        desLb.font = .ls_JostRomanFont(12)
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(nameLb)
        self.contentView.addSubview(desLb)
        
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(44)
            make.top.equalToSuperview()
        }
        
        nameLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
        desLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLb.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CS_WalletMnemonicsTipsController: CS_WalletBaseController {

    var mnemonic = ""
    var accountInfo: AccountModel?
    
    private var dataSource = [CS_WalletMnemonicsTipsCell.CellModel]()
    
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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (kScreenW / 3 - 30), height: 133)
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.register(CS_WalletMnemonicsTipsCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_WalletMnemonicsTipsCell.self))
        return view
    }()
    
 
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 168, height: 50))
        button.setTitle("crazy_str_confirm_right_now".ls_localized, for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        return button
    }()

    var agreeBtn = UIButton()

}

extension CS_WalletMnemonicsTipsController{
    private func createMnemonicWords() {

        dataSource = [
            CS_WalletMnemonicsTipsCell.CellModel(icon: "mnemonic_tips_1@2x", name: "Mnemonics are the same  as your wallet password".ls_localized, des: "Mnemonics are your assets key,  if it's lost of found by someon".ls_localized),
            CS_WalletMnemonicsTipsCell.CellModel(icon: "mnemonic_tips_2@2x", name: "Write down on a paper".ls_localized, des: "If you cope to save, it's a risk to  be exposed to the internet".ls_localized),
            CS_WalletMnemonicsTipsCell.CellModel(icon: "mnemonic_tips_3@2x", name: "Save your keys in a safe  place".ls_localized, des: "If you lose your keys, your assets  will be lost as well.".ls_localized),
        ]
        
        collectionView.reloadData()
    }
    
    @objc func handleSceenShot() {
//        tipsAlert.show()
    }
    
}

extension CS_WalletMnemonicsTipsController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_WalletMnemonicsTipsCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_WalletMnemonicsTipsCell.self), for: indexPath) as! CS_WalletMnemonicsTipsCell
        let model = dataSource[indexPath.row]
        cell.data = model
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}

//MARK: action
extension CS_WalletMnemonicsTipsController {
    
    
    @objc func clickConfirmButton(_ sender: UIButton) {
        guard agreeBtn.isSelected else {
            LSHUD.showInfo("Please agree")
            return
        }
        
        let vc = CS_WalletMnemonicController()
        pushTo(vc)
    }
}

extension CS_WalletMnemonicsTipsController {
 
    fileprivate func setupView() {
        navigationView.titleLabel.text = "crazy_str_my_wallet".ls_localized
       
        view.addSubview(reminderView)
        view.addSubview(collectionView)
        view.addSubview(confirmButton)
        
        reminderView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(navigationView.snp.bottom).offset(5)
            make.right.equalTo(0)
            make.height.equalTo(59)
        }
         
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(CS_ms(5))
            make.right.equalTo(-CS_ms(5))
            make.top.equalTo(reminderView.snp.bottom).offset(30)
            make.height.equalTo(140)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(-13 - 48)
            make.centerX.equalToSuperview()
            make.width.equalTo(168)
            make.height.equalTo(50)
        }


        agreeBtn = UIButton(type: .custom)
        agreeBtn.isSelected = true
        agreeBtn.setImage(UIImage.ls_bundle("agree_icon_selected@2x"), for: .selected)
        agreeBtn.setImage(UIImage.ls_bundle("agree_icon_not_selected@2x"), for: .normal)

        agreeBtn.setTitle("""
                          I understand that if I lose my keys Crazy Land will not be
                          able to recover my assets and they will be forever lost
                          """, for: .normal)
        agreeBtn.titleLabel?.numberOfLines = 2
        agreeBtn.setTitleColor(UIColor.white, for: .normal)
        agreeBtn.titleLabel?.font = UIFont.ls_JostRomanFont(12)
        agreeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        agreeBtn.addTarget(self, action: #selector(clickAgreeButton(_:)), for: .touchUpInside)
        view.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(confirmButton.snp.bottom).offset(10)
            make.width.equalTo(kScreenW)
            make.height.equalTo(26)
        }        
    }

    @objc func clickAgreeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}
