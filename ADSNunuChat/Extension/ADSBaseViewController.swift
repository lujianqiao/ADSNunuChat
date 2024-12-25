//
//  ADSBaseViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit
//import LKRExtension

/// 基类方便后期做扩展
open class ADSBaseViewController: UIViewController {
    /// 是否离开页面重置浏览时间 - 每次设置只在一个声明周期里面生效
    public var isResetVistPageDate: Bool = true
    /// 导航栏背景颜色
    private var navigationBgImageColor: UIColor?
    /// 浏览页面开始时间
    private var vistPageStartDate: Date = .init()
    /// 浏览页面结束时间
    private var vistPageEndDate: Date = .init()
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = hidesBottomBarWhenPushedInitially
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isResetVistPageDate {
            vistPageStartDate = .init()
        } else {
            isResetVistPageDate = true
        }
        renderNavigationBarStyle(animated)
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isResetVistPageDate {
            vistPageEndDate = .init()
        }
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    /// 修改导航栏的颜色 - 通过lkrNavigationBarBackgroundImage的逻辑来修改背景颜色
    /// - Parameter color: 导航栏的颜色
    public func changeNavigationBarColor(_ color: UIColor) {
        navigationBgImageColor = color
        renderNavigationBarStyle(true)
    }
}
// MARK: 外部方法
public extension ADSBaseViewController {
    /// 页面浏览时长 - 秒
    var vistPageDuration: TimeInterval {
        let endTime = vistPageEndDate.timeIntervalSince1970
        let startTime = vistPageStartDate.timeIntervalSince1970
        return endTime - startTime
    }
}
// MARK: 设置默认的导航栏
@objc extension ADSBaseViewController: ADSNavigationBarUIDelegate {
    /// 是否允许手势进行返回
    open func shouldBeginInteractivePopGesture(_ gesture: UIGestureRecognizer) ->  Bool { true }
    /// 设置 titleView 的 tintColor
    open var lkrTitleViewTintColor: UIColor? { ADSNavigationAppearance.appearance.titleColor }
    /// 设置 titleView 的 font
    open var lkrTitleViewFont: UIFont? { ADSNavigationAppearance.appearance.titleFont }
    /// 设置导航栏的背景图，默认为 NavBarBackgroundImage
    open var lkrNavigationBarBackgroundImage: UIImage? {
        let appearance = ADSNavigationAppearance.appearance
        if let image = appearance.backgroundImage {
            return image
        }
        var color: UIColor = appearance.backgroundColor
        if let bgColor = navigationBgImageColor {
            color = bgColor
        }
        return .imageFromColor(color, size: CGSize(width: 4, height: 4))
    }
    /// 设置导航栏底部的分隔线图片，默认为 NavBarShadowImage，必须在 navigationBar 设置了背景图后才有效（系统限制如此）
    open var lkrNavigationBarShadowImage: UIImage? {
        .imageFromColor(.clear, size: CGSize(width: 1, height: 1))
    }
    /// 设置当前导航栏的 UIBarButtonItem 的 tintColor，默认为NavBarTintColor
    open var lkrNavigationBarTintColor: UIColor? { .white }
    /// 设置每个界面导航栏的显示/隐藏
    open var preferredNavigationBarHidden: Bool { false }
    /// hidesBottomBarWhenPushed 的初始值，默认为 NO，以保持与系统默认值一致，但通常建议改为 YES，因为一般只有 tabBar 首页那几个界面要求为 NO
    /// 在initWithnib 初始化的时候调用
    open var hidesBottomBarWhenPushedInitially: Bool { true }
    /// 返回按钮图标
    open var lkrBackIndicatorImage: UIImage? {
        ADSNavigationAppearance.appearance.backImage
    }
}
