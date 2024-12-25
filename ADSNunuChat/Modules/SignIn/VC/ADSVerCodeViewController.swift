//
//  ADSVerCodeViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/24.
//

import UIKit

class ADSVerCodeViewController: ADSBaseViewController {

    lazy var navBar: ADSSignInNavBar = {
        let bar = ADSSignInNavBar(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        bar.backgroundColor = .clear
        bar.titleLabel.text = "Verification codes"
        return bar
    }()
    
    lazy var codeLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Verification codes"
        lab.textColor = .init(hex: "#0C092A")
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var codeBGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCorner(radius: 20)
        return view
    }()
    
    lazy var codeImageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_email")
        return image
    }()
    
    lazy var codeField: UITextField = {
        let field: UITextField = .init()
        field.placeholder = "Verification codes"
        field.textColor = .init(hex: "#0C092A")
        field.font = UIFont.systemFont(ofSize: 14)
        return field
    }()
    
    lazy var sendAgainLab: UILabel = {
        let lab: UILabel = .init()
        lab.text = ""
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.isEnabled = false
        return lab
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
            vc.type = .userName
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    var timer: Timer?
    var countDown: Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }

    override var preferredNavigationBarHidden: Bool {true}
}
 
extension ADSVerCodeViewController {
    func setUpUI() {
        view.backgroundColor = .init(hex: "#EFEEFC")
        view.addSubview(navBar)
        
        view.addSubview(codeLabel)
        codeLabel.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(navBar.snp.bottom).offset(24)
        }
        
        view.addSubview(codeBGView)
        codeBGView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(codeLabel.snp.bottom).offset(8)
            make.height.equalTo(56)
        }
        
        codeBGView.addSubview(codeImageView)
        codeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(17)
            make.size.equalTo(CGSize(width: 22, height: 18))
        }
        
        codeBGView.addSubview(codeField)
        codeField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(codeImageView.snp.right).offset(17)
            make.right.equalTo(-17)
        }
        
        view.addSubview(sendAgainLab)
        sendAgainLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(codeBGView.snp.bottom).offset(24)
        }
        
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(sendAgainLab.snp.bottom).offset(204)
            make.height.equalTo(56)
        }
        
        view.layoutIfNeeded()
        nextBtn.addGradientLayer(colors: [.init(hex: "#6049FF"), .init(hex: "#BF36FF")], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1.0, y: 0))
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.countDown -= 1
            self.sendAgainLab.rz.colorfulConfer { confer in
                confer.text("send again")?.textColor(.init(hex: "#858494"))
                confer.text("   (\(self.countDown)s)")?.textColor(.init(hex: "#6A5AE0"))
            }
            if self.countDown <= 0 {
                self.sendAgainLab.rz.colorfulConfer { confer in
                    confer.text("send again")?.textColor(.init(hex: "#6A5AE0"))
                }
                self.sendAgainLab.isEnabled = true
            }
        }
    }
}
