//
//  ADSSignVC.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/26.
//

import UIKit

class ADSSignVC: ADSBaseViewController {

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
            let vc = ADSSignUpViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var signInBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "sign_in_button"), for: .normal)
        btn.setBackgroundImage(.init(named: "sign_in_button_bg"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSSignInViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getData()
        // Do any additional setup after loading the view.
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
    
    func getData() {
        httpProvider.request(.getUserInfo(nil)) { _ in
        }
    }
}
