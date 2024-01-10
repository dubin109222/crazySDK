//
//  CS_SwapDetailInfoController.swift
//  CrazyWallet
//
//  Created by BigB on 2023/7/3.
//

import Foundation
import SnapKit
import UIKit
import JXSegmentedView

class SwapInfoView : UIView {
    
    var data : TokenName? {
        didSet {
            swapTagIcon.image = data?.icon()
//            swapTagLb.text = data?.token?.name()
            swapTagLb.setTitle(data?.name(), for: .normal)
            swapTagLb.ls_layout(.imageRight)

            swapTagDesLb.text = Config.chain.name
            
            let token = CS_AccountManager.shared.coinTokenList.first(where: {$0.token == data})
            balanceLb.text = "crazy_str_balance_".ls_localized + Utils.formatAmount(token?.balance ?? "0")
            balanceIcon.image = data?.icon()


        }
    }
    

    
    // 标签 Pay/Get
    lazy var tipLb : UILabel = {
        let tipLb = UILabel()
        tipLb.textColor = UIColor.ls_color(0x999999)
        tipLb.font = .ls_JostRomanRegularFont(12)
        return tipLb
    }()
    
    //  余额
    lazy var balanceLb : UILabel = {
        let balanceLb = UILabel()
        balanceLb.textColor = .ls_color(0xCCCCCC)
        balanceLb.font = .ls_JostRomanRegularFont(12)
        return balanceLb
    }()

    lazy var balanceIcon : UIImageView = {
        let balanceIcon = UIImageView()
        balanceIcon.contentMode = .scaleAspectFill
        return balanceIcon
    }()
    
    // 货币
    lazy var swapTagIcon : UIImageView = {
        let swapTagIcon = UIImageView()
        swapTagIcon.contentMode = .scaleAspectFill
        return swapTagIcon
    }()
    
    lazy var swapTagLb : UIButton = {
        let swapTagLb = UIButton(type: .custom)
        swapTagLb.setImage(UIImage.ls_named("icon_arrow_down@2x"), for: .normal)
        swapTagLb.setTitle("", for: .normal)
        swapTagLb.contentHorizontalAlignment = .left;
        swapTagLb.titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)
        swapTagLb.addTarget(self, action: #selector(clickChooseTokenHandle(_:)), for: .touchUpInside)

        swapTagLb.titleLabel?.font = .ls_JostRomanFont(18)
        swapTagLb.titleLabel?.textColor = .ls_color(0xFFFFFF)
        return swapTagLb
    }()
    
    lazy var swapTagDesLb : UILabel = {
        let swapTagDesLb = UILabel()
        swapTagDesLb.textColor = .ls_color(0x999999)
        swapTagDesLb.font = .ls_JostRomanRegularFont(12)
        return swapTagDesLb
    }()
    
    // 兑换的金额
    lazy var swapInputView : UITextField = {
        let swapInputView = UITextField()
        swapInputView.font = .ls_JostRomanFont(24)
        swapInputView.placeholder = "0.00"
        swapInputView.textColor = .white
        swapInputView.keyboardType = .decimalPad
        swapInputView.textAlignment = .right
        swapInputView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return swapInputView
    }()
    
    lazy var swapInputPriceLb : UILabel = {
        let swapInputPriceLb = UILabel()
        swapInputPriceLb.font = .ls_JostRomanRegularFont(12)
        swapInputPriceLb.textColor = .ls_color(0x999999)
        return swapInputPriceLb
    }()
    
    var inputChange: ((String?) -> Void)?

    @objc private func textFieldDidChange(_ field: UITextField) {
        inputChange?(field.text)
    }
    
