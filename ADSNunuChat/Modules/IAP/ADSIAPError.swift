//
//  STIAPError.swift
//  ShortTV
//
//  Created by 陈蔚祥 on 2024/8/26.
//

import UIKit

public enum ADSIAPError: Error {
    /// 订阅失败
    case subscribeFail(_ code: Int)
    /// 续订失败
    case restoreFail(_ code: Int)
    /// 无效商品
    case invalidProduct(_ code: Int, _ invalidId: String)
    /// 不存在的商品
    case withoutProduct(_ code: Int)
}
// MARK: CustomNSError
extension ADSIAPError: CustomNSError {
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        userInfo[NSCocoaErrorDomain] = errorDescription
        return userInfo
    }
    public var errorCode: Int {
        switch self {
        case let .subscribeFail(code): return code
        case let .restoreFail(code): return code
        case let .invalidProduct(code, _): return code
        case let .withoutProduct(code): return code
        }
    }
    public static var errorDomain: String { "com.shortTV.iap.error" }
}
// MARK: LocalizedError
extension ADSIAPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .subscribeFail: return "subscribed fail."
        case .restoreFail: return "restore fail."
        case let .invalidProduct(_, invalidId): return "iap invalid: \(invalidId)"
        case .withoutProduct: return "without product."
        }
    }
}
