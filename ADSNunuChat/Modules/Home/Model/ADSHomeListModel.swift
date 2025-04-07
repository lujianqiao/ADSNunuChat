//
//  ADSHomeListModel.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/12.
//

import Foundation
import SmartCodable

class ADSHomeListModel: SmartCodable {
    
    var id: String = ""
    var user_id: Int = 0
    var nick_name: String = ""
    var user_header: String = ""
    var title: String = ""
    var content: String = ""
    var img: String = ""
    var praise_num: Int = 0
    var created_at: Int = 0
    var type: Int = 0
    var unlock_price: Int = 0
    var is_self: Bool = false
    var is_praised: Bool = false
    var is_followed: Bool = false
    
    var images: [String] {
        return self.img.components(separatedBy: ",")
    }
    
    required init() {}
}
