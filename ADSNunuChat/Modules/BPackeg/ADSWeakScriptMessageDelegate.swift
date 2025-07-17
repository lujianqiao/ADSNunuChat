//
//  ADSWeakScriptMessageDelegate.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/7/17 _. All rights reserved.
//

import UIKit
import WebKit

public class ADSWeakScriptMessageDelegate: NSObject,WKScriptMessageHandler {
    weak var target:WKScriptMessageHandler?
    
    public init(scriptTarget:WKScriptMessageHandler) {
        super.init()
        self.target = scriptTarget
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if self.target != nil && self.target!.responds(to: #selector(userContentController(_:didReceive:))) {
            self.target?.userContentController(userContentController, didReceive: message)
        }
    }
    
}
