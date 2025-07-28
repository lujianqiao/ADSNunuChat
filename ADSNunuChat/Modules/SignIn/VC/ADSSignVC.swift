//
//  ADSSignVC.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/26.
//

import UIKit
import Network
import Combine


class ADSSignVC: ADSBaseViewController {

    private var canGoBPackeg: Bool = false
    private var bPackegModel: LaunchResultModel = .init()
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue(label: "NetworkPermissionObserver")
    private var hasNetworkPermission: Bool = false
    
    lazy var BGImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_bg")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var centerImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_center")
        return image
    }()
    
    lazy var signUpBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(.init(named: "sign_up"), for: .normal)
        btn.setBackgroundImage(.init(named: "sign_up_bg"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if self.canGoBPackeg {
                let login = ADSBLoginVC()
                login.data = self.bPackegModel
                let delegate = ADSConst.getSceneDelegate()
                delegate?.window?.rootViewController = login
            } else {
                let vc = ADSSignUpViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var signInBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "sign_in_button"), for: .normal)
        btn.setBackgroundImage(.init(named: "sign_in_button_bg"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            
            if self.canGoBPackeg {
                let login = ADSBLoginVC()
                login.data = self.bPackegModel
                let delegate = ADSConst.getSceneDelegate()
                delegate?.window?.rootViewController = login
            } else {
                let vc = ADSSignInViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        checkNetwork()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        monitor?.cancel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }
    
    override var preferredNavigationBarHidden: Bool {true}

}

extension ADSSignVC {
    func setUpUI() {
        view.addSubview(BGImage)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(centerImage)
        centerImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 342.scale, height: 69.scale))
        }
        
        view.addSubview(signUpBtn)
        signUpBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(centerImage.snp.bottom).offset(90)
            make.size.equalTo(CGSize(width: 272.scale, height: 56.scale))
        }
        
        view.addSubview(signInBtn)
        signInBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(signUpBtn.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 272.scale, height: 56.scale))
        }
        
    }
    
    func checkNetwork() {
        if #available(iOS 12.0, *) {
                    monitor = NWPathMonitor()
                    monitor?.pathUpdateHandler = { [weak self] path in
                        DispatchQueue.main.async {
                            if path.status == .satisfied {
                                if #available(iOS 14.0, *) {
                                    self?.hasNetworkPermission = !path.isConstrained
                                } else {
                                    self?.hasNetworkPermission = true
                                }
                            } else {
                                self?.hasNetworkPermission = false
                            }
                            
                            if self?.hasNetworkPermission == true {
                                self?.getBper()
                            }
                        }
                    }
                    monitor?.start(queue: queue)
                }
    }
    
    func getData() {
        httpProvider.request(.getUserInfo(nil)) { _ in
        }
        getBper()
    }
    
    func getBper() {
        // 判断当前语言是否是中文
        if let language = Locale.preferredLanguages.first, language.hasPrefix("zh-") {return}
        if ADSConst.isChineseCarrier() {return}
        
        let parma: [String: Any] = ["fwercard": ADSConst.isSIMInserted() ? 1: 0,
                                    "regervpn": ADSConst.isVPNConnected() ? 1: 0,
                                    "ergergdebug": 0,
                                    "langerguage": [Locale.preferredLanguages.first ?? "en-CN"],
                                    "zogernet": TimeZone.current.identifier]
        
        httpBProvider.request(.getOpenStatus(parma)) { result in
            
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                guard let resultModel = ADSBOpenModel.deserialize(from: json) else {return}
                guard resultModel.code == "0000" else {return}
                guard let aes = AESCBC(key: AESkey, iv: AESIV) else  {return}
                // 解密
                guard let decry = aes.decrypt(hexString: resultModel.result) else {return}
                guard let resultJson = try? JSONSerialization.jsonObject(with: decry, options: []) as? [String: Any] else {return}
                guard let resultModel = LaunchResultModel.deserialize(from: resultJson) else {return}
                
                self.canGoBPackeg = true
                self.bPackegModel = resultModel
                
            case .failure(_):
                debugPrint("启动接口异常")
            }
        }
    }
    
}
