//
//  ADSSettingViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/7.
//

import UIKit

enum ADSSettingType: String {
    case terms_serves = "Terms of service"
    case terms_use = "Terms of use"
    case clear = "Clear cache"
}

class ADSSettingViewController: ADSBaseViewController {

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
    
    let items: [ADSSettingType] = [.terms_serves, .terms_use, .clear]
    
    lazy var signOutBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(.init(named: "mine_sign_out"), for: .normal)
        btn.backgroundColor = .init(hex: "#FFE6E6")
        btn.addCorner(radius: 10)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
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
        rightLab.text = "10 M"
        rightLab.textColor = .init(hex: "#858585")
        rightLab.font = .systemFont(ofSize: 11)
        view.addSubview(rightLab)
        rightLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImage.snp.left).offset(-4)
        }
        rightLab.isHidden = type != .clear
        
        return view
    }
    
}
