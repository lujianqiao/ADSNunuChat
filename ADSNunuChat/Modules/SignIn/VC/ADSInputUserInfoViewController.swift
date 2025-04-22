//
//  ADSInputUserInfoViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/24.
//

import UIKit
import TZImagePickerController
import RxSwift

class ADSInputUserInfoViewController: ADSBaseViewController {

    var avatarIamge: UIImage?
    
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
        image.image = UIImage(named: "sign_up_icon")
        return image
    }()
    
    lazy var notHaveAccountLab: UILabel = {
        let lab: UILabel = .init()
        lab.rz.colorfulConfer { confer in
            confer.text("Already have an account? Sign in")?.textColor(.init(hex: "#969696")).font(.systemFont(ofSize: 12))
            confer.text(" Sign in")?.textColor(.init(hex: "#FF2C2C")).font(.systemFont(ofSize: 12, weight: .bold)).tapActionByLable("notHaveAccountLab")
        }
        lab.rz.tapAction {[weak self] label, tapActionId, range in
            guard let self = self else { return }
            let vc = ADSSignInViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return lab
    }()
    
    lazy var avatarLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Set your avatar"
        lab.textColor = .init(hex: "#969696")
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return lab
    }()
    
    lazy var skipBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "skip"), for: .normal)
        btn.rx.tap.subscribe(onNext: { _ in
            let delegate = ADSConst.getSceneDelegate()
            delegate?.window?.rootViewController = ADSTabBarViewController()
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var selectAvatarBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "avatar_select"), for: .normal)
        btn.setBackgroundImage(.init(named: "avatar_bg"), for: .normal)
        btn.addCorner(radius: 15)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            guard let picker = TZImagePickerController.init(maxImagesCount: 1, delegate: self) else {return}
            picker.preferredLanguage = "en"
            present(picker, animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var nameLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Nickname"
        lab.textColor = .init(hex: "#969696")
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return lab
    }()
    
    lazy var nameField: UITextField = {
        let field: UITextField = .init()
        field.placeholder = "Enter your Nickname"
        field.textColor = .init(hex: "#0C092A")
        field.font = UIFont.systemFont(ofSize: 14)
        field.addCorner(radius: 15)
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 2
        
        let view = UIView(frame: .init(x: 0, y: 0, width: 10, height: 10))
        field.leftView = view
        field.leftViewMode = .always
        
        return field
    }()
    
    lazy var startBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(.init(named: "Start_gray"), for: .normal)
        btn.setImage(.init(named: "Start"), for: .selected)
        btn.addCorner(radius: 20)
        btn.setBackgroundImage(.init(named: "agree_bg_gray"), for: .normal)
        btn.setBackgroundImage(.init(named: "agree_bg"), for: .selected)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.startBtnAction()
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

extension ADSInputUserInfoViewController {
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
        
        BGView.addSubview(avatarLabel)
        avatarLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(notHaveAccountLab.snp.bottom).offset(25)
        }
    
        BGView.addSubview(skipBtn)
        skipBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.width.equalTo(52)
            make.height.equalTo(30)
            make.centerY.equalTo(avatarLabel)
        }
        
        BGView.addSubview(selectAvatarBtn)
        selectAvatarBtn.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(avatarLabel.snp.bottom).offset(8)
            make.width.height.equalTo(109)
        }
        
        BGView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(selectAvatarBtn.snp.bottom).offset(18)
        }
        
        BGView.addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(14)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
        BGView.addSubview(startBtn)
        startBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(272)
            make.height.equalTo(56)
            make.top.equalTo(nameField.snp.bottom).offset(20)
        }
        
        let nameValid = nameField.rx.text.orEmpty.map({$0.count > 0})
        
        nameValid.bind(to: startBtn.rx.isEnabled).disposed(by: rx.disposeBag)
        nameValid.bind(to: startBtn.rx.isSelected).disposed(by: rx.disposeBag)
        
    }
    
    
    func startBtnAction() {
        
        if let image = avatarIamge {
            let imageName = "\(Date().timeIntervalSince1970).png"
            guard let imageData = UIImage.compressData(image: image, maxLength: 1024 * 1024) else {return}
            
            
            let hud = ADSHUD.showHUD()
            httpProvider.request(.uploadFile(imageName, imageData)) { result in
                
                hud.hide(animated: true)
                switch result {
                case .success(let response):
                    
                    guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                    guard let data = json["data"] as? [String: Any] else {return}
                    guard let imageUrl = data["url"] as? String else {return}
                    self.updateUserInfo(with: imageUrl)
                    
                case .failure(_):
                    ADSHUD.showText(text: "Data anomalies")
                }
                
            }
        } else {
            updateUserInfo(with: nil)
        }
        
    }
    
    /// 更新用户信息
    func updateUserInfo(with avatar: String?) {
        
        let hud = ADSHUD.showHUD()
        httpProvider.request(.updateUserInfo(nameField.text, avatar, nil, nil)) { result in
            hud.hide(animated: true)
            switch result {
            case .success(_):
                
                let delegate = ADSConst.getSceneDelegate()
                delegate?.window?.rootViewController = ADSTabBarViewController()
                
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
        }
        
    }
    
}

extension ADSInputUserInfoViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        guard let image = photos.first else { return }
        selectAvatarBtn.setImage(image, for: .normal)
        avatarIamge = image
        
    }
}
