//
//  ADSBLoginVC.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/7/16 _. All rights reserved.
//

import UIKit
import RZColorfulSwift
import RxSwift

class ADSBLoginVC: ADSBaseViewController {

    /// 是否同意隐私政策
    private var isAgree: Bool = false
    
    lazy var navBar: ADSSignInNavBar = {
        let bar = ADSSignInNavBar(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        bar.backgroundColor = .clear
        if self.navigationController?.viewControllers.count ?? 0 <= 1 {
            bar.backBtn.isHidden = true
        }
        return bar
    }()
    
    lazy var BGImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        return image
    }()
    
    lazy var BGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.roundedCorners([.topLeft, .topRight], radius: 16)
        return view
    }()
    
    lazy var signInView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_icon")
        return image
    }()
    
    lazy var signInBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(.init(named: "Start"), for: .normal)
        btn.addCorner(radius: 20)
        btn.setBackgroundImage(.init(named: "agree_bg"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.signInBtnAction()
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

    override var preferredNavigationBarHidden: Bool {true}
    
}

extension ADSBLoginVC {
    func setUpUI() {
        view.backgroundColor = .init(hex: "#EFEEFC")
        
        view.addSubview(BGImage)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(navBar)
        
        view.addSubview(BGView)
        BGView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kStatusBarHeight + 44)
        }
        
        BGView.addSubview(signInView)
        signInView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(32)
            make.width.equalTo(108)
            make.height.equalTo(40)
        }
        
        BGView.addSubview(signInBtn)
        signInBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(272)
            make.height.equalTo(56)
            make.top.equalTo(200)
        }
        
    }
    
    
    /// 登录
    func signInBtnAction() {
        
        ADSHUD.showHUD()
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
                    
                    ADSConst.setUserDefaultsData(with: "\(loginModel.token)", key: ADSConst.userBTokenKey)
                    ADSConst.setUserDefaultsData(with: loginModel.password, key: ADSConst.userBPassword)
                    
                    debugPrint(resultJson)
                }
            case .failure(_):
                debugPrint("启动接口异常")
            }
        }
        
    }
    
}
