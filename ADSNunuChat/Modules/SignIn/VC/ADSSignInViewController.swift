//
//  ADSSignInViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit
import RZColorfulSwift

class ADSSignInViewController: ADSBaseViewController {

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
    
    lazy var notHaveAccountLab: UILabel = {
        let lab: UILabel = .init()
        lab.rz.colorfulConfer { confer in
            confer.text("Dont’t have an account?")?.textColor(.init(hex: "#969696")).font(.systemFont(ofSize: 12))
            confer.text(" Sign up")?.textColor(.init(hex: "#FF2C2C")).font(.systemFont(ofSize: 12, weight: .bold)).tapActionByLable("notHaveAccountLab")
        }
        lab.rz.tapAction {[weak self] label, tapActionId, range in
            guard let self = self else { return }
            let vc = ADSSignUpViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return lab
    }()
    
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
    
    
    lazy var signInBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(.init(named: "Start_gray"), for: .normal)
        btn.setImage(.init(named: "Start"), for: .selected)
        btn.addCorner(radius: 20)
        btn.setBackgroundImage(.init(named: "agree_bg_gray"), for: .normal)
        btn.setBackgroundImage(.init(named: "agree_bg"), for: .selected)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let delegate = ADSConst.getSceneDelegate()
            delegate?.window?.rootViewController = ADSTabBarViewController()
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

extension ADSSignInViewController {
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
            make.left.equalTo(14)
            make.top.equalTo(32)
            make.width.equalTo(108)
            make.height.equalTo(40)
        }
        
        BGView.addSubview(notHaveAccountLab)
        notHaveAccountLab.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(signInView.snp.bottom).offset(8)
        }
        
        
        BGView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(notHaveAccountLab.snp.bottom).offset(25)
        }
        
        BGView.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(14)
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
        BGView.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(emailField.snp.bottom).offset(20)
        }
    
        
        BGView.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(14)
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
        BGView.addSubview(signInBtn)
        signInBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(272)
            make.height.equalTo(56)
            make.top.equalTo(passwordField.snp.bottom).offset(20)
        }
        
    }
}
