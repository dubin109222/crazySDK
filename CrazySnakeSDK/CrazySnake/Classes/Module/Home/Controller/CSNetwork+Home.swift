//
//  CSNetwork+Home.swift
//  CrazySnake
//
//  Created by BigB on 2023/7/12.
//

import Foundation
import HandyJSON


struct ListRewardItem: HandyJSON {
    var reward_type: String = ""
    var reward_num: String = ""
    var prop_id: String = ""
    var reward_img: String = ""

}


extension CSNetworkManager {
    func getMessageTips<T:HandyJSON>(_ para: [String:Any],_ response: @escaping(([T]) -> ()) ){
        LSNetwork.shared.httpGetRequest(path: "/v2/api/message/tips", para: para) { (json) in
            if let model = JSONDeserializer<T>.deserializeModelArrayFrom(json: json.rawString(), designatedPath: "data") as? [T] {
                response(model)
            }
        }
    }
    
    
    // 兑换码兑换
    func giftCkdExchange<T:HandyJSON>(_ para: [String:Any],_ response: @escaping(([T]) -> ()) ){
        LSNetwork.shared.httpPostRequest(path: "/v2/api/gift_ckd/exchange", para: para) { (json) in
            if let model = JSONDeserializer<ResponseContent>.deserializeFrom(json: json.rawString()) {
                
                if model.status != 200 {
                    LSHUD.hide()
                    LSHUD.showError(model.message)
                    return
                }
            }

            if let model = JSONDeserializer<T>.deserializeModelArrayFrom(json: json.rawString(), designatedPath: "data") as? [T] {
                response(model)
            }
        }
    }
}


struct AnimationModel: HandyJSON {
    var status: Int  = -1
    var message: String = ""
    var data: Bool = false
}

// 新手引导任务动画
extension CSNetworkManager {
    func checkAnimation<T:HandyJSON>(_ para: [String:Any],
                                    _ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpGetRequest(path: "/v2/api/novice_task/checkAnimation", para: para) { (json) in
            if let model = JSONDeserializer<ResponseContent>.deserializeFrom(json: json.rawString()) {                
                if model.status != 200 {
                    LSHUD.hide()
                    LSHUD.showError(model.message)
                    UIViewController.current()?.view.isUserInteractionEnabled = true
                    return
                }
            }

            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func saveAnimation<T:HandyJSON>(_ para: [String:Any],
                                    _ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpGetRequest(path: "/v2/api/novice_task/saveAnimation", para: para) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
}

// 获取gwei状态
extension CSNetworkManager {
    func getGweiValue<T:HandyJSON>(_ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpGetRequest(path: "/v2/api/common/gwei", para: nil) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(), designatedPath: "data") {
                response(model)
            }
        }
    }

}
