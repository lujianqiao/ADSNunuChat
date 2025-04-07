//
//  ADSPublishArticleVC.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/13.
//

import UIKit
import RxSwift
import TZImagePickerController

class ADSPublishArticleVC: ADSBaseViewController {

    // 花费
    private var coins: Int = 0
    
    private var images: [UIImage] = []
    var type: ADSStoryDetailType = .homeDetail
    
    lazy var bgImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        return image
    }()
    
    lazy var postBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "home_post"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if self.type == .homeDetail {
                self.postHomeDetailAction()
            } else {
                self.postStoryDetailAction()
            }
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var bgView: UIScrollView = {
        let view = UIScrollView()
        view.contentSize = .init(width: kScreenWidth, height: 724)
        view.roundedCorners([.topLeft, .topRight], radius: 20)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var noteBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Publish notes", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addCorner(radius: 15)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSPublishArticleAlert()
            vc.alertIn(self, animateType: .scale, completion: nil)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var uploadLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Upload step diagram"
        lab.textColor = .init(hex: "#969696")
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return lab
    }()
    
    lazy var photoBGView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 13
        return view
    }()
    
    
    lazy var photoOneBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "home_take_photo"), for: .normal)
        btn.addCorner(radius: 10)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.isHidden = true
        return btn
    }()
    
    lazy var photoTwoBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "home_take_photo"), for: .normal)
        btn.addCorner(radius: 10)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.isHidden = true
        return btn
    }()
    
    lazy var photoThreeBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "home_take_photo"), for: .normal)
        btn.addCorner(radius: 10)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.isHidden = true
        return btn
    }()
    
    lazy var addBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "home_add"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.addPhotoAction()
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "title"
        lab.textColor = .init(hex: "#969696")
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return lab
    }()
    
    lazy var titleTextField: UITextField = {
        let field: UITextField = .init()
        field.placeholder = "Enter a title"
        field.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        field.textColor = .black
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1
        field.addCorner(radius: 15)
        
        let view = UIView.init(frame: .init(x: 0, y: 0, width: 20, height: 10))
        field.leftView = view
        field.leftViewMode = .always
        
        return field
    }()
    
    lazy var contentLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "content"
        lab.textColor = .init(hex: "#969696")
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return lab
    }()
    
    lazy var contentTextView: UITextView = {
        let text = UITextView()
        text.textColor = .black
        text.font = .systemFont(ofSize: 14)
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.borderWidth = 1
        text.addCorner(radius: 15)
        return text
    }()
    
    lazy var unlockBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "home_unlock"), for: .normal)
        btn.setTitle("10 coins to unlock", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.addCorner(radius: 20)
        
        if self.type == .storyDetail {
            btn.isHidden = true
        }
        
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.unlockBtnAction()
        }).disposed(by: rx.disposeBag)
        
        return btn
    }()
    
    lazy var freeBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setBackgroundImage(UIImage(named: "home_free_bg"), for: .normal)
        btn.setTitle("free to view", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.addCorner(radius: 20)
        
        if self.type == .storyDetail {
            btn.isHidden = true
        }
        
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.freeBtnAction()
        }).disposed(by: rx.disposeBag)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

}