    var chooseTokenHandle: ((CGRect) -> ())?
    @objc func clickChooseTokenHandle(_ sender : UIButton) {
        if let buttonFrameInWindow = sender.superview?.convert(sender.frame, to: nil) {
            self.chooseTokenHandle?(buttonFrameInWindow)
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // landscape
        if self.isLandscape() {
            
            // 标签 Pay/Get
            self.addSubview(tipLb)
            tipLb.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(23)
                make.top.equalToSuperview().offset(20)
            }
            
            //  余额
            self.addSubview(balanceLb)
            balanceLb.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(18)
                make.right.equalToSuperview().offset(-32)
            }
            
            self.addSubview(balanceIcon)
            balanceIcon.snp.makeConstraints { make in
                make.centerY.equalTo(balanceLb)
                make.size.equalTo(12)
                make.right.equalTo(balanceLb.snp.left).offset(-5)
            }
            
            // 货币
            self.addSubview(swapTagIcon)
            swapTagIcon.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-21)
                make.left.equalToSuperview().offset(20)
                make.size.equalTo(32)
            }
            
            self.addSubview(swapTagLb)
            swapTagLb.snp.makeConstraints { make in
                make.top.equalTo(swapTagIcon)
                make.left.equalTo(swapTagIcon.snp.right).offset(8.5)
                make.height.equalTo(13.5)
            }
            
            self.addSubview(swapTagDesLb)
            swapTagDesLb.snp.makeConstraints { make in
                make.top.equalTo(swapTagLb.snp.bottom).offset(5.6)
                make.left.equalTo(swapTagLb)
            }
            
            // 兑换的金额
            self.addSubview(swapInputView)
            swapInputView.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-32.5)
                make.top.equalTo(swapTagIcon).offset(-2)
                make.left.equalTo(swapTagLb.snp.right).offset(20)
                make.height.equalTo(19)
                make.width.greaterThanOrEqualTo(120)
            }
            
            self.addSubview(swapInputPriceLb)
            swapInputPriceLb.snp.makeConstraints { make in
                make.right.equalTo(swapInputView)
                make.top.equalTo(swapInputView.snp.bottom)
            }

        } else { // portrait
            // 标签 Pay/Get
            self.addSubview(tipLb)
            tipLb.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(23)
                make.top.equalToSuperview().offset(20)
            }
            
            //  余额
            self.addSubview(balanceLb)
            balanceLb.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(19.5)
                make.right.equalToSuperview().offset(-20)
            }
            
            self.addSubview(balanceIcon)
            balanceIcon.snp.makeConstraints { make in
                make.centerY.equalTo(balanceLb)
                make.size.equalTo(12)
                make.right.equalTo(balanceLb.snp.left).offset(-5)
            }
            
            // 货币
            self.addSubview(swapTagIcon)
            swapTagIcon.snp.makeConstraints { make in
                make.top.equalTo(tipLb.snp.bottom).offset(27)
                make.left.equalToSuperview().offset(20)
                make.size.equalTo(32)
            }
            
            self.addSubview(swapTagLb)
            swapTagLb.snp.makeConstraints { make in
                make.top.equalTo(swapTagIcon)
                make.left.equalTo(swapTagIcon.snp.right).offset(8.5)
            }
            
            self.addSubview(swapTagDesLb)
            swapTagDesLb.snp.makeConstraints { make in
                make.top.equalTo(swapTagLb.snp.bottom).offset(2)
                make.left.equalTo(swapTagLb)
            }
            
            // 兑换的金额
            self.addSubview(swapInputView)
            swapInputView.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-20)
                make.top.equalTo(swapTagIcon)
                make.left.equalTo(swapTagLb.snp.right).offset(20)
                make.height.equalTo(19)
            }
            
            self.addSubview(swapInputPriceLb)
            swapInputPriceLb.snp.makeConstraints { make in
                make.right.equalTo(swapInputView)
                make.top.equalTo(swapInputView.snp.bottom)
            }

        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CS_SwapDetailInfoController: CS_BaseController {
    
    private func registerNotication(){
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletChange(_:)), name: NotificationName.walletChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyWalletInfoChange(_:)), name: NotificationName.walletBalanceChanged, object: nil)
    }
    
    
    @objc private func notifyWalletInfoChange(_ notify: Notification) {
        self.updateUI()
    }

    
    @objc private func notifyWalletChange(_ notify: Notification) {
        self.updateUI()
    }

    
    lazy var paySwapInfoView : SwapInfoView = {
        let infoView = SwapInfoView(frame: .zero)
        weak var weakSelf = self
        infoView.inputChange = { text in
            weakSelf?.changeGetSwapTextfield(payAmount: text)
        }
        infoView.chooseTokenHandle = { frame in
            weakSelf?.showChangeAlert(true,buttonFrame: frame)
        }
        return infoView
    }()
    
    lazy var getSwapInfoView : SwapInfoView = {
        let infoView = SwapInfoView(frame: .zero)
        weak var weakSelf = self

        infoView.inputChange = { text in
            self.changePaySwapTextfield(payAmount: text)
        }
        infoView.chooseTokenHandle = { frame in
            weakSelf?.showChangeAlert(false,buttonFrame: frame)
        }

        return infoView
    }()

    // 1pay = ratioGet
    var payRatio = ""
    // ratioPay = 1Get
    var getRatio = ""

    
    lazy var payView : UIView = {
        let payView = UIView()
        
        let bgImgView = UIImageView()
        bgImgView.image = UIImage.init(named: "swap_info_bg_top")
        payView.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let contentView = self.paySwapInfoView
        payView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentView.tipLb.text = "crazy_str_pay".ls_localized
        
        return payView
    }()
    
    func showChangeAlert(_ isTop: Bool, buttonFrame : CGRect) {
        let alert = CS_SwapSelectTokenAlert()
        alert.deselected = [self.swapConfig?.from ?? .Snake, self.swapConfig?.to ?? .Snake]
        
        alert.show { make in
            make.top.equalTo(buttonFrame.origin.y)
            make.left.equalTo(buttonFrame.origin.x)
            make.width.equalTo(140)
            make.height.equalTo(100)
        }
        
        weak var weakSelf = self
        alert.selecedToken = { token in
            weakSelf?.tokenChange(token, isPay: isTop)
            
        }
    }
    
    private func tokenChange(_ token: TokenName , isPay: Bool ) {
        if isPay {
            if overtrunStatus == false {
                if token == self.swapConfig?.to {
                    let temp = self.swapConfig?.from
                    self.swapConfig?.to = temp
                }
                self.swapConfig?.from = token
            } else {
                if token == self.swapConfig?.from {
                    let temp = self.swapConfig?.to
                    self.swapConfig?.from = temp
                }
                self.swapConfig?.to = token
            }
        } else {
            if overtrunStatus == true {
                if token == self.swapConfig?.to {
                    let temp = self.swapConfig?.from
                    self.swapConfig?.to = temp
                }
                self.swapConfig?.from = token
            } else {
                if token == self.swapConfig?.from {
                    let temp = self.swapConfig?.to
                    self.swapConfig?.from = temp
                }

                self.swapConfig?.to = token
            }
        }
        self.updateUI()
        self.requestPrice()

    }

    
    lazy var getView : UIView = {
        let getView = UIView()
        
        let bgImgView = UIImageView()
        bgImgView.image = UIImage.init(named: "swap_info_bg_bottom")
        getView.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let contentView = self.getSwapInfoView
        getView.addSubview(contentView)
        
        if self.isLandscape() {
            
            contentView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        } else {
            contentView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview()
            }
        }

        contentView.tipLb.text = "crazy_str_get".ls_localized
        
        return getView
    }()
    
    // 刷新按钮
    lazy var reloadBtn : UIButton = {
        let reloadBtn = UIButton.init(type: .custom)
        reloadBtn.setImage(UIImage.ls_bundle("swap_info_reload@2x"), for: .normal)
        reloadBtn.backgroundColor = .ls_color(0x252428)
        reloadBtn.layer.masksToBounds = true
        reloadBtn.layer.cornerRadius = 10
        reloadBtn.addTarget(self, action: #selector(reloadData), for: .touchUpInside)
        return reloadBtn
    }()
    
    @objc func reloadData() {
        CS_AccountManager.shared.loadTokenBlance()
        self.overtrunStatus = false
        self.requestWelfareInfo()
    }
    
    // 确认兑换
    lazy var confirmSwapBtn : UIButton = {
        let confirmSwapBtn = UIButton(type: .custom)
        confirmSwapBtn.setTitle("crazy_str_confirm_swap".ls_localized, for: .normal)
        confirmSwapBtn.titleLabel?.font = .ls_JostRomanFont(16)
        confirmSwapBtn.frame = CGRect(x: 0, y: 0, width: 231, height: 50)
        confirmSwapBtn.layer.masksToBounds = true
        confirmSwapBtn.layer.cornerRadius = 10
        confirmSwapBtn.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)

        
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.45, green: 0.3, blue: 0.9, alpha: 1).cgColor, UIColor(red: 0.64, green: 0.3, blue: 0.9, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = confirmSwapBtn.bounds
        confirmSwapBtn.layer.insertSublayer(gradient1, at: 0)
        return confirmSwapBtn
    }()
    
    @objc private func clickConfirmButton(_ sender: UIButton) {
        view.endEditing(true)
        guard let amount = paySwapInfoView.swapInputView.text, Double(amount) ?? 0 > 0 else {
            return
        }
        guard let contract = CS_AccountManager.shared.basicConfig?.contract?.swapper else {
            return
        }
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        
        let token = paySwapInfoView.data
        var swapType = CS_SwapType.SnakeToUSDT
        if token == .USDT {
            swapType = .USDTToSnake
            
            let balance = TokenName.USDT.balance()
            guard Double(balance) ?? 0 >= Double(amount) ?? 0 else {
                LSHUD.showError("Insufficient balance".ls_localized)
                return
            }
#if DEBUG
#else
            guard Double(amount) ?? 0 >= 1 else {
                LSHUD.showError("USDT need more than 1U".ls_localized)
                return
            }
#endif
            
        } else {
            let balance = TokenName.Snake.balance()
            guard Double(balance) ?? 0 >= Double(amount) ?? 0 else {
                LSHUD.showError("Insufficient balance".ls_localized)
                return
            }
        }
        
        LSHUD.showLoading()
        weak var weakSelf = self
        CS_ContractSwap.swapIsApproved(swapType: swapType) { isApproved in
            if isApproved {
                weakSelf?.swapEstimateGas(address, contract: contract.contract_address, swapType: swapType)
            } else {
                weakSelf?.approveEstimateGas(address, contract: contract.contract_address,swapType: swapType)
            }
        }
    }
    
    var isMock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationView.isHidden = true
        
        self.backView.image = nil
        self.backView.backgroundColor = .ls_color("#171718")
        
        
        self.initSubViews()
        
        GuideMaskManager.checkGuideState(.swap_detail) { isFinish in
            self.isMock = !isFinish
            self.loadData()
            self.guideStepOne()

        }
    }
    
    func loadData()  {
        requestWelfareInfo()
    }
    
    var amount = 1
    
    // 翻转状态
    var overtrunStatus : Bool = false {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI() {
        if let model = self.swapConfig {
            self.paySwapInfoView.data = overtrunStatus ? model.to : model.from
            self.getSwapInfoView.data = overtrunStatus ? model.from : model.to
            
            if let tokenFrom = model.from ,
               let tokenTo = model.to {
                let from = overtrunStatus ? tokenTo.name() : tokenFrom.name()
                let to = overtrunStatus ? tokenFrom.name() : tokenTo.name()
                let ratio = overtrunStatus ? getRatio : payRatio
                self.overtrunRateBtn.setTitle("1 \(from) = \(Utils.formatAmount(ratio)) \(to)", for: .normal)
                self.overtrunRateBtn.ls_layout(.imageRight)

            }
            
            // pay 输入为基准点
            self.changeGetSwapTextfield(payAmount: self.paySwapInfoView.swapInputView.text)
        }
        

    }
    
    // 计算出得到的值
    private func changeGetSwapTextfield(payAmount : String?) {
        let ratio = overtrunStatus ? getRatio : payRatio
        let text = "\((Double(ratio) ?? 0) * (Double(payAmount ?? "0") ?? 0))"
        self.getSwapInfoView.swapInputView.text = Utils.formatAmount(text)
    }
    // 计算出需要支付的值
    private func changePaySwapTextfield(payAmount : String?) {
        let ratio = overtrunStatus ? payRatio : getRatio
        let text = "\((Double(ratio) ?? 0) * (Double(payAmount ?? "0") ?? 0))"
        self.paySwapInfoView.swapInputView.text = Utils.formatAmount(text)
    }


    func requestWelfareInfo() {
        
        weak var weakSelf = self
        var para :[String:Any] = [:]
        let wallet_address = CS_AccountManager.shared.accountInfo?.wallet_address
        para["wallet_address"] = wallet_address
        
        LSHUD.showLoading()
        CSNetworkManager.shared.getSwapDefaultToken(para) { (resp: CS_SwapConfigModel) in
            weakSelf?.swapConfig = resp
            weakSelf?.updateUI()
            weakSelf?.requestPrice()
        }
    }

    
    var swapConfig: CS_SwapConfigModel?
    
    func requestPrice() {
        guard let model = swapConfig,
              let tokenFrom = model.from ,
              let tokenTo = model.to
        else {
            LSHUD.hide()
            return
        }
        weak var weakSelf = self
        var para :[String:Any] = [:]
        let from = tokenFrom.name()
        let to = tokenTo.name()
        para["from"] = from
        para["to"] = to
        para["amount"] = EthUnitUtils.getWei(amount: "1", token: TokenName(rawValue: tokenFrom.name())!)
        CSNetworkManager.shared.getSwapRatio(para) { resp in
            LSHUD.hide()
            if resp.status == .success,let model = resp.data {
                self.updateUI()
                let ratio = EthUnitUtils.getAmount(wei: model.ratio, token: tokenTo)
                weakSelf?.payRatio = ratio ?? "0"
                weakSelf?.overtrunRateBtn.setTitle("1 \(from) = \(Utils.formatAmount(ratio)) \(to)", for: .normal)
                weakSelf?.overtrunRateBtn.ls_layout(.imageRight)

            }
        }

        var getPara :[String:Any] = [:]
        let getFrom = tokenTo.name()
        let getTo = tokenFrom.name()
        getPara["from"] = getFrom
        getPara["to"] = getTo
        getPara["amount"] = EthUnitUtils.getWei(amount: "1", token: TokenName(rawValue: tokenTo.name())!)

        CSNetworkManager.shared.getSwapRatio(getPara) { resp in
            LSHUD.hide()
            if resp.status == .success,let model = resp.data {
                self.updateUI()
                let ratio = EthUnitUtils.getAmount(wei: model.ratio, token: tokenFrom)
                weakSelf?.getRatio = ratio ?? "0"
            }
        }
    }
    

    // 汇率比例计算
    let overtrunRateBtn = UIButton(type: .custom)

    @objc func clickOverturnBtn(_ sender : UIButton) {
        self.overtrunStatus.toggle()
    }
    
    private func initSubViews() {
        
        if self.isLandscape() {
            
            
            self.payView.backgroundColor = UIColor.ls_color("#1F1F20")
            self.getView.backgroundColor = UIColor.ls_color("#1F1F20")

            self.view.addSubview(payView)
            payView.snp.makeConstraints { make in
                make.left.equalTo(CS_ms(30))
                make.top.equalToSuperview().offset(20)
                make.right.equalTo(self.view.snp.centerX).offset(-5)
                make.height.equalTo(106)
            }
            
            self.view.addSubview(getView)
            getView.snp.makeConstraints { make in
                make.left.equalTo(self.view.snp.centerX).offset(5)
                make.right.equalToSuperview().offset(-20)
                make.top.equalToSuperview().offset(20)
                make.height.equalTo(106)
            }
            
            let overtrunBtn = UIButton(type: .custom)
            overtrunBtn.setImage(UIImage.ls_bundle("swap_info_overturn_landscape@2x"), for: .normal)
            overtrunBtn.addTarget(self, action: #selector(clickOverturnBtn(_:)), for: .touchUpInside)
            self.view.addSubview(overtrunBtn)
            
            overtrunBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(payView)
                make.size.equalTo(50)
            }
            
            
            let hStackView = UIStackView()

            hStackView.alignment = .center
            hStackView.spacing = 20
            hStackView.addSubview(reloadBtn)
            hStackView.addSubview(confirmSwapBtn)
            self.view.addSubview(hStackView)
            hStackView.snp.makeConstraints { make in
                make.top.equalTo(payView.snp.bottom).offset(15)
                make.centerX.equalToSuperview()
                make.width.equalTo(335)
                make.height.equalTo(50)
            }
            
            reloadBtn.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 84, height: 50))
                make.left.equalToSuperview()
            }
            
            confirmSwapBtn.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 231, height: 50))
                make.right.equalToSuperview()
            }
            
            // 翻转汇率
            

            overtrunRateBtn.titleLabel?.font = .ls_JostRomanRegularFont(12)
            overtrunRateBtn.setTitleColor(.ls_color(0x999999), for: .normal)
            overtrunRateBtn.addTarget(self, action: #selector(clickOverturnBtn(_:)), for: .touchUpInside)
            overtrunRateBtn.setImage(.ls_bundle("swap_overtrun_btn@2x"), for: .normal)
            overtrunRateBtn.ls_layout(.imageRight)
            self.view.addSubview(overtrunRateBtn)
            overtrunRateBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(hStackView.snp.bottom).offset(20)
                make.height.equalTo(20)
            }
            
            
            
            // line
            let line = UIView()
            line.backgroundColor = .white.withAlphaComponent(0.1)
            self.view.addSubview(line)
            line.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(overtrunRateBtn.snp.bottom).offset(10)
                make.height.equalTo(1)
            }
            
            let slippageHStack = UIStackView()
            slippageHStack.axis = .horizontal
            slippageHStack.alignment = .center
            slippageHStack.spacing = 10
            self.view.addSubview(slippageHStack)
            slippageHStack.translatesAutoresizingMaskIntoConstraints = false
            slippageHStack.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 5).isActive = true
            slippageHStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            

            
            let slippageLb = UILabel()
            slippageLb.text = "crazy_str_slippage".ls_localized
            slippageLb.font = .ls_JostRomanRegularFont(12)
            slippageLb.textColor = .ls_color(0x999999)
            slippageHStack.addArrangedSubview(slippageLb)
            slippageLb.translatesAutoresizingMaskIntoConstraints = false
            slippageLb.leftAnchor.constraint(equalTo: slippageHStack.leftAnchor).isActive = true
            
            
            let slippageValue = UILabel()
            slippageValue.text = "0.5%"
            slippageValue.textColor = .ls_color(0x17f179)
            slippageValue.font = .ls_JostRomanFont(16)
            slippageHStack.addArrangedSubview(slippageValue)
            slippageValue.translatesAutoresizingMaskIntoConstraints = false
            slippageValue.leftAnchor.constraint(equalTo: slippageLb.rightAnchor,constant: 22.5).isActive = true
            slippageValue.centerYAnchor.constraint(equalTo: slippageHStack.centerYAnchor).isActive = true

            
            let gasfeeLb = UILabel()
            gasfeeLb.text = "crazy_str_fees".ls_localized
            gasfeeLb.font = .ls_JostRomanRegularFont(12)
            gasfeeLb.textColor = .ls_color(0x999999)
            slippageHStack.addArrangedSubview(gasfeeLb)
            gasfeeLb.translatesAutoresizingMaskIntoConstraints = false
            gasfeeLb.centerYAnchor.constraint(equalTo: slippageHStack.centerYAnchor).isActive = true
            gasfeeLb.leftAnchor.constraint(equalTo: slippageValue.rightAnchor,constant: 87).isActive = true

            
            let gasfeeValue = UILabel()
            gasfeeValue.text = "0.2%"
            gasfeeValue.font = .ls_JostRomanFont(16)
            gasfeeValue.textColor = .white
            slippageHStack.addArrangedSubview(gasfeeValue)
            gasfeeValue.translatesAutoresizingMaskIntoConstraints = false
            gasfeeValue.rightAnchor.constraint(equalTo: slippageHStack.rightAnchor).isActive = true
            gasfeeValue.centerYAnchor.constraint(equalTo: slippageHStack.centerYAnchor).isActive = true
            gasfeeValue.leftAnchor.constraint(equalTo: gasfeeLb.rightAnchor,constant: 32).isActive = true




        } else {
            self.view.addSubview(payView)
            payView.snp.makeConstraints { make in
                make.left.top.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(117)
            }
            
            self.view.addSubview(getView)
            getView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.top.equalTo(payView.snp.bottom).offset(11.5)
                make.height.equalTo(117)
            }
            
            let overtrunBtn = UIButton(type: .custom)
            overtrunBtn.setImage(UIImage.ls_bundle("swap_info_overturn_portrait@2x"), for: .normal)
            overtrunBtn.addTarget(self, action: #selector(clickOverturnBtn(_:)), for: .touchUpInside)
            self.view.addSubview(overtrunBtn)
            
            overtrunBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(payView.snp.bottom).offset(5.5)
                make.size.equalTo(51.5)
            }
            
            self.view.addSubview(reloadBtn)
            reloadBtn.snp.makeConstraints { make in
                make.top.equalTo(getView.snp.bottom).offset(30)
                make.left.equalTo(getView)
                make.size.equalTo(CGSize(width: 84, height: 50))
            }
            
            self.view.addSubview(confirmSwapBtn)
            confirmSwapBtn.snp.makeConstraints { make in
                make.top.equalTo(getView.snp.bottom).offset(30)
                make.right.equalTo(getView)
                make.size.equalTo(CGSize(width: 231, height: 50))
            }
            
            // 翻转汇率
            

            overtrunRateBtn.titleLabel?.font = .ls_JostRomanRegularFont(12)
            overtrunRateBtn.setTitleColor(.ls_color(0x999999), for: .normal)
            overtrunRateBtn.addTarget(self, action: #selector(clickOverturnBtn(_:)), for: .touchUpInside)
            overtrunRateBtn.setImage(.ls_bundle("swap_overtrun_btn@2x"), for: .normal)
            overtrunRateBtn.ls_layout(.imageRight)
            self.view.addSubview(overtrunRateBtn)
            overtrunRateBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(reloadBtn.snp.bottom).offset(10)
                make.height.equalTo(30)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            
            
            
            // line
            let line = UIView()
            line.backgroundColor = .white
            self.view.addSubview(line)
            line.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(overtrunRateBtn.snp.bottom).offset(10)
                make.height.equalTo(1)
            }
            
            let slippageLb = UILabel()
            slippageLb.text = "crazy_str_slippage".ls_localized
            slippageLb.font = .ls_JostRomanRegularFont(12)
            slippageLb.textColor = .ls_color(0x999999)
            self.view.addSubview(slippageLb)
            slippageLb.snp.makeConstraints { make in
                make.top.equalTo(line.snp.bottom).offset(16.5)
                make.left.equalToSuperview().offset(25)
            }
            
            let slippageValue = UILabel()
            slippageValue.text = "0.5%"
            slippageValue.textColor = .ls_color(0x17f179)
            slippageValue.font = .ls_JostRomanFont(16)
            self.view.addSubview(slippageValue)
            slippageValue.snp.makeConstraints { make in
                make.centerY.equalTo(slippageLb)
                make.right.equalToSuperview().offset(-20)
            }
            
            
            let gasfeeLb = UILabel()
            gasfeeLb.text = "crazy_str_fees".ls_localized
            gasfeeLb.font = .ls_JostRomanRegularFont(12)
            gasfeeLb.textColor = .ls_color(0x999999)
            self.view.addSubview(gasfeeLb)
            gasfeeLb.snp.makeConstraints { make in
                make.top.equalTo(slippageLb.snp.bottom).offset(25)
                make.left.equalToSuperview().offset(25)
            }
            
            let gasfeeValue = UILabel()
            gasfeeValue.text = "0.2%"
            gasfeeValue.font = .ls_JostRomanFont(16)
            gasfeeValue.textColor = .white
            self.view.addSubview(gasfeeValue)
            gasfeeValue.snp.makeConstraints { make in
                make.centerY.equalTo(gasfeeLb)
                make.right.equalToSuperview().offset(-20)
            }

        }
        
        
        
    }
}

