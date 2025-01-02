//
//  ADSMinePersonalUpdateView.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/2.
//

import UIKit

class ADSMinePersonalUpdateView: UIView {

    /// 收藏
    lazy var collView: UIView = {
        let view = UIView()
        view.addCorner(radius: 20)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var collImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_coll_icon")
        return image
    }()
    
    lazy var collLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "My \n Collections"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var collNumBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setImage(UIImage(named: "mine_wallte_arrow_small"), for: .normal)
        btn.setTitle("10", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        btn.positionStyle = .right
        btn.spacingBetweenImageAndTitle = 2
        btn.backgroundColor = .black
        return btn
    }()
    
    /// 教程
    lazy var tutorView: UIView = {
        let view = UIView()
        view.addCorner(radius: 20)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var tutorImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_tutorials_icon")
        return image
    }()
    
    lazy var tutorLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "My \n Tutorials"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var tutorNumBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setImage(UIImage(named: "mine_wallte_arrow_small"), for: .normal)
        btn.setTitle("10", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        btn.positionStyle = .right
        btn.spacingBetweenImageAndTitle = 2
        btn.backgroundColor = .black
        return btn
    }()
    
    /// 动态
    lazy var monView: UIView = {
        let view = UIView()
        view.addCorner(radius: 20)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var monImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_moment_icon")
        return image
    }()
    
    lazy var monLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "My \n Moments"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var monNumBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setImage(UIImage(named: "mine_wallte_arrow_small"), for: .normal)
        btn.setTitle("10", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        btn.positionStyle = .right
        btn.spacingBetweenImageAndTitle = 2
        btn.backgroundColor = .black
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collView)
        collView.snp.makeConstraints { make in
            make.left.equalTo(15.scale)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 105.scale, height: 115.scale))
        }
        
        collView.addSubview(collImage)
        collImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(12.scale)
            make.width.height.equalTo(30.scale)
        }
        
        collView.addSubview(collLabel)
        collLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collImage.snp.bottom).offset(11)
        }
        
        collView.addSubview(collNumBtn)
        collNumBtn.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(26.scale)
        }
        
        addSubview(tutorView)
        tutorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 105.scale, height: 115.scale))
        }
        
        tutorView.addSubview(tutorImage)
        tutorImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(12.scale)
            make.width.height.equalTo(30.scale)
        }
        
        tutorView.addSubview(tutorLabel)
        tutorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collImage.snp.bottom).offset(11)
        }
        
        tutorView.addSubview(tutorNumBtn)
        tutorNumBtn.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(26.scale)
        }
        
        addSubview(monView)
        monView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15.scale)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 105.scale, height: 115.scale))
        }
        
        monView.addSubview(monImage)
        monImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(12.scale)
            make.width.height.equalTo(30.scale)
        }
        
        monView.addSubview(monLabel)
        monLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collImage.snp.bottom).offset(11)
        }
        
        monView.addSubview(monNumBtn)
        monNumBtn.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(26.scale)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
