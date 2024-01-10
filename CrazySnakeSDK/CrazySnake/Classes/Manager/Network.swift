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

//#if DEBUG
///// test server
//fileprivate let kServerHost = "https://snake-api.test.mtmt.app"
//fileprivate let kServerHostTrustKey = "snake-api.test.mtmt.app"
//
//#else
///// format server
//fileprivate let kServerHost = "https://snake-api.test.mtmt.app"
//fileprivate let kServerHostTrustKey = "snake-api.test.mtmt.app"
//#endif


fileprivate let kServerHostTest = "https://api-platform-test.crazysnake.io"
fileprivate let kServerHostTrustKeyTest = "api-platform-test.crazysnake.io"
fileprivate let kServerHostUat = "https://api-platform-test.crazysnake.io"
fileprivate let kServerHostTrustKeyUat = "api-platform-test.crazysnake.io"
fileprivate let kServerHostFormat = "https://api.crazyland.io"
fileprivate let kServerHostTrustKeyFormat = "api.crazyland.io"

fileprivate let APP_TYPE = "mobile-ios"
fileprivate let APP_NAME = "SNAKE-SDK"

class LSNetwork: NSObject {

    enum ResultCode: Int {
        case success = 200
        case gas_limit = 1001
        case local_error = -100
    }
    
    static let shared = LSNetwork()
    
    private override init() {
        super.init()        
    }
    
    /// serverHost
    public var hostAddress: String {
        if CSSDKManager.shared.serverType == 2 {
            return kServerHostTest
        } else if CSSDKManager.shared.serverType == 1 {
            return kServerHostUat
        } else {
            return kServerHostFormat
        }
    }
    
    lazy var sessionManager: Session = {
        if CSSDKManager.shared.serverType == 2 {
            let trustManager = ServerTrustManager(evaluators: [
                kServerHostTrustKeyTest: DisabledTrustEvaluator()
            ])
            let session = Session(serverTrustManager: trustManager)
            
            return session
        } else if CSSDKManager.shared.serverType == 1 {
            let trustManager = ServerTrustManager(evaluators: [
                kServerHostTrustKeyUat: DisabledTrustEvaluator()
            ])
            let session = Session(serverTrustManager: trustManager)
            
            return session
        } else {
            let trustManager = ServerTrustManager(evaluators: [
                kServerHostTrustKeyFormat: DisabledTrustEvaluator()
            ])
            let session = Session(serverTrustManager: trustManager)
            
            return session
        }
        
    }()

}

