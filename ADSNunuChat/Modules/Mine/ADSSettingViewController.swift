//
//  ADSSettingViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/7.
//

import UIKit
import Kingfisher

enum ADSSettingType: String {
    case terms_use = "User Agreement"
    case privacy_policy = "Privacy Policy"
    case clear = "Clear cache"
}

class ADSSettingViewController: ADSBaseViewController {

    var rightLab: UILabel?
    
    lazy var BGImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.roundedCorners([.topLeft, .topRight], radius: 20)
        view.backgroundColor = .white
        return view
    }()
    
    let items: [ADSSettingType] = [.terms_use, .privacy_policy, .clear]
    
    lazy var signOutBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(.init(named: "mine_sign_out"), for: .normal)
        btn.backgroundColor = .init(hex: "#FFE6E6")
        btn.addCorner(radius: 10)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.signOutAction()
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
}

extension ADSSettingViewController {
    func setUpUI() {
        title = "settings"
        view.addSubview(BGImage)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kNavHeight + 4)
        }
        
        for (index, item) in items.enumerated() {
            let view = creatItemView(type: item)
            view.rx.tap().subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.itemAction(with: item)
            }).disposed(by: rx.disposeBag)
            bgView.addSubview(view)
            view.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(15 + (15 + 50) * index)
                make.height.equalTo(50)
            }
        }
        
        bgView.addSubview(signOutBtn)
        signOutBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(65 * items.count + 20)
            make.height.equalTo(50)
        }
    }
    
    
    func creatItemView(type: ADSSettingType) -> UIView {
        
        let view = UIView()
        view.addCorner(radius: 10)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        
        let titleLab = UILabel()
        titleLab.text = type.rawValue
        titleLab.textColor = .black
        titleLab.font = .systemFont(ofSize: 14)
        view.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        let rightImage = UIImageView(image: .init(named: "mine_arrow_black"))
        view.addSubview(rightImage)
        rightImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.width.height.equalTo(16)
        }
        
        let rightLab = UILabel()
        rightLab.text = "10 MB"
        rightLab.textColor = .init(hex: "#858585")
        rightLab.font = .systemFont(ofSize: 11)
        view.addSubview(rightLab)
        rightLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImage.snp.left).offset(-4)
        }
        rightLab.isHidden = type != .clear
        getKingfisherCacheSize {[weak rightLab] size in
            guard let rightLab = rightLab else { return }
            rightLab.text = size
        }
        self.rightLab = rightLab
        
        return view
    }
    
    func signOutAction() {
        ADSConst.setUserDefaultsData(with: nil, key: ADSConst.userTokenKey)
        let delegate = ADSConst.getSceneDelegate()
        delegate?.window?.rootViewController = ADSNavigationController(rootViewController: ADSSignVC())
    }
    
    func itemAction(with type: ADSSettingType) {
        switch type {
        case .terms_use:
            let vc = ADSUserAgreementViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .privacy_policy:
            let vc = ADSPrivacyPolicyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .clear:
            KingfisherManager.shared.cache.clearCache()
            self.rightLab?.text = "0 MB"
        default:
            break
        }
    }
    
    func getKingfisherCacheSize(completion: @escaping (String) -> Void) {
        // 获取 Kingfisher 的默认缓存
        let cache = KingfisherManager.shared.cache
        
        // 计算缓存大小
        cache.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                // 将缓存大小转换为 MB 或 KB
                let sizeInMB = Double(size) / 1024.0 / 1024.0
                completion(String(format: "%.2f MB", sizeInMB))
            case .failure(let error):
                print("计算缓存大小失败: \(error.localizedDescription)")
                completion("0 MB")
            }
        }
    }
    
}
