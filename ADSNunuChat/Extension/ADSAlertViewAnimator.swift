//
//  ADSAlertViewAnimator.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/26.
//

import UIKit
import SnapKit

public enum LKRAlertAnimateType {
    /// 形变
    case scale
    /// 从下往上
    case up
    /// 从上往下
    case down
}
/// 使用该抽象类 内部会把实现该协议的视图控制器的 view 作为childViewController添加到containerview上 视图控制器的view
public protocol ADSAlertViewAnimator where Self: UIViewController {
    typealias Completion = (Bool) -> Void
    /// 动画时长 默认0.3秒
    var alertDuration: CGFloat { get }
    /// 蒙层点击 返回是否响应 默认true
    var hasClickAlertDiming: Bool { get }
    /// 设置背景蒙层的颜色，如果实现了这个代理方法，
    /// 统一的LKRAlertAppearance.appearance.maskColor就失效
    var maskColor: UIColor? { get }
    /// 是否添加导航栏
    var isAddNavigation: Bool { get }
    /// 是否响应 自动隐藏谭框 当弹框设置了自动隐藏时间
    var shouldAutoHiddenAlertIfTimeComed: Bool { get }
    /// 展示弹窗
    /// - Parameters:
    ///   - viewController: 在那个Controller上显示
    ///   - animateType: 动画的类型
    ///   - autoHiddenTime: 多少秒以后自动关闭
    ///   - completion: 事件回调
    func alertIn(_ viewController: UIViewController, animateType: LKRAlertAnimateType, autoHiddenTime: Int, completion: Completion?)
    func alertIn(_ viewController: UIViewController, animateType: LKRAlertAnimateType, completion: Completion?)
    /// 消失
    func alertHidden(completion: Completion?)
    /// view的布局
    /// - Parameters:
    ///   - containerView: 内容容器
    ///   - presentedView: 父容器
    ///   - animateType: 弹窗的模式
    func presentAlertView(containerView: UIView, presentedView: UIView, animateType: LKRAlertAnimateType)
}
// MARK: 默认实现
public extension ADSAlertViewAnimator {
    /// 动画时长
    var alertDuration: CGFloat { 0.3 }
    var hasClickAlertDiming: Bool { true }
    /// 设置背景蒙层的颜色，如果实现了这个代理方法，
    /// 统一的LKRAlertAppearance.appearance.maskColor就失效
    var maskColor: UIColor? { nil }
    var isAddNavigation: Bool { false }
    var shouldAutoHiddenAlertIfTimeComed: Bool { true }
    func presentAlertView(containerView: UIView, presentedView: UIView, animateType: LKRAlertAnimateType) {
        containerView.addSubview(presentedView)
        presentedView.snp.makeConstraints { make in
            switch animateType {
            case .scale:
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            case .up:
                make.left.right.bottom.equalToSuperview()
            case .down:
                make.left.right.top.equalToSuperview()
            }
            
        }
    }
    func alertIn(_ viewController: UIViewController, animateType: LKRAlertAnimateType, autoHiddenTime: Int, completion: Completion?) {
        let containerVC = ADSAlertContainerViewController(self,
                                                          duration: alertDuration,
                                                          animateType: animateType)
        containerVC.autoHiddenTime = autoHiddenTime
        if let maskColor = maskColor {
            containerVC.maskColor = maskColor
        }
        containerVC.slideUpCompletion = { filish in
            completion?(filish)
        }
        containerVC.shouldDimingClick = { [weak self] in
            guard let self = self else { return true }
            return self.hasClickAlertDiming
        }
        containerVC.presentAlertView = { [weak self] containerView, presentedView in
            guard let self = self else { return }
            self.presentAlertView(containerView: containerView, presentedView: presentedView, animateType: animateType)
        }
        containerVC.shouldAutoHidden = { [weak self] in
            guard let self = self else { return true }
            return self.shouldAutoHiddenAlertIfTimeComed
        }
        if isAddNavigation {
            let nav: ADSNavigationController = .init(rootViewController: containerVC)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            viewController.present(nav, animated: false)
        } else {
            containerVC.modalPresentationStyle = .custom
            viewController.present(containerVC, animated: false)
        }
    }
    func alertIn(_ viewController: UIViewController, animateType: LKRAlertAnimateType, completion: Completion?) {
        alertIn(viewController, animateType: animateType, autoHiddenTime: 0, completion: completion)
    }
    func alertHidden(completion: Completion?) {
        guard let fir = parent,
        let vc = fir as? ADSAlertContainerViewController else {
            dismiss(animated: true)
            return
        }
        vc.slideDown(completion: completion)
    }
}
class ADSAlertContainerViewController: UIViewController {
    typealias Completion = (Bool) -> Void
    typealias Intercept = () -> Bool
    typealias PresentAlertViewHandler = (UIView, UIView) -> Void
    var slideUpCompletion: Completion?
    var shouldDimingClick: Intercept?
    var shouldAutoHidden: Intercept?
    var presentAlertView: PresentAlertViewHandler?
    /// 背景颜色
    var maskColor: UIColor = ADSAlertAppearance.appearance.maskColor
    let contentViewController: UIViewController
    let duration: CGFloat
    let animateType: LKRAlertAnimateType
    var autoHiddenTime: Int = 0
    private var isHandleAutoHidden = false
    private var isHiddening = false
    private var isShowed = false
    init(_ contentViewController: UIViewController, duration: CGFloat, animateType: LKRAlertAnimateType) {
        self.contentViewController = contentViewController
        self.duration = duration
        self.animateType = animateType
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        addChild(contentViewController)
        presentedView(contentViewController.view, containerView: view)
        contentViewController.didMove(toParent: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !isShowed else { return }
        animateTransition(isPresenting: true, completion: slideUpCompletion)
        isShowed = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CGFloat(autoHiddenTime) > duration * 5 && !isHandleAutoHidden {
            isHandleAutoHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + CGFloat(autoHiddenTime)) { [weak self] in
                guard let self = self else { return }
                if let should = self.shouldAutoHidden, !should() {
                    return
                }
                self.slideDown(completion: nil)
            }
        }
    }
    @objc
    private func dimingViewClick(_ sender: UITapGestureRecognizer) {
        if let should = shouldDimingClick, !should() {
            return
        }
        slideDown(completion: nil)
    }
    func slideDown(completion: Completion?) {
        guard !isHiddening else { return }
        isHiddening = true
        animateTransition(isPresenting: false) { [weak self] filish in
            guard let self = self else { return }
            self.isHiddening = false
            self.isHandleAutoHidden = false
            self.isShowed = false
            self.dismiss(animated: false) {
                completion?(filish)
            }
        }
    }
    private func animateTransition(isPresenting: Bool, completion: Completion?) {
        switch animateType {
        case .scale:
            makeScale(isPresenting: isPresenting, completion: completion)
        case .up:
            makeUp(isPresenting: isPresenting, completion: completion)
        case .down:
            makeDown(isPresenting: isPresenting, completion: completion)
        }
    }
    private func makeUp(isPresenting: Bool, completion: Completion?) {
        let translation = UIScreen.main.bounds.height
        if isPresenting {
            dimingView.alpha = 0
            contentViewController.view.transform = CGAffineTransform.identity
            contentViewController.view.transform  = CGAffineTransform.identity.translatedBy(x: 0, y: translation)
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
                self.dimingView.alpha = 1
                self.contentViewController.view.transform = CGAffineTransform.identity
            } completion: { filish in
                completion?(filish)
            }
            return
        }
        dimingView.alpha = 1
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
            self.dimingView.alpha = 0
            self.contentViewController.view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: translation)
        } completion: { filish in
            completion?(filish)
        }
    }
    private func makeDown(isPresenting: Bool, completion: Completion?) {
        let translation = UIScreen.main.bounds.height
        if isPresenting {
            dimingView.alpha = 0
            contentViewController.view.transform = CGAffineTransform.identity
            contentViewController.view.transform  = CGAffineTransform.identity.translatedBy(x: 0, y: -translation)
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
                self.dimingView.alpha = 1
                self.contentViewController.view.transform = CGAffineTransform.identity
            } completion: { filish in
                completion?(filish)
            }
            return
        }
        dimingView.alpha = 1
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
            self.dimingView.alpha = 0
            self.contentViewController.view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -translation)
        } completion: { filish in
            completion?(filish)
        }
    }
    private func makeScale(isPresenting: Bool, completion: Completion?) {
        if isPresenting {
            dimingView.alpha = 0
            contentViewController.view.transform = CGAffineTransform.identity
            contentViewController.view.transform  = CGAffineTransform.identity.scaledBy(x: 0.4, y: 0.4)
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
                self.dimingView.alpha = 1
                self.contentViewController.view.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            } completion: { filish in
                completion?(filish)
            }
            return
        }
        dimingView.alpha = 1
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
            self.dimingView.alpha = 0
            self.contentViewController.view.transform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
        } completion: { filish in
            completion?(filish)
        }
    }
    private func presentedView(_ presentedView: UIView, containerView: UIView) {
        containerView.addSubview(dimingView)
        presentAlertView?(containerView, presentedView)
        dimingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private lazy var dimingView: UIView = {
        let aview = UIView()
        aview.backgroundColor = maskColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimingViewClick(_:)))
        aview.addGestureRecognizer(tap)
        return aview
    }()
}

class ADSAlertAppearance {
    public static let appearance: ADSAlertAppearance = .init()
    /// 背景蒙层的统一颜色
    public var maskColor: UIColor = .black.withAlphaComponent(0.5)
}
