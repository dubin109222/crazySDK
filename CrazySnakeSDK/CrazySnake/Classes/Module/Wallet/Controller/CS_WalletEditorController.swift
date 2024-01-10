//
//  CS_WalletEditorController.swift
//  CrazySnake
//
//  Created by Lee on 16/06/2023.
//

import UIKit

class CS_WalletEditorController: CS_BaseAlertController {

    var accountInfo: AccountModel?
    private var page = 1
    private var dataSource = [CS_UserAvatarModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emptyStyle = .loading
        setupView()
        requestMyNFTList()
    }
    
    lazy var contentBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_2()
        return view
    }()
    
    lazy var avatarIcon: UIImageView = {
        let view = UIImageView()
        if let iconUrl = accountInfo?.iconUrl {
            let url = URL.init(string: iconUrl)
            view.kf.setImage(with: url, placeholder: UIImage.ls_placeHeader())
        }
        return view
    }()
    
    lazy var avatarLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_font(12))
        label.textAlignment = .center
        label.text = "Avatar".ls_localized
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_font(12))
        label.textAlignment = .center
        label.text = "Name".ls_localized
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 30
        layout.itemSize = CS_WalletAvatarCell.itemSize()
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: 370, height: 160), collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.emptyDataSetDelegate = self
        view.emptyDataSetSource = self
        view.register(CS_WalletAvatarCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_WalletAvatarCell.self))
        view.backgroundColor = .ls_dark_3()
        view.contentInset = UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 20)
        weak var weakSelf = self
        view.ls_addHeader(false) {
            weakSelf?.page = 1
            weakSelf?.requestMyNFTList()
        }
        return view
    }()
    
    lazy var inputBack: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_dark_3()
        view.ls_cornerRadius(10)
        return view
    }()
    
    lazy var inputField: UITextField = {
        let field = UITextField()
//        field.placeholder = CS_AccountManager.shared.userInfo?.name
        field.textColor = .ls_white()
        field.font = UIFont.ls_font(12)
        field.attributedPlaceholder = NSAttributedString(string: "\(accountInfo?.nickName ?? "nickname")", attributes: [NSAttributedString.Key.foregroundColor: UIColor.ls_text_light()])
        return field
    }()
    
    lazy var stakeButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 90, height: 34))
        button.addTarget(self, action: #selector(clickStakeButton(_:)), for: .touchUpInside)
        button.setTitle("Modify".ls_localized, for: .normal)
        return button
    }()
    
}

extension CS_WalletEditorController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_WalletAvatarCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_WalletAvatarCell.self), for: indexPath) as! CS_WalletAvatarCell
        let model = dataSource[indexPath.row]
        cell.setData(model,selectedUrl: accountInfo?.iconUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        
        if model.status == 1 {
            changeAvatar(model)
        } else {
            let alert = CS_UnlockAvatarAlert()
            alert.showWith(model)
        }
        
    }
    
}


//MARK: request
extension CS_WalletEditorController {
    func requestMyNFTList() {
        
        guard let address = accountInfo?.wallet_address else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
       
        CSNetworkManager.shared.getUserAvatarList(para) { resp in
            if resp.status == .success {
                if weakSelf?.page == 1 {
                    weakSelf?.dataSource.removeAll()
                }
                if let list = resp.data?.list {
                    weakSelf?.dataSource.append(contentsOf: list)
                }
                weakSelf?.emptyStyle = .empty
            } else {
                weakSelf?.emptyStyle = .error
            }
            weakSelf?.collectionView.ls_compeletLoading(true, hasMore: false)
            weakSelf?.collectionView.reloadData()
        }
    }
    
    func changeAvatar(_ model: CS_UserAvatarModel) {
        
        guard let address = accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: accountInfo?.private_key)
        guard let sign = sign else { return }
        LSHUD.showLoading()
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["avatar_id"] = model.avatar_id
        para["nonce"] = nonce
        para["sign"] = sign
        CSNetworkManager.shared.changeAvatar(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let url = URL.init(string: model.image)
                weakSelf?.accountInfo?.iconUrl = model.image
                weakSelf?.accountInfo?.save()
                weakSelf?.avatarIcon.kf.setImage(with: url, placeholder: UIImage.ls_placeHeader())
                if CS_AccountManager.shared.accountInfo?.id == weakSelf?.accountInfo?.id {
                    CS_AccountManager.shared.userInfo?.avatar_image = model.image
                    CS_AccountManager.shared.userInfo?.avatar = model.avatar_id
                }
                
                NotificationCenter.default.post(name: NotificationName.userInfoChanged, object: weakSelf?.accountInfo)
                weakSelf?.collectionView.reloadData()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}

//MARK: action
extension CS_WalletEditorController {
    @objc private func clickStakeButton(_ sender: UIButton) {
        
        guard let name = inputField.text, name.count > 0 else { return }
        
        guard let address = accountInfo?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: accountInfo?.private_key)
        guard let sign = sign else { return }
        LSHUD.showLoading()
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["name"] = name
        para["nonce"] = nonce
        para["sign"] = sign
        CSNetworkManager.shared.changeNickname(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                
                weakSelf?.accountInfo?.nickName = name
                weakSelf?.accountInfo?.save()
                if CS_AccountManager.shared.accountInfo?.id == weakSelf?.accountInfo?.id {
                    CS_AccountManager.shared.userInfo?.name = name
                }
                NotificationCenter.default.post(name: NotificationName.userInfoChanged, object: weakSelf?.accountInfo)
                weakSelf?.dismiss(animated: false)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
}

//MARK: UI
extension CS_WalletEditorController {
    
    private func setupView() {
        titleLabel.text = "Avatar editor".ls_localized
        
        contentView.backgroundColor = .ls_dark_3()
        contentView.addSubview(contentBackView)
        contentBackView.addSubview(avatarIcon)
        contentBackView.addSubview(avatarLabel)
        contentBackView.addSubview(nameLabel)
        contentBackView.addSubview(collectionView)
        contentBackView.addSubview(inputBack)
        contentBackView.addSubview(inputField)
        
        contentBackView.addSubview(stakeButton)
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(482)
            make.height.equalTo(274)
            make.center.equalToSuperview()
        }
        
        contentBackView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(100)
            make.top.equalTo(15)
            make.width.equalTo(370)
            make.height.equalTo(160)
        }
        
        avatarIcon.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(60)
            make.height.width.equalTo(60)
        }
        
        avatarLabel.snp.makeConstraints { make in
            make.centerX.equalTo(avatarIcon)
            make.top.equalTo(avatarIcon.snp.bottom).offset(2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(avatarIcon)
            make.bottom.equalTo(-20)
        }
        
        inputBack.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(collectionView)
            make.width.equalTo(360)
            make.height.equalTo(34)
        }
        
        stakeButton.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(collectionView)
            make.width.equalTo(90)
            make.height.equalTo(34)
        }
        
        inputField.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(inputBack).offset(20)
            make.right.equalTo(stakeButton.snp.left).offset(-20)
            make.height.equalTo(34)
        }
    }
}
