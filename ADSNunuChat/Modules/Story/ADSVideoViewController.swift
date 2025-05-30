//
//  ADSVideoViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/13.
//

import UIKit
import Kingfisher

class ADSVideoViewController: ADSBaseViewController {

    var model: ADSHomeListModel = ADSHomeListModel()
    
    lazy var bgImageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_call_bg")
        return image
    }()
    
    lazy var avatar: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_avatar_default")
        image.addCorner(radius: 55)
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = ""
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        return lab
    }()
    
    lazy var IDLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = ""
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    lazy var callLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "calling"
        lab.textColor = .white.withAlphaComponent(0.5)
        lab.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lab
    }()
    
    lazy var timeLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "00:00"
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 32, weight: .black)
        return lab
    }()
    
    lazy var hangUpBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "story_hang_up"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var flipBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "story_flip"), for: .normal)
//        btn.isHidden = true
        return btn
    }()
    
    var timer: Timer?
    var timingNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        reloadData()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    func setUpUI() {
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(157)
            make.width.height.equalTo(110)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatar.snp.bottom).offset(20)
        }
        
        view.addSubview(IDLabel)
        IDLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        view.addSubview(callLabel)
        callLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(IDLabel.snp.bottom).offset(100)
        }
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(callLabel.snp.bottom).offset(10)
        }
        
        view.addSubview(hangUpBtn)
        hangUpBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(110)
            make.width.height.equalTo(73)
        }
        
        view.addSubview(flipBtn)
        flipBtn.snp.makeConstraints { make in
            make.centerY.equalTo(hangUpBtn)
            make.left.equalTo(hangUpBtn.snp.right).offset(26)
            make.width.height.equalTo(45)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] timer in
            guard let self = self else { return }
            
            self.timingNum  = self.timingNum + 1
            
            print("timingNum==\(self.timingNum)")
            self.timeLabel.text = "00:\(String(format: "%02d", self.timingNum))"
            
            if self.timingNum % 2 == 0 {
                playAudio()
            }
            
            if self.timingNum >= 60 {
                
                ADSHUD.showText(text: "No one is answering the call")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true)
                }
            }
        })
        
    }

    
    func reloadData() {
        avatar.kf.setImage(with: URL(string: model.user_header), placeholder: UIImage(named: "mine_avatar_default"))
        nameLabel.text = model.nick_name
        IDLabel.text = "ID: \(model.user_id)"
        
    }
    
    func playAudio() {
        guard let path = Bundle.main.path(forResource: "1000", ofType: "mp3") else {
            print("Sound file not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        ADSGToolsAudioPlayer.shared.playAudioWithUrl(url: url)
    }
    
}
