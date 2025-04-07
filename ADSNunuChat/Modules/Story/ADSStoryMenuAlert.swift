//
//  ADSStoryMenuAlert.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/21.
//

import UIKit

class ADSStoryMenuAlert: UIViewController {

    var model: ADSHomeListModel = ADSHomeListModel()
    
    lazy var BGView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCorner(radius: 15)
        return view
    }()
    
    lazy var titlelabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Report"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lab
    }()
    
    lazy var closeBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "story_close"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.alertHidden(completion: nil)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var blockBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Block", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.addCorner(radius: 23)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.blockBtnAction()
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    

    func setUpUI() {
        view.addSubview(BGView)
        BGView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(CGSize(width: 295, height: 140)).priority(.low)
        }
        
        BGView.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        
        BGView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        BGView.addSubview(blockBtn)
        blockBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
            make.width.equalTo(225)
            make.height.equalTo(46)
        }
    }
    
    
    
    func blockBtnAction() {
        httpProvider.request(.blockAction("\(model.user_id)", "1")) { result in
            self.alertHidden(completion: nil)
        }
    }

}

// MARK: 弹窗协议
extension ADSStoryMenuAlert: ADSAlertViewAnimator {}
