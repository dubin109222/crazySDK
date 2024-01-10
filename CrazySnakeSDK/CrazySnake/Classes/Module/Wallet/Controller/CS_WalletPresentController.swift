//
//  CS_PresentController.swift
//  CrazyWallet
//
//  Created by Lee on 29/06/2023.
//

import UIKit

class CS_WalletPresentController: CS_WalletBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isPresentVC = true
        view.backgroundColor = .ls_black(0.7)
        backView.backgroundColor = .ls_color("#1E1E20")
        navigationView.changeStyle(.present)
        navigationView.backView.backgroundColor = .ls_color("#1E1E20")
        navigationView.snp.remakeConstraints { make in
            make.top.equalTo(69)
            make.left.right.equalTo(0)
            make.height.equalTo(56)
        }
        
        backView.snp.remakeConstraints { make in
            make.top.equalTo(navigationView)
            make.left.right.bottom.equalTo(0)
        }
    }
    
}
