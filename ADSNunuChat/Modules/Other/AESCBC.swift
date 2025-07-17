//
//  AESCBC.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/7/16 _. All rights reserved.
//

import CommonCrypto
import Foundation

struct AESCBC {
    private let key: Data
    private let iv: Data
    
    init?(key: String, iv: String) {
        // 确保密钥和IV是16字节长度(128位)
        guard key.count == 16, iv.count == 16 else {
            print("Error: 密钥和IV必须是16个字符长度")
            return nil
        }
        
        guard let keyData = key.data(using: .utf8),
              let ivData = iv.data(using: .utf8) else {
            print("Error: 密钥或IV转换失败")
            return nil
        }
        
        self.key = keyData
        self.iv = ivData
    }
    
    // 加密字符串，返回十六进制字符串
    func encrypt(hexString: String) -> Data? {
        guard let data = Data(hexString: hexString) else {
            print("Error: 输入的十六进制字符串无效")
            return nil
        }
        
        guard let encryptedData = crypt(data: data, option: CCOperation(kCCEncrypt)) else {
            return nil
        }
        
        return encryptedData
    }
    
    // 解密十六进制字符串，返回原始十六进制字符串
    func decrypt(hexString: String) -> Data? {
        guard let data = Data(hexString: hexString) else {
            print("Error: 输入的十六进制字符串无效")
            return nil
        }
        
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else {
            return nil
        }
        
        return decryptedData
    }
    
    private func crypt(data: Data, option: CCOperation) -> Data? {
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData = Data(count: cryptLength)
        
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option,
                                CCAlgorithm(kCCAlgorithmAES),
                                CCOptions(kCCOptionPKCS7Padding),
                                keyBytes.baseAddress, key.count,
                                ivBytes.baseAddress,
                                dataBytes.baseAddress, data.count,
                                cryptBytes.baseAddress, cryptLength,
                                &bytesLength)
                    }
                }
            }
        }
        
        guard UInt32(status) == UInt32(kCCSuccess) else {
            print("Error: 加密/解密失败 - 状态 \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}
