//
//  CS_OpenBoxModel.swift
//  CrazySnake
//
//  Created by Lee on 29/03/2023.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CS_OpenBoxResp: BaseRespModel{

    var data: [CS_OpenBoxModel] = [CS_OpenBoxModel]()
}

struct CS_OpenBoxModel: HandyJSON {
    /// 1, 类型1nft，2道具
    var type = 1
    var nft: CS_NFTDataModel?
    var prop: CS_NFTPropModel?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.nft <-- "detail"
        mapper <<< self.prop <-- "detail"
    }
}

