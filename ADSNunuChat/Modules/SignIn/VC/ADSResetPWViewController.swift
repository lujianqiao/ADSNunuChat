//
//  ADSResetPWViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/24.
//

import UIKit

class ADSResetPWViewController: ADSBaseViewController {

    lazy var navBar: ADSSignInNavBar = {
        let bar = ADSSignInNavBar(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        bar.backgroundColor = .clear
        bar.titleLabel.text = "Reset Password"
        return bar
    }()
    
    lazy var deslabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Enter your email and we will send you a link to reset your password."
        lab.numberOfLines = 0
        lab.textColor = .init(hex: "#858494")
        lab.font = UIFont.systemFont(ofSize: 16)
        return lab
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
    
    lazy var resetBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Reset Password", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.addCorner(radius: 20)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSVerCodeViewController()
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

extension ADSResetPWViewController {
    func setUpUI() {
        view.backgroundColor = .init(hex: "#EFEEFC")
        view.addSubview(navBar)
        
        view.addSubview(deslabel)
        deslabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(navBar.snp.bottom).offset(24)
        }
        
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(deslabel.snp.bottom).offset(24)
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
        
        view.addSubview(resetBtn)
        resetBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(emailBGView.snp.bottom).offset(165)
            make.height.equalTo(56)
        }
        
        view.layoutIfNeeded()
        resetBtn.addGradientLayer(colors: [.init(hex: "#6049FF"), .init(hex: "#BF36FF")], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1.0, y: 0))
    }
}
