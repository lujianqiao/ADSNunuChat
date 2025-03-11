//
//  ADSUserInfoModel.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/11.
//

import UIKit
import SmartCodable

class UserInfoManager {
    
    static let share = UserInfoManager()
    
    var userInfo: ADSUserInfoModel?
    
}

struct ADSUserInfoModel: SmartCodable {
    
    var user_id: Int = 0
    var nick_name: String = ""
    var user_header: String = ""
    var sex: String = "0"
    var age: Int = 0
    var country: String = ""
    var fans_num: Int = 0
    var liked_num: Int = 0
    var follow_num: Int = 0
    var uuid: String = ""
    var is_followed: Int = 0
    var coins: Int = 0
    
}
