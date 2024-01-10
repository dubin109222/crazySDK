//
//  CS_NameDescribeModel.swift
//  CrazySnake
//
//  Created by Lee on 06/04/2023.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CS_NameDescribeModelResp: NSObject{

    var data: [CS_NameDescLanguageModel] = [CS_NameDescLanguageModel]()
    
    init(_ json: JSON) {
        super.init()
        let dataArray = json.arrayValue
        for dataJson in dataArray{
            let value = CS_NameDescLanguageModel(dataJson)
            data.append(value)
        }
    }
}

struct CS_NameDescLanguageModel {
    var language = ""
    var data: [CS_NameDescribeModel] = [CS_NameDescribeModel]()
    
    init(_ json: JSON) {
        language = json["language"].stringValue
        let dataArray = json["data"].rawString()
        if let responseModel = JSONDeserializer<CS_NameDescribeModel>.deserializeModelArrayFrom(json:dataArray) as? [CS_NameDescribeModel] {
            data = responseModel
        }
    }
}

struct CS_NameDescribeModel : HandyJSON {
    var ID = ""
    var name = ""
    var desc = ""
    var type = 0
    var icon: UIImage? = nil

}
