//
//  ADSHUD.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/10.
//

import Foundation
import MBProgressHUD

struct ADSHUD {
    
    static func showText(text: String, showView: UIView = kWindow ?? UIWindow()) {
        let hud = MBProgressHUD.showAdded(to: showView, animated: true)
        hud.mode = .text
        hud.label.text = text
        hud.offset = CGPoint(x: 0.0, y: 1000000.0)
        hud.hide(animated: true, afterDelay: 2)
    }
    
    static func showHUD(showView: UIView = kWindow ?? UIWindow()) -> MBProgressHUD {
        let window = kWindow ?? UIWindow()
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        return hud
    }
    
}
