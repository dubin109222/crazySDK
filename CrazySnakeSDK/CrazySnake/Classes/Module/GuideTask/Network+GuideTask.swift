//
//  Network+GuideTask.swift
//  CrazySnake
//
//  Created by BigB on 2023/11/16.
//

import Foundation
import HandyJSON

struct TaskRewardListItem: HandyJSON {
    var reward_id: String = ""
    var reward_num: String = ""
}

struct TaskRewardItem: HandyJSON {
    var reward_type: String = ""
    var reward_num: String = ""
    var reward_list: [TaskRewardListItem]? = nil
}

struct NewTaskRewardItem: HandyJSON {
    var reward_id: String = ""
    var reward_type: String = ""
    var reward_num: String = ""


}


class TaskItem: HandyJSON {
    
    
    required init() {
    }
    
    var split_num: [String] = []
    var task_type: String? = nil
    var id: String = ""
    var task_status: String = "-1"
    var reward: [TaskRewardItem] = []
    var newReward: [NewTaskRewardItem] = []
    var task_tab: String = ""
    
    func convertData() {
        newReward.removeAll()
        for item in reward {
            
            if item.reward_type == "reward_prop" {
                for subItem in item.reward_list ?? [] {
                    newReward.append(NewTaskRewardItem(reward_id: subItem.reward_id, reward_type: item.reward_type, reward_num: subItem.reward_num))
                }
            } else {
                newReward.append(NewTaskRewardItem(reward_id: "", reward_type: item.reward_type, reward_num: item.reward_num))
            }
        }
    }
    
}

class TaskModule: HandyJSON {
    var module_list: [TaskItem] = []
    var module_name: String = ""

    required init() {
        
    }
    
}






extension CSNetworkManager {
    // 获取任务列表
    func getNoviceTask<T: HandyJSON>(_ para: [String:Any],_ response: @escaping(([T]) -> ()) ){
        LSNetwork.shared.httpGetRequest(path: "/v2/api/novice_task/list", para: para) { (json) in
            
            if let model = JSONDeserializer<T>.deserializeModelArrayFrom(json: json.rawString(),designatedPath: "data") as? [T] {
                response(model)
            }
            
            
        }
    }
    
    // 领取任务奖励
    func rewardNoviceTask<T: HandyJSON>(_ para: [String:Any],_ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpPostRequest(path: "/v2/api/novice_task/getReward", para: para) { (json) in
            
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
