//
//  CS_SwapOrderHistoryCell.swift
//  CrazyWallet
//
//  Created by BigB on 2023/7/4.
//

import UIKit
import SnapKit

class CS_SwapOrderHistoryCell: UICollectionViewCell {
    
    var clickWithdrawAction: CS_NoParasBlock?

    var data : CS_SwapHistoryModel? {
        didSet {
            self.timeLb.text = (data?.created_at ?? "") + "(UTC)"
            self.fromNameLb.text = TokenName(rawValue: data?.token_in ?? "")?.name()
            self.fromPriceLb.text = Utils.formatAmount(data?.amount_out)
            self.fromIcon.image = TokenName(rawValue: data?.token_in ?? "")?.icon()
            
            self.toNameLb.text = TokenName(rawValue: data?.token_out ?? "")?.name()
            self.toPriceLb.text = Utils.formatAmount(data?.amount_in)
            self.toIcon.image = TokenName(rawValue: data?.token_out ?? "")?.icon()
            
            self.swapBottomView.removeFromSuperview()
            self.swapBottomView = UIView()
            self.contentView.addSubview(swapBottomView)
            swapBottomView.snp.makeConstraints { make in
                make.bottom.left.right.equalToSuperview()
                make.top.equalTo(swapView.snp.bottom)
                
            }

            if data?.status == 0 {
                self.swapBottomView.addSubview(self.processView)
                self.processView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else if data?.status == 1 {
                self.swapBottomView.addSubview(self.finishView)
                self.finishView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }

            } else if data?.status == 2 {
                self.swapBottomView.addSubview(self.failedView)
                self.failedView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else if data?.status == 3{
                self.swapBottomView.addSubview(self.claimView)
                if self.isLandscape() {
                    self.claimView.snp.makeConstraints { make in
                        make.right.top.bottom.equalToSuperview()
                        make.width.equalTo(175)
                    }
                } else {
                    self.claimView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                }
                
            }
        }
    }
    
    // MARK: - Lazy
    // MARK: Swap Top View
    lazy var tipsLb : UILabel = {
        let tipsLb = UILabel()
        tipsLb.text = "crazy_str_data_of_swap".ls_localized
        tipsLb.textColor = .ls_color(0x999999)
        tipsLb.font = .ls_JostRomanRegularFont(12)
        return tipsLb
    }()
    
    lazy var timeLb: UILabel = {
        let timeLb = UILabel()
        timeLb.text = "2023 - 03 - 15  20:20:20"
        timeLb.font = .ls_JostRomanRegularFont(12)
        timeLb.textColor = .ls_color(0x999999)
        return timeLb
    }()
    
    // MARK: Swap View
    
    lazy var swapView : UIView = {
        let swapView = UIView()
        
        if self.isLandscape() {
            // 分割线
            let line = UIView()
            line.backgroundColor = .init(white: 1, alpha: 0.1)
            line.isHidden = true
            swapView.addSubview(line)
            line.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(1)
                make.top.bottom.equalToSuperview()
            }
            
            // 分割箭头
            let downIcon = UIImageView()
            downIcon.image = UIImage.ls_bundle("swap_right_icon@2x")
            swapView.addSubview(downIcon)
            downIcon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 17, height: 11))
            }
            
            
            swapView.addSubview(fromIcon)
            fromIcon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(17)
                make.size.equalTo(32)
            }
            
            swapView.addSubview(fromNameLb)
            fromNameLb.snp.makeConstraints { make in
                make.left.equalTo(fromIcon.snp.right).offset(8.5)
                make.top.equalTo(fromIcon).offset(3.5)
            }
            
            swapView.addSubview(fromNameDesLb)
            fromNameDesLb.snp.makeConstraints { make in
    //            make.bottom.equalTo(fromIcon).offset(-3)
                make.top.equalTo(fromNameLb.snp.bottom).offset(3)
                make.left.equalTo(fromNameLb)
            }
            
            swapView.addSubview(fromPriceLb)
            fromPriceLb.snp.makeConstraints { make in
                make.right.equalTo(line.snp.left).offset(-28)
                make.centerY.equalToSuperview()
            }
            
            let payLb = UILabel()
            payLb.text = "crazy_str_pay".ls_localized
            payLb.textColor = .ls_color(0x999999)
            payLb.font = .ls_JostRomanRegularFont(12)
            swapView.addSubview(payLb)
            payLb.snp.makeConstraints { make in
                make.right.equalTo(fromPriceLb.snp.left).offset(-9.5)
                make.centerY.equalToSuperview()
            }
            
            swapView.addSubview(toIcon)
            toIcon.snp.makeConstraints { make in
                make.left.equalTo(downIcon.snp.right).offset(17)
                make.centerY.equalToSuperview()
                make.size.equalTo(32)
            }
            
            swapView.addSubview(toNameLb)
            toNameLb.snp.makeConstraints { make in
                make.left.equalTo(toIcon.snp.right).offset(8.5)
                make.top.equalTo(toIcon).offset(3.5)
            }
            
            swapView.addSubview(toNameDesLb)
            toNameDesLb.snp.makeConstraints { make in
    //            make.bottom.equalTo(toIcon).offset(-3)
                make.top.equalTo(toNameLb.snp.bottom).offset(3)
                make.left.equalTo(toNameLb)
            }
            
            swapView.addSubview(toPriceLb)
            toPriceLb.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-21.5)
                make.centerY.equalToSuperview()
            }
            
            let getLb = UILabel()
            getLb.text = "crazy_str_get".ls_localized
            getLb.textColor = .ls_color(0x999999)
            getLb.font = .ls_JostRomanRegularFont(12)
            swapView.addSubview(getLb)
            getLb.snp.makeConstraints { make in
                make.right.equalTo(toPriceLb.snp.left).offset(-9.5)
                make.centerY.equalToSuperview()
            }

        } else {
            // 分割线
            let line = UIView()
            line.backgroundColor = .init(white: 1, alpha: 0.1)
            swapView.addSubview(line)
            line.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15.5)
                make.width.equalTo(136)
                make.height.equalTo(1)
            }
            
            // 分割箭头
            let downIcon = UIImageView()
            downIcon.image = UIImage(named: "swap_down_icon@2x")
            swapView.addSubview(downIcon)
            downIcon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(27.5)
                make.size.equalTo(CGSize.init(width: 11, height: 17))
            }
            
            
            swapView.addSubview(fromIcon)
            fromIcon.snp.makeConstraints { make in
                make.bottom.equalTo(downIcon.snp.top).offset(-12.5)
                make.left.equalToSuperview().offset(17)
                make.size.equalTo(32)
            }
            
            swapView.addSubview(fromNameLb)
            fromNameLb.snp.makeConstraints { make in
                make.left.equalTo(fromIcon.snp.right).offset(8.5)
                make.top.equalTo(fromIcon).offset(3.5)
            }
            
            swapView.addSubview(fromNameDesLb)
            fromNameDesLb.snp.makeConstraints { make in
    //            make.bottom.equalTo(fromIcon).offset(-3)
                make.top.equalTo(fromNameLb.snp.bottom).offset(3)
                make.left.equalTo(fromNameLb)
            }
            
            swapView.addSubview(fromPriceLb)
            fromPriceLb.snp.makeConstraints { make in
                make.right.equalTo(line)
                make.bottom.equalTo(line.snp.top).offset(-26.5)
            }
            
            let payLb = UILabel()
            payLb.text = "crazy_str_pay".ls_localized
            payLb.textColor = .ls_color(0x999999)
            payLb.font = .ls_JostRomanRegularFont(12)
            swapView.addSubview(payLb)
            payLb.snp.makeConstraints { make in
                make.right.equalTo(fromPriceLb.snp.left).offset(-9.5)
                make.centerY.equalTo(fromPriceLb).offset(3)
            }
            
            swapView.addSubview(toIcon)
            toIcon.snp.makeConstraints { make in
                make.top.equalTo(downIcon.snp.bottom).offset(12.5)
                make.left.equalToSuperview().offset(17)
                make.size.equalTo(32)
            }
            
            swapView.addSubview(toNameLb)
            toNameLb.snp.makeConstraints { make in
                make.left.equalTo(toIcon.snp.right).offset(8.5)
                make.top.equalTo(toIcon).offset(3.5)
            }
            
            swapView.addSubview(toNameDesLb)
            toNameDesLb.snp.makeConstraints { make in
    //            make.bottom.equalTo(toIcon).offset(-3)
                make.top.equalTo(toNameLb.snp.bottom).offset(3)
                make.left.equalTo(toNameLb)
            }
            
            swapView.addSubview(toPriceLb)
            toPriceLb.snp.makeConstraints { make in
                make.right.equalTo(line)
                make.top.equalTo(line.snp.bottom).offset(26.5)
            }
            
            let getLb = UILabel()
            getLb.text = "crazy_str_get".ls_localized
            getLb.textColor = .ls_color(0x999999)
            getLb.font = .ls_JostRomanRegularFont(12)
            swapView.addSubview(getLb)
            getLb.snp.makeConstraints { make in
                make.right.equalTo(toPriceLb.snp.left).offset(-9.5)
                make.centerY.equalTo(toPriceLb).offset(-3)
            }

        }
        


        
        return swapView
    }()

    lazy var fromIcon : UIImageView = {
        let fromIcon = UIImageView()
        fromIcon.image = .init(named: "icon_token_gascoin")
        return fromIcon
    }()
    
    lazy var fromNameLb: UILabel = {
        let fromNameLb = UILabel()
        fromNameLb.font = .ls_JostRomanFont(14)
        fromNameLb.textColor = .white
        return fromNameLb
    }()
    
    lazy var fromNameDesLb: UILabel = {
        let fromNameDesLb = UILabel()
        fromNameDesLb.font = .ls_JostRomanRegularFont(12)
        fromNameDesLb.textColor = .ls_color(0x999999)
        return fromNameDesLb
    }()
    
    lazy var fromPriceLb: UILabel = {
        let fromPriceLb = UILabel()
        fromPriceLb.font = .ls_JostRomanFont(24)
        fromPriceLb.textColor = .white
        return fromPriceLb
    }()
    
    lazy var toIcon : UIImageView = {
        let toIcon = UIImageView()
        toIcon.image = .init(named: "icon_token_gascoin")
        return toIcon
    }()
    
    lazy var toNameLb: UILabel = {
        let toNameLb = UILabel()
        toNameLb.font = .ls_JostRomanFont(14)
        toNameLb.textColor = .white
        return toNameLb
    }()
    
    lazy var toNameDesLb: UILabel = {
        let toNameDesLb = UILabel()
        toNameDesLb.font = .ls_JostRomanRegularFont(12)
        toNameDesLb.textColor = .ls_color(0x999999)
        return toNameDesLb
    }()
    
    lazy var toPriceLb: UILabel = {
        let toPriceLb = UILabel()
        toPriceLb.font = .ls_JostRomanFont(24)
        toPriceLb.textColor = .white
        return toPriceLb
    }()

    
    
    // MARK: Swap Bottom View
    var swapBottomView = UIView()
    
    @objc func clickHelpBtn(_ sender : UIButton) {
        if let model = self.data {
            if model.progress_type == 1 {
                let alert = CS_SwapProgress3Alert()
                alert.setData(model)
                alert.show()
            } else if model.progress_type == 2 {
                let alert = CS_SwapProgress5Alert()
                alert.setData(model)
                alert.show()
            }
        }

    }
    
    // 0进行中，1已完成，2已失败，3可领取
    // 进行中
    lazy var processView : UIView = {
        let processView = UIView()
        
        let processLb = UILabel()
        processLb.text = "In Process...."
        processLb.textColor = .ls_color(0x999999)
        processLb.font = .ls_JostRomanRegularFont(12)
        processView.addSubview(processLb)
        processLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        let processIcon = UIImageView()
        processIcon.image = UIImage.ls_bundle("Swap_process_icon@2x")
        processView.addSubview(processIcon)
        processIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(12)
            make.right.equalTo(processLb.snp.left).offset(-6)
        }
        
        let processHelpBtn = UIButton(type: .custom)
        processHelpBtn.setImage(UIImage.ls_bundle("Swap_cell_help@2x"), for: .normal)
