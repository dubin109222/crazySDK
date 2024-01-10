//
//  CS_HomsSocialController.swift
//  CrazySnake
//
//  Created by Lee on 10/04/2023.
//

import UIKit

class CS_HomsSocialController: CS_BaseAlertController {

    private var dataSource = CS_HomeSocialModel.socialList()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: false)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CS_HomeSocialCell.itemSize()
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: CS_kScreenW-2*CS_ms(24), height: 1000), collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.register(CS_HomeSocialCell.self, forCellWithReuseIdentifier: NSStringFromClass(CS_HomeSocialCell.self))
        view.backgroundColor = .clear
        return view
    }()
}

extension CS_HomsSocialController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CS_HomeSocialCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CS_HomeSocialCell.self), for: indexPath) as! CS_HomeSocialCell
        let model = dataSource[indexPath.row]
        cell.setData(model)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        
        if model.code.isEmpty {
            if let url = URL(string: model.link) {
                if model.isWkWebview {
                    guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
                        return
                    }
                    let webVc = WebViewController()
                    webVc.url =  url.absoluteString + "&wallet_address=\(address)"
                    let _ = webVc.view
                    webVc.loadUrl()
                    CrazyPlatform.pushTo(webVc)
                    webVc.navigationView.titleLabel.text = "Customer Service Center".ls_localized

                } else {
                    UIApplication.shared.open(url)
                    dismiss(animated: false)
                }
            }
        } else {
            if model.code == "Voucher" {
                let alertView = CS_VoucherAlert()
                alertView.show()
            }
        }
    }
    
}

//MARK: UI
extension CS_HomsSocialController {
    
    private func setupView() {
//        tapDismissEnable = true
        closeButton.isHidden = true
        contentView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        
        collectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(160*3)
            make.height.equalTo(105*2)
        }
    }
}
