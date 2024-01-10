//
//  CSNetworkManager.swift
//  CrazySnake
//
//  Created by Lee on 01/09/2022.
//

import UIKit
import HandyJSON

class CSNetworkManager: NSObject {
    
    let url_host = "https://snake-www.test.mtmt.app"
    
    static let shared = CSNetworkManager()

    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }


}

extension CSNetworkManager {
    
    func getConfigNameDesc(_ response: @escaping((CS_NameDescribeModelResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/config/name_desc_lan.json", para: nil) { (json) in
            let resp = CS_NameDescribeModelResp(json)
            response(resp)
        }
    }
    
    func getGasInfo(_ response: @escaping((GasFeeResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/api/token/gas_limit", para: nil) { (json) in
            let resp = GasFeeResp(json)
            response(resp)
        }
//        GasNetwork.shared.httpGetGasRequest { (json) in
//            let resp = GasFeeResp(json)
//            response(resp)
//        }
    }
    
    func getSwapAmount(_ from: String, to: String, amount: String,_ response: @escaping((SwapAmountResp) -> ()) ){
        
        var para :[String:Any] = [:]
        para["from"] = from
        para["to"] = to
//        if CSSDKManager.shared.serverType == 1 {
//            para["fee"] = "\(500)"
//        } else {
//        }
        para["fee"] = "\(3000)"
        para["amount_in"] = amount
        
        LSNetwork.shared.httpGetRequest(path: "/api/token/swap_ratio", para: para) { (json) in
            let resp = SwapAmountResp(json)
            response(resp)
        }
    }
    
    func postFreeGas(_ para: [String:Any],_ response: @escaping((PostFreeGasResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/user_order/free_gas", para: para) { (json) in
            let resp = PostFreeGasResp(json)
            response(resp)
        }
    }
    
    func postFreeGasByName(_ para: [String:Any]?,_ response: @escaping((PostFreeGasResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/user_order/free_gas_by_name", para: para) { (json) in
            let resp = PostFreeGasResp(json)
            response(resp)
        }
    }
}

//MARK: user
extension CSNetworkManager {
    /// user login
    func userLogin(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v2/api/login", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    func getUserInfo(_ para: [String:Any],_ response: @escaping((CS_UserInfoResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/user/info", para: para) { (json) in
            let resp = CS_UserInfoResp(json)
            response(resp)
        }
    }
    
    func getUserAvatarList(_ para: [String:Any],_ response: @escaping((CS_UserAvatarListResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/user/avatar_list", para: para) { (json) in
            let resp = CS_UserAvatarListResp(json)
            response(resp)
        }
    }
    
    func changeAvatar(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/user/change_avatar", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    func changeNickname(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/user/change_name", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    
}

// MARK: Contract
extension CSNetworkManager{
    
    func getBasicConfig(_ response: @escaping((CS_BasicConfigModelResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/common/basic_config", para: nil) { (json) in
            let resp = CS_BasicConfigModelResp(json)
            response(resp)
        }
    }
    
    
    func getConfigLanguage<T:HandyJSON>(type: String = "1", _ responseHandle: @escaping(([T]) -> ()) ){
        // get请求，访问网络数据 /config/language/\(type).json
        // 定义URL
        let apiUrl = URL(string: "\(LSNetwork.shared.hostAddress)/config/language/\(type).json")!
        
        // 创建URLSession对象
        let session = URLSession.shared
        
        // 创建一个data任务以获取数据
        let task = session.dataTask(with: apiUrl) { (data, response, error) in
            // 处理可能的错误
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // 检查响应的HTTP状态码
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // 解析JSON数据
                    do {
                        if let jsonData = data {
                            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]
                            
                            if (json?.count ?? 0) == 0 {
                                return
                            }
                            let jsonArray = json?.first?["data"] as? [Any]
                                                        
                            if let model = JSONDeserializer<T>.deserializeModelArrayFrom(array: jsonArray) as? [T] {
                                responseHandle(model)
                            }
                        }
                        

                    } catch {
                        print("JSON解析错误: \(error)")
                    }
                } else {
                    print("HTTP状态码不是200，而是: \(httpResponse.statusCode)")
                }
            }
        }
        
        // 启动任务
        task.resume()
        

//        LSNetwork.shared.httpGetRequest(path: "/config/language/\(type).json", para: nil) { (json) in
//            if let model = JSONDeserializer<T>.deserializeModelArrayFrom(json: json.rawString(),designatedPath: "data") as? [T] {
//                response(model)
//            }
//        }

    }
    
    
    func getShareConfig<T:HandyJSON>(_ response: @escaping((T) -> ()) ){
        LSNetwork.shared.httpGetRequest(path: "/v2/api/common/share_config", para: nil) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(),designatedPath: "data") {
                response(model)
            }
        }
    }
    
    /// get contract ABI
    func getContractABI(_ contract: String,_ response: @escaping((CS_ContractABIResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/common/get_contract_abi/\(contract)", para: nil) { (json) in
            let resp = CS_ContractABIResp(json)
            response(resp)
        }
    }
    
    /// get contract gas price
    func getContractGasPrice(_ response: @escaping((CS_ContractGasPriceResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/token/gas_price", para: nil) { (json) in
            let resp = CS_ContractGasPriceResp(json)
            response(resp)
        }
    }
    
    /// get estimate gas
    func getEstimateGas(_ para: [String:Any]?,_ response: @escaping((CS_EstimateGasPriceResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/common/gas/estimate", para: para) { (json) in
            let resp = CS_EstimateGasPriceResp(json)
            response(resp)
        }
    }
    
    func getEstimateGasByName(_ para: [String:Any]?,_ response: @escaping((CS_EstimateGasPriceResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/common/gas/estimate_by_name", para: para) { (json) in
            let resp = CS_EstimateGasPriceResp(json)
            if resp.status == .gas_limit {
                let alert = CS_ConfirmAlert()
                alert.show("Notice".ls_localized, content: "The current blockchain is busy,please try again later!".ls_localized,showCancel: false)
            }
            response(resp)
        }
    }
    
    // 下注
    func fightVoteDiamond(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v2/api/center_fight/vote", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    // 批量领取所有
    func claimAllDiamond(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        LSNetwork.shared.httpPostRequest(path: "/v2/api/center_fight/claim", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    

}

// MARK: Wallet
extension CSNetworkManager{
    
    /// wallet blance list
    func getWalletBlanceList(_ para: [String:Any],_ response: @escaping((WalletBalanceResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/token/balances", para: para) { (json) in
            let resp = WalletBalanceResp(json)
            response(resp)
        }
    }
    
    func getWalletHistoryList(_ para: [String:Any],_ response: @escaping((CS_WalletRecordResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/user_order/list_transfers", para: para) { (json) in
            let resp = CS_WalletRecordResp(json)
            response(resp)
        }
    }
}

// MARK: NFT-Lab
extension CSNetworkManager{
    
    /// 1算力总榜，2单nft算力榜，3单币质押榜，4nft质押榜
    func getNFTRankList(_ para: [String:Any],_ response: @escaping((CS_RankTotalPowerResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/rank/index", para: para) { (json) in
            let resp = CS_RankTotalPowerResp(json)
            response(resp)
        }
    }
    
    func getNFTDetail(_ para: [String:Any],_ response: @escaping((NFTDetailResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/nft/details", para: para) { (json) in
            if let model = JSONDeserializer<NFTDetailResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// nft my nft list
    func getMyNFTList(_ para: [String:Any],_ response: @escaping((NFTDataListResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/nft/my", para: para) { (json) in
            if let model = JSONDeserializer<NFTDataListResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func getMyChainNFTList(_ para: [String:Any],_ response: @escaping((NFTDataListResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/nft/my_chain", para: para) { (json) in
            if let model = JSONDeserializer<NFTDataListResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// nft my backpack list
    /// sub_type 类型0所有，2孵化器，3进化精华，4进阶精华，5饲料包，6坑位卡，7加速包，8盲盒
    func getMybackpackList(_ para: [String:Any],_ response: @escaping((CS_NFTPropListResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/nft/props", para: para) { (json) in
            if let model = JSONDeserializer<CS_NFTPropListResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// nft level up
    func nftLevelUp(_ para: [String:Any],_ response: @escaping((CS_NFTUpgradeResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/nft/upgrade", para: para) { (json) in
            if let model = JSONDeserializer<CS_NFTUpgradeResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// nft recycle
    func nftRecycle(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/nft/recycle", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    /// nft evolve
    func nftEvolve(_ para: [String:Any],_ response: @escaping((CS_NFTUpgradeResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/nft/evolve", para: para) { (json) in
            if let model = JSONDeserializer<CS_NFTUpgradeResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// nft can incubate nft list
    func getIncubateNFTList(_ para: [String:Any],_ response: @escaping((NFTDataListResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/incubate/can", para: para) { (json) in
            if let model = JSONDeserializer<NFTDataListResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// start incubate
    func startIncubate(_ para: [String:Any],_ response: @escaping((CS_NFTIncubaDetailResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/incubate/start", para: para) { (json) in
            let resp = CS_NFTIncubaDetailResp(json)
            response(resp)
        }
    }
    
    /// get incubate info
    func getIncubateDetail(_ para: [String:Any],_ response: @escaping((CS_NFTIncubaDetailResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/incubate/detail", para: para) { (json) in
            let resp = CS_NFTIncubaDetailResp(json)
            response(resp)
        }
    }
    
    /// incubate speed up
    func incubateSpeedUp(_ para: [String:Any],_ response: @escaping((CS_NFTIncubateSpeedUpResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/incubate/speed_up", para: para) { (json) in
            let resp = CS_NFTIncubateSpeedUpResp(json)
            response(resp)
        }
    }
    
    /// incubate Withdraw
    func incubateWithdraw(_ para: [String:Any],_ response: @escaping((CS_NFTUpgradeResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/incubate/withdraw", para: para) { (json) in
            if let model = JSONDeserializer<CS_NFTUpgradeResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func openBox(_ para: [String:Any],_ response: @escaping((CS_OpenBoxResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/nft/open", para: para) { (json) in
            if let model = JSONDeserializer<CS_OpenBoxResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// nft my nft list
//    func getMyNFTList(_ wallet_address: String, state: Int, quality: Int, page: Int,_ response: @escaping((NFTDataListResp) -> ()) ){
//
//        var para :[String:Any] = [:]
//        para["wallet_address"] = wallet_address
//        para["status"] = "\(state)"
//        para["quality"] = "\(quality)"
//        para["page"] = "\(page)"
//        para["page_size"] = "20"
//
//        LSNetwork.shared.httpGetRequest(path: "/v1/api/nft/my", para: para) { (json) in
//            let resp = NFTDataListResp(json)
//            response(resp)
//        }
//    }
    
    func nftTransferIn(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v2/api/nft/transfer_in", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    func nftTransferOut(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v2/api/nft/transfer_out", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
}

// MARK: NFT-Stake
extension CSNetworkManager{
    
    func getNFTSetInfoList(_ wallet: String,_ response: @escaping((CS_NFTSetInfoResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/nft_staking/suitable_recommend/\(wallet)", para: nil) { (json) in
            if let model = JSONDeserializer<CS_NFTSetInfoResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// get stake info
    func getStakeInfo(_ wallet: String,_ response: @escaping((CS_NFTStakeInfoResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/nft_staking/params/\(wallet)", para: nil) { (json) in
            let resp = CS_NFTStakeInfoResp(json)
            response(resp)
        }
    }
    
    // 获取派遣主界面
    func getDispatchParams<T:HandyJSON>(_ wallet: String ,
                                        _ response: @escaping((T) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/nft_dispatch/params", para: ["wallet_address":wallet]) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(),
                                                               designatedPath: "data") {
                response(model)
            }
        }
    }
    
    // 获取公共参数
    func getDispatchCommonParams<T:HandyJSON>(_ wallet: String ,
                                        _ response: @escaping((T) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/nft_dispatch/common", para: ["wallet_address":wallet]) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(),
                                                               designatedPath: "data") {
                response(model)
            }
        }
    }
    
    // 购买派遣体力
    func posDispatchBuyStrength<T:HandyJSON>(_ wallet_address: String ,
                                              strength: Int,
                                        _ response: @escaping((T) -> ()) ){
        
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/nft_dispatch/buy_strength", para: [
            "wallet_address": wallet_address,
            "strength": strength,
            "nonce": nonce,
            "sign": sign
        ]) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(),
                                                               designatedPath: "data") {
                response(model)
            } else {
                let resp = RespModel(json)
                LSHUD.showError(resp.message)
            }
        }
    }

    
    
    
    // 获取升级详情
    func getDispatchUpgradeParams<T:HandyJSON>(_ wallet: String ,
                                        team_id: String,
                                        _ response: @escaping((T) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/nft_dispatch/upgrade_team_detail",
                                        para: [
                                            "wallet_address":wallet,
                                            "team_id":team_id
                                        ]
        ) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(),
                                                               designatedPath: "data") {
                response(model)
            }
        }
    }
    
    // 升级队伍
    func postDispatchUpgradeParams<T:HandyJSON>(_ wallet_address: String ,
                                        team_id: String,
                                        _ response: @escaping((T) -> ()) ){
        
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/nft_dispatch/upgrade_team", para: [
            "wallet_address": wallet_address,
            "team_id": team_id,
            "nonce": nonce,
            "sign": sign
        ]) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(),
                                                               designatedPath: "data") {
                response(model)
            } else if let model = JSONDeserializer<BaseRespModel>.deserializeFrom(json: json.rawString()) {
                if model.status == .serve_error {
                    LSHUD.showInfo(model.message)
                }
            }
        }
    }
    
    // 领取奖励
    func postDispatchClaimParams<T:HandyJSON>(wallet_address: String ,
                                             team_id: String,
                                        _ response: @escaping((T) -> ()) ){
        let (nonce, sign) = Utils.signInfo(privateKey: CS_AccountManager.shared.accountInfo?.private_key)
        guard let sign = sign else { return }
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/nft_dispatch/claim", para: [
            "wallet_address": wallet_address,
            "team_id": team_id,
            "nonce": nonce,
            "sign": sign
        ]) { (json) in
            if let model = JSONDeserializer<T>.deserializeFrom(json: json.rawString(),
                                                               designatedPath: "data") {
                response(model)
            }
        }
    }
    
    /// get staking suitable
    func getStakeSuitable(_ wallet: String,_ response: @escaping((CS_NFTStakeSuitableResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/nft_staking/suitable/\(wallet)", para: nil) { (json) in
            if let model = JSONDeserializer<CS_NFTStakeSuitableResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// nftStakeUseSoltCards
    func nftStakeUseSoltCards(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v2/api/nft_staking/use_slotcards", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    /// nft stake single
    func nftSingleStake(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v2/api/nft_staking/stake", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    /// 派遣队伍
    func nftDispatch(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/nft_dispatch/dispatch", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    /// nft unstake single
    func nftSingleUnstake(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v2/api/nft_staking/unstake", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    /// nft stake set
    func nftStakeSet(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v2/api/nft_staking/group_stake", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    /// nft unstake set
    func nftUnstakeSet(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v2/api/nft_staking/group_unstake", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    /// nft stake claim gas price
    func nftStakeClaimGasPrice(_ wallet: String,_ response: @escaping((CS_EstimateGasPriceResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/nft_staking/claim_estimate/\(wallet)", para: nil) { (json) in
            let resp = CS_EstimateGasPriceResp(json)
            response(resp)
        }
    }
    
    /// nft stake claim
    func nftStakeClaim(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v2/api/nft_staking/claim", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
}

//MARK: swap
extension CSNetworkManager {

    
    func swapTokenToUSDT(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/token/swap/token_to_usdt", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
  
    
    func welfareSwap(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/token/swap/welfare", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
}

//MARK: token stake
extension CSNetworkManager {
    /// get stake time list
    func getStakeTimeList(_ wallet: String,token: String,_ response: @escaping((CS_StakeTimeResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/token_staking/main/\(wallet)/\(token)", para: nil) { (json) in
            let resp = CS_StakeTimeResp(json)
            response(resp)
        }
    }
    
    /// my stake token record list
    func getStakeRecordList(_ address: String, token: String,para: [String:Any]?,_ response: @escaping((CS_StakeTokenRecordResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/token_staking/params/\(address)/\(token)", para: para) { (json) in
            let resp = CS_StakeTokenRecordResp(json)
            response(resp)
        }
    }
    
    /// my stake token record list
    func unstake(_ para: [String:Any]?,_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/token_staking/unstake", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
}

//MARK: Games
extension CSNetworkManager {
    func getCurrentSessionInfo(_ para: [String:Any]?, _ response: @escaping((CS_SessionInfoResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/center_fight/current_round", para: para) { (json) in
            let resp = CS_SessionInfoResp(json)
            response(resp)
        }
    }
    
    func getSessionHistoryList(_ para: [String:Any]?, _ response: @escaping((CS_SessionHistoryResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/center_fight/history_round", para: para) { (json) in
            let resp = CS_SessionHistoryResp(json)
            response(resp)
        }
    }
    
    func getMineGameHistoryList(_ para: [String:Any]?,_ response: @escaping((CS_MineHistoryResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/center_fight/user_round", para: para) { (json) in
            if let model = JSONDeserializer<CS_MineHistoryResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func getRankList(_ para: [String:Any]?, _ response: @escaping((CS_GameRankResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v2/api/center_fight/rank", para: para) { (json) in
            if let model = JSONDeserializer<CS_GameRankResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
}


//MARK: Event
extension CSNetworkManager {
    /// getEventList
    func getEventList(_ response: @escaping((CS_EventListResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/events", para: nil) { (json) in
            let resp = CS_EventListResp(json)
            response(resp)
        }
    }
    
    /// getEventDetail
    func getEventDetail(_ para: [String:Any]?, _ response: @escaping((CS_EventDetailResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/event/details", para: para) { (json) in
            let resp = CS_EventDetailResp(json)
            response(resp)
        }
    }
    
    func getEventHistoryList(_ para: [String:Any],_ response: @escaping((CS_EventRecordResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/event/buy_records", para: para) { (json) in
            let resp = CS_EventRecordResp(json)
            response(resp)
        }
    }
}

//MARK: Market
extension CSNetworkManager {
    
    func getDiamondBalance(_ para: [String:Any],_ response: @escaping((CS_DiamondBalanceResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/market/diamond_balance", para: para) { (json) in
            let resp = CS_DiamondBalanceResp(json)
            response(resp)
        }
    }
    
    /// market list
    func getMarketList(_ para: [String:Any],_ response: @escaping((CS_MarketListResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/market/list", para: para) { (json) in
            if let model = JSONDeserializer<CS_MarketListResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// market selling list
    func getMarketSellingList(_ para: [String:Any],_ response: @escaping((CS_MarketListResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/market/my_selling", para: para) { (json) in
            if let model = JSONDeserializer<CS_MarketListResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    func getMarketSellableSetsList(_ para: [String:Any],_ response: @escaping((CS_MarketSetsListResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/market/select_group", para: para) { (json) in
            if let model = JSONDeserializer<CS_MarketSetsListResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// market sellable list
    func getMarketSellableList(_ para: [String:Any],_ response: @escaping((CS_MarketListResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/market/list_sellable", para: para) { (json) in
            if let model = JSONDeserializer<CS_MarketListResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
    
    /// market stop sell
    func marketStopSell(_ para: [String:Any],_ response: @escaping((CS_MarketSellResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/market/stop_sell", para: para) { (json) in
            let resp = CS_MarketSellResp(json)
            response(resp)
        }
    }
    
    /// market start sell
    func marketStartSell(_ para: [String:Any],_ response: @escaping((CS_MarketSellResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/market/start_sell", para: para) { (json) in
            let resp = CS_MarketSellResp(json)
            response(resp)
        }
    }
    
    func marketBuy(_ para: [String:Any],_ response: @escaping((CS_MarketSellResp) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/market/buy", para: para) { (json) in
            let resp = CS_MarketSellResp(json)
            response(resp)
        }
    }
    
    func sendNft(_ para: [String:Any],_ response: @escaping((RespModel) -> ()) ){
        
        LSNetwork.shared.httpPostRequest(path: "/v1/api/nft/send", para: para) { (json) in
            let resp = RespModel(json)
            response(resp)
        }
    }
    
    func getMarketHistoryList(_ para: [String:Any],_ response: @escaping((CS_MarketHistoryResp) -> ()) ){
        
        LSNetwork.shared.httpGetRequest(path: "/v1/api/market/trade_history", para: para) { (json) in
            if let model = JSONDeserializer<CS_MarketHistoryResp>.deserializeFrom(json: json.rawString()) {
                response(model)
            }
        }
    }
}



