//
//  ADSKeychainManager.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/9/19 _. All rights reserved.
//

import Foundation
import Security

class ADSKeychainManager {
    
    // 单例模式
    static let shared = ADSKeychainManager()
    private init() {}
    
    // 服务标识符（建议使用你的 bundle identifier）
    private let service = Bundle.main.bundleIdentifier ?? "zj.mk.koody.com"
    
    // 保存账号密码到钥匙串
    func save(account: String, password: String) -> Bool {
        // 先将密码转换为 Data
        guard let passwordData = password.data(using: .utf8) else {
            return false
        }
        
        // 创建查询字典
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: passwordData
        ]
        
        // 先删除已存在的项目（如果存在）
        SecItemDelete(query as CFDictionary)
        
        // 添加新项目到钥匙串
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }
    
    // 从钥匙串读取密码
    func getPassword(for account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let password = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return password
    }
    
    // 更新钥匙串中的密码
    func updatePassword(for account: String, newPassword: String) -> Bool {
        guard let newPasswordData = newPassword.data(using: .utf8) else {
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: newPasswordData
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        return status == errSecSuccess
    }
    
    // 从钥匙串删除账号
    func deleteAccount(_ account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        return status == errSecSuccess
    }
    
    // 检查账号是否存在
    func accountExists(_ account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: false,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        return status == errSecSuccess
    }
    
    // 获取所有保存的账号
    func getAllAccounts() -> [String] {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: false,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let items = result as? [[String: Any]] else {
            return []
        }
        
        let accounts = items.compactMap { $0[kSecAttrAccount as String] as? String }
        return accounts
    }
}
