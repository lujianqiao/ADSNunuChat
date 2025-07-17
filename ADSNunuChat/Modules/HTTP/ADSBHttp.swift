//
//  ADSBHttp.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/7/14 _. All rights reserved.
//

import Foundation
import Moya

let httpBProvider = MoyaProvider<ADSBHttp>()

enum ADSBHttp {
    case getOpenStatus(_ param: [String: Any])
    case signIn(_ param: [String: Any])
    case verifyPurchaseProof(_ param: [String: Any])
}

extension ADSBHttp: TargetType {
    var baseURL: URL {
        return URL.init(string: "https://opi.cphub.link")!
    }
    
    var path: String {
        switch self {
        case .getOpenStatus:
            return "/opi/v1/get/server/timeo"
        case .signIn:
            return "/opi/v1/ufwes/dweer/dbl"
        case .verifyPurchaseProof:
            return "/opi/v1/pp/ne/bp"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getOpenStatus,
                .signIn,
                .verifyPurchaseProof:
                return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getOpenStatus(let param):
            let data = ADSBHttp.handleAESCrypt(param: param)?.data(using: .utf8) ?? Data()
            return .requestCompositeData(bodyData: data, urlParameters:[:])
        case .signIn(let param):
            let data = ADSBHttp.handleAESCrypt(param: param)?.data(using: .utf8) ?? Data()
            return .requestCompositeData(bodyData: data, urlParameters:[:])
        case .verifyPurchaseProof(let param):
            let data = ADSBHttp.handleAESCrypt(param: param)?.data(using: .utf8) ?? Data()
            return .requestCompositeData(bodyData: data, urlParameters:[:])
            
        }
    }
    
    var headers: [String : String]? {
        var header: [String: String] = [:]
        header["Content-Type"] = "application/json"
        header["deviceNo"] = ADSConst.uniqueDeviceID
        header["appVersion"] = ADSConst.AppCurrentVersion
        header["appId"] = AppId
        header["pushToken"] = "fwkeflwejfoiqej"
        
        if let auth = ADSConst.getUserDefaultsData(with: ADSConst.userTokenKey) {
            header["Authorization"] = auth
        }
        
        return header
    }
    
}


extension ADSBHttp {
    
    static func handleAESCrypt(param: [String: Any]) -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: param, options: []) {
            let hexData = jsonData.toHexString()
            
            if let aes = AESCBC(key: AESkey, iv: AESIV) {
                // 解密
                if let decry = aes.encrypt(hexString: hexData) {
                    debugPrint("decry===\(decry)")
                    return decry.toHexString()
                }
            }
            
        }
        return nil
    }
    
}
