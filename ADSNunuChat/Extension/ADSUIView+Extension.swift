//
//  ADSUIView+Extension.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit

extension UIView {
    /// 添加边线
    ///
    /// - Parameters:
    ///   - color: 边线颜色
    ///   - width: 边线宽度
    public func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /// 添加圆角
    ///
    /// - Parameter radius: 弧度值
    public func addCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
// MARK: 动画相关
public extension UIView {
    /// 添加抖动动画
    /// - Parameters:
    ///   - duration: 执行一次的时间
    ///   - offset: 抖动的偏移量
    ///   - repeatCount: 执行的次数
    func shake(duration: TimeInterval = 0.1,
               offset: CGPoint = .init(x: 4, y: 0),
               repeatCount: Float = 2.0) {
        // 获取当前View的位置
        let position = layer.position
        // 移动的两个终点位置
        let x = CGPoint(x: position.x + offset.x, y: position.y + offset.y)
        let y = CGPoint(x: position.x - offset.x, y: position.y - offset.y)
        // 设置动画
        let animation = CABasicAnimation(keyPath: "position")
        // 设置运动形式
        animation.timingFunction = .init(name: .easeInEaseOut)
        // 设置开始位置
        animation.fromValue = x
        animation.byValue = position
        animation.toValue = y
        animation.autoreverses = true
        animation.duration = duration
        animation.repeatCount = repeatCount
        layer.add(animation, forKey: nil)
    }
}
// MARK: 渐变色
extension UIView {
    /// 普通模式下的渐变
    @discardableResult
    func gradientNoraml(_ cornerRadius: CGFloat, direction: LKRGradientDirection = .horizontal) -> CAGradientLayer {
        addGradientLayer(colors: [UIColor(hex: "#EF7ED4"),
                                  UIColor(hex: "#328FFC")],
                         startPoint: direction.startPoint,
                         endPoint: direction.endPoint,
                         cornerRadius: cornerRadius)
    }
    /// 禁用模式下的渐变
    @discardableResult
    func gradientDisable(_ cornerRadius: CGFloat, direction: LKRGradientDirection = .horizontal) -> CAGradientLayer {
        addGradientLayer(colors: [UIColor(hex: "#EF7ED4", alpha: 0.18),
                                  UIColor(hex: "#328FFC", alpha: 0.18)],
                         startPoint: CGPoint(x: 0, y: 0),
                         endPoint: CGPoint(x: 1, y: 0),
                         cornerRadius: cornerRadius)
    }
    
    /// 设置渐变背景（只支持双色渐变）   注意：autolayout布局下无效，需要先调用方法layoutIfNeeded()方法；或者设置bouns
    /// - Parameters:
    ///   - colors: 渐变颜色组
    ///   - startPoint: 起点
    ///   - endPoint: 终点
    ///   - locations: 渐变位置
    ///   - cornerRadius: 圆角
    @discardableResult
    func addGradientLayer(colors: [UIColor],
                          startPoint: CGPoint,
                          endPoint: CGPoint,
                          locations: [NSNumber] = [0, 1],
                          cornerRadius: CGFloat = .zero) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        var cgColors: [CGColor] = []
        colors.forEach({ cgColors.append($0.cgColor) })
        layer.colors = cgColors
        layer.locations = locations
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.cornerRadius = cornerRadius
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }
}


/// 渐变方向
enum LKRGradientDirection {
    /// 水平
    case horizontal
    /// 垂直
    case vertical
    /// 渐变起始位置
    var startPoint: CGPoint {
        switch self {
        case .horizontal: return .init(x: 0, y: 0)
        case .vertical: return .init(x: 0, y: 0)
        }
    }
    /// 渐变结束位置
    var endPoint: CGPoint {
        switch self {
        case .horizontal: return .init(x: 1, y: 0)
        case .vertical: return .init(x: 0, y: 1)
        }
    }
}
