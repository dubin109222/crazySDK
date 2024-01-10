//
//  CS_NFTPropDetailController.swift
//  CrazySnake
//
//  Created by Lee on 10/03/2023.
//

import UIKit
import Kingfisher

class CS_NFTPropDetailController: CS_BaseAlertController {
    
    var openBoxSuccess: CS_NoParasBlock?
    var prop: CS_NFTPropModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
        setData()
    }
    
    func setData() {
        guard let prop = prop else { return }
        titleLabel.text = prop.props_type.disPlayName()
        imageView.image = prop.props_type.iconImage()
        infotitleLabel.text = prop.props_type.disPlayName()
        infoLabel.text = prop.props_type.displayDesc()
        amountLabel.text = "\(prop.num)"
        useButton.isHidden = !prop.showUseButton()
    }
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.lineBreakMode = .byTruncatingMiddle
        label.text = CS_AccountManager.shared.accountInfo?.wallet_address
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var imageShadowView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 86, height: 9)
        view.backgroundColor = .ls_color("#0E0D11")
        view.ls_cornerRadius(28)
        return view
    }()
    
    lazy var infoBackView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 402*CS_kRate, height: 108))
        view.backgroundColor = .ls_color("#D3BDFF",alpha: 0.2)
        view.ls_addCorner([.topLeft,.bottomLeft], cornerRadius: 15)
        return view
    }()
    
    lazy var infotitleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_white(), .ls_JostRomanFont(16))
        label.text = "Title"
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    lazy var saleBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .ls_color("#D3BDFF",alpha: 0.2)
        view.ls_cornerRadius(12)
        return view
    }()
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle( "nft_icon_prop_amount@2x")
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_color("#FFE063"), .ls_JostRomanFont(19))
        return label
    }()
    
    lazy var saleLabel: UILabel = {
        let label = UILabel()
        label.ls_set(.ls_text_gray(), .ls_JostRomanFont(12))
        label.textAlignment = .center
        label.text = "crazy_str_quantity_for_sale".ls_localized
        return label
    }()
    
    lazy var useButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 160*CS_kRate, height: 40))
        button.addTarget(self, action: #selector(clickUseButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_use".ls_localized, for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var sellButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 160*CS_kRate, height: 40))
        button.ls_cornerRadius(7)
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.addTarget(self, action: #selector(clickSellButton(_:)), for: .touchUpInside)
        button.ls_addColorLayer(.ls_color("#E3803E"), .ls_color("#ED984D"))
        button.setTitle("Sell", for: .normal)
        button.isHidden = true
        return button
    }()
}

//MARK: action
extension CS_NFTPropDetailController {
    @objc private func clickSellButton(_ sender: UIButton) {
        
    }
    
    @objc private func clickUseButton(_ sender: UIButton) {
        let account = CS_AccountManager.shared.accountInfo
        guard let address = account?.wallet_address else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: account?.private_key)
        guard let sign = sign else { return }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["item_id"] = prop?.item_id
        para["num"] = "1"
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.openBox(para) { resp in
            
            if resp.status == .success {
                
                if resp.data.first?.nft?.image != nil && resp.data.first?.nft?.image.isEmpty == false ,
                   let url = URL.init(string: resp.data.first?.nft?.image ?? "") {
                       KingfisherManager.shared.retrieveImage(with: url) { result in
                           switch result {
                           case .success(let imageResult):
                               // 图片加载成功的处理
                               let image = imageResult.image
                               // 在这里使用加载成功的图片进行显示或其他操作
                               LSHUD.hide()
                               NotificationCenter.default.post(name: NotificationName.CS_OpenBoxSuccess, object: nil)
                               weakSelf?.showAlert(resp.data.first)

                           case .failure(let error):
                               // 图片加载失败的处理
                               LSHUD.hide()

                               print("图片加载失败: \(error)")
                           }
                       }
                }
                else if resp.data.first?.prop?.icon != nil && resp.data.first?.prop?.icon.isEmpty == false ,
                        let url = URL.init(string: resp.data.first?.prop?.icon ?? "") {
                    KingfisherManager.shared.retrieveImage(with: url) { result in
                        switch result {
                        case .success(let imageResult):
                            // 图片加载成功的处理
                            let image = imageResult.image
                            // 在这里使用加载成功的图片进行显示或其他操作
                            LSHUD.hide()
                            NotificationCenter.default.post(name: NotificationName.CS_OpenBoxSuccess, object: nil)
                            weakSelf?.showAlert(resp.data.first)

                        case .failure(let error):
                            // 图片加载失败的处理
                            LSHUD.hide()

                            print("图片加载失败: \(error)")
                        }
                    }
                } else {
                    LSHUD.hide()
                    LSHUD.showError(resp.message)
                }
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func showAlert(_ model: CS_OpenBoxModel?){
        let alert = CS_NFTOpenBoxSuccessAlert()
        alert.model = model
        alert.show()
        weak var weakSelf = self
        alert.clickReceiveAction = {
            weakSelf?.openBoxSuccess?()
            weakSelf?.dismiss(animated: false)
        }
    }
}


//MARK: UI
extension CS_NFTPropDetailController {
    
    private func setupView() {
        contentView.addSubview(addressLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(imageShadowView)
        contentView.addSubview(infoBackView)
        contentView.addSubview(infotitleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(saleBackView)
        contentView.addSubview(iconView)
        contentView.addSubview(amountLabel)
        contentView.addSubview(saleLabel)
        contentView.addSubview(sellButton)
        contentView.addSubview(useButton)
        
        titleLabel.snp.remakeConstraints { make in
            make.left.equalTo(contentView).offset(33*CS_kRate)
            make.top.equalTo(contentView).offset(16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(17*CS_kRate)
            make.width.equalTo(97)
            make.height.equalTo(83)
        }
        
        imageShadowView.snp.makeConstraints { make in
            make.centerX.equalTo(imageView).offset(-16)
            make.bottom.equalTo(imageView).offset(6)
            make.width.equalTo(86)
            make.height.equalTo(9)
        }
        
        infoBackView.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.right.equalTo(contentView)
            make.width.equalTo(402*CS_kRate)
            make.height.equalTo(108)
        }
        
        infotitleLabel.snp.makeConstraints { make in
            make.left.equalTo(infoBackView).offset(24)
            make.top.equalTo(infoBackView).offset(13)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(infotitleLabel)
            make.top.equalTo(infotitleLabel.snp.bottom).offset(6)
            make.right.equalTo(infoBackView).offset(-24)
        }
        
        saleBackView.snp.makeConstraints { make in
            make.left.equalTo(21*CS_kRate)
            make.bottom.equalTo(contentView).offset(-27)
            make.width.equalTo(114)
            make.height.equalTo(56)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(saleBackView).offset(18)
            make.top.equalTo(saleBackView).offset(10)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(saleBackView).offset(54)
            make.centerY.equalTo(iconView)
        }
        
        saleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(saleBackView)
            make.bottom.equalTo(saleBackView).offset(-8)
        }
        
        sellButton.snp.makeConstraints { make in
            make.bottom.equalTo(saleBackView)
            make.right.equalTo(infoBackView.snp.centerX).offset(-10*CS_kRate)
            make.width.equalTo(160*CS_kRate)
            make.height.equalTo(40)
        }
        
        useButton.snp.makeConstraints { make in
            make.bottom.height.width.equalTo(sellButton)
            make.left.equalTo(sellButton.snp.right).offset(20*CS_kRate)
        }
    }
}
