//
//  CS_NewFeatureAlert.swift
//  CrazySnake
//
//  Created by Lee on 28/03/2023.
//

import UIKit

enum CS_NewFeaturePage: String {
    case stakeToken = "CS_NewFuture_StakeToken"
    case labUpgrade = "CS_NewFuture_Upgrade"
    case labEvolution = "CS_NewFuture_Evolution"
    case labRecycle = "CS_NewFuture_Recycle"
    case labIncubation = "CS_NewFuture_Incubation"
    case wallet = "CS_NewFuture_Wallet"
    case stakeNFT = "CS_NewFuture_StakeNFT"
    case market = "CS_NewFuture_Market"
    case guideTask = "CS_NewFuture_GuideTask"
    case firstGuideTask = "CS_NewFuture_FirstGuideTask"
    
    func needShow() -> Bool {
        let show = !UserDefaults.standard.bool(forKey: self.rawValue)
        return show
    }
    
    public func setNeedShow(_ needShow : Bool = true) {
        UserDefaults.standard.set(!needShow, forKey: self.rawValue )
        UserDefaults.standard.synchronize()
    }
    
    
    func contentText() -> String? {
        var content = ""
        switch self {
        case .stakeToken:
            content = "crazy_str_guide_desc".ls_localized
        case .labUpgrade:
            content = "crazy_str_guide_level_up_desc".ls_localized
        case .labEvolution:
            content = "crazy_str_guide_upgrade_desc".ls_localized
        case .labRecycle:
            content = "crazy_str_guide_recycle_desc".ls_localized
        case .labIncubation:
            content = "crazy_str_guide_incubation_desc".ls_localized
        case .wallet:
            content = "crazy_str_guide_wallet_desc".ls_localized
        case .stakeNFT:
            content = "crazy_str_guide_nft_stake_desc".ls_localized
        case .market:
            content = "You can trade with other players in the market, where you can sell or buy freely and smoothly, come on! Crazy Land welcomes you to our family"
        case .guideTask:
            content = "Guide task".ls_localized
            
        case .firstGuideTask:
            content = "Welcome to CrazyLand, where you will experience the charm of web3. Please click on the novice tasks in the upper right corner".ls_localized
        default:
            content = ""
        }
        return content
    }
}

class CS_NewFeatureAlert: CS_BaseAlert {

    var currentPage: CS_NewFeaturePage?
    var clickDoneHandle: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.ls_bundle("icon_newfeature@2x")
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 125, height: 34))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_i_know".ls_localized, for: .normal)
        return button
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .clear
        view.font = .ls_JostRomanFont(12)
        view.textColor = .ls_text_gray()
        view.isEditable = false
//        view.textContainerInset = UIEdgeInsets.init(top: 24, left: 16, bottom: 16, right: 16)
        return view
    }()
}

//MARK: function
extension CS_NewFeatureAlert {
    static func showPage(_ page: CS_NewFeaturePage , clickDoneHandle: (() -> ())? = nil){
        guard page.needShow() == true else {
            return
        }
        let alert = CS_NewFeatureAlert()
        alert.currentPage = page
        alert.textView.text = page.contentText()
        alert.show()
        alert.clickDoneHandle = clickDoneHandle
    }
}


//MARK: action
extension CS_NewFeatureAlert {
    @objc private func clickConfirmButton(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: currentPage?.rawValue ?? "")
        dismissSelf()
        self.clickDoneHandle?()
    }
}


//MARK: UI
extension CS_NewFeatureAlert {
    
    private func setupView() {
        tapDismissEnable = false
        backView.backgroundColor = .ls_black(0.8)
        contentView.backgroundColor = .ls_color("#201D27")
        
        addSubview(iconView)
        contentView.addSubview(textView)
        addSubview(confirmButton)
        
        contentView.snp.remakeConstraints { make in
            make.left.equalTo(80)
            make.right.equalTo(-50)
            make.bottom.equalTo(-45)
            make.height.equalTo(120)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.bottom.equalTo(-37)
            make.width.equalTo(162)
            make.height.equalTo(152)
        }
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(160)
            make.top.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-30)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.bottom)
            make.right.equalTo(contentView).offset(-50)
            make.width.equalTo(125)
            make.height.equalTo(34)
        }
    }
}
