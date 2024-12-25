//
//  ADSNavigationAppearance.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit

public class ADSNavigationAppearance {
    public typealias GlobalHandler = () -> Void
    public static let appearance: ADSNavigationAppearance = .init()
    /// title color
    public var titleColor: UIColor = .white
    /// title font
    public var titleFont: UIFont = .systemFont(ofSize: 18, weight: .bold)
    /// 背景颜色 - 不支持暗黑模式
    public var backgroundColor: UIColor = .init(hex: "#1D1C23")
    /// 背景图片 - 支持暗黑模式
    public var backgroundImage: UIImage?
    /// 返回按钮图标
    public var backImage: UIImage? = UIImage(named: "nav_back")
    /// 统一的返回按钮事件 - 可以通过LKRNavigationController内部的backHandler处理单独的事件
    public var globalBackHandler: GlobalHandler?
}
