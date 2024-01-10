//
//  Arrary+Extension.swift
//  Platform
//
//  Created by Lee on 23/09/2021.
//  Copyright © 2021 Saving. All rights reserved.
//

import Foundation

extension Array{
    public func shuffle() -> Array {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count-index))) + index
            if index != newIndex {
                list.swapAt(index, newIndex)
            }
        }
        return list
    }
    
    func ls_objectAt(_ index: Int) -> Any? {
        if index < self.count {
            return self[index]
        }
        return nil
    }
}
