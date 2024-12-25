//
//  ADSNavigationController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit

open class ADSNavigationController: UINavigationController {
    public typealias BackHandler = () -> Bool
    /// 导航栏的返回事件 返回值 true响应基类的事件，false则反之
    /// false globalBackHandler也不会响应
    public var backHandler: BackHandler?
    open override func viewDidLoad() {
        super.viewDidLoad()
        if let gestureRecognizer = self.interactivePopGestureRecognizer {
            gestureRecognizer.delegate = self
        }
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if viewControllers.count > 1 {
            let backBtn: UIButton = .init(type: .custom)
            var backImg = ADSNavigationAppearance.appearance.backImage
            if let topViewController = navigationBarUI,
               let newBackImg = topViewController.lkrBackIndicatorImage {
                backImg = newBackImg
            }
            backBtn.setImage(backImg, for: .normal)
            backBtn.setImage(backImg?.withTintColor(.init(hex: "#828282")), for: .highlighted)
            backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
            let backItem = UIBarButtonItem(customView: backBtn)
            viewController.navigationItem.leftBarButtonItem = backItem
        }
    }
    
    @objc
    func backAction() {
        if let handler = backHandler, !handler() {
            return
        }
        ADSNavigationAppearance.appearance.globalBackHandler?()
        popViewController(animated: true)
    }
    /// 获取控制器的代理对象
    private var navigationBarUI: ADSNavigationBarUIDelegate? {
        let topViewController = topViewController as? ADSNavigationBarUIDelegate
        guard let topViewController = topViewController else { return nil }
        return topViewController
    }
}
// MARK: 手势处理
extension ADSNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard children.count > 1 else { return false }
        guard let topViewController = topViewController else { return false }
        // 默认不允许手势返回
        if let topViewController = navigationBarUI {
            return topViewController.shouldBeginInteractivePopGesture(gestureRecognizer)
        }
        return true
    }
}
// MARK: 判断只有一个视图手势禁止
extension ADSNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let interactivePopGestureRecognizer = interactivePopGestureRecognizer {
            if viewControllers.count > 1 {
                interactivePopGestureRecognizer.isEnabled = true
            } else {
                interactivePopGestureRecognizer.isEnabled = false
            }
        }
    }
}
