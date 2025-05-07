//
//  ADSHUD.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/10.
//

import Foundation
import ProgressHUD

struct ADSHUD {
    
    static func showText(text: String, showView: UIView = kWindow ?? UIWindow()) {
        
        ProgressHUD.animate(text, .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ProgressHUD.remove()
        }
        
    }
    
    static func showHUD(showView: UIView = kWindow ?? UIWindow()) {
        ProgressHUD.animate(nil, .activityIndicator)
    }
    
    static func hidenHUD() {
        ProgressHUD.remove()
    }
    
    static func showSuccess(text: String = "", showView: UIView = kWindow ?? UIWindow()) {
        ProgressHUD.succeed(text)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ProgressHUD.remove()
        }
    }
    
}
