//
//  CS_WalletChooseController.swift
//  CrazyWallet
//
//  Created by Lee on 29/06/2023.
//

import UIKit

class CS_WalletChooseController: CS_WalletPresentController {
    typealias CS_AccountBlock = (AccountModel?) -> Void
    
    var clickImportAction: CS_NoParasBlock?
    var clickAddAction: CS_NoParasBlock?
    var clickSettingAction: CS_AccountBlock?

    private var dataSource = AccountModel.findAccountList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.rowHeight = 74
        view.register(CS_WalletAccountCell.self, forCellReuseIdentifier: NSStringFromClass(CS_WalletAccountCell.self))
        view.backgroundColor = .ls_color("#171718")
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 100, right: 0)
        return view
    }()
    
    lazy var improtButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 168, height: 50))
        button.addTarget(self, action: #selector(clickImportButton(_:)), for: .touchUpInside)
        button.setBackgroundImage(nil, for: .normal)
        button.setTitle("Import Wallet", for: .normal)
        button.backgroundColor = .ls_color("#252428")
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 168, height: 50))
        button.addTarget(self, action: #selector(clickAddButton(_:)), for: .touchUpInside)
        button.setTitle("Add New Wallet", for: .normal)
        return button
    }()
    
}

//MARK: TableView
extension CS_WalletChooseController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CS_WalletAccountCell.self)) as! CS_WalletAccountCell
        let model = dataSource[indexPath.row]
        cell.setData(model,current: CS_AccountManager.shared.accountInfo)
        weak var weakSelf = self
        cell.clickSettingAction = {
            weakSelf?.dismiss(animated: true) {
                weakSelf?.clickSettingAction?(model)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if model.id == CS_AccountManager.shared.accountInfo?.id {
            return
        }
        CSSDKManager.shared.walletLoginType = 1
        CS_AccountManager.shared.accountInfo = model
        UserDefaults.standard.setValue(model.id, forKey: CacheKey.lastSelectedAccountId)
        NotificationCenter.default.post(name: NotificationName.walletChanged, object: model)
        dismiss(animated: true)
    }
}

//MARK: action
extension CS_WalletChooseController {
    @objc private func clickImportButton(_ sender: UIButton) {
        weak var weakSelf = self
        dismiss(animated: true) {
            weakSelf?.clickImportAction?()
        }
    }
    
    @objc private func clickAddButton(_ sender: UIButton) {
        weak var weakSelf = self
        dismiss(animated: true) {
            weakSelf?.clickAddAction?()
        }
    }
}


//MARK: UI
extension CS_WalletChooseController {
    
    private func setupView() {
        navigationView.titleLabel.text = "Choose Wallet".ls_localized
        
        view.addSubview(tableView)
        view.addSubview(improtButton)
        view.addSubview(addButton)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(navigationView.snp.bottom)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(-14)
            make.left.equalTo(view.snp.centerX).offset(5)
            make.width.equalTo(168)
            make.height.equalTo(50)
        }
        
        improtButton.snp.makeConstraints { make in
            make.bottom.width.height.equalTo(addButton)
            make.right.equalTo(addButton.snp.left).offset(-10)
        }
    }
}
