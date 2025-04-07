//
//  ADSRechargeModel.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/14.
//


import Foundation
import SmartCodable

struct ADSRechargeModel: SmartCodable {
    var id: String = ""
    var purchase_id: String = ""
    var coins: String = ""
    var money: String = ""
    var ext_reward: Int = 0
}
