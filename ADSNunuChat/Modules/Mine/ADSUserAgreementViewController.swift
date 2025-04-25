//
//  ADSUserAgreementViewController.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/4/22 _. All rights reserved.
//
    

import UIKit
import WebKit
import MBProgressHUD

class ADSUserAgreementViewController: ADSBaseViewController, WKUIDelegate {

    var webView: WKWebView?
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        if let url = URL(string: "https://app.sbnhlsaa.link/#/usersAgreement") {
            let request = URLRequest(url: url)
            webView?.load(request)
            hud = ADSHUD.showHUD()
        }
        if let web = webView {
            view.addSubview(web)
            
        }
        webView?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        // Do any additional setup after loading the view.
    }
}

extension ADSUserAgreementViewController: WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hud?.hide(animated: true)
    }
}
