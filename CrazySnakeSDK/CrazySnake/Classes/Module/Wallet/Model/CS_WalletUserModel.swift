//
//  CS_WalletUserModel.swift
//  CrazySnake
//
//  Created by Lee on 18/07/2023.
//

import UIKit
import HandyJSON

class CS_WalletHavePasswordResp: BaseRespModel {
    var data: CS_WalletHavePasswordModel?
}

struct CS_WalletHavePasswordModel : HandyJSON {
    ///  1已设置，0未设置
    var is_set = 0
}

class CS_WalletSetPasswordResp: BaseRespModel {
    var data: CS_WalletSetPasswordModel?
}

struct CS_WalletSetPasswordModel : HandyJSON {
    ///  1成功，其他都是失败
    var success = 0
}
