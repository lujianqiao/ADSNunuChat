//
//  ADSSetGenderViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit

class ADSSetGenderViewController: ADSBaseViewController {

    lazy var navBar: ADSSignInNavBar = {
        let bar = ADSSignInNavBar(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        bar.backgroundColor = .clear
        bar.titleLabel.text = "Sign up"
        return bar
    }()
    
    lazy var centerImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_gender_center")
        return image
    }()
    
    lazy var famaleBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "sign_in_gender_famale_normal"), for: .normal)
        btn.setImage(UIImage(named: "sign_in_gender_famale_select"), for: .selected)
        return btn
    }()
    
    lazy var maleBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "sign_in_gender_male_normal"), for: .normal)
        btn.setImage(UIImage(named: "sign_in_gender_male_select"), for: .selected)
        btn.isSelected = true
        return btn
    }()
    
    lazy var sFamaleBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setImage(UIImage(named: "sign_in_gender_normal"), for: .normal)
        btn.setImage(UIImage(named: "sign_in_gender_select"), for: .selected)
        btn.setTitle("Famale", for: .normal)
        btn.setTitleColor(.init(hex: "#3E3C49"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.spacingBetweenImageAndTitle = 4
        return btn
    }()
    
    lazy var sMaleBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setImage(UIImage(named: "sign_in_gender_normal"), for: .normal)
        btn.setImage(UIImage(named: "sign_in_gender_select"), for: .selected)
        btn.setTitle("Male", for: .normal)
        btn.setTitleColor(.init(hex: "#3E3C49"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.spacingBetweenImageAndTitle = 4
        return btn
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
            let vc = ADSInputUserInfoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override var preferredNavigationBarHidden: Bool {true}

}

extension ADSSetGenderViewController {
    func setUpUI() {
        view.backgroundColor = .init(hex: "#EFEEFC")
        view.addSubview(navBar)
        
        view.addSubview(centerImage)
        centerImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(43 + kNavHeight)
            make.width.height.equalTo(74)
        }
        
        view.addSubview(famaleBtn)
        famaleBtn.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(kNavHeight + 44)
            make.size.equalTo(CGSize(width: 219.scale, height: 228.scale))
        }
        
        view.addSubview(sFamaleBtn)
        sFamaleBtn.snp.makeConstraints { make in
            make.centerX.equalTo(famaleBtn)
            make.top.equalTo(famaleBtn.snp.bottom).offset(6)
        }
        
        view.addSubview(maleBtn)
        maleBtn.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.top.equalTo(kNavHeight + 44)
            make.size.equalTo(CGSize(width: 219.scale, height: 228.scale))
        }
        
        view.addSubview(sMaleBtn)
        sMaleBtn.snp.makeConstraints { make in
            make.centerX.equalTo(maleBtn)
            make.top.equalTo(maleBtn.snp.bottom).offset(6)
        }
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(sMaleBtn.snp.bottom).offset(40)
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
