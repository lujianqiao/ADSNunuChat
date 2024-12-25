//
//  ADSUIColor+Extension.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//
import UIKit

public extension UIColor {
    /// 字符串初始化
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var value: UInt32 = 0
        scanner.scanHexInt32(&value)
        self.init(hex: value, alpha: alpha)
    }
    /// 初始化
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0xff00) >> 8
        let b = hex & 0xff
        self.init(red: CGFloat(r) / 0xff,
                  green: CGFloat(g) / 0xff,
                  blue: CGFloat(b) / 0xff,
                  alpha: alpha)
    }
    /// 生成随机颜色
    class var random: UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return randomColor
    }
}
