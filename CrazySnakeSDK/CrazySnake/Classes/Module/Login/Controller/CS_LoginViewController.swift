//
//  CS_LoginViewController.swift
//  CrazySnake
//
//  Created by BigB on 2023/12/11.
//

import UIKit
import SnapKit

enum LoginType : CaseIterable{
    case apple
    case google
    case facebook
    case twitter
    
    var title: String {
        switch self {
        case .apple:
            return "Apple"
        case .google:
            return "Google"
        case .facebook:
            return "Facebook"
        case .twitter:
            return "Twitter"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .apple:
            return .ls_bundle("_login_apple@2x")
        case .google:
            return .ls_bundle("_login_google@2x")
        case .facebook:
            return .ls_bundle("_login_facebook@2x")
        case .twitter:
            return .ls_bundle("_login_twitter@2x")
        }
    }
    
    var url: String {
        switch self {
        case .apple:
            return "apple"
        case .google:
            return "google"
        case .facebook:
            return "facebook"
        case .twitter:
            return "twitter"
        }
    }
    
    
        
    
}

class CS_LoginCollectionCell: UICollectionViewCell {
    
    var data: LoginType = .apple {
        didSet {
            self.iconView.image = data.icon
            self.titleLb.text = data.title
        }
    }
    
    
    var iconView: UIImageView = UIImageView()
    var titleLb: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLb.textColor = .white
        self.titleLb.font = .ls_JostRomanFont(16)
        
        self.backgroundColor = .ls_color("#232337")
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalTo(18)
            make.centerY.equalToSuperview()
        }
        self.contentView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CS_LoginViewController: CS_BaseController {

    

    let loginList: [LoginType] = LoginType.allCases

    lazy var collctionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 280, height: 50)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 28
        layout.scrollDirection = .vertical
        
        let collctionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collctionView.backgroundColor = UIColor.clear
        collctionView.showsHorizontalScrollIndicator = false
        collctionView.showsVerticalScrollIndicator = false
        collctionView.register(CS_LoginCollectionCell.self, forCellWithReuseIdentifier: "CS_LoginCollectionCell")
        collctionView.delegate = self
        collctionView.dataSource = self
        return collctionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.backView.image = nil
        self.backView.backgroundColor = .ls_color("#181824")
        
        self.navigationView.backView.image = nil
        self.navigationView.backgroundColor = .clear
        
        navigationView.titleLabel.text = "Crypto wallet Trusted by millions".ls_localized
        
        // 阅读协议
        
        let readLb = UILabel()
        readLb.text = "Please see our User".ls_localized
        readLb.textAlignment = .center
        readLb.textColor = .ls_color("#7E7EA7")
        readLb.font = .ls_JostRomanFont(11)

//    https://assets.crazyland.io/common/game/1/privacy_notice.html
//    https://assets.crazyland.io/common/game/1/terms_of_service.html
        let serviceAgreementBtn = UIButton(type: .custom)
        serviceAgreementBtn.setTitle(" <Service Agreement> ", for: .normal)
        serviceAgreementBtn.titleLabel?.textColor = .white
        serviceAgreementBtn.titleLabel?.font = .ls_JostRomanFont(11)
        
        let andLb = UILabel()
        andLb.text = "and".ls_localized
        andLb.textAlignment = .center
        andLb.textColor = .ls_color("#7E7EA7")
        andLb.font = .ls_JostRomanFont(11)
        
        let privacyPolicyBtn = UIButton(type: .custom)
        privacyPolicyBtn.setTitle(" <Privacy Policy> ", for: .normal)
        privacyPolicyBtn.titleLabel?.textColor = .white
        privacyPolicyBtn.titleLabel?.font = .ls_JostRomanFont(11)

        let readStackView = UIStackView(arrangedSubviews: [readLb,serviceAgreementBtn,andLb,privacyPolicyBtn])
        readStackView.isHidden = true
        self.view.addSubview(readStackView)
        readStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-CS_ms(23))
            make.height.equalTo(20)
        }
        


        // 导入钱包按钮
        let importWalletBtn = UIButton(type: .custom)
        importWalletBtn.setTitle("Import Wallet".ls_localized, for: .normal)
        importWalletBtn.setTitleColor(UIColor.white, for: .normal)
        importWalletBtn.titleLabel?.font = UIFont.ls_JostRomanFont(16)
        importWalletBtn.backgroundColor = UIColor.ls_color("#202030")
        importWalletBtn.layer.cornerRadius = 10
        importWalletBtn.layer.masksToBounds = true
        importWalletBtn.addTarget(self, action: #selector(clickImportBtn(_:)), for: .touchUpInside)
        self.view.addSubview(importWalletBtn)
        importWalletBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(readLb.snp.top).offset(-17.5)
            make.width.equalTo(178)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }

        let lineTips = UILabel()
        lineTips.text = "Third party login"
        lineTips.textColor = .ls_color("#7E7EA7")
        lineTips.font = .ls_JostRomanRegularFont(12)
        self.view.addSubview(lineTips)
        lineTips.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(importWalletBtn.snp.top).offset(-18)
        }
        
        let line1 = UIView()
        line1.backgroundColor = .ls_color("#7E7EA7")
        self.view.addSubview(line1)
        line1.snp.makeConstraints { make in
            make.centerY.equalTo(lineTips)
            make.right.equalTo(lineTips.snp.left).offset(-30)
            make.height.equalTo(1)
            make.width.equalTo(100)
        }
        
        let line2 = UIView()
        line2.backgroundColor = .ls_color("#7E7EA7")
        self.view.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.centerY.equalTo(lineTips)
            make.left.equalTo(lineTips.snp.right).offset(30)
            make.height.equalTo(1)
            make.width.equalTo(100)
        }

        // 三方登陆，collectionview
        self.view.addSubview(collctionView)
        collctionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(CS_ms(47))
            make.width.equalTo(590)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(importWalletBtn.snp.top).offset(-20)
        }
    }
    
    @objc func clickImportBtn(_ sender : UIButton ) {
        CrazyPlatform.toImportWalletController()
    }
}


extension CS_LoginViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.loginList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CS_LoginCollectionCell", for: indexPath) as! CS_LoginCollectionCell
        cell.data = self.loginList[indexPath.row]
        return cell
    }
}

extension CS_LoginViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let loginStyle = self.loginList[indexPath.row]
        let url = LSNetwork.shared.hostAddress + "/v2/api/oauth2/" + loginStyle.url 
        let vc = CS_LoginWebView()
        vc.url = url
        let _ = vc.view
        vc.loadUrl()
        self.pushTo(vc)
    
    }
}

extension CS_LoginViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 280, height: 50)
    }
}
