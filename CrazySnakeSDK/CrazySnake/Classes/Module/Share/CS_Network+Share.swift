//
//  CS_Network+Share.swift
//  CrazySnake
//
//  Created by Lee on 31/07/2023.
//

import UIKit
import HandyJSON

//MARK: action
extension CSNetworkManager {
    
    func getSharePageData(_ wallet: String,_ response: @escaping((CS_ShareResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/user_share/params/\(wallet)", para: nil) { (json) in
            if let model = JSONDeserializer<CS_ShareResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func bindShareLink(_ wallet: String, code: String,para: [String:Any]?,_ response: @escaping((BaseRespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/user_share/bind/\(wallet)/\(code)", para: para) { (json) in
            if let model = JSONDeserializer<BaseRespModel>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func claimShareTastReward(_ wallet: String, taskId: String,para: [String:Any]?,_ response: @escaping((BaseRespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/user_share/claim/\(wallet)/\(taskId)", para: para) { (json) in
            if let model = JSONDeserializer<BaseRespModel>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func getShareSwapData(_ name: String,amount: String,_ response: @escaping((CS_ShareSwapResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/user_share/cash/price/\(name)/\(amount)", para: nil) { (json) in
            if let model = JSONDeserializer<CS_ShareSwapResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func shareWithdrawGasPrice(_ token: String,amount: String,wallet: String,_ response: @escaping((CS_EstimateGasPriceResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/user_share/withdraw/estimate/\(token)/\(amount)/\(wallet)", para: nil) { (json) in
            let resp = CS_EstimateGasPriceResp(json)
            response(resp)
        }
    }
    
    func shareWithdraw(_ para: [String:Any]?,_ response: @escaping((BaseRespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/user_share/withdraw", para: para) { (json) in
            if let model = JSONDeserializer<BaseRespModel>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func getShareWithdrawHistory(_ userId: String,page: String,size: String,_ response: @escaping((CS_ShareWithdrawHistoryResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/user_share/withdraw/list/\(userId)/\(page)/\(size)", para: nil) { (json) in
            if let model = JSONDeserializer<CS_ShareWithdrawHistoryResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func getShareFriends(_ userId: String,page: String,size: String,_ response: @escaping((CS_ShareFirendsResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/user_share/clusters/\(userId)/\(page)/\(size)", para: nil) { (json) in
            if let model = JSONDeserializer<ResponseContent>.deserializeFrom(json: json.rawString()) {
                
                if model.status != 200 {
                    LSHUD.hide()
                    LSHUD.showError(model.message)
                    return
                }
            }

            if let model = JSONDeserializer<CS_ShareFirendsResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
}

