//
//  CS_GweiGasAlertController.swift
//  CrazySnake
//
//  Created by BigB on 2023/12/10.
//

import UIKit

class CS_GweiGasAlertController: CS_BaseAlertController {
    var clickConfirmAction: CS_NoParasBlock?

    var showTitle = ""
    var current_gwei : Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        self.gweiValue = current_gwei
    }
    
    
    
      
    
    lazy var cancelBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 140, height: 40))
        button.ls_cornerRadius(7)
        button.ls_addColorLayer(.ls_color("#E3803E"), .ls_color("#E3803E"))
        button.titleLabel?.font = .ls_JostRomanFont(16)
        button.setTitleColor(.ls_white(), for: .normal)
        button.addTarget(self, action: #selector(clickCancelBtn(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_cancel".ls_localized, for: .normal)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 140, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_confirm".ls_localized, for: .normal)
        return button
    }()
    
    lazy var iknowBtn: UIButton = {
        let button = UIButton.purposeLayerButton(CGRect(x: 0, y: 0, width: 140, height: 40))
        button.addTarget(self, action: #selector(clickConfirmButton(_:)), for: .touchUpInside)
        button.setTitle("crazy_str_i_know".ls_localized, for: .normal)
        button.isHidden = true
        return button
    }()

    
    lazy var titleDesLb: UILabel = {
        let titleDesLb = UILabel()
        titleDesLb.font = .ls_JostRomanFont(12)
        titleDesLb.text = """
Detected high Gwei on the chain, which will greatly increase Gas Coin expenses. It is recommended that you conduct transactions when the transaction cost is low.
"""
        titleDesLb.textColor = .white
        titleDesLb.numberOfLines = 0
        return titleDesLb
    }()
    
    lazy var gweiTitleLb: UILabel = {
        let label = UILabel()
        label.text = "Current Gwei Index: "
        label.font = .ls_JostRomanFont(12)
        label.textColor = .ls_color("#999999")
        label.numberOfLines = 0
        return label
    }()
    
    lazy var gweiValueLb: UILabel = {
        let label = UILabel()
        label.font = .ls_JostRomanFont(16)
        label.numberOfLines = 0
        return label
    }()
    
    var gweiValue : Double = 0 {
        didSet {
            gweiValueLb.text = "\(gweiValue)"
            switch gweiValue {
            case 0...100 :
                self.gweiValueLb.textColor = .ls_color("#9BFF87")
            case 100...300 :
                self.gweiValueLb.textColor = .ls_color("#FFE187")
            default :
                self.gweiValueLb.textColor = .ls_color("#FF8787")
            }
        }
    }

    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    lazy var queryBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Gwei Query", for: .normal)
        btn.titleLabel?.font = .ls_JostRomanRegularFont(12)
        btn.addTarget(self, action: #selector(clickQueryBtn), for: .touchUpInside)
        btn.setTitleColor(.white, for: .normal)
        btn.setImage(.ls_bundle("_gwei_search@2x"), for: .normal)
        btn.ls_layout(.imageLeft)
        btn.backgroundColor = .ls_color("#302B3B")
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 12
        return btn
    }()

}

//MARK: action
extension CS_GweiGasAlertController {
    @objc private func clickCancelBtn(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @objc private func clickConfirmButton(_ sender: UIButton) {
        dismiss(animated: false)
        clickConfirmAction?()
    }
}

//MARK: action
extension CS_GweiGasAlertController {
    @objc func clickQueryBtn() {
        if let url = URL.init(string: "https://polygonscan.com/gastracker") {
            UIApplication.shared.open(url)
        }
    }
}



//MARK: UI
extension CS_GweiGasAlertController {
    
    private func setupView() {
        titleLabel.text = showTitle
        contentView.backgroundColor = .ls_color("#201D27")
        contentView.addSubview(cancelBtn)
        contentView.addSubview(confirmButton)
        contentView.addSubview(iknowBtn)

        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(450)
            make.height.equalTo(351)
        }
        
        iknowBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-15 - 70)
            make.bottom.equalTo(-15)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.width.height.equalTo(cancelBtn)
            make.left.equalTo(cancelBtn.snp.right).offset(30)
        }
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(titleDesLb)
        scrollView.addSubview(gweiTitleLb)
        scrollView.addSubview(gweiValueLb)
        scrollView.addSubview(queryBtn)

        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-13)
        }
        
        titleDesLb.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-22)
            make.width.equalTo(450 - 44)
        }
        gweiTitleLb.snp.makeConstraints { make in
            make.top.equalTo(titleDesLb.snp.bottom).offset(20)
            make.left.equalTo(titleDesLb)
            make.height.greaterThanOrEqualTo(10)
        }
        gweiValueLb.snp.makeConstraints { make in
            make.centerY.equalTo(gweiTitleLb)
            make.left.equalTo(gweiTitleLb.snp.right)
            make.height.greaterThanOrEqualTo(12)
        }
        queryBtn.snp.makeConstraints { make in
            make.left.equalTo(gweiValueLb.snp.right).offset(6)
            make.right.lessThanOrEqualTo(-13)
            make.size.equalTo(CGSize(width: 102, height: 24))
            make.centerY.equalTo(gweiValueLb)
        }
        
        // tips
        let tips1 = CS_GweiGasAlertController.createTipsLb(imgName: "_gwei_low_icon@2x", tips: "Low transaction costs < ", value: "100", valueColor: "#9BFF87")
        let tips2 = CS_GweiGasAlertController.createTipsLb(imgName: "_gwei_medium_icon@2x", tips: "Medium cost transactions < ", value: "300", valueColor: "#FFE187")
        let tips3 = CS_GweiGasAlertController.createTipsLb(imgName: "_gwei_high_icon@2x", tips: "High cost transactions > ", value: "300", valueColor: "#FF8787")
        
        scrollView.addSubview(tips1)
        scrollView.addSubview(tips2)
        scrollView.addSubview(tips3)

        tips1.snp.makeConstraints { make in
            make.top.equalTo(gweiValueLb.snp.bottom).offset(25)
            make.left.right.equalTo(titleDesLb)
            make.height.equalTo(16)
        }
        tips2.snp.makeConstraints { make in
            make.top.equalTo(tips1.snp.bottom).offset(10)
            make.left.right.equalTo(titleDesLb)
            make.height.equalTo(16)
        }
        tips3.snp.makeConstraints { make in
            make.top.equalTo(tips2.snp.bottom).offset(10)
            make.left.right.equalTo(titleDesLb)
            make.height.equalTo(16)
        }

        scrollView.layoutIfNeeded()
        
        scrollView.contentSize = CGSize(width: 250, height: tips3.frame.maxY + 10)
        
    }
}

extension CS_GweiGasAlertController {
    // MARK: 创建一行提示
    public static func createTipsLb(imgName: String , tips: String , value: String , valueColor: String) -> UIView {
        
        let tipsView = UIView()
        
        let icon = UIImageView()
        icon.image = .ls_bundle(imgName)
        
        let tipsLb = UILabel()
        tipsLb.textColor = .white
        tipsLb.font = .ls_JostRomanRegularFont(12)
        tipsLb.text = tips
        let attrText = NSMutableAttributedString(string: tips)
        
        let valueAttr = NSAttributedString(string: value, attributes: [.foregroundColor: UIColor.ls_color(valueColor)])
        attrText.append(valueAttr)
        tipsLb.attributedText = attrText
        
        let valueLb = UILabel()
        valueLb.font = .ls_JostRomanRegularFont(12)
        valueLb.text = value
        valueLb.textColor = .ls_color(valueColor)
        
        tipsView.addSubview(icon)
        tipsView.addSubview(tipsLb)
        tipsView.addSubview(valueLb)
        
        icon.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        
        tipsLb.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(5.5)
            make.centerY.equalTo(icon)
            make.right.equalTo(-13)
            make.top.bottom.equalToSuperview()
        }
        
        return tipsView
    }
}
