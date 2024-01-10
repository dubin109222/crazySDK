//
//  CS_SwapGascoinItem.swift
//  CrazyWallet
//
//  Created by BigB on 2023/7/3.
//

import UIKit
import SnapKit


class CS_SwapGascoinItem : UICollectionViewCell {
    var style = CS_SwapGascoinListController.Style.gasCoin
    var data : CS_SwapTokenItem? {
        didSet {
            if data?.is_confirming == 1 {
                self.isConfirmingView.isHidden = false
                self.tokenContentView.isHidden = true
                self.isUserInteractionEnabled = false
            } else {
                self.isConfirmingView.isHidden = true
                self.tokenContentView.isHidden = false
                self.isUserInteractionEnabled = true
            }

            if self.style == .gasCoin {
                self.coinLb.text = data?.gas_coin
                //            self.tokenValue.text = Utils.formatAmount(data?.need_amount)
                self.tokenValue.text = data?.need_snake                
            } else {
                self.coinLb.text = data?.currency_amount
                self.tokenValue.text = data?.token_amount
            }
            self.coinImgView.image = self.data?.currency.icon()
            self.tipLb.text = self.data?.currency.name()
        }
    }
    
    lazy var coinImgView : UIImageView = {
        let coinImgView = UIImageView()
        coinImgView.image = UIImage.init(named: "swap_gascoin_icon")
        return coinImgView
    }()
    

    lazy var coinLb : UILabel = {
        let coinLb = UILabel()
        coinLb.textColor = .white
        coinLb.font = .ls_JostRomanFont(24)
        coinLb.text = "100"
        return coinLb
    }()
    
    lazy var tipLb : UILabel = {
        let tipLb = UILabel()
        tipLb.font = .ls_JostRomanRegularFont(12)
        tipLb.textColor = .ls_color(0xAF81FE)
        tipLb.text = "GasCoin"
        return tipLb
    }()
    
    lazy var tokenValue : UILabel = {
        let tokenValue = UILabel()
        tokenValue.textColor = .white
        tokenValue.font = .ls_JostRomanFont(14)
        return tokenValue
    }()

    let tokenContentView = UIView()
    
    lazy var isConfirmingView: UIView = {
        let isConfirmingView = UIView()
        let tipsLb = UILabel()
        tipsLb.text = "Confirming..."
        tipsLb.font = .ls_JostRomanFont(14)
        tipsLb.textColor = .ls_color(0xAF81FE)

        isConfirmingView.addSubview(tipsLb)
        tipsLb.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return isConfirmingView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .ls_color(0x1e1d20)
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        self.contentView.addSubview(coinImgView)
        coinImgView.contentMode = .scaleAspectFill
        coinImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 77, height: 66.5))
        }
        
        self.contentView.addSubview(coinLb)
        coinLb.snp.makeConstraints { make in
            make.top.equalTo(coinImgView.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(self.tipLb)
        tipLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(coinLb.snp.bottom)
        }
        
        
        tokenContentView.isHidden = true
        tokenContentView.backgroundColor = .ls_color(0x252327)
        tokenContentView.layer.borderColor = UIColor.ls_color(0x444444).cgColor
        tokenContentView.layer.borderWidth = 1
        tokenContentView.layer.masksToBounds = true
        tokenContentView.layer.cornerRadius = 10
        self.contentView.addSubview(tokenContentView)
        tokenContentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(51)
        }
        
        self.contentView.addSubview(self.isConfirmingView)
        isConfirmingView.snp.makeConstraints { make in
            make.edges.equalTo(tokenContentView)
        }

        
        let tokenIcon = UIImageView()
        tokenIcon.contentMode = .scaleAspectFill
        tokenIcon.image = TokenName.Snake.icon()
//        tokenIcon.image = .init(named: "swap_gascoin_icon")
        tokenContentView.addSubview(tokenIcon)
        tokenIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.size.equalTo(22.5)
        }
        
        tokenContentView.addSubview(tokenValue)
        tokenValue.snp.makeConstraints { make in
            make.left.equalTo(tokenIcon.snp.right).offset(12)
            make.bottom.equalTo(tokenIcon.snp.centerY).offset(-3)
        }
        
        
        let tokenName = UILabel()
        tokenName.text = "Snake Token"
        tokenName.textColor = .ls_color(0xf9db1a)
        tokenName.font = .ls_JostRomanRegularFont(12)
        tokenContentView.addSubview(tokenName)
        tokenName.snp.makeConstraints { make in
            make.top.equalTo(tokenValue.snp.bottom).offset(6)
            make.left.equalTo(tokenValue)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