//        processHelpBtn.setImage(UIImage.init(systemName: "info.circle"), for: .normal)
        
        processHelpBtn.addTarget(self, action: #selector(clickHelpBtn(_:)), for: .touchUpInside)
        processView.addSubview(processHelpBtn)
        processHelpBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(processHelpBtn.snp.height)
        }
        return processView
    }()
    // 已完成
    lazy var finishView: UIView = {
        let finishView = UIView()
        let finishLb = UILabel()
        finishLb.text = "crazy_str_finished".ls_localized
        finishLb.textColor = .ls_color(0x999999)
        finishLb.font = .ls_JostRomanRegularFont(12)
        finishView.addSubview(finishLb)
        finishLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        let finishIcon = UIImageView()
        finishIcon.image = UIImage.init(named: "swap_cell_finish")
        finishView.addSubview(finishIcon)
        finishIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(12)
            make.right.equalTo(finishLb.snp.left).offset(-6)
        }
        return finishView
    }()
    
    // 已失败
    lazy var failedView: UIView = {
        let failedView = UIView()
        let failedLb = UILabel()
        failedLb.text = "crazy_str_failed".ls_localized
        failedLb.textColor = .ls_color(0x999999)
        failedLb.font = .ls_JostRomanRegularFont(12)
        failedView.addSubview(failedLb)
        failedLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        let failedIcon = UIImageView()
        failedIcon.image = UIImage.init(named: "swap_cell_failed")
        failedView.addSubview(failedIcon)
        failedIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(12)
            make.right.equalTo(failedLb.snp.left).offset(-6)
        }

        return failedView
    }()
    // 可领取
    lazy var claimView: UIView = {
        let claimBtn = UIButton(type: .custom)
        claimBtn.setTitle("Claim".ls_localized, for: .normal)
        claimBtn.titleLabel?.font = .ls_JostRomanFont(16)
        claimBtn.setTitleColor(.white, for: .normal)
        claimBtn.addTarget(self, action: #selector(clickStatusButton(_:)), for: .touchUpInside)
        
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.45, green: 0.3, blue: 0.9, alpha: 1).cgColor, UIColor(red: 0.64, green: 0.3, blue: 0.9, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        if self.isLandscape() {
            gradient1.frame = CGRectMake(0, 0, 175, 34)
        } else {
            gradient1.frame = CGRectMake(0, 0, 335, 34)
        }
        
        claimBtn.layer.insertSublayer(gradient1, at: 0)
        
        return claimBtn
    }()

    @objc private func clickStatusButton(_ sender: UIButton) {
        clickWithdrawAction?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.contentView.backgroundColor =  .ls_color(0x1b1b1b)
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        swapView.backgroundColor = .ls_color(0x212122)

        if self.isLandscape() {
            
            self.contentView.addSubview(swapView)
            swapView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(33.5)
                make.bottom.equalToSuperview().offset(-34)
            }

            
            let swapTopView = UIView()
            self.contentView.addSubview(swapTopView)
            swapTopView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(swapView.snp.top)
            }
            
            swapTopView.addSubview(tipsLb)
            tipsLb.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(17)
                make.top.equalToSuperview().offset(10.5)
            }
            
            swapTopView.addSubview(timeLb)
            timeLb.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalTo(tipsLb)
            }
            
            
            self.contentView.addSubview(swapBottomView)
            swapBottomView.snp.makeConstraints { make in
                make.bottom.left.right.equalToSuperview()
                make.top.equalTo(swapView.snp.bottom)
                
            }

        } else {
            self.contentView.addSubview(swapView)
            swapView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(33.5)
                make.bottom.equalToSuperview().offset(-34)
            }

            
            let swapTopView = UIView()
            self.contentView.addSubview(swapTopView)
            swapTopView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(swapView.snp.top)
            }
            
            swapTopView.addSubview(tipsLb)
            tipsLb.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(17)
                make.top.equalToSuperview().offset(10.5)
            }
            
            swapTopView.addSubview(timeLb)
            timeLb.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalTo(tipsLb)
            }
            
            
            self.contentView.addSubview(swapBottomView)
            swapBottomView.snp.makeConstraints { make in
                make.bottom.left.right.equalToSuperview()
                make.top.equalTo(swapView.snp.bottom)
                
            }
        }
    }
    
 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
