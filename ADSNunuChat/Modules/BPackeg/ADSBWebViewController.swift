//
//  ADSBWebViewController.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/7/16 _. All rights reserved.
//

import UIKit
import WebKit

class ADSBWebViewController: UIViewController {

//    private var url: String = ""
    private var data: LaunchResultModel = .init()
    
    lazy var launchImageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "launch")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    /// web view
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        return webView
    }()
    /// web配置
    private lazy var config: WKWebViewConfiguration = {
        let userContentController = WKUserContentController()
        // 加载刷新的监听
        let reloadJs = "window.addEventListener('pageshow', function(event){if(event.persisted){location.reload();}});"
        let reloadScript = WKUserScript(source: reloadJs, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(reloadScript)
        userContentController.add(ADSWeakScriptMessageDelegate(scriptTarget: self), name: "inVite")
        // 初始化配置
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        config.mediaTypesRequiringUserActionForPlayback = []
        // 需要配置允许使用相机
        config.allowsInlineMediaPlayback = true
        config.preferences.javaScriptEnabled = true
        config.ignoresViewportScaleLimits = true
        return config
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        handleData()
//        loadWeb()
        // Do any additional setup after loading the view.
    }
    
    convenience init(model: LaunchResultModel) {
        self.init()
        self.data = model
    }
    
    func setUpUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(launchImageView)
        launchImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func handleData() {
        if data.loginFlag == 1 {
            // 已经登录
            guard let token = ADSConst.getUserDefaultsData(with: ADSConst.userBTokenKey) else {return}
            let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
            let openParams: [String: Any] = ["token": token, "timestamp": "\(timeStamp)"]
            if let openParamsValue = ADSBHttp.handleAESCrypt(param: openParams) {
                let url = "\(self.data.openValue)?openParams=\(openParamsValue)&appId=\(AppId)"
                self.loadWeb(url: url)
            }
        } else {
            // 未登录
            
            var param: [String: Any] = ["ddeeNn": ADSConst.uniqueDeviceID]
            if let ps = ADSConst.getUserDefaultsData(with: ADSConst.userBPassword) {
                param["fqerfqed"] = ps
            }
            
            httpBProvider.request(.signIn(param)) { result in
                ADSHUD.hidenHUD()
                switch result {
                case .success(let response):
                    guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                    guard let result = json["result"] as? String else {return}
                    if let aes = AESCBC(key: AESkey, iv: AESIV) {
                        // 解密
                        guard let decry = aes.decrypt(hexString: result) else {return}
                        guard let resultJson = try? JSONSerialization.jsonObject(with: decry, options: []) as? [String: Any] else {return}
                        guard let loginModel = BLoginModel.deserialize(from: resultJson) else {return}
                        
                        if !loginModel.token.isEmpty {
                            ADSConst.setUserDefaultsData(with: "\(loginModel.token)", key: ADSConst.userBTokenKey)                            
                        }
                        if !loginModel.password.isEmpty {
                            ADSConst.setUserDefaultsData(with: loginModel.password, key: ADSConst.userBPassword)
                        }
                        
                        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
                        let openParams: [String: Any] = ["token": loginModel.token, "timestamp": "\(timeStamp)"]
                        if let openParamsValue = ADSBHttp.handleAESCrypt(param: openParams) {
                            let url = "\(self.data.openValue)?openParams=\(openParamsValue)&appId=\(AppId)"
                            self.loadWeb(url: url)
                        }
                        
                        debugPrint(resultJson)
                    }
                case .failure(_):
                    debugPrint("启动接口异常")
                }
            }
            
        }
    }
    
    /// 加载地址
    func loadWeb(url: String) {
        guard let webUrl = URL(string: url) else {
            debugPrint("web地址异常")
            return
        }
        let request = URLRequest(url: webUrl)
        webView.load(request)
    }

}

extension ADSBWebViewController: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "rechargePay" {
            guard let param = message.body as? [String: Any] else {return}
            guard let batchNo = param["batchNo"] as? String else {return}
            guard let callbackJson = param["callbackJson"] as? String else {return}
            rechargeAction(with: batchNo, callbackJson: callbackJson)
            debugPrint(param)
        }
    }
    
    /// 充值
    func rechargeAction(with batchNo: String, callbackJson: String) {
        // TODO: -充值
        ADSHUD.showHUD(showView: self.view)
        ADSIAPNewManager.shared.payAction(productId: batchNo) { productId, receipt, transaction in
            ADSHUD.hidenHUD()
            
            // 拿到购买凭证
            guard let transactionIdentifier = transaction.transactionIdentifier else {return}
            
            let param: [String: Any] = ["dfaadfat": receipt,
                                        "sdfadsp": transactionIdentifier,
                                        "qewfqwec": callbackJson]
            
            httpBProvider.request(.verifyPurchaseProof(param)) { result in
               
                switch result {
                case .success(let response):

                        // 验证通过
                        ADSHUD.showText(text: "Recharge successful", showView: self.view)

                case .failure(_):
                    debugPrint("充值接口验证失败")
                }
            }
        } failed: { error in
            ADSHUD.hidenHUD()
            ADSHUD.showText(text: "Recharge failed", showView: self.view)
        } canceled: {
            ADSHUD.hidenHUD()
            ADSHUD.showText(text: "Cancel recharge", showView: self.view)
        }
    }
}

extension ADSBWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 如果目标帧为空或目标不是主框架
            if navigationAction.targetFrame == nil || !(navigationAction.targetFrame?.isMainFrame ?? false) {
                if let url = navigationAction.request.url {
                    UIApplication.shared.open(url, options: [:], completionHandler: { success in
                        // 可在这里处理打开 URL 成功或失败的逻辑
                    })
                }
            }
            return nil
    }
}

extension ADSBWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ADSHUD.showHUD()
        debugPrint("开始加载网页")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ADSHUD.hidenHUD()
        launchImageView.isHidden = true
        debugPrint("网页记载完毕")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        debugPrint("网页加载失败\(error.localizedDescription)")
    }
}
