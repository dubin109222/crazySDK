//
//  CS_MarketManager.swift
//  CrazySnake
//
//  Created by Lee on 25/04/2023.
//

import UIKit

class CS_MarketManager: NSObject {

    static let shared = CS_MarketManager()
    
    private override init() {
        super.init()
    }
    
    var diamondBalance = ""
    
}