extension CS_SwapDetailInfoController {
    func guideStepOne() {
        if self.isMock {
            self.paySwapInfoView.swapInputView.text = "0"
            
            let maskRect = self.paySwapInfoView.swapInputView.convert(self.paySwapInfoView.swapInputView.bounds, to: nil)
            weak var weakSelf = self
            GuideMaskView.show (tipsText: "Enter the number of TOKEN to be redeemed.",
                                currentStep: "1",
                                totalStep: "2",
                                maskRect: maskRect,
                                textWidthDefault: 223,
                                direction: .left){
                // 去掉第二步
//                weakSelf?.guideStepTwo()
                weakSelf?.guideStepThree()
            } skipHandle: {
                weakSelf?.guideStepEnd()
            }
        }
    }
    
    func guideStepTwo() {
        let maskRect = self.getSwapInfoView.swapInputView.convert(self.getSwapInfoView.swapInputView.bounds, to: nil)
        weak var weakSelf = self
        GuideMaskView.show (tipsText: "Enter the number of TOKEN acquired.",
                            currentStep: "2",
                            totalStep: "3",
                            maskRect: maskRect,
                            textWidthDefault: 223,
                            direction: .right){
            weakSelf?.guideStepThree()
            
            
        } skipHandle: {
            weakSelf?.guideStepEnd()
        }
    }
    
