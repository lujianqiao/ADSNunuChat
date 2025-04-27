//
//  ADSString+Extension.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/4/27 _. All rights reserved.
//

import UIKit

public extension String {
    
    /// 计算文字的高度
    /// - Parameters:
    ///   - font: font
    ///   - width: 需要显示的宽度
    /// - Returns: 文字高度
    func calculateTextHeight(_ font: UIFont, width: CGFloat) -> Float {
        let text = NSString(string: self)
        // 配置文本绘制选项
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        // 配置计算属性参数
        let atrributes = [NSAttributedString.Key.font: font]
        let size = CGSize(width: CGFloat(width), height: CGFloat(MAXFLOAT))
        let rect = text.boundingRect(with: size,
                                     options: options,
                                     attributes: atrributes,
                                     context: nil)
        return Float(ceil(rect.height))
    }
    
}
