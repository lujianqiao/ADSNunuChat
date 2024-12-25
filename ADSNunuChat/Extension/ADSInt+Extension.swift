//
//  ADSInt+Extension.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import Foundation

extension Int {
    
    /// 屏幕比例
    var scale: Double {
        return Double(self) * (kScreenWidth / 375)
    }
    
}
