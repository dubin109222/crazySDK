//
//  CSResultRespon.swift
//  CrazySnake
//
//  Created by Lee on 22/07/2022.
//

import UIKit

@objc open class CSResultRespon: NSObject {
    
    /// 500: "Http error"
    /// -1: Unknown error
    /// -2: Data parsing error, invalid format
    /// -3: Other error
    /// -4: Waiting for blockchain confirmation
    /// -5: Transfer error
    /// -6: Value error
    /// -7: Gas too low
    /// -8: Blockchain error
    
    /// 0: success -1: failed
    @objc public var code: Int = -1 {
        didSet {
            message = (ResultCode(rawValue: code) ?? .unknwon).tipsContent()
        }
    }
    @objc public var message: String?
    @objc public var data: Any?
    /// 授权状态 0:未知 1:已授权 -1:未授权
    @objc public var isApproved = 0
    
    static func contractResponse(_ code:ResultCode, isApproved: Int, content: Any? = nil, _ response: @escaping((CSResultRespon) -> ())) {
        DispatchQueue.main.async {
            let result = CSResultRespon()
            result.code = code.rawValue
            result.data = content
            result.isApproved = isApproved
            response(result)
        }
    }
    
    static func contractResponse(_ code:ResultCode, content: Any? = nil, _ response: @escaping((CSResultRespon) -> ())) {
        DispatchQueue.main.async {
            let result = CSResultRespon()
            result.code = code.rawValue
            result.data = content
            response(result)
        }
    }
    
    /// result respon in main thread
    /// - Parameters:
    ///   - code: result code 0: success
    ///   - message: log message
    ///   - content: content
    static func contractResponse(_ code:Int, message: String?, content: Any? = nil, _ response: @escaping((CSResultRespon) -> ())) {
        DispatchQueue.main.async {
            let result = CSResultRespon()
            result.code = code
            result.message = message
            result.data = content
            response(result)
        }
    }
    
    /// result respon in main thread
    /// - Parameters:
    ///   - code: result code 0: success
    ///   - message: log message
    ///   - dic: dic
    static func contractResponse(_ code:Int, message: String?, dic: [String: Any]? = nil, _ response: @escaping((CSResultRespon) -> ())) {
        DispatchQueue.main.async {
            let result = CSResultRespon()
            result.code = code
            result.message = message
            result.data = dic
            response(result)
        }
    }
    
}

enum ResultCode: Int {
    case success = 0
    // Unknown error
    case unknwon = -1
    // Data Parsing error，invalid format
    case invalidFormat = -2
    // Transfer error
    case transferError = -3
    // Waiting for blockchain confirmation
    case blockChainError = -4
    // Gas Balance error
    case gasLimitError = -5
    // Balance error
    case blanceError = -6
    // Network fluctuation, please try again
    case retryError = -7
    // HTTP error
    case httpError = 500
    
    func tipsContent() -> String {
        return ""
    }
    
}

