//
//  ADSAccountViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/7.
//

import UIKit

class ADSAccountViewController: ADSBaseViewController {

    lazy var BGImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.roundedCorners([.topLeft, .topRight], radius: 20)
        view.backgroundColor = .white
        return view
    }()
    
//    lazy var rightBtn: UIButton = {
//        let btn: UIButton = .init()
//        btn.setBackgroundImage(.init(named: "mine_save_bg"), for: .normal)
//        btn.setTitle("Save", for: .normal)
//        btn.setTitleColor(.black, for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
//        return btn
//    }()
    
    /// 邮箱
    lazy var emailLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Email"
        lab.textColor = .init(hex: "#969696")
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return lab
    }()
    
    lazy var emailField: UITextField = {
        let field: UITextField = .init()
        field.placeholder = "Enter your email"
        field.textColor = .init(hex: "#0C092A")
        field.font = UIFont.systemFont(ofSize: 14)
        field.addCorner(radius: 15)
        field.layer.borderColor = UIColor.init(hex: "#9B9B9B").cgColor
        field.layer.borderWidth = 1
        
        let view = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        field.leftView = view
        field.leftViewMode = .always
        
        field.isEnabled = false
        
        return field
    }()
    
    /// 密码
    lazy var passwordLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Password"
        lab.textColor = .init(hex: "#969696")
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return lab
    }()
    
    lazy var passwordField: UITextField = {
        let field: UITextField = .init()
        field.placeholder = "Enter the password"
        field.textColor = .init(hex: "#0C092A")
        field.font = UIFont.systemFont(ofSize: 14)
        field.addCorner(radius: 15)
        field.layer.borderColor = UIColor.init(hex: "#9B9B9B").cgColor
        field.layer.borderWidth = 1
        
        let view = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        field.leftView = view
        field.leftViewMode = .always
        return field
    }()
    
    lazy var deleteBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Delete account", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.backgroundColor = .init(hex: "#F33939")
        btn.addCorner(radius: 22)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.deleteAction()
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getData()
        // Do any additional setup after loading the view.
    }

}

extension ADSAccountViewController {
    func setUpUI() {
        title = "My account"
//        navigationItem.rightBarButtonItem = .init(customView: rightBtn)
        view.addSubview(BGImage)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kNavHeight + 4)
        }
        
        bgView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(25)
        }
        
        bgView.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(14)
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
        bgView.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(emailField.snp.bottom).offset(20)
        }
    
        
        bgView.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(14)
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
        bgView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordField.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 180, height: 44))
        }
    }
    
    func getData() {
        if let userInfo = UserInfoManager.share.userInfo {
            emailField.text = userInfo.email
        }
    }
    
    func deleteAction() {
        
        guard let pasd = ADSConst.getUserDefaultsData(with: ADSConst.userPassword), pasd == passwordField.text else {
            ADSHUD.showText(text: "Wrong password")
            return
        }
        
        
        ADSHUD.showHUD()
        httpProvider.request(.signOff) { result in
            ADSHUD.hidenHUD()
            switch result {
            case .success(let response):
                
                ADSConst.setUserDefaultsData(with: nil, key: ADSConst.userTokenKey)
                let delegate = ADSConst.getSceneDelegate()
                delegate?.window?.rootViewController = ADSNavigationController(rootViewController: ADSSignVC())
                
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
        }
    }
}
