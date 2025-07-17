//
//  ADSData+Extension.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/7/16 _. All rights reserved.
//

import Foundation

// Data扩展，用于十六进制转换
extension Data {
    // 十六进制字符串转Data
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        var index = hexString.startIndex
        
        for _ in 0..<len {
            let nextIndex = hexString.index(index, offsetBy: 2)
            if let byte = UInt8(hexString[index..<nextIndex], radix: 16) {
                data.append(byte)
                index = nextIndex
            } else {
                return nil
            }
        }
        self = data
    }
    
    // Data转十六进制字符串
    func toHexString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
