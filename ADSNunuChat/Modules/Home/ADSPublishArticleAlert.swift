//
//  ADSPublishArticleAlert.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/13.
//

import UIKit

class ADSPublishArticleAlert: UIViewController {

    lazy var bgView: UIView = {
        let view = UIView()
        view.addCorner(radius: 20)
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "home_alert_bg")
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Publish notes"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lab
    }()
    
    lazy var contentLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "1. Please ensure that the materials used are from your own creations or experiences\n\n2. Please share scientifically proven content\n\n3. Please do not share overly revealing or sexually suggestive content\n\n4. Please do not post inflammatory words"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var gotBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setBackgroundImage(UIImage(named: "home_got_bg"), for: .normal)
        btn.setTitle("got it", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.alertHidden(completion: nil)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 295, height: 399))
        }
        
        bgView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        
        bgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        bgView.addSubview(gotBtn)
        gotBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
            make.width.equalTo(225)
            make.height.equalTo(46)
        }

        // Do any additional setup after loading the view.
    }

}

// MARK: 弹窗协议
extension ADSPublishArticleAlert: ADSAlertViewAnimator {}