extension ADSPublishArticleVC {
    func setUpUI() {
        
        title = "Beauty"
        navigationItem.rightBarButtonItem = .init(customView: postBtn)
        view.addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kNavHeight + 4)
        }
        
        bgView.addSubview(noteBtn)
        noteBtn.snp.makeConstraints { make in
            make.left.equalTo(kScreenWidth - 94 - 15)
            make.top.equalTo(20)
            make.size.equalTo(CGSize(width: 100, height: 30))
        }
        
        bgView.addSubview(uploadLabel)
        uploadLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(20)
        }
        
        bgView.addSubview(photoBGView)
        photoBGView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(uploadLabel.snp.bottom).offset(8)
            make.height.equalTo(79)
        }
        
        photoBGView.addArrangedSubview(photoOneBtn)
        photoOneBtn.snp.makeConstraints { make in
            make.width.height.equalTo(79)
        }
        photoBGView.addArrangedSubview(photoTwoBtn)
        photoTwoBtn.snp.makeConstraints { make in
            make.width.height.equalTo(79)
        }
        photoBGView.addArrangedSubview(photoThreeBtn)
        photoThreeBtn.snp.makeConstraints { make in
            make.width.height.equalTo(79)
        }
        photoBGView.addArrangedSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(photoBGView.snp.bottom).offset(18)
        }
        
        bgView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.width.equalTo(kScreenWidth - 30)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
        bgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(titleTextField.snp.bottom).offset(18)
        }
        
        bgView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.width.equalTo(kScreenWidth - 30)
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.height.equalTo(167)
        }
        
        bgView.addSubview(unlockBtn)
        unlockBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(contentTextView.snp.bottom).offset(25)
            make.width.equalTo((kScreenWidth - 45) / 2)
            make.height.equalTo(40)
        }
        
        bgView.addSubview(freeBtn)
        freeBtn.snp.makeConstraints { make in
            make.left.equalTo(unlockBtn.snp.right).offset(15)
            make.top.equalTo(contentTextView.snp.bottom).offset(25)
            make.width.equalTo((kScreenWidth - 45) / 2)
            make.height.equalTo(40)
        }
        
        
        let emailValid = titleTextField.rx.text.orEmpty.map({$0.count > 0})
        let pasd = contentTextView.rx.text.orEmpty.map({$0.count > 0})
        let allValid = Observable.combineLatest(emailValid, pasd) { $0 && $1 }.share(replay: 1)
        
        allValid.bind(to: postBtn.rx.isEnabled).disposed(by: rx.disposeBag)
    }
    
    func addPhotoAction() {
        let num = 3 - images.count
        guard num > 0 else {return}
        guard let picker = TZImagePickerController.init(maxImagesCount: num, delegate: self) else {return}
        picker.preferredLanguage = "en"
        present(picker, animated: true)
    }
    
    func postHomeDetailAction() {
        
        let hud = ADSHUD.showHUD()
        let tasks = images.map { image in
            return uploadImageAction(with: image)
        }
        
        Observable.zip(tasks).subscribe(onNext: {[weak self] files in
            guard let self = self else { return }
            
            // 调用举报接口
            var titleValue: String = ""
            var contentValue: String = ""
            var img: String = ""
            if let title = self.titleTextField.text {
                titleValue = title
            }
            if let content = self.contentTextView.text {
                contentValue = content
            }
            
            if files.count > 0 {
                img = files.joined(separator: ",")
            }
            
            httpProvider.request(.postMakeUp(titleValue, contentValue, img, "0", "\(coins)")) { result in
                hud.hide(animated: true)
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case .failure(_):
                    ADSHUD.showText(text: "Data anomalies")
                }
            }
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    func postStoryDetailAction() {
        let hud = ADSHUD.showHUD()
        let tasks = images.map { image in
            return uploadImageAction(with: image)
        }
        
        Observable.zip(tasks).subscribe(onNext: {[weak self] files in
            guard let self = self else { return }
            
            // 调用举报接口
            var titleValue: String = ""
            var contentValue: String = ""
            var img: String = ""
            if let title = self.titleTextField.text {
                titleValue = title
            }
            if let content = self.contentTextView.text {
                contentValue = content
            }
            
            if files.count > 0 {
                img = files.joined(separator: ",")
            }
            
            httpProvider.request(.postDress(titleValue, contentValue, img)) { result in
                hud.hide(animated: true)
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case .failure(_):
                    ADSHUD.showText(text: "Data anomalies")
                }
            }
            
        }).disposed(by: rx.disposeBag)
    }
    
    
    /// 上传图片
    func uploadImageAction(with image: UIImage) -> Observable<String> {
        
        return Observable<String>.create { observer in
            
            
            let imageData = UIImage.compressImage(image: image, maxLength: 1024 * 1024)
            guard let imageData = imageData else {
                return Disposables.create()
            }

            let imageName = "\(Date().timeIntervalSince1970).png"
            httpProvider.request(.uploadFile(imageName, imageData)) { result in
                
                switch result {
                case .success(let response):
                    
                    guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                    guard let data = json["data"] as? [String: Any] else {return}
                    guard let imageUrl = data["url"] as? String else {return}
                    observer.onNext(imageUrl)
                    observer.onCompleted()
                case .failure(_):
                    ADSHUD.showText(text: "Data anomalies")
                }
                
            }
            
            return Disposables.create()
        }
        
    }
    
    // 花钱解锁
    func unlockBtnAction() {
        coins = 10
        unlockBtn.setBackgroundImage(UIImage(named: "home_free_bg"), for: .normal)
        freeBtn.setBackgroundImage(nil, for: .normal)
    }
    // 免费
    func freeBtnAction() {
        coins = 0
        unlockBtn.setBackgroundImage(nil, for: .normal)
        freeBtn.setBackgroundImage(UIImage(named: "home_free_bg"), for: .normal)
    }
}

extension ADSPublishArticleVC: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        guard photos.count > 0 else {return}
        
        images.append(contentsOf: photos)
        if images.count >= 3 {
            addBtn.isHidden = true
        }
        
        if images.count > 0  {
            let item = images[0]
            photoOneBtn.isHidden = false
            photoOneBtn.setImage(item, for: .normal)
        }
        
        if images.count > 1  {
            let item = images[1]
            photoTwoBtn.isHidden = false
            photoTwoBtn.setImage(item, for: .normal)
        }
        
        if images.count > 2  {
            let item = images[2]
            photoThreeBtn.isHidden = false
            photoThreeBtn.setImage(item, for: .normal)
        }
        
        
    }
}
