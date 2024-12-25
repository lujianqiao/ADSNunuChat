//
//  ADSInputUserInfoViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/24.
//

import UIKit

enum ADSInputUserInfoType {
    case userName
    case age
}

class ADSInputUserInfoViewController: ADSBaseViewController {

    lazy var navBar: ADSSignInNavBar = {
        let bar = ADSSignInNavBar(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        bar.backgroundColor = .clear
        if type == .userName {
            bar.titleLabel.text = "Create a username"
        } else {
            bar.titleLabel.text = "How old are you?"
        }
        return bar
    }()
    
    /// 用户信息
    lazy var infoLabel: UILabel = {
        let lab: UILabel = .init()
        if type == .userName {
            lab.text = "Username"
        } else {
            lab.text = "Age"
        }
        lab.textColor = .init(hex: "#0C092A")
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var infoBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCorner(radius: 20)
        return view
    }()
    
    lazy var infoImageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_user")
        return image
    }()
    
    lazy var infoField: UITextField = {
        let field: UITextField = .init()
        field.textColor = .init(hex: "#0C092A")
        field.font = UIFont.systemFont(ofSize: 14)
        if type == .userName {
            field.keyboardType = .default
            field.placeholder = "Your username"
        } else {
            field.keyboardType = .numberPad
        }
        return field
    }()
    
    /// 下一步
    lazy var nextBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.addCorner(radius: 20)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            
            if self.type == .userName {
                let vc = ADSInputUserInfoViewController()
                vc.type = .age
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = ADSAvatarViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    /// 跳过
    lazy var skipBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Skip", for: .normal)
        btn.setTitleColor(.init(hex: "#858494"), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return btn
    }()
    
    lazy var hasAccountLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = ""
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    
    var type: ADSInputUserInfoType = .userName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

    override var preferredNavigationBarHidden: Bool {true}
    
}

extension ADSInputUserInfoViewController {
    func setUpUI() {
        view.backgroundColor = .init(hex: "#EFEEFC")
        view.addSubview(navBar)
        
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(kNavHeight + 24)
        }
        
        view.addSubview(infoBGView)
        infoBGView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(infoLabel.snp.bottom).offset(8)
            make.height.equalTo(56)
        }
        
        infoBGView.addSubview(infoImageView)
        infoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(17)
            make.size.equalTo(CGSize(width: 22, height: 18))
        }
        
        infoBGView.addSubview(infoField)
        infoField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(infoImageView.snp.right).offset(17)
            make.right.equalTo(-17)
        }
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(infoBGView.snp.bottom).offset(195)
            make.height.equalTo(56)
        }
        
        view.addSubview(skipBtn)
        skipBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nextBtn.snp.bottom).offset(16)
        }
        
        view.addSubview(hasAccountLabel)
        hasAccountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-50)
        }
        hasAccountLabel.rz.colorfulConfer { confer in
            confer.text("Already have account")?.textColor(.init(hex: "#7B7890")).font(.systemFont(ofSize: 14))
            confer.text("  Sign in")?.textColor(.init(hex: "#7C37FA")).font(.systemFont(ofSize: 14)).tapActionByLable("noAccountLabelTap")
        }
        hasAccountLabel.rz.tapAction {[weak self] label, tapActionId, range in
            guard let self = self else { return }
            if tapActionId == "noAccountLabelTap" {
                let vc = ADSSignInViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        view.layoutIfNeeded()
        nextBtn.addGradientLayer(colors: [.init(hex: "#6049FF"), .init(hex: "#BF36FF")], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1.0, y: 0))
    }
}
