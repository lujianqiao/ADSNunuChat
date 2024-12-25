//
//  ADSButton.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit

class ADSButton: UIButton {
    @objc
    public enum LKRPositionStyle: Int {
        /// 图片在左 系统默认
        case left
        /// 图片在右
        case right
        /// 图片在上
        case top
        /// 图片在下
        case bottom
    }
    /// 图片的位置 默认在左边 和系统默认一致
    @objc
    public var positionStyle: LKRPositionStyle = .left {
        didSet { setNeedsLayout() }
    }
    /// 图片与文字之间的间距 只有当文字和图片同时存在 才会生效
    @objc
    public var spacingBetweenImageAndTitle: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    /// preferredMaxLayoutWidth 在高度需要自适应的情况下，如果你想让button的titlelabel换行就设置一个最大宽度
    @objc
    public var preferredMaxLayoutWidth: CGFloat = 0
    
    @objc
    public var adjustsImageTintColorAutomatically = false
    /// 设置扩大点击范围的大小
    public var enlargeEdgeInsets: UIEdgeInsets?
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let inset = enlargeEdgeInsets else {
            return super.point(inside: point, with: event)
        }
        var bounds = self.bounds
        let x = -inset.left
        let y = -inset.top
        let width = bounds.width + inset.left + inset.right
        let height = bounds.height + inset.top + inset.bottom
        bounds = .init(x: x, y: y, width: width, height: height)
        return bounds.contains(point)
    }
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var maxSize = size
        if self.bounds.size == maxSize {
            /// 如果调用 sizeToFit 那么传进来的 size 是当前按钮的size 这儿计算不能限制高度 重新计算出size
            if preferredMaxLayoutWidth > 1 {
                maxSize = .init(width: preferredMaxLayoutWidth,
                                height: CGFloat.greatestFiniteMagnitude)
            } else {
                maxSize = .init(width: CGFloat.greatestFiniteMagnitude,
                                height: CGFloat.greatestFiniteMagnitude)
            }
        }
        let isImageViewShowing = self.currentImage != nil
        let isTitleLabelShowing = self.currentTitle != nil || self.currentAttributedTitle != nil
        var spacingBetween = spacingBetweenImageAndTitle
        if !isImageViewShowing || !isTitleLabelShowing {
            /// 图片和文字有一个不显示  那么文字与图片的间距不参与计算
            spacingBetween = 0
        }
        /// 外部设置的内容偏倚
        let contentInset = self.contentEdgeInsets.removeFloatMin
        /// 最终结果
        var resultSize: CGSize = .zero
        /// 布局区域
        let contentLimitSize: CGSize = .init(width: maxSize.width - contentInset.left - contentInset.right, height: maxSize.height - contentInset.top - contentInset.bottom)
        var imageTotalSize: CGSize = .zero
        var titleTotalSize: CGSize = .zero
        switch positionStyle {
        case .left: fallthrough
        case .right:
            /// 图片和文字水平排版， 高度以图片或者文字的最大高度为最终高度
            ///  这儿有个和系统不一样的问题  titleLabel 为多行时，系统的 sizeThatFits: 计算结果固定是单行的，所以当 titleLabel 多行的情况下计算的结果与系统不一致
            if isImageViewShowing {
                let imageLimitHeight = contentLimitSize.height - self.imageEdgeInsets.top - self.imageEdgeInsets.bottom
                var imageSize: CGSize = .zero
                if let imageView = imageView, imageView.image != nil {
                   imageSize = imageView.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: imageLimitHeight))
                } else if let currentImage = currentImage {
                    imageSize = currentImage.size
                }
                imageSize.height = min(imageSize.height, imageLimitHeight)
                imageTotalSize = CGSize.init(width: imageSize.width + self.imageEdgeInsets.left + self.imageEdgeInsets.right, height: imageSize.height + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom)
            }
            if isTitleLabelShowing {
                let titleLimitSize = CGSize.init(width: contentLimitSize.width - self.titleEdgeInsets.left - self.titleEdgeInsets.right - imageTotalSize.width - spacingBetween, height: contentLimitSize.height - self.titleEdgeInsets.top - self.titleEdgeInsets.bottom)
                if var titleSize: CGSize = self.titleLabel?.sizeThatFits(titleLimitSize) {
                    titleSize.height = min(titleSize.height, titleLimitSize.height)
                    titleTotalSize = CGSize.init(width: titleSize.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right, height: titleSize.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom)
                }
            }
            resultSize.width = imageTotalSize.width + spacingBetween + titleTotalSize.width + contentInset.left + contentInset.right
            resultSize.height = max(imageTotalSize.height, titleTotalSize.height) + contentInset.top + contentInset.bottom
        case .top: fallthrough
        case .bottom:
            /// 图片和文字上下排版 宽度以文字或图片的最大宽度 为最终宽度
            if isImageViewShowing {
                let imageLimitWidth = contentLimitSize.width - self.imageEdgeInsets.left - self.imageEdgeInsets.right
                var imageSize: CGSize = .zero
                if let imageView = imageView, imageView.image != nil {
                   imageSize = imageView.sizeThatFits(CGSize.init(width: imageLimitWidth, height: CGFloat.greatestFiniteMagnitude))
                } else if let currentImage = currentImage {
                    imageSize = currentImage.size
                }
                imageSize.width = min(imageSize.width, imageLimitWidth)
                imageTotalSize = CGSize.init(width: imageSize.width + self.imageEdgeInsets.right + self.imageEdgeInsets.left, height: imageSize.height + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom)
            }
            if isTitleLabelShowing {
                let titleLimitSize = CGSize.init(width: contentLimitSize.width - self.titleEdgeInsets.left - self.titleEdgeInsets.right, height: contentLimitSize.height - imageTotalSize.height - spacingBetween - self.titleEdgeInsets.top - self.titleEdgeInsets.bottom)
                if var titleSize = self.titleLabel?.sizeThatFits(titleLimitSize) {
                    titleSize.height = min(titleSize.height, titleLimitSize.height)
                    titleTotalSize = CGSize.init(width: titleSize.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right, height: titleSize.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom)
                }
            }
            resultSize.width = contentInset.left + contentInset.right + max(imageTotalSize.width, titleTotalSize.width)
            resultSize.height = contentInset.top + contentInset.bottom + imageTotalSize.height + spacingBetween + titleTotalSize.height
        }
        return resultSize
    }
    
    private func layoutLeftOrRight(_ isImageViewShowing: Bool, _ isTitleLabelShowing: Bool) {
        var spacingBetween = self.spacingBetweenImageAndTitle
        if !isImageViewShowing || !isTitleLabelShowing {
            /// 图片和文字有一个不显示  那么文字与图片的间距不参与计算
            spacingBetween = 0
        }
        /// 外部设置的内容偏倚
        let contentInset = self.contentEdgeInsets.removeFloatMin
        var imageLimitSize = CGSize.zero
        var imageTotalSize = CGSize.zero
        var titleTotalSize = CGSize.zero
        var imageFrame = CGRect.zero
        var titleFrame = CGRect.zero
        
        if isImageViewShowing {
            let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
            imageLimitSize = CGSize.init(width: contentSize.width - self.imageEdgeInsets.horizontalValue, height: contentSize.height - self.imageEdgeInsets.verticalValue)
            var imageSize = CGSize.zero
            if let imageView = imageView, imageView.image != nil {
                imageSize = imageView.sizeThatFits(imageLimitSize)
            } else if let currentImage = currentImage {
                imageSize = currentImage.size
            }
            imageSize.width = min(imageLimitSize.width, imageSize.width)
            imageSize.height = min(imageLimitSize.height, imageSize.height)
            imageFrame = CGRect.init(origin: CGPoint.zero, size: imageSize)
            imageTotalSize = CGSize.init(width: imageSize.width + self.imageEdgeInsets.horizontalValue, height: imageSize.height + self.imageEdgeInsets.verticalValue)
        }
        if isTitleLabelShowing {
            let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
            let titleLimitSize = CGSize.init(width: contentSize.width - self.titleEdgeInsets.horizontalValue - imageTotalSize.width - spacingBetween, height: contentSize.height - self.titleEdgeInsets.verticalValue)
            if var titleSize = titleLabel?.sizeThatFits(titleLimitSize) {
                titleSize.width = min(titleLimitSize.width, titleSize.width)
                titleSize.height = min(titleLimitSize.height, titleSize.height)
                titleFrame = CGRect.init(origin: CGPoint.zero, size: titleSize)
                titleTotalSize = CGSize.init(width: titleSize.width + self.titleEdgeInsets.horizontalValue, height: titleSize.height + self.titleEdgeInsets.verticalValue)
            }
        }
        
        switch self.contentVerticalAlignment {
        case .center:
            if isImageViewShowing {
                let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
                imageFrame.setY(contentInset.top + contentSize.height.getCenter(imageFrame.height) + self.imageEdgeInsets.top)
            }
            if isTitleLabelShowing {
                let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
                titleFrame.setY(contentInset.top + contentSize.height.getCenter(titleFrame.height) + self.titleEdgeInsets.top)
            }
        case .top:
            if isImageViewShowing {
                imageFrame.setY(contentInset.top + self.imageEdgeInsets.top)
            }
            if isTitleLabelShowing {
                titleFrame.setY(contentInset.top + self.titleEdgeInsets.top)
            }
        case .bottom:
            if isImageViewShowing {
                imageFrame.setY(self.bounds.height - contentInset.bottom - self.imageEdgeInsets.bottom - imageFrame.height)
            }
            if isTitleLabelShowing {
                titleFrame.setY(self.bounds.height - contentInset.bottom - self.titleEdgeInsets.bottom - titleFrame.height)
            }
        case .fill:
            if isImageViewShowing {
                let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
                imageFrame.setY(contentInset.top + self.imageEdgeInsets.top)
                imageFrame.setHeight(contentSize.height - self.imageEdgeInsets.verticalValue)
            }
            if isTitleLabelShowing {
                let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
                titleFrame.setY(contentInset.top + self.titleEdgeInsets.top)
                titleFrame.setHeight(contentSize.height - self.titleEdgeInsets.verticalValue)
            }
         default: break
        }
        if self.positionStyle == .left {
            let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
            switch self.contentHorizontalAlignment {
            case .center:
                let contentWidth = imageTotalSize.width + spacingBetween + titleTotalSize.width
                let minX = contentInset.left + contentSize.width.getCenter(contentWidth)
                if isImageViewShowing {
                    imageFrame.setX(minX + self.imageEdgeInsets.left)
                }
                if isTitleLabelShowing {
                    titleFrame.setX(minX + imageTotalSize.width + spacingBetween + self.titleEdgeInsets.left)
                }
            case .left:
                if isImageViewShowing {
                    imageFrame.setX(contentInset.left + self.imageEdgeInsets.left)
                }
                if isTitleLabelShowing {
                    titleFrame.setX(contentInset.left + imageTotalSize.width + spacingBetween + self.titleEdgeInsets.left)
                }
            case .right:
                if imageTotalSize.width + spacingBetween + titleTotalSize.width > contentSize.width {
                    if isImageViewShowing {
                        imageFrame.setX(contentInset.left + self.imageEdgeInsets.left)
                    }
                    if isTitleLabelShowing {
                        titleFrame.setX(contentInset.left + imageTotalSize.width + spacingBetween + self.titleEdgeInsets.left)
                    }
                } else {
                    if isTitleLabelShowing {
                        titleFrame.setX(self.bounds.width - contentInset.right - self.titleEdgeInsets.right - titleFrame.width)
                    }
                    if isImageViewShowing {
                        imageFrame.setX(self.bounds.width - contentInset.right - titleTotalSize.width - spacingBetween - imageTotalSize.width + self.imageEdgeInsets.left)
                    }
                }
            case .fill:
                if isImageViewShowing && isTitleLabelShowing {
                    imageFrame.setX(contentInset.left + self.imageEdgeInsets.left)
                    titleFrame.setX(contentInset.left + imageTotalSize.width + spacingBetween + self.titleEdgeInsets.left)
                    titleFrame.setWidth(self.bounds.width - contentInset.right - self.titleEdgeInsets.right - titleFrame.minX)
                } else if isImageViewShowing {
                    imageFrame.setX(contentInset.left + self.imageEdgeInsets.left)
                    imageFrame.setWidth(contentSize.width - self.imageEdgeInsets.horizontalValue)
                } else {
                    titleFrame.setX(contentInset.left + self.titleEdgeInsets.left)
                    titleFrame.setWidth(contentSize.width - self.titleEdgeInsets.horizontalValue)
                }
             default: break
            }
        } else {
            let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
            switch self.contentHorizontalAlignment {
            case .center:
                let contentWidth = imageTotalSize.width + spacingBetween + titleTotalSize.width
                let minX = contentInset.left + contentSize.width.getCenter(contentWidth)
                if isTitleLabelShowing {
                    titleFrame.setX(minX + self.titleEdgeInsets.left)
                }
                if isImageViewShowing {
                    imageFrame.setX(minX + titleTotalSize.width + spacingBetween + self.imageEdgeInsets.left)
                }
            case .left:
                if imageTotalSize.width + spacingBetween + titleTotalSize.width > contentSize.width {
                    if isImageViewShowing {
                        imageFrame.setX(self.bounds.width - contentInset.right - self.imageEdgeInsets.right - imageFrame.width)
                    }
                    if isTitleLabelShowing {
                        titleFrame.setX(self.bounds.width - contentInset.right - imageTotalSize.width - spacingBetween - titleTotalSize.width + self.titleEdgeInsets.left)
                    }
                } else {
                    if isTitleLabelShowing {
                        titleFrame.setX(contentInset.left + self.titleEdgeInsets.left)
                    }
                    if isImageViewShowing {
                        imageFrame.setX(contentInset.left + titleTotalSize.width + spacingBetween + self.imageEdgeInsets.left)
                    }
                }
            case .right:
                if isImageViewShowing {
                    imageFrame.setX(self.bounds.width - contentInset.right - self.imageEdgeInsets.right - imageFrame.width)
                }
                if isTitleLabelShowing {
                    titleFrame.setX(self.bounds.width - contentInset.right - imageTotalSize.width - spacingBetween - self.titleEdgeInsets.right - titleFrame.width)
                }
            case .fill:
                if isImageViewShowing && isTitleLabelShowing {
                    imageFrame.setX(self.bounds.width - contentInset.right - self.imageEdgeInsets.right - imageFrame.width)
                    titleFrame.setX(contentInset.left + self.titleEdgeInsets.left)
                    titleFrame.setWidth(imageFrame.minX - self.imageEdgeInsets.left - spacingBetween - self.titleEdgeInsets.right - titleFrame.minX)
                } else if isImageViewShowing {
                    imageFrame.setX(contentInset.left + self.imageEdgeInsets.left)
                    imageFrame.setWidth(contentSize.width - self.imageEdgeInsets.horizontalValue)
                } else {
                    titleFrame.setX(contentInset.left + self.titleEdgeInsets.left)
                    titleFrame.setWidth(contentSize.width - self.titleEdgeInsets.horizontalValue)
                }
             default: break
            }
        }
        if isImageViewShowing && self.imageView != nil {
            imageFrame.flatted()
            self.imageView?.frame = imageFrame
        }
        if isTitleLabelShowing {
            titleFrame.flatted()
            self.titleLabel?.frame = titleFrame
        }
    }
    
    private func layoutTopOrBottom(_ isImageViewShowing: Bool, _ isTitleLabelShowing: Bool) {
        var spacingBetween = self.spacingBetweenImageAndTitle
        if !isImageViewShowing || !isTitleLabelShowing {
            /// 图片和文字有一个不显示  那么文字与图片的间距不参与计算
            spacingBetween = 0
        }
        /// 外部设置的内容偏倚
        let contentInset = self.contentEdgeInsets.removeFloatMin
        var imageLimitSize = CGSize.zero
        var titleLimitSize = CGSize.zero
        var imageTotalSize = CGSize.zero
        var titleTotalSize = CGSize.zero
        var imageFrame = CGRect.zero
        var titleFrame = CGRect.zero
        if isImageViewShowing {
            let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
            imageLimitSize = CGSize.init(width: contentSize.width - self.imageEdgeInsets.horizontalValue, height: contentSize.height - self.imageEdgeInsets.verticalValue)
            var imageSize = CGSize.zero
            if let imageView = imageView, imageView.image != nil {
                imageSize = imageView.sizeThatFits(imageLimitSize)
            } else if let currentImage = currentImage {
                imageSize = currentImage.size
            }
            imageSize.width = min(imageLimitSize.width, imageSize.width)
            imageSize.height = min(imageLimitSize.height, imageSize.height)
            imageFrame = CGRect.init(origin: CGPoint.zero, size: imageSize)
            imageTotalSize = CGSize.init(width: imageSize.width + self.imageEdgeInsets.horizontalValue, height: imageSize.height + self.imageEdgeInsets.verticalValue)
        }
        if isTitleLabelShowing {
            let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
            titleLimitSize = CGSize.init(width: contentSize.width - self.titleEdgeInsets.horizontalValue, height: contentSize.height - spacingBetween - self.titleEdgeInsets.verticalValue)
            if var titleSize = self.titleLabel?.sizeThatFits(titleLimitSize) {
                titleSize.width = min(titleLimitSize.width, titleSize.width)
                titleSize.height = min(titleLimitSize.height, titleSize.height)
                titleFrame = CGRect.init(origin: CGPoint.zero, size: titleSize)
                titleTotalSize = CGSize.init(width: titleSize.width + titleEdgeInsets.horizontalValue, height: titleSize.height + titleEdgeInsets.verticalValue)
            }
        }
        switch self.contentHorizontalAlignment {
        case .center:
            if isImageViewShowing {
                imageFrame.setX(contentInset.left + self.imageEdgeInsets.left + imageLimitSize.width.getCenter(imageFrame.width))
            }
            if isTitleLabelShowing {
                titleFrame.setX(contentInset.left + self.titleEdgeInsets.left + titleLimitSize.width.getCenter(titleFrame.width))
            }
        case .left:
            if isImageViewShowing {
                imageFrame.setX(contentInset.left + self.imageEdgeInsets.left)
            }
            if isTitleLabelShowing {
                titleFrame.setX(contentInset.left + self.titleEdgeInsets.left)
            }
        case .right:
            if isImageViewShowing {
                imageFrame.setX(contentInset.left + self.imageEdgeInsets.left + imageLimitSize.width.getCenter(imageFrame.width))
            }
            if isTitleLabelShowing {
                titleFrame.setX(contentInset.left + self.titleEdgeInsets.left + titleLimitSize.width.getCenter(titleFrame.width))
            }
        case .fill:
            if isImageViewShowing {
                imageFrame.setX(contentInset.left + self.imageEdgeInsets.left)
                imageFrame.setWidth(imageLimitSize.width)
            }
            if isTitleLabelShowing {
                titleFrame.setX(contentInset.left + self.titleEdgeInsets.left)
                titleFrame.setWidth(titleLimitSize.width)
            }
         default: break
        }
        if positionStyle == .top {
            let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
            switch self.contentVerticalAlignment {
            case .center:
                let contentHeight = imageTotalSize.height + spacingBetween + titleTotalSize.height
                let minY = contentSize.height.getCenter(contentHeight) + contentInset.top
                if isImageViewShowing {
                    imageFrame.setY(minY + self.imageEdgeInsets.top)
                }
                if isTitleLabelShowing {
                    titleFrame.setY(minY + imageTotalSize.height + spacingBetween + self.titleEdgeInsets.top)
                }
            case .top:
                if isImageViewShowing {
                    imageFrame.setY(contentInset.top + self.imageEdgeInsets.top)
                }
                if isTitleLabelShowing {
                    titleFrame.setY(contentInset.top + imageTotalSize.height + spacingBetween + self.titleEdgeInsets.top)
                }
            case .bottom:
                if isImageViewShowing {
                    imageFrame.setY(self.bounds.height - self.imageEdgeInsets.bottom - titleTotalSize.height - spacingBetween - self.imageEdgeInsets.bottom - imageFrame.height)
                }
                if isTitleLabelShowing {
                    titleFrame.setY(self.bounds.height - contentInset.bottom - self.titleEdgeInsets.bottom - titleFrame.height)
                }
            case .fill:
                if isImageViewShowing && isTitleLabelShowing {
                    imageFrame.setY(contentInset.top + self.imageEdgeInsets.top)
                    titleFrame.setY(contentInset.top + imageTotalSize.height + spacingBetween + self.titleEdgeInsets.top)
                    titleFrame.setHeight(self.bounds.height - contentInset.bottom - self.titleEdgeInsets.bottom - titleFrame.minY)
                } else if isImageViewShowing {
                    imageFrame.setY(contentInset.top + self.imageEdgeInsets.top)
                    imageFrame.setHeight(contentSize.height - self.imageEdgeInsets.verticalValue)
                } else {
                    titleFrame.setY(contentInset.top + self.titleEdgeInsets.top)
                    titleFrame.setHeight(contentSize.height - self.titleEdgeInsets.verticalValue)
                }
            default: break
            }
        } else {
            let contentSize = CGSize.init(width: self.bounds.width - contentInset.horizontalValue, height: self.bounds.height - contentInset.verticalValue)
            switch self.contentVerticalAlignment {
            case .center:
                let contentHeight = imageTotalSize.height + titleTotalSize.height + spacingBetween
                let minY = contentSize.height.getCenter(contentHeight) + contentInset.top
                if isTitleLabelShowing {
                    titleFrame.setY(minY + self.titleEdgeInsets.top)
                }
                if isImageViewShowing {
                    imageFrame.setY(minY + titleTotalSize.height + spacingBetween + self.imageEdgeInsets.top)
                }
            case .top:
                if isTitleLabelShowing {
                    titleFrame.setY(contentInset.top + self.titleEdgeInsets.top)
                }
                if isImageViewShowing {
                    imageFrame.setY(contentInset.top + titleTotalSize.height + spacingBetween + self.imageEdgeInsets.top)
                }
            case .bottom:
                if isImageViewShowing {
                    imageFrame.setY(self.bounds.height - contentInset.bottom - self.imageEdgeInsets.bottom - imageFrame.height)
                }
                if isTitleLabelShowing {
                    titleFrame.setY(self.bounds.height - contentInset.bottom - imageTotalSize.height -  spacingBetween - self.titleEdgeInsets.bottom - titleFrame.height)
                }
            case .fill:
                if isImageViewShowing && isTitleLabelShowing {
                    imageFrame.setY(self.bounds.height - contentInset.bottom - self.imageEdgeInsets.bottom - imageFrame.height)
                    titleFrame.setY(contentInset.top + self.titleEdgeInsets.top)
                    titleFrame.setHeight(self.bounds.height - contentInset.bottom - imageTotalSize.height - spacingBetween - self.titleEdgeInsets.bottom - titleFrame.minY)
                } else if isImageViewShowing {
                    imageFrame.setY(contentInset.top + self.imageEdgeInsets.top)
                    imageFrame.setHeight(contentSize.height - self.imageEdgeInsets.verticalValue)
                } else {
                    titleFrame.setY(contentInset.top + self.titleEdgeInsets.top)
                    titleFrame.setHeight(contentSize.height - self.titleEdgeInsets.verticalValue)
                }
             default: break
            }
        }
        if isImageViewShowing && self.imageView != nil {
            imageFrame.flatted()
            self.imageView?.frame = imageFrame
        }
        if isTitleLabelShowing && self.titleLabel != nil {
            titleFrame.flatted()
            self.titleLabel?.frame = titleFrame
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        guard !bounds.isEmpty else { return }
        let isImageViewShowing = currentImage != nil
        let isTitleLabelShowing = currentTitle != nil || currentAttributedTitle != nil
        switch positionStyle {
        case .left: fallthrough
        case .right:
            layoutLeftOrRight(isImageViewShowing, isTitleLabelShowing)
        case .top: fallthrough
        case .bottom:
            layoutTopOrBottom(isImageViewShowing, isTitleLabelShowing)
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        if preferredMaxLayoutWidth > 1 {
            return sizeThatFits(CGSize.init(width: preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude))
        }
        return sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }
    
    public func updateImageRenderModeIfNeed() {
        if currentImage == nil { return }
        let states: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
        states.forEach {
            if let image = self.image(for: $0) {
                if adjustsImageTintColorAutomatically {
                    self.setImage(image, for: $0)
                } else {
                    self.setImage(image.withRenderingMode(.alwaysOriginal), for: $0)
                }
            }
        }
    }
    
    open override func setImage(_ image: UIImage?, for state: UIControl.State) {
        var simage = image
        if adjustsImageTintColorAutomatically {
            simage = simage?.withRenderingMode(.alwaysTemplate)
        }
        super.setImage(simage, for: state)
    }
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        if adjustsImageTintColorAutomatically {
            updateImageRenderModeIfNeed()
        }
    }
}
// MAKR: 快捷赋值
extension CGRect {
    mutating func setX(_ x: CGFloat) { origin.x = x }
    mutating func setY(_ y: CGFloat) { origin.y = y }
    mutating func setWidth(_ width: CGFloat) { size.width = width }
    mutating func setHeight(_ height: CGFloat) { size.height = height }
    /// 按照屏幕分辨率适配
    mutating func flatted() {
        origin.x = origin.x.flatSpecificScale()
        origin.y = origin.y.flatSpecificScale()
        size.width = size.width.flatSpecificScale()
        size.height = size.height.flatSpecificScale()
    }
}
// MARK: 计算的扩展
extension CGFloat {
    /// 删除最小值，防止最小值出现的计算错误
    var removeFloatMin: CGFloat {
        if self == CGFloat.leastNormalMagnitude { return 0 }
        return self
    }
    /// 计算中心位置
    func getCenter(_ child: CGFloat) -> CGFloat {
        let result = (self - child) / 2.0
        return result.removeFloatMin
    }
    /// 按照屏幕分辨率适配
    func flatSpecificScale() -> CGFloat {
        var value = removeFloatMin
        let scale = UIScreen.main.scale
        value = ceil(value * scale) / scale
        return value
    }
}
// MARK: 计算的扩展
extension UIEdgeInsets {
    var horizontalValue: CGFloat { `left` + `right` }
    var verticalValue: CGFloat { top + bottom }
    var removeFloatMin: UIEdgeInsets {
        UIEdgeInsets.init(top: top.removeFloatMin,
                          left: `left`.removeFloatMin,
                          bottom: bottom.removeFloatMin,
                          right: `right`.removeFloatMin)
    }
}