    func guideStepThree() {
        let maskRect = self.confirmSwapBtn.convert(self.confirmSwapBtn.bounds, to: nil)
        weak var weakSelf = self
        GuideMaskView.show (tipsText: "Click the button to confirm swap.",
                            currentStep: "2",
                            totalStep: "2",
                            maskRect: maskRect,
                            textWidthDefault: 223,
                            direction: .down){
            
            weakSelf?.guideStepEnd()
        } skipHandle: {
            weakSelf?.guideStepEnd()
        }
    }
    
    func guideStepEnd() {
        GuideMaskManager.saveGuideState(.swap_detail)
        self.isMock = false
    }
}

extension CS_SwapDetailInfoController {
    // 兑换逻辑 - copy之前的
    func approveEstimateGas(_ address: String, contract: String, swapType: CS_SwapType){
        let encodeData = CS_ContractApprove.encodeDataTokenApprove(to: contract) ?? ""
        let para = CS_ContractApprove.estimateTokenApprovePara(to: contract)
        weak var weakSelf = self
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "Approve"
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    weakSelf?.approve(address, contract: contract, swapType: swapType, funcHash: encodeData)
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func approve(_ address: String, contract: String, swapType: CS_SwapType, funcHash: String){
        weak var weakSelf = self
        LSHUD.showLoading()
        CS_ContractSwap.approve(swapType: swapType, funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
                weakSelf?.swapEstimateGas(address, contract: contract, swapType: swapType)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func swapEstimateGas(_ address: String, contract: String,swapType: CS_SwapType) {
        
        let amount = paySwapInfoView.swapInputView.text ?? "0"
        let amountOut = "\((Double(getSwapInfoView.swapInputView.text ?? "0") ?? 0) * 0.95)"
        let encodeData = CS_ContractSwap.shared.encodeDataSwapToken(swapType: swapType, amount: amount, amountOutMin: amountOut) ?? ""
        let para = CS_ContractSwap.shared.swapTokenPara(swapType: swapType, amount: "\(amount)", amountOutMin: amountOut)
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.getEstimateGasByName(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                let vc = CS_EstimateGasAlertController()
                vc.showTitle = "Swap".ls_localized
                vc.gasPrice = resp.data
                vc.contractAddress = contract
                vc.para = para
                weakSelf?.present(vc, animated: false)
                vc.clickConfirmAction = {
                    if swapType == .SnakeToUSDT {
                        weakSelf?.swapTokenToUSDT(address, contract: contract)
                    } else {
                        weakSelf?.swap(address, contract: contract,gasPrice: resp.data?.gas, swapType: swapType, funcHash: encodeData)
                    }
                }
            } else if resp.status != .gas_limit {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func swap(_ address: String, contract: String,gasPrice: String?,swapType: CS_SwapType, funcHash: String){
        LSHUD.showLoading()
        let amount = paySwapInfoView.swapInputView.text ?? "0"
        var amountOut = "\((Double(getSwapInfoView.swapInputView.text ?? "0") ?? 0) * 0.95)"
        amountOut = Utils.formatAmount(amountOut)
        CS_ContractSwap.shared.swapToken(gasPrice:gasPrice,swapType: swapType, amount: amount, amountOutMin: amountOut, funcHash: funcHash) { resp in
            LSHUD.hide()
            if resp.code == 0 {
                LSHUD.showInfo(resp.message)
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
    
    func swapTokenToUSDT(_ address: String, contract: String){
        guard let address = CS_AccountManager.shared.accountInfo?.wallet_address else { return }
        guard let contractName = CS_AccountManager.shared.basicConfig?.contract?.current_token.first?.contract_name else { return }
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        let amount = paySwapInfoView.swapInputView.text ?? "0"
        var amountOut = "\((Double(getSwapInfoView.swapInputView.text ?? "0") ?? 0) * 0.95)"
        amountOut = Utils.formatAmount(amountOut)
        let amountInWei = EthUnitUtils.getWei(amount: "\(amount)", token: .Snake)
        let amountOutWei = EthUnitUtils.getWei(amount: amountOut, token: .USDT)
        var para :[String:Any] = [:]
        para["wallet_address"] = address
        para["contract_name"] = contractName
        para["amount_in"] = amountInWei
        para["amount_out"] = amountOutWei
        para["pool_fee"] = "3000"
        para["nonce"] = nonce
        para["sign"] = sign
        LSHUD.showLoading()
        CSNetworkManager.shared.swapTokenToUSDT(para) { resp in
            LSHUD.hide()
            if resp.status == .success {
                LSHUD.showInfo(resp.message)
                CS_AccountManager.shared.loadTokenBlance()
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }
}


extension CS_SwapDetailInfoController : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
