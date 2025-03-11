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
}

extension ADSHttp: TargetType {
    var baseURL: URL {
        return URL.init(string: "http://serapi.dabweapro.xyz/api")!
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register, .signin, .uploadFile, .updateUserInfo, .getUserInfo:
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
