//
//  ADSHttp.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/10.
//

import Foundation
import Moya

let httpProvider = MoyaProvider<ADSHttp>()

enum ADSHttp {
    
    case register(_ account: String, _ passwd: String)
    case signin(_ account: String, _ passwd: String)
    case uploadFile(_ fileName: String, _ fileData: Data)
    case updateUserInfo(_ name: String?, _ avatar: String?, _ sex: String?, _ age: Int?)
    case getUserInfo(_ userID: String?)
    case getMakeUpList(_ is_self: String, _ page: String, _ page_size: String, _ type: String?, _ user_id: String?, _ keywords: String? = nil)
    // unlock_price: 0表示免费 大于0就表示需要多少coin
    case postMakeUp(_ title: String, _ content: String, _ img: String, _ type: String, _ unlock_price: String)
    
    case getDressList(_ is_self: String, _ page: String, _ page_size: String, _ user_id: String?)
    case postDress(_ title: String, _ content: String, _ img: String)
    
    /// 状态，1关注，0取消关注
    case followAction(_ to_user_id: String, _ status: Int)
    
    /// 粉丝列表
    case followerList(_ page: String, _ pageSize: String)
    case followingList(_ page: String, _ pageSize: String)
    
    /// 点赞接口 status: 0 不喜欢，1喜欢
    case likeAction(_ id: String, _ status: String)
    /// 点赞列表
    case likeList(_ page: String, _ page_size: String, _ type: String)
    /// 注销账号
    case signOff
    /// 拉黑或者取消拉黑 status: 1 拉黑，0取消拉黑
    case blockAction(_ to_user_id: String, _ status: String)
    /// 拉黑列表
    case blockList(_ page: String, _ pageSize: String)
    /// 举报
    case reportAction(_ userID: String)
    ///  充值验证
    case verifyPurchaseProof(_ purchaseId: String, _ receiptData: String, _ transactionId: String, _ env: String = "2")
    
    case getRechargeList
}

extension ADSHttp: TargetType {
    var baseURL: URL {
        return URL.init(string: "https://opi.sbnhlsaa.link")!
    }
    
    var path: String {
        switch self {
        case .register:
            return "/signUp"
        case .signin:
            return "/signIn"
        case .uploadFile:
            return "/upFiles"
        case .updateUserInfo:
            return "/meInfoUpdate"
        case .getUserInfo:
            return "/meInfo"
        case .getMakeUpList:
            return "/mps"
        case .postMakeUp:
            return "/mp/post"
        case .getDressList:
            return "/ds"
        case .postDress:
            return "/d/post"
        case .followAction:
            return "/follow"
        case .getRechargeList:
            return "/pConfigs"
        case .followerList:
            return "/fans"
        case .followingList:
            return "/follows"
        case .likeAction:
            return "/mpd/star"
        case .likeList:
            return "/mpd/stars"
        case .signOff:
            return "/signOff"
        case .blockAction:
            return "/blackOne"
        case .blockList:
            return "/blacks"
        case .reportAction:
            return "/reportSome"
        case .verifyPurchaseProof:
            return "/sub"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register,
                .signin,
                .uploadFile,
                .updateUserInfo,
                .getUserInfo,
                .getMakeUpList,
                .postMakeUp,
                .getDressList,
                .postDress,
                .followAction,
                .getRechargeList,
                .followerList,
                .followingList,
                .likeAction,
                .likeList,
                .signOff,
                .blockAction,
                .blockList,
                .reportAction,
                .verifyPurchaseProof:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .register(let account, let pw):
            
            let params = ["email": account, "pwd": pw]
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
         
        case .signin(let account, let pwd):
            let params = ["email": account, "pwd": pwd]
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
            
        case .uploadFile(let fileName, let fileData):
            let formData = MultipartFormData(provider: .data(fileData), name: "file", fileName: "\(fileName)", mimeType: "image/png")
            return .uploadMultipart([formData])
            
        case .updateUserInfo(let name, let avatar, let sex, let age):
            
            var params: [String: Any] = [:]
            
            if let nameStr = name {
                params["nick_name"] = nameStr
            }
            
            if let avatarStr = avatar {
                params["user_header"] = avatarStr
            }
            
            if let sexValue = sex {
                params["sex"] = sexValue
            }
            
            if let ageValue = age {
                params["age"] = ageValue
            }
            
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
         
            
        case .getUserInfo(let userID):
            var params: [String: Any] = [:]
            
            if let user_id = userID {
                params["user_id"] = user_id
            }
        
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .getMakeUpList(let is_self, let page, let page_size, let type, let user_id, let keywords):
            
            var params: [String: Any] = [:]
            params["is_self"] = is_self
            params["page"] = page
            params["page_size"] = page_size
            
            if let type = type {
                params["type"] = type
            }
            
            
            if let user_id = user_id {
                params["user_id"] = user_id
            }
            
            if let keywordsValue = keywords {
                params["keywords"] = keywordsValue
            }
        
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
            
        case .postMakeUp(let title, let content, let img, let type, let unlock_price):
            var params: [String: Any] = [:]
            params["title"] = title
            params["content"] = content
            params["img"] = img
            params["type"] = type
            params["unlock_price"] = unlock_price
        
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
            
        case .getDressList(let is_self, let page, let page_size, let user_id):
            
            var params: [String: Any] = [:]
            params["is_self"] = is_self
            params["page"] = page
            params["page_size"] = page_size
            if let user_id_value = user_id {
                params["user_id"] = user_id_value
            }
        
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
            
        case .postDress(let title, let content, let img):
            
            var params: [String: Any] = [:]
            params["title"] = title
            params["content"] = content
            params["img"] = img
        
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .followAction(let to_user_id, let status):
            
            var params: [String: Any] = [:]
            params["to_user_id"] = to_user_id
            params["status"] = status
        
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .followerList(let page, let pageSize):
          
            var params: [String: Any] = [:]
            params["page"] = page
            params["page_size"] = pageSize
        
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .followingList(let page, let pageSize):
          
            var params: [String: Any] = [:]
            params["page"] = page
            params["page_size"] = pageSize
        
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .likeAction(let id, let status):
            var params: [String: Any] = [:]
            params["id"] = id
            params["status"] = status
        
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .likeList(let page, let page_size, let type):
            var params: [String: Any] = [:]
            params["page"] = page
            params["page_size"] = page_size
            params["type"] = type
            
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .blockAction(let to_user_id, let status):
            var params: [String: Any] = [:]
            params["to_user_id"] = to_user_id
            params["status"] = status
            
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .blockList(let page, let page_size):
            var params: [String: Any] = [:]
            params["page"] = page
            params["page_size"] = page_size
            
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .reportAction(let user_id):
            var params: [String: Any] = [:]
            params["user_id"] = user_id
            params["description"] = ""
            params["img"] = ""
            params["type"] = ""
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .verifyPurchaseProof(let purchaseId, let receiptData, let transactionId, let env):
            
            var params: [String: Any] = [:]
            params["purchaseId"] = purchaseId
            params["receiptData"] = receiptData
            params["transactionId"] = transactionId
            params["env"] = env
            let data = try! JSONSerialization.data(withJSONObject:params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        case .getRechargeList,
                .signOff:
            return .requestCompositeData(bodyData: Data(), urlParameters:[:])
        }
    }
    
    var headers: [String : String]? {
        var header: [String: String] = [:]
        header["Content-Type"] = "application/json"
        
        if let auth = ADSConst.getUserDefaultsData(with: ADSConst.userTokenKey) {
            header["Authorization"] = auth
        }
        
        return header
    }
    
    
}
