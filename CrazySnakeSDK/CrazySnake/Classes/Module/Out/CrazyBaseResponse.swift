//
//  CrazyBaseResponse.swift
//  CrazySnake
//
//  Created by Lee on 10/05/2023.
//

import UIKit

@objc open class CrazyBaseResponse: NSObject {
    
    
    /// 200: success
    @objc public var status: Int = 200
    @objc public var message: String?
    @objc public var data: Any?
    
    
    static func response(_ status:Int,message: String, content: Any? = nil, _ response: @escaping((CrazyBaseResponse) -> ())) {
        DispatchQueue.main.async {
            let result = CrazyBaseResponse()
            result.status = status
            result.message = message
            result.data = content
            response(result)
        }
    }
}
