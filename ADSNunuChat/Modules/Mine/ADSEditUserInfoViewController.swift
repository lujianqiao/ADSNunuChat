//
//  ADSEditUserInfoViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/6.
//

import UIKit
import Kingfisher
import TZImagePickerController

class ADSEditUserInfoViewController: ADSBaseViewController {

    var avatarIamge: UIImage?
    
    lazy var BGImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    lazy var rightBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setBackgroundImage(.init(named: "mine_save_bg"), for: .normal)
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.startBtnAction()
        }).disposed(by: rx.disposeBag)
        return btn
    }()

    
    lazy var bgView: UIView = {
        let view = UIView()
        view.roundedCorners([.topLeft, .topRight], radius: 20)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var avatarLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Set your avatar"
        lab.textColor = .init(hex: "#969696")
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return lab
    }()
    
    lazy var avatarBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "mine_photo"), for: .normal)
        btn.addCorner(radius: 15)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
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
    
    lazy var nameTextField: UITextField = {
        let field: UITextField = .init()
        field.placeholder = "Please enter your name"
        field.textColor = .black
        field.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        field.addCorner(radius: 15)
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1
        
        let view = UIView(frame: .init(x: 0, y: 0, width: 20, height: 4))
        field.leftView = view
        field.leftViewMode = .always
        
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

    override var preferredNavigationBarHidden: Bool {false}

}

extension ADSEditUserInfoViewController {
    func setUpUI() {
        view.addSubview(BGImage)
        navigationItem.rightBarButtonItem = .init(customView: rightBtn)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kNavHeight + 4)
        }
        
        bgView.addSubview(avatarLabel)
        avatarLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(20)
        }
        
        bgView.addSubview(avatarBtn)
        avatarBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(avatarLabel.snp.bottom).offset(20)
            make.width.height.equalTo(105)
        }
        
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(avatarBtn.snp.bottom).offset(20)
        }
        
        bgView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        
        if let userInfoModel = UserInfoManager.share.userInfo {
            avatarBtn.kf.setImage(with: URL(string: userInfoModel.user_header), for: .normal, placeholder: UIImage(named: "mine_photo"))
            nameTextField.text = userInfoModel.nick_name
        }
    }
    
    func startBtnAction() {
        
        if let image = avatarIamge {
            let imageName = "\(Date().timeIntervalSince1970).png"
            guard let imageData = UIImage.compressData(image: image, maxLength: 1024 * 1024) else {return}
            
            
            ADSHUD.showHUD()
            httpProvider.request(.uploadFile(imageName, imageData)) { result in
                
                ADSHUD.hidenHUD()
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
        
        ADSHUD.showHUD()
        httpProvider.request(.updateUserInfo(nameTextField.text, avatar, nil, nil)) { result in
            ADSHUD.hidenHUD()
            switch result {
            case .success(_):
                
                self.navigationController?.popViewController(animated: true)
                
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
        }
        
    }
}

extension ADSEditUserInfoViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        guard let image = photos.first else { return }
        avatarBtn.setImage(image, for: .normal)
        avatarIamge = image
        
    }
}
