//
//  ADSUIImage+Extension.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit

// MARK: 图片颜色处理相关
public extension UIImage {
    /// 绘制一张纯色的图片
    /// - Parameters:
    ///   - color: color
    ///   - size: size
    /// - Returns: image
    static func imageFromColor(_ color: UIColor, size: CGSize) -> UIImage {
        let imageSize = size
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        UIRectFill(CGRect(x: 0,
                          y: 0,
                          width: imageSize.width,
                          height: imageSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    /// 对图片做透明度处理
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    /// 开始设置图片
    static func image(_ name: String) -> UIImage? {
        var language = UIImage.currentLanguageCode
        if language.contains("en"),
           let image = UIImage(named: "\(name)_en") {
            return image
        }
        return UIImage(named: name)
    }
    /// 用自定义颜色初始化图片
    /// - Parameter color: color
    /// - Returns: image
    func changed(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        guard let cgImage = cgImage else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage)
        color.setFill()
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    /// 压缩尺寸 直接压缩到指定尺寸
    func compressImage(size: CGSize) -> UIImage? {
        if self.size.width > size.width {
            UIGraphicsBeginImageContext(size)
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        } else {
            return self
        }
    }

    /// 压缩尺寸 直接压缩到指定尺寸
    static func compressImage(image: UIImage, size: CGSize) -> UIImage? {
        if let image = image.copy() as? UIImage, image.size.width > size.width {
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage;
        } else {
            return image;
        }
    }

    /// 将图片压缩到指定大小 1M=1024*1024
    static func compressData(image base: UIImage, maxLength: Int) -> Data? {
        var compression: CGFloat = 1
        guard var data = base.jpegData(compressionQuality: compression) else {
            return nil
        }
        guard data.count > maxLength else {
            return data
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max+min)/2;
            data = base.jpegData(compressionQuality: compression) ?? Data()
            if (data.count < Int(Double(maxLength) * 0.9)) {
                min = compression
            } else if (data.count > maxLength) {
                max = compression
            } else {
                break
            }
        }

        guard data.count > maxLength else {
            return data
        }
        // 缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
        guard var theImage = UIImage(data: data) else {
            return nil
        }
        var lastDataLength = 0;
        while data.count > maxLength && data.count != lastDataLength  {
            lastDataLength = data.count
            let ratio: Float = Float(maxLength) / Float(data.count)
            let width = theImage.size.width*CGFloat(sqrt(ratio))
            let height = theImage.size.height*CGFloat(sqrt(ratio))
            let size = CGSize(width: floor(width), height: floor(height))
            UIGraphicsBeginImageContext(size)
            theImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height));
            theImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            UIGraphicsEndImageContext()
            data = theImage.jpegData(compressionQuality: compression) ?? Data()
        }
        return data
    }

    /// 将图片压缩到指定大小 1M=1024*1024 先压缩尺寸
    static func compressImage(image base: UIImage, maxLength: Int) -> Data? {
        // 先压缩尺寸 在压缩质量
        let aspectRatio = CGFloat(base.size.width) / CGFloat(base.size.height)
        var pixelWidth: CGFloat = CGFloat(UIScreen.main.bounds.size.width) * 2
        // 超宽图片
        if (aspectRatio > 1.8) {
            pixelWidth = pixelWidth * aspectRatio
        }
        // 超高图片
        if (aspectRatio < 0.2) {
            pixelWidth = pixelWidth * 0.5
        }
        let pixelHeight = pixelWidth / aspectRatio
        guard let image = compressImage(image: base, size: CGSize(width: pixelWidth, height: pixelHeight)) else {
            return nil
        }
        return compressData(image: image, maxLength: maxLength)
    }
}
private extension UIImage {
    /// 获取当前app的语言
    static var currentLanguageCode: String {
        var code = ""
        let languages = UserDefaults.standard.object(forKey: "AppLanguages")
        if let languages = languages, let currCode = languages as? String {
            code = currCode.lowercased()
        } else {
            code = NSLocale.current.identifier.lowercased()
        }
        code = code.replacingOccurrences(of: "-", with: "_")
        return language(code: code)
    }
    /// 获取语言code映射
    static private func language(code: String) -> String {
        if code.elementsEqual("zh_cn") || code.contains("zh_hans") {
            return "zh_CN"
        } else if code.elementsEqual("zh_tw") || code.elementsEqual("zh_hk") || code.elementsEqual("zh_mo") || code.contains("zh_hant") {
            return "zh_TW"
        } else if code.contains("vi") {
            return "vi"
        }
        return "en_US"
    }
}
// MARK: 处理图片
public extension UIImage {
    // 模糊值
    enum BlurryType {
        /// 高斯模糊
        case GaussianBlur
        /// 均值模糊
        case BoxBlur
        /// 环形卷积模糊
        case DiscBlur
        /// 运动模糊
        case MotionBlur
        /// 名称
        var name: String {
            switch self {
            case .GaussianBlur: return "CIGaussianBlur"
            case .BoxBlur: return "CIBoxBlur"
            case .DiscBlur: return "CIDiscBlur"
            case .MotionBlur: return "CIMotionBlur"
            }
        }
    }
    /// 图片模糊处理
    /// - Parameters:
    ///   - blurry: 模糊的类型
    ///   - value: 模糊值（越大越模糊）
    /// - Returns: UIImage?
    func toBlurry(blurry: BlurryType, value: Int = 25) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let input = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: blurry.name)
        filter?.setValue(input, forKey: kCIInputImageKey)
        filter?.setValue(NSNumber(value: value), forKey: kCIInputRadiusKey)
        let context = CIContext(options: nil)
        guard let outputImg = filter?.outputImage,
              let imgRef = context.createCGImage(outputImg, from: outputImg.extent) else { return nil }
        return UIImage.init(cgImage: imgRef)
    }
}
