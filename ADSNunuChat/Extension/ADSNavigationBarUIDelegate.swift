//
//  ADSNavigationBarUIDelegat.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit
//import LKRExtension

public protocol ADSNavigationBarUIDelegate: UIViewController {
    /// 设置 titleView 的 tintColor
    var lkrTitleViewTintColor: UIColor? { get }
    /// 设置 titleView 的 font
    var lkrTitleViewFont: UIFont? { get }
    /// 设置导航栏的背景图，默认为 NavBarBackgroundImage
    var lkrNavigationBarBackgroundImage: UIImage? { get }
    /// 设置导航栏底部的分隔线图片，默认为 NavBarShadowImage，必须在 navigationBar 设置了背景图后才有效（系统限制如此）
    var lkrNavigationBarShadowImage: UIImage? { get }
    /// 设置当前导航栏的 UIBarButtonItem 的 tintColor，默认为NavBarTintColor
    var lkrNavigationBarTintColor: UIColor? { get }
    /// 返回按钮图标
    var lkrBackIndicatorImage: UIImage? { get }
    /// 设置每个界面导航栏的显示/隐藏
    var preferredNavigationBarHidden: Bool { get }
    /// hidesBottomBarWhenPushed 的初始值，默认为 NO，以保持与系统默认值一致，但通常建议改为 YES，因为一般只有 tabBar 首页那几个界面要求为 NO
    var hidesBottomBarWhenPushedInitially: Bool { get }
    /// 更新导航栏
    func renderNavigationBarStyle(_ animated: Bool)
    /// 设置导航栏颜色
    func updateNavigationBarStyle()
    /// 是否允许手势返回
    func shouldBeginInteractivePopGesture(_ gesture: UIGestureRecognizer) ->  Bool
}
// MARK: 默认实现
public extension ADSNavigationBarUIDelegate {
    /// 更新导航栏
    func renderNavigationBarStyle(_ animated: Bool) {
        guard let nav = navigationController else { return }
        let navBar: UINavigationBar = nav.navigationBar
        updateNavigationBarStyle()
        if preferredNavigationBarHidden {
            if !nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(true, animated: animated)
            }
        } else {
            if nav.isNavigationBarHidden {
                nav.setNavigationBarHidden(false, animated: animated)
            }
        }
        // 隐藏 高斯模糊层 _UIBarBackgroundShadowView
        for view in navBar.subviews {
            if "\(view.self)".contains("UIBarBackground"){
                for effectView in view.subviews {
                    if "\(effectView.self)".contains("UIVisualEffectView"),
                       let effectView = effectView as? UIVisualEffectView {
                        effectView.isHidden = true
                    }
                }
            }
        }
    }
    /// 设置导航栏颜色
    func updateNavigationBarStyle() {
        guard let nav = navigationController else { return }
        let navBar: UINavigationBar = nav.navigationBar
        var titleAttrs: [NSAttributedString.Key: Any] = [:]
        titleAttrs[.foregroundColor] = lkrTitleViewTintColor
        titleAttrs[.font] = lkrTitleViewFont
        if #available(iOS 13.0, *) {
            let barButtonAppearance: UIBarButtonItemAppearance = .init()
            var titleTextAttributes: [NSAttributedString.Key: Any] = [:]
            titleTextAttributes[.foregroundColor] = lkrNavigationBarTintColor
            barButtonAppearance.normal.titleTextAttributes = titleTextAttributes
            let appearance: UINavigationBarAppearance = .init()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = lkrNavigationBarBackgroundImage
            appearance.backgroundColor = .clear
            appearance.titleTextAttributes = titleAttrs
            appearance.setBackIndicatorImage(lkrBackIndicatorImage,
                                             transitionMaskImage: lkrBackIndicatorImage)
            appearance.shadowImage = lkrNavigationBarShadowImage
            appearance.buttonAppearance = barButtonAppearance
            appearance.doneButtonAppearance = barButtonAppearance
            appearance.backButtonAppearance = barButtonAppearance
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
        } else {
            navBar.setBackgroundImage(lkrNavigationBarBackgroundImage, for: .default)
            navBar.backgroundColor = .clear
            navBar.tintColor = lkrNavigationBarTintColor
            navBar.shadowImage = lkrNavigationBarShadowImage
            navBar.titleTextAttributes = titleAttrs
        }
    }
}
