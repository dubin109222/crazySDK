//
//  CS_ShareWithdrawGasAlertController.swift
//  CrazySnake
//
//  Created by Lee on 08/08/2023.
//

import UIKit

class CS_ShareWithdrawGasAlertController: CS_EstimateGasAlertController {

    var token = ""
    var amount = ""
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func requestGas() {
        
        weak var weakSelf = self
        LSHUD.showLoading()
        CSNetworkManager.shared.shareWithdrawGasPrice(token, amount: amount, wallet: address) { resp in
            LSHUD.hide()
            if resp.status == .success {
                if let gas = resp.data {
                    weakSelf?.gasPrice = gas
                    weakSelf?.setData()
                }
            } else {
                LSHUD.showError(resp.message)
            }
        }
    }

}
