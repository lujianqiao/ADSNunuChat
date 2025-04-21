//
//  ADSUIViewController+Extension.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/4/21 _. All rights reserved.
//
    
import UIKit

extension UIViewController {
    var currentViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.currentViewController
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.currentViewController
        }
        if let presentedViewController = presentedViewController {
            return presentedViewController.currentViewController
        }
        return self
    }
}
