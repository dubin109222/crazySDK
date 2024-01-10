//
//  SendInfoView.swift
//  Platform
//
//  Created by Lee on 29/04/2022.
//  Copyright © 2022 ELFBOX. All rights reserved.
//

import UIKit

class SendInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var sendAmountTitle :UILabel = {
        let lab = UILabel()
        lab.text = "crazy_str_transfer_out_amount".ls_localized
        lab.textColor = .ls_text_gray()
        lab.font = .ls_JostRomanFont(12)
        return lab
    }()
    
    lazy var sendAmountLabel :UILabel = {
        let lab = UILabel()
        lab.text = "--"
        lab.textColor = .ls_green()
        lab.font = .ls_JostRomanFont(16)
        return lab
    }()

    lazy var gasFeeTitle :UILabel = {
        let lab = UILabel()
        lab.text = "crazy_str_gas_fee".ls_localized
        lab.textColor = .ls_text_gray()
        lab.font = .ls_JostRomanFont(12)
        return lab
    }()
    
    lazy var gasFeeAmount :UILabel = {
        let lab = UILabel()
        lab.text = "--"
        lab.textColor = .ls_color("#D3AD64")
        lab.font = .ls_JostRomanFont(16)
        return lab
    }()
    
    lazy var gasFeeUnitTitle :UILabel = {
        let lab = UILabel()
        lab.text = "crazy_str_matic".ls_localized
        lab.textColor = .ls_text_gray()
        lab.font = .ls_JostRomanFont(12)
        return lab
    }()
}

//MARK: UI
extension SendInfoView {
    
    private func setupView() {
        
        addSubview(sendAmountTitle)
        addSubview(sendAmountLabel)
        addSubview(gasFeeTitle)
        addSubview(gasFeeAmount)

        sendAmountTitle.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(10)
        }
        
        sendAmountLabel.snp.makeConstraints { make in
            make.left.equalTo(sendAmountTitle)
            make.top.equalTo(sendAmountTitle.snp.bottom).offset(6)
            make.right.equalTo(self.snp.centerX).offset(0)
        }
        
        gasFeeTitle.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(10)
            make.top.equalTo(sendAmountTitle)
        }
        
        gasFeeAmount.snp.makeConstraints { make in
            make.left.equalTo(gasFeeTitle)
            make.top.equalTo(sendAmountLabel)
        }
    }
}
