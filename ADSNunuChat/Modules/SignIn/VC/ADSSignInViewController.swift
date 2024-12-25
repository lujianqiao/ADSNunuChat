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
        bar.titleLabel.text = "Sign in"
        return bar
    }()
    
    /// 邮箱
    lazy var emailLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Email Address"
        lab.textColor = .init(hex: "#0C092A")
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var emailBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCorner(radius: 20)
        return view
    }()
    
    lazy var emailImageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_email")
        return image
    }()
    
    lazy var emailField: UITextField = {
        let field: UITextField = .init()
        field.placeholder = "Your email address"
        field.textColor = .init(hex: "#0C092A")
        field.font = UIFont.systemFont(ofSize: 14)
        return field
    }()
    
    /// 密码
    lazy var passwordLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Password"
        lab.textColor = .init(hex: "#0C092A")
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var passwordBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCorner(radius: 20)
        return view
    }()
    
    lazy var passwordImageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_password")
        return image
    }()
    
    lazy var passwordField: UITextField = {
        let field: UITextField = .init()
        field.placeholder = "Your password"
        field.textColor = .init(hex: "#0C092A")
        field.font = UIFont.systemFont(ofSize: 14)
        return field
    }()
    
    lazy var showPWBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "sign_in_password_hidden"), for: .normal)
        btn.setImage(UIImage(named: "sign_in_password_show"), for: .selected)
        return btn
    }()
    
    
    lazy var signInBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Sign In", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.addCorner(radius: 20)
        return btn
    }()
    
    lazy var forgetPasswordlabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Forgot password?"
        lab.textColor = .init(hex: "#6A5AE0")
        lab.font = UIFont.systemFont(ofSize: 16)
        return lab
    }()
    
    lazy var noAccountLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = ""
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
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
        view.addSubview(navBar)
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(kNavHeight + 68)
        }
        
        view.addSubview(emailBGView)
        emailBGView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.height.equalTo(56)
        }
        
        emailBGView.addSubview(emailImageView)
        emailImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(17)
            make.size.equalTo(CGSize(width: 22, height: 18))
        }
        
        emailBGView.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(emailImageView.snp.right).offset(17)
            make.right.equalTo(-17)
        }
        
        view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(emailBGView.snp.bottom).offset(16)
        }
        
        view.addSubview(passwordBGView)
        passwordBGView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.height.equalTo(56)
        }
        
        passwordBGView.addSubview(passwordImageView)
        passwordImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(19)
            make.size.equalTo(CGSize(width: 18, height: 22))
        }
        
        passwordBGView.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(emailImageView.snp.right).offset(17)
            make.right.equalTo(-50)
        }
        
        passwordBGView.addSubview(showPWBtn)
        showPWBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
            make.width.height.equalTo(30)
        }
        
        view.addSubview(signInBtn)
        signInBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(passwordBGView.snp.bottom).offset(24)
            make.height.equalTo(56)
        }
        
        view.addSubview(forgetPasswordlabel)
        forgetPasswordlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(signInBtn.snp.bottom).offset(24)
        }
        
        
        view.addSubview(noAccountLabel)
        noAccountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        noAccountLabel.rz.colorfulConfer { confer in
            confer.text("Don’t have account")?.textColor(.init(hex: "#7B7890")).font(.systemFont(ofSize: 14))
            confer.text("  Sign Up")?.textColor(.init(hex: "#7C37FA")).font(.systemFont(ofSize: 14)).tapActionByLable("noAccountLabelTap")
        }
        noAccountLabel.rz.tapAction {[weak self] label, tapActionId, range in
            guard let self = self else { return }
            if tapActionId == "noAccountLabelTap" {
                let vc = ADSSignUpViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        view.layoutIfNeeded()
        signInBtn.addGradientLayer(colors: [.init(hex: "#6049FF"), .init(hex: "#BF36FF")], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1.0, y: 0))
    }
}
