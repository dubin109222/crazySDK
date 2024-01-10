//
//  Network.swift
//  constellation
//
//  Created by Lee on 2020/4/3.
//  Copyright © 2020 Constellation. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// log
///
/// - parameter message:  message
/// - parameter file:     file名
/// - parameter method:   method名
/// - parameter line:     line
fileprivate func NetLog<T>(message: T?,
                           file: String = #file,
                           method: String = #function,
                           line: Int = #line)
{
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(String(describing:  message))")
    #endif
}


fileprivate let kServerHostTrustKeyFormat = "gasstation-mainnet.matic.network"


class GasNetwork: NSObject {

    enum ResultCode: Int {
        case success = 200
        case local_error = -100
    }
    
    static let shared = GasNetwork()
    
    private override init() {
        super.init()
        
    }
    
    /// serverHost
    private var hostAddress: String {
        return "kServerHostFormat"
    }
    
    lazy var sessionManager: Session = {
        let trustManager = ServerTrustManager(evaluators: [
            kServerHostTrustKeyFormat: DisabledTrustEvaluator()
        ])
        let session = Session(serverTrustManager: trustManager)
        
        return session
        
    }()

}

extension GasNetwork{
    
 
    /// 支持https
    func validateHTTPS(){
        
//        let trustManager = ServerTrustManager(evaluators: [
//            kServerHost: DisabledTrustEvaluator()
//        ])
//        let session = Session(serverTrustManager: trustManager)
//

//        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
//            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
//            var credential: URLCredential?
//
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                disposition = URLSession.AuthChallengeDisposition.useCredential
//                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//            } else {
//                if challenge.previousFailureCount > 0 {
//                    disposition = .cancelAuthenticationChallenge
//                } else {
//                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
//
//                    if credential != nil {
//                        disposition = .useCredential
//                    }
//                }
//            }
//            return (disposition, credential)
//        }
        
    
    }
    
    
}


// MARK: request
extension GasNetwork {
    
    
    /// http get
    @discardableResult
    func httpGetGasRequest(response:  @escaping (JSON)->()) -> DataRequest {
        
        let url = "https://gasstation-mainnet.matic.network/v2"
        let reqest = sessionManager.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (result) in
            
            switch result.result {
            case .success(let value):
                let jsonSwift = JSON(value)
                response(jsonSwift)
//                NetLog(message: "url:\(url)")
                NetLog(message: "JSON: \(jsonSwift)")
                
            case .failure(let error):
                NetLog(message: error)
                let json:JSON = ["status":-100,"message":"request fail"]
                response(json)
//                NetLog(message: "url:\(url)")
//                NetLog(message: "JSON: \(json)")
            }
            
        }
        
        return reqest
    }
    
}

fileprivate extension GasNetwork {
    

    func getHttpHeader(_ timestamp:String) -> HTTPHeaders {
        // let iosVersion : NSString = UIDevice.currentDevice().systemVersion

        //UIDevice.current.systemVersion
        //        let deviceUUID:String! =  UIDevice.current.identifierForVendor?.uuidString
        var header = HTTPHeaders()
//        header["apptype"] = APP_TYPE
//        header["appname"] = APP_NAME
//        header["x-version"] = CS_kAppVersion
//        header["Accept-Language"] = LocalizableManager.shared.currentLanguage
        header["x-os"] = "ios"
//        header["x-build"] = CS_kAppBuildVersion
//        header["x-device-id"] = UUID
        header["x-channel"] = "AppStore"
//        if let token = LoginManager.shared.getUserToken() {
//            header["token"] = token
//        }
//        header["timestamp"] = String(format: "%@",timestamp)
        header["Content-Type"] = "application/json"
        return header
    }
    
    func getSign(_ path:String) -> String {
        let encode = path.ls_urlEncoded()
        let sign = encode.ls_md5
//        NetLog(message: "befor sign:\(encode) \n after sign:\(sign)")
        return sign
    }
    

    /// get sign form sort dictionary key=value（String）
    private func getSignString(dic:Dictionary<String,Any>?) -> String{
        
        if dic?.keys.count == 0 || dic == nil {
            return ""
        }
        var result: String = ""
        let sortKeys =  dic?.keys.sorted(by: <)
        
        for item in sortKeys! {
            // result = "\(String(describing: result))\(item)=\(dic![item])"
            let value = dic![item]
            
            if let value = value {
                let valueType = type(of: value)
                if valueType == Array<Any>.self ||  valueType == NSArray.self{
                    continue
                }
                var valueEncode = value
                if (valueType == String.self || valueType == NSString.self) {
                    var str = value as! String
                    if str == "" {
                        continue
                    }
                    /**
                     nil string in iOS after sign is %20，in server is +，result sign not same。do not sign nil string
                    */
                    str = str.replacingOccurrences(of: " ", with: "")
                    str = str.replacingOccurrences(of: "*", with: "")
                    str = str.ls_urlEncoded()
                    
                    str = str.replacingOccurrences(of: "%2A", with: "")
                    valueEncode = str
                }
                
                if result == "" {
                    result = "\(result)\(item)=\(valueEncode)"
                }else{
                    result = "\(result)&\(item)=\(valueEncode)"
                }
            }

        }
        let md5Str = result.ls_md5
        LSLog("result:\(result)")
        return md5Str
    }
    
    
    //dictionary to json string
    func toJSONString(dict:Dictionary<String, Any>?)->String{
        
        if let dict = dict {
            let data = try? JSONSerialization.data(withJSONObject: dict)
            
            let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            return strJson! as String
        }else{
            return ""
        }
    }
    
}
