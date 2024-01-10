//
//  MnemonicWordModel.swift
//  Platform
//
//  Created by Lee on 23/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import UIKit

class MnemonicVerifyModel: NSObject {
    var mnemonic: MnemonicWordModel?
    var selected: MnemonicWordModel?
    
    init(_ data: MnemonicWordModel) {
        super.init()
        mnemonic = data
    }
}

struct MnemonicWordModel {
    
    var index: Int = 0
    var word: String = ""
    
    var isVerifySelected = false
    var verifyDisplayIndex: Int = 0
    
}

extension MnemonicWordModel {
    static func mneonicListFrom(_ mneonic: String) -> [MnemonicWordModel] {
        let list = mneonic.components(separatedBy: " ")
        var modelList = [MnemonicWordModel]()
        for (index, element) in list.enumerated() {
            var model = MnemonicWordModel()
            model.index = index + 1
            model.word = element
            modelList.append(model)
        }
        return modelList
    }
}
