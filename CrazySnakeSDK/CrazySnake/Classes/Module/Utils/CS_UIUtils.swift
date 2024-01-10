//
//  CS_UIUtils.swift
//  CrazySnake
//
//  Created by Lee on 10/04/2023.
//

import UIKit

class CS_UIUtils: NSObject {

}

extension String {
    func cs_configName() -> String {
        var name = ""
        
        guard let language = CS_AccountManager.shared.nameDescList.first(where: {$0.language == CSSDKManager.shared.language.local()}) else {
            return name
        }
        
        guard let nameModel = language.data.first(where: {$0.ID == self}) else {
            return name
        }
        name = nameModel.name
        return name
    }
}

