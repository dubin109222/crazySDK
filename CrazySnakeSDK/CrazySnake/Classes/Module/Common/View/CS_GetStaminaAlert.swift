//
//  CS_UpgradeLevelAlert.swift
//  CrazySnake
//
//  Created by BigB on 2023/9/27.
//

import UIKit
import SnapKit
import HandyJSON

class StaminaCell: UICollectionViewCell {
    let countLb = UILabel()
    
    var data: NFT_DisPatch_Strength_Prices? {
        didSet {
            countLb.text = "x \(data?.num ?? 0)"
            priceLb.text = "\(data?.price ?? 0)"
            icon.image = .ls_bundle("stamina_icon_\(data?.icon ?? "1")@2x")
            

        }
    }
    

    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = UIColor.ls_color("#FFBB50").cgColor
            } else {
                self.layer.borderColor = UIColor.ls_color("#222222").cgColor
            }
        }
    }
    
    let icon: UIImageView = UIImageView()
    let priceLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        
        icon.image = .ls_bundle("stamina_icon_1@2x")
        self.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.size.equalTo(80)
            make.centerX.equalToSuperview()
        }
        
        countLb.textColor = .white
        countLb.font = .ls_JostRomanRegularFont(12)
        self.addSubview(countLb)
        countLb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
        }
        
        priceLb.textColor = .white
        priceLb.font = .ls_JostRomanFont(12)
        priceLb.text = "0"
        self.addSubview(priceLb)
        priceLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(10)
            make.top.equalTo(icon.snp.bottom).offset(4)
        }
        
        
        let coinIcon = UIImageView()
        coinIcon.image = .ls_bundle("icon_token_gascoin@2x")
        self.addSubview(coinIcon)

        coinIcon.snp.makeConstraints { make in
            make.size.equalTo(14)
            make.right.equalTo(priceLb.snp.left).offset(-2)
            make.centerY.equalTo(priceLb)
        }
        
      
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CS_GetStaminaAlert: CS_BaseAlert {
    
    // 创建一个倒计时定时器
    var timer: DispatchSourceTimer?

    // 倒计时时间
    var remainingSeconds: Int = 0 
    
    var data : NFT_DisPatch_DataModel? {
        didSet {
            staminaValue = "\(data?.strength?.balance ?? 0)"
            self.collectionView.reloadData()
            self.collectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
            if ((data?.strength?.recover_time ?? 0) > 0) {
                let min = self.remainingSeconds  / 60
                let sec = self.remainingSeconds  % 60
                
                self.subTitleLb.text = "\(self.data?.strength?.recover_speed ?? 1) points of stamina restored after \(String(format: "%02d", min)):\(String(format: "%02d", sec))"
                
                // 判断定时器是否启动，如果没有启动则启动定时器。倒计时时间为recover_time
                if timer == nil {
                    remainingSeconds = data?.strength?.recover_time ?? 0
                    timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
                    timer?.schedule(deadline: .now(), repeating: .seconds(1))
                    timer?.setEventHandler(handler: { [weak self] in
                        if self?.remainingSeconds == 0 {
                            self?.timer?.cancel()
                            self?.timer = nil
                            
                            // 请求网络数据
                            self?.loadData()
                            
                        } else {
                            self?.remainingSeconds -= 1
                            DispatchQueue.main.async {
                                // remainingSeconds 转换成 MM:SS 格式,并显示在subTitleLb上,以2位数显示
                                let min = (self?.remainingSeconds ?? 1) / 60
                                let sec = (self?.remainingSeconds ?? 1) % 60
                                self?.subTitleLb.text = "\(self?.data?.strength?.recover_speed ?? 1) points of stamina restored after \(String(format: "%02d", min)):\(String(format: "%02d", sec))"

                            }
                        }
                    })
                    timer?.resume()
                }
                
            } else {
                self.subTitleLb.text = "Stamina is full"
            }


            
        }
    }
    
    var staminaValue: String = "" {
        didSet {
            self.titleLb.text = "Current Strength:\(staminaValue)"
        }
    }
    
    let confirmBtn = UIButton(type: .custom)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(366)
            make.height.equalTo(258)
        }
        

        self.initSubViews()
        closeButton.isHidden = false

    }
    
    public func loadData() {
        
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else {
            return
        }
        
        CSNetworkManager.shared.getDispatchParams(address) { (model: NFT_DisPatch_DataModel) in
            self.data = model
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func dismissSelf() {
        // 关闭定时器
        timer?.cancel()
        timer = nil


        super.dismissSelf()
    }
    
    
    lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

        return collectionView
    }()

    // 刷新列表
    var reloadHandle: ((String) -> ())?
    
    @objc func clickConfirmBtn(_ sender : UIButton) {
        // 购买体力值
        struct StrengthData: HandyJSON {
            // 购买后剩余体力
            var strength: String = "0"
            // 购买后剩余gascoin
            var gas_coin_left: String = "0"
        }
        
        if (data?.strength?.balance ?? 0) >= 100 {
            LSHUD.showInfo("The stamina is full,no need to purchase")
        } else {
            guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }

            guard let selectIndex = self.collectionView.indexPathsForSelectedItems?.first?.row else {
                return
            }
            guard let selectData = self.data?.strength?.prices?[selectIndex] else {return}
            
            CSNetworkManager.shared.posDispatchBuyStrength(address, strength: selectData.num) { (respons: StrengthData) in
                LSHUD.showSuccess("ok")
                // 刷新剩余体力
                // 刷新余额gasCoin
                self.staminaValue = respons.strength
                self.reloadHandle?(respons.gas_coin_left)
            }
        }
    }

    let titleLb = UILabel()

    let subTitleLb = UILabel()

    func initSubViews()  {
        
        
        titleLb.text = "Current Strength:"
        titleLb.textColor = .white
        titleLb.font = .ls_JostRomanFont(16)
        
        self.contentView.addSubview(titleLb)
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(18)
        }
        
        subTitleLb.text = "Stamina is full"
        subTitleLb.textColor = .ls_color("#999999")
        subTitleLb.font = .ls_JostRomanFont(11)
        self.contentView.addSubview(subTitleLb)
        subTitleLb.snp.makeConstraints { make in
            make.left.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(10)
        }

        let lineView = UIView()
        lineView.backgroundColor = .ls_color(r: 81, g: 81, b: 81)
        self.contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.right.left.equalTo(titleLb)
            make.top.equalTo(subTitleLb.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        collectionView.backgroundColor = .clear
        collectionView.register(StaminaCell.self, forCellWithReuseIdentifier: "StaminaCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.right.equalTo(titleLb)
            make.bottom.equalToSuperview().offset(-60)
        }
        
        confirmBtn.addTarget(self, action: #selector(clickConfirmBtn(_:)), for: .touchUpInside)
        confirmBtn.setTitle("100", for: .normal)
//        confirmBtn.setImage(.ls_bundle("icon_token_gascoin@2x"), for: .normal)
        do {
            let icon = UIImageView()
            icon.image = .ls_bundle("icon_token_gascoin@2x")
            confirmBtn.addSubview(icon)
            icon.snp.makeConstraints { make in
                make.size.equalTo(24)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            }
        }
        confirmBtn.layer.masksToBounds = true
        confirmBtn.layer.borderWidth = 1
        confirmBtn.layer.cornerRadius = 7
        confirmBtn.layer.borderColor = UIColor.white.cgColor
        self.contentView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 156, height: 34))
            make.bottom.equalToSuperview().offset(-4)
        }

        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.48, green: 0.34, blue: 0.88, alpha: 1).cgColor, UIColor(red: 0.56, green: 0.34, blue: 0.88, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = CGRectMake(0, 0, 156, 34)
        confirmBtn.layer.insertSublayer(gradient1, at: 0)
    }
}


extension CS_GetStaminaAlert : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.strength?.prices?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StaminaCell", for: indexPath) as! StaminaCell
       
        cell.data = self.data?.strength?.prices?[indexPath.row]
       
        
        return cell
    }
}

extension CS_GetStaminaAlert : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! StaminaCell
        confirmBtn.setTitle("\(cell.data?.price ?? 0)", for: .normal)
    }
}


extension CS_GetStaminaAlert: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 102, height: 112)
    }
}
