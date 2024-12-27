//
//  ADSConst.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit

public let kScreenWidth: Double = UIScreen.main.bounds.size.width
public let kScreenHeight: Double = UIScreen.main.bounds.size.height
/// 获取keywindow
public var kWindow: UIWindow? { UIApplication.shared.topWindow }

// MARK: 安全距离相关
/// 状态栏高度
public var kStatusBarHeight: Double { UIApplication.shared.statusBarFrame.size.height }
/// 导航栏高度
public var kNavigationBarHeight: CGFloat { 44.0 }
/// 顶部导航栏高度(状态栏和导航栏的高度)
public var kNavHeight: CGFloat { kStatusBarHeight + kNavigationBarHeight }
/// 底部安全区域总高度
public var kSafeMarginHeight: CGFloat { kNavHeight + kSafeBottomMargin }
/// 标签栏高度
public var kTabbarHeight: CGFloat { iPhoneXSeries ? (49.0 + kSafeBottomMargin) : 49.0 }
/// 顶部安全区域高度
public var kSafeTopMargin: CGFloat {
    if #available(iOS 13.0, *) {
        return kWindow?.safeAreaInsets.top ?? .zero
    } else if #available(iOS 11.0, *) {
        return kWindow?.safeAreaInsets.top ?? .zero
    } else {
        return .zero
    }
}
/// 底部安全区域高度
public var kSafeBottomMargin: CGFloat {
    if #available(iOS 13.0, *) {
        return kWindow?.safeAreaInsets.bottom ?? .zero
    } else if #available(iOS 11.0, *) {
        return kWindow?.safeAreaInsets.bottom ?? .zero
    } else {
        return .zero
    }
}
/// 是否是iphonex系列
public var iPhoneXSeries: Bool {
    guard #available(iOS 11.0, *),
          (kWindow?.safeAreaInsets.bottom ?? 0.0) > 0.0 else {
        return false
    }
    return true
}
/// 是不是暗黑模式
public var isDarkMode: Bool {
    // iOS 12 以下不支持暗模式
    guard #available(iOS 12.0, *) else { return false }
    return UIScreen.main.traitCollection.userInterfaceStyle == .dark
}

struct ADSConst {
    
    /// APP名称
    static var AppDisplayName: String {
        let infoDictionary: Dictionary? = Bundle.main.infoDictionary
        let kAppDisplayName = infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        return kAppDisplayName
    }
    
    
    /// APP版本号
    static var AppCurrentVersion: String {
        let infoDictionary: Dictionary? = Bundle.main.infoDictionary
        let kAppCurrentVersion = infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return kAppCurrentVersion
    }
    
    /// 设备号
    static var uniqueDeviceID: String {
        if let uuidString = UserDefaults.standard.object(forKey: "device_uuid") {
            if let uuid = uuidString as? String {
                return uuid
            }
        }
        
        let uuid = UUID().uuidString
        UserDefaults.standard.setValue(uuid, forKey: "device_uuid")
        UserDefaults.standard.synchronize()
        return uuid
    }
    
    /// 获取SceneDelegate
    static func getSceneDelegate() -> SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return nil
        }
        return sceneDelegate
    }
}