extension LSNetwork{
    
 
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
extension LSNetwork {
    /// http get
    @discardableResult
    func httpGetRequest(path:String,para:Parameters?, response:  @escaping (JSON)->()) -> DataRequest {
        
        let url = getRequestUrl(path)
        NetLog(message: "get:" + url)
        NetLog(message: para)
        let timestamp = Date().ls_milliStamp
        var header = getHttpHeader(timestamp)
//        header["sign"] = getSign(path)
        header["sign"] = getSign(para, timestamp: timestamp)
//        NetLog(message: header)
        let reqest = sessionManager.request(url, method: .get, parameters: para, encoding: URLEncoding.default, headers: header).response { (result) in
            
            switch result.result {
            case .success(let value):
                let jsonSwift = JSON(value as Any)
                response(jsonSwift)
                NetLog(message: "url:\(url)")
//                NetLog(message: "JSON: \(jsonSwift)")
                debugPrint("JSON: \n",jsonSwift.dictionaryValue)

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
    
    /// http put
    func httpPutRequest(path:String,para:Parameters?, response:  @escaping (JSON)->()){
        
        let url = getRequestUrl(path)
//        NetLog(message: "put:" + url)
//        NetLog(message: para)
        let timestamp = Date().ls_milliStamp
        var header = getHttpHeader(timestamp)
        header["sign"] = getSign(para, timestamp: timestamp)
        AF.request(url, method: .put, parameters: para, encoding: JSONEncoding.default, headers: header).response { (result) in
            
            switch result.result {
            case .success(let value):
                let jsonSwift = JSON(value as Any)
//                NetLog(message: "url:\(url)")
                debugPrint("JSON: \n",jsonSwift.dictionaryValue)

                
            case .failure(let error):
                NetLog(message: error)
                let json:JSON = ["status":-100,"message":"request fail"]
                response(json)
                NetLog(message: "url:\(url)")
                NetLog(message: "JSON: \(json)")
            }
            
        }
    }
    
    /// http post
    @discardableResult
    func httpPostRequest(path:String,para:Parameters?, response:  @escaping (JSON)->()) -> DataRequest{
        
        let url = getRequestUrl(path)
        NetLog(message: "post:" + url)
        NetLog(message: para)
        let timestamp = Date().ls_milliStamp
        var header = getHttpHeader(timestamp)
        header["sign"] = getSign(para, timestamp: timestamp)
        
        
        
        let request = sessionManager.request(url, method: .post, parameters: para, encoding: JSONEncoding.default, headers: header).response { (result) in
            
            switch result.result {
            case .success(let value):
                let jsonSwift = JSON(value as Any)
                response(jsonSwift)
                NetLog(message: "url:\(url)")
//                NetLog(message: "JSON: \(jsonSwift)")
                debugPrint("JSON: \n",jsonSwift.dictionaryValue)

                
            case .failure(let error):
                NetLog(message: error)
                if let data = result.data {
                    let str = String(data: data, encoding: String.Encoding.utf8)
                    NetLog(message: str)
                }
                
                let json:JSON = ["status":-100,"message":"request fail"]
                response(json)
//                NetLog(message: "url:\(url)")
//                NetLog(message: "JSON: \(json)")
            }
            
        }
        
        return request
    }
    
    // http delete
    func httpDeleteRequest(path:String,para:Parameters?, response:  @escaping (JSON)->()){
        
        let url = getRequestUrl(path)
        NetLog(message: "delete:" + url)
        NetLog(message: para)
        let timestamp = Date().ls_milliStamp
        var header = getHttpHeader(timestamp)
        header["sign"] = getSign(path)
        
        AF.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header).response { (result) in
            
            switch result.result {
            case .success(let value):
                let jsonSwift = JSON(value as Any)
                response(jsonSwift)
                NetLog(message: "url:\(url)")
//                NetLog(message: "JSON: \(jsonSwift)")
                debugPrint("JSON: \n",jsonSwift.dictionaryValue)

            case .failure(let error):
                NetLog(message: error)
                let json:JSON = ["status":-100,"message":"request fail"]
                response(json)
                NetLog(message: "url:\(url)")
                NetLog(message: "JSON: \(json)")
            }
            
        }
    }
}

fileprivate extension LSNetwork {
    
     func getRequestUrl(_ path: String) -> String {
        let url = hostAddress + path
        //        url = url.addingPercentEncoding(withAllowedCharacters: )
        return url
    }
    
    func getHttpHeader(_ timestamp:String) -> HTTPHeaders {
        // let iosVersion : NSString = UIDevice.currentDevice().systemVersion

        //UIDevice.current.systemVersion
        //        let deviceUUID:String! =  UIDevice.current.identifierForVendor?.uuidString
        var header = HTTPHeaders()
//        header["apptype"] = APP_TYPE
//        header["appname"] = APP_NAME
//        header["x-version"] = CS_kAppVersion
//        header["Accept-Language"] = LocalizableManager.shared.currentLanguage
        header["x-access-version"] = CrazyPlatform.getSDKVersion()
        header["x-os"] = "ios"
//        header["x-build"] = CS_kAppBuildVersion
        header["x-device-id"] = CrazyPlatform.deviceId
        header["x-channel"] = "AppStore"
        header["x-client-id"] = "\(CSSDKManager.shared.gameId)"
        header["x-chain-id"] = "\(WalletChainType.Platon.chainId())"
        header["x-wow-disable-request-encrypt"] = "1"
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
    
    
    func getSign(_ para:Parameters?,timestamp:String) -> String{
        var signPara = para
//        signPara?["versioncode"] = CS_kAppBuildVersion
        signPara?["apptype"] = APP_TYPE
        signPara?["appname"] = APP_NAME
        signPara?["timestamp"] = timestamp
        let sign = getSignString(dic: signPara)
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
//        LSLog("result:\(result)")
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
