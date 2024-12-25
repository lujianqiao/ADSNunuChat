//
//  ADSAvatarViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/24.
//

import UIKit
import TZImagePickerController

class ADSAvatarViewController: ADSBaseViewController {

    private var avatarIamge: UIImage?
    
    lazy var navBar: ADSSignInNavBar = {
        let bar = ADSSignInNavBar(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        bar.backgroundColor = .clear
        bar.titleLabel.text = "Set your profile"
        return bar
    }()
    
    lazy var setBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "sign_in_set_avatar"), for: .normal)
        btn.addCorner(radius: 70)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            guard let picker = TZImagePickerController.init(maxImagesCount: 1, delegate: self) else {return}
            present(picker, animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var addImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_add")
        return image
    }()
    
    lazy var desLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Proper photo is required"
        lab.textColor = .init(hex: "#6A5AE0")
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textAlignment = .center
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
            let vc = ADSResetPWViewController()
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

extension ADSAvatarViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        guard let image = photos.first else { return }
        setBtn.setImage(image, for: .normal)
        avatarIamge = image
        
    }
}


extension ADSAvatarViewController {
    
    func setUpUI() {
        view.backgroundColor = .init(hex: "#EFEEFC")
        view.addSubview(navBar)
        
        view.addSubview(setBtn)
        setBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(80 + kNavHeight)
            make.width.height.equalTo(140)
        }
        
        view.addSubview(addImage)
        addImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(setBtn.snp.bottom)
            make.width.height.equalTo(36)
        }
        
        view.addSubview(desLabel)
        desLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(addImage.snp.bottom).offset(30)
        }
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(desLabel.snp.bottom).offset(37)
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
