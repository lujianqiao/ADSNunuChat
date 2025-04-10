//
//  ADSStorySpendGoldAlert.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/4/9.
//

import UIKit
import RxSwift
import RxRelay

class ADSStorySpendGoldAlert: ADSBaseViewController {

    var confirmObservable: Observable<Void> {confirmRelay.asObservable()}
    private let confirmRelay: PublishRelay<Void> = .init()
    
    var data: ADSHomeListModel = .init()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var topImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_beans")
        return image
    }()
    
    lazy var bgImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_spend_gold_bg")
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var contentLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "It will cost you \(self.data.unlock_price) coins to view the makeup tutorial?"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 2
        return lab
    }()
    
    lazy var cancleBtn: UIButton = {
        let btn: UIButton = .init()
        btn.backgroundColor = .clear
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.addCorner(radius: 23)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.alertHidden(completion: nil)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn: UIButton = .init()
        btn.backgroundColor = .black
        btn.setTitle("Confirm", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn.addCorner(radius: 23)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.alertHidden { _ in
                self.confirmRelay.accept(())
            }
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
            make.width.equalTo(295).priority(.low)
            make.height.equalTo(270).priority(.low)
        }
        
        bgView.addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(216)
        }
        
        bgView.addSubview(topImage)
        topImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 125, height: 125))
        }
        
        bgImage.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(21)
            make.top.equalTo(84)
        }
        
        
        bgImage.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { make in
            make.left.equalTo(13)
            make.bottom.equalTo(-20)
            make.width.equalTo(127)
            make.height.equalTo(46)
        }
        
        bgImage.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.right.equalTo(-13)
            make.bottom.equalTo(-20)
            make.width.equalTo(127)
            make.height.equalTo(46)
        }
        // Do any additional setup after loading the view.
    }

}

// MARK: 弹窗协议
extension ADSStorySpendGoldAlert: ADSAlertViewAnimator {}
