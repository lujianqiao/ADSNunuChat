//
//  ADSSignUpViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ADSSignUpViewController: ADSBaseViewController {

    lazy var navBar: ADSSignInNavBar = {
        let bar = ADSSignInNavBar(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        bar.backgroundColor = .clear
        bar.titleLabel.text = "Sign up"
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
    
    /// 确认密码
    lazy var CPasswordLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Confirm password"
        lab.textColor = .init(hex: "#0C092A")
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var CPasswordBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCorner(radius: 20)
        return view
    }()
    
    lazy var CPasswordImageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_password")
        return image
    }()
    
    lazy var CPasswordField: UITextField = {
        let field: UITextField = .init()
        field.placeholder = "Confirm password"
        field.textColor = .init(hex: "#0C092A")
        field.font = UIFont.systemFont(ofSize: 14)
        return field
    }()
    
    lazy var CPshowPWBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "sign_in_password_hidden"), for: .normal)
        btn.setImage(UIImage(named: "sign_in_password_show"), for: .selected)
        return btn
    }()
    
    /// 注册
    lazy var signUpBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Sign up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.addCorner(radius: 20)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSSetGenderViewController()
            self.navigationController?.pushViewController(vc, animated: true)
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

extension ADSSignUpViewController {
    func setUpUI() {
        view.backgroundColor = .init(hex: "#EFEEFC")
        view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kNavHeight)
        }
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
        
        view.addSubview(CPasswordLabel)
        CPasswordLabel.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(passwordBGView.snp.bottom).offset(16)
        }
        
        view.addSubview(CPasswordBGView)
        CPasswordBGView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(CPasswordLabel.snp.bottom).offset(8)
            make.height.equalTo(56)
        }
        
        CPasswordBGView.addSubview(CPasswordImageView)
        CPasswordImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(19)
            make.size.equalTo(CGSize(width: 18, height: 22))
        }
        
        CPasswordBGView.addSubview(CPasswordField)
        CPasswordField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(CPasswordImageView.snp.right).offset(17)
            make.right.equalTo(-50)
        }
        
        CPasswordBGView.addSubview(CPshowPWBtn)
        CPshowPWBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
            make.width.height.equalTo(30)
        }
        
        
        
        view.addSubview(signUpBtn)
        signUpBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(CPasswordBGView.snp.bottom).offset(24)
            make.height.equalTo(56)
        }
        
        
       
        
        view.layoutIfNeeded()
        signUpBtn.addGradientLayer(colors: [.init(hex: "#6049FF"), .init(hex: "#BF36FF")], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1.0, y: 0))
    }
}
