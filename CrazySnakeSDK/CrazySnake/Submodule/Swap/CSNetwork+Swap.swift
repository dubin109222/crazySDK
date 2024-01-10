//
//  CSNetwork+Swap.swift
//  CrazyWallet
//
//  Created by BigB on 2023/7/4.
//

import Foundation
import HandyJSON

extension CSNetworkManager {
    
    func getWelfareSwap(_ para: [String:Any],_ response: @escaping((CS_SwapWelfareResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/token/swap/welfare_config", para: para) { (json) in
            let resp = CS_SwapWelfareResp(json)
            response(resp)
        }
    }
    
    func getSwapDefaultToken<T: HandyJSON>(_ para: [String:Any],_ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpGetRequest(path: "/v2/api/token/swap_default_token", para: para) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(), designatedPath: "data") {
                response(model)
            }
            
        }
    }
    
    /// get swap ratio
    func getSwapRatio(_ para: [String:Any],_ response: @escaping((CS_SwapRatioResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/token/swap/ratio", para: para) { (json) in
            let resp = CS_SwapRatioResp(json)
            response(resp)
        }
    }

    /// getSwapGasCoinList
    func getSwapGasCoinList<T:HandyJSON>(_ response: @escaping(([T]) -> ()) ) {
        LSNetwork.shared.httpGetRequest(path: "/v2/api/token/gas_coins", para: nil) { (json) in
            if let model = JSONDeserializer<T>.deserializeModelArrayFrom(json: json.rawString(), designatedPath: "data") as? [T] {
                response(model)
            }
        }
    }
    

    func getGameTokens<T:HandyJSON>(_ para: [String:Any],_ response: @escaping(([T]) -> ()) ){
        LSNetwork.shared.httpGetRequest(path: "/v2/api/token/currencies", para: para) { (json) in
            if let model = JSONDeserializer<T>.deserializeModelArrayFrom(json: json.rawString(), designatedPath: "data") as? [T] {
                response(model)
            }
        }
    }
    
    
    
    
    /// swap histor list
    func getSwapHistoryList(_ para: [String:Any],_ response: @escaping((CS_SwapHistoryResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/user_order/list_swaps", para: para) { (json) in
            let resp = CS_SwapHistoryResp(json)
            response(resp)
        }
    }
    
    


}
