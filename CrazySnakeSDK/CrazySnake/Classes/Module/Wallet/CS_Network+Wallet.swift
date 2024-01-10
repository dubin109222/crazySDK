//
//  CS_Network+Wallet.swift
//  CrazySnake
//
//  Created by Lee on 18/07/2023.
//

import UIKit
import HandyJSON

//MARK: wallet
extension CSNetworkManager {
    func checkWhetherSetPassword<T:HandyJSON>(_ para: [String:Any],_ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpGetRequest(path: "/v2/api/user/check_pay_password", para: para) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func userSetPassword<T:HandyJSON>(_ para: [String:Any],_ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpPostRequest(path: "/v2/api/user/set_pay_password", para: para) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func verifyPassword<T:HandyJSON>(_ para: [String:Any],_ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpPostRequest(path: "/v2/api/user/verify_pay_password", para: para) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
}

// MARK: - Bind
extension CSNetworkManager {
    
    struct ResponseContent: HandyJSON {
        var status: Int = -1
        var message: String = ""
        var data: [String:Any]?
    }
    
    /// 查询绑定
    func checkBindAccount<T:HandyJSON>(_ para: [String:Any],_ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpGetRequest(path: "/v2/api/user/check_bind_account", para: para) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(),designatedPath: "data") {
                response(model)
            }
        }
    }
    
    /// 绑定
    func bindAccount<T:HandyJSON>(_ para: [String:Any],_ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpPostRequest(path: "/v2/api/user/bind_account", para: para) { (json) in
            
            if let model = JSONDeserializer<ResponseContent>.deserializeFrom(json: json.rawString()) {
                
                if model.status != 200 {
                    LSHUD.hide()
                    LSHUD.showError(model.message)
                    return
                }
            }

            
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(),designatedPath: "data") {
                response(model)
            }
        }
    }

    
    /// 取消绑定
    func unbindAccount<T:HandyJSON>(_ para: [String:Any],_ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpPostRequest(path: "/v2/api/user/unbind_account", para: para) { (json) in
            if let model = JSONDeserializer<ResponseContent>.deserializeFrom(json: json.rawString()) {
                
                if model.status != 200 {
                    LSHUD.hide()
                    LSHUD.showError(model.message)
                    return
                }
            }

            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(),designatedPath: "data") {
                response(model)
            }
        }
    }

}

