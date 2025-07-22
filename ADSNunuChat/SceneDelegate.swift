//
//  SceneDelegate.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/18.
//

import UIKit
import IQKeyboardManagerSwift

let AESkey = "d4wa9a5te5b5d2gc"
let AESIV = "1244nu5p9yv81ns0"
let AppId = "14949641"

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        initThreeLibrary()
        
        // 判断当前语言是否是中文
        if let language = Locale.preferredLanguages.first, language.hasPrefix("zh-") {
            goApakage()
        } else if ADSConst.isChineseCarrier() {
            // 使用中国网络运营商
            goApakage()
        } else {
            window?.rootViewController = ADSLaunchScreenViewController()
           
            let parma: [String: Any] = ["fwercard": ADSConst.isSIMInserted() ? 1: 0,
                                        "regervpn": ADSConst.isVPNConnected() ? 1: 0,
                                        "ergergdebug": 0,
                                        "langerguage": [Locale.preferredLanguages.first ?? "en-CN"],
                                        "zogernet": TimeZone.current.identifier]
            
            httpBProvider.request(.getOpenStatus(parma)) { result in
                
                switch result {
                case .success(let response):
                    guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {
                        self.goApakage()
                        return}
                    guard let resultModel = ADSBOpenModel.deserialize(from: json) else {
                        self.goApakage()
                        return}
                    guard resultModel.code == "0000" else {
                        self.goApakage()
                        return}
                    guard let aes = AESCBC(key: AESkey, iv: AESIV) else  {
                        self.goApakage()
                        return}
                    // 解密
                    guard let decry = aes.decrypt(hexString: resultModel.result) else {
                        self.goApakage()
                        return}
                    guard let resultJson = try? JSONSerialization.jsonObject(with: decry, options: []) as? [String: Any] else {
                        self.goApakage()
                        return}
                    guard let resultModel = LaunchResultModel.deserialize(from: resultJson) else {
                        self.goApakage()
                        return}
                    
                    let web = ADSBWebViewController.init(model: resultModel)
                    self.window?.rootViewController = web
                    debugPrint(resultJson)
                case .failure(_):
                    debugPrint("启动接口异常")
                    self.goApakage()
                }
            }
        }
    }
    
    /// 去A包
    func goApakage() {
        if let _ = ADSConst.getUserDefaultsData(with: ADSConst.userTokenKey) {
            window?.rootViewController = ADSTabBarViewController()
        } else {
            let signInVC = ADSNavigationController(rootViewController: ADSSignVC())
            window?.rootViewController = signInVC
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


    /// 三方库相关初始化配置
    func initThreeLibrary() {
        // 配置 IQKeyboardManager
//        IQKeyboardManager.shared.enable = true
        // 点击空白处收起键盘
        IQKeyboardManager.shared.resignOnTouchOutside = true
//        // 设置按钮文字
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = SLocalized.mine_edit_complete.tr
//        // 设置按钮字体颜色
//        IQKeyboardManager.shared.toolbarTintColor = UIColor(hex: 0x5b5b5b)
    }
    
}

extension UIApplication {
    /// 获取当前的key window
    var topWindow: UIWindow? {
        var view = UIApplication.shared.keyWindow
        let windows = UIApplication.shared.windows
        /// 检查是否有键盘弹起
        for window in windows {
            let viewName = NSStringFromClass(type(of: window))
            if viewName == "UIRemoteKeyboardWindow" {
                view = window
                break
            }
            if window.isKeyWindow {
                view = window
             }
        }
        return view
    }
}
