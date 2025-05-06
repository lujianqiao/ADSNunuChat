//
//  ADSStoryDetailVC.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/17.
//

import UIKit
import Kingfisher

enum ADSStoryDetailType {
    case homeDetail
    case storyDetail
}

class ADSStoryDetailVC: ADSBaseViewController {

    private let maskViewH: CGFloat = kScreenHeight - kScreenWidth
    var model: ADSHomeListModel = ADSHomeListModel()
    var type: ADSStoryDetailType = .homeDetail
    
    private let spendDoldAlert = ADSStorySpendGoldAlert()
    private let rechargeAlert = ADSStoryRechargeTipAlert()
    private let menuAlert = ADSStoryMenuAlert()
    
    lazy var menuBtn: UIButton = {
        let btn: UIButton = .init(frame: .init(x: 0, y: 0, width: 30, height: 30))
        btn.setImage(UIImage(named: "story_menu"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.menuAlert.model = self.model
            self.menuAlert.alertIn(self, animateType: .scale, completion: nil)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var bgImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        return image
    }()
    
    lazy var bgView: UIScrollView = {
        let view = UIScrollView()
        view.contentSize = .init(width: kScreenWidth, height: 724)
        view.roundedCorners([.topLeft, .topRight], radius: 20)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var avatarImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_avatar_default")
        image.addCorner(radius: 16)
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Lucy Jordan"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var followBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setBackgroundImage(.init(named: "story_follow_bg"), for: .normal)
        btn.setImage(UIImage(named: "story_follow_add"), for: .normal)
        btn.setTitle("Followed", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.spacingBetweenImageAndTitle = 4
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.followAction()
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var bigImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_avatar_default")
        image.contentMode = .scaleAspectFill
        image.addCorner(radius: 15)
        return image
    }()
    
    lazy var imageOne: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_avatar_default")
        image.contentMode = .scaleAspectFill
        image.addCorner(radius: 5)
        image.layer.borderWidth = 1
        image.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.changeImage(with: 0)
        }).disposed(by: rx.disposeBag)
        return image
    }()
    
    lazy var imageTwo: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_avatar_default")
        image.contentMode = .scaleAspectFill
        image.addCorner(radius: 5)
        image.layer.borderWidth = 1
        image.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.changeImage(with: 1)
        }).disposed(by: rx.disposeBag)
        return image
    }()
    
    lazy var imageThree: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_avatar_default")
        image.contentMode = .scaleAspectFill
        image.addCorner(radius: 5)
        image.layer.borderWidth = 1
        image.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.changeImage(with: 2)
        }).disposed(by: rx.disposeBag)
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "The specific painting method of the base makeup"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lab.numberOfLines = 2
        return lab
    }()
    
    lazy var likeBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setImage(UIImage(named: "story_like_normal"), for: .normal)
        btn.setImage(UIImage(named: "story_like_select"), for: .selected)
        btn.setTitle("105 likes", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.spacingBetweenImageAndTitle = 4
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.likeAction()
        }).disposed(by: rx.disposeBag)
        
        
        return btn
    }()
    
    lazy var contentLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Discover the secrets to flawless skin with our latest beauty obsession! Our skincare routine is a game-changer, leaving your skin feeling refreshed and glowing. Say goodbye to dullness and embrace natural glow. game-changer, leaving your skin feeling refreshed and glowing. Say goodbye to dullness and embrace natural glow."
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var callBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "story_call"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSVideoViewController()
            vc.model = self.model
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var maskView: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: kScreenWidth, height: maskViewH))
        view.addGradientLayer(colors: [UIColor.init(hex: "#FFC7FD").withAlphaComponent(0), UIColor.init(hex: "#FFC7FD")], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0, y: 1))
        return view
    }()
    
    lazy var unlockBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setBackgroundImage(.init(named: "mine_unlock_bg"), for: .normal)
        btn.setImage(UIImage(named: "home_unlock"), for: .normal)
        btn.setTitle("Unlock to view", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.spendDoldAlert.data = self.model
            self.spendDoldAlert.alertIn(self, animateType: .scale, completion: nil)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        itemObservable()
        reloadData()
        // Do any additional setup after loading the view.
    }

}


extension ADSStoryDetailVC {
    func setUpUI() {
        
        navigationItem.rightBarButtonItem = .init(customView: menuBtn)
        
        view.addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kNavHeight + 4)
        }
        
        bgView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.left.top.equalTo(14)
            make.width.height.equalTo(32)
        }
        
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImage)
            make.left.equalTo(avatarImage.snp.right).offset(10)
        }
        
        bgView.addSubview(followBtn)
        followBtn.snp.makeConstraints { make in
            make.top.equalTo(19)
            make.left.equalTo(kScreenWidth - 71 - 15)
            make.width.equalTo(71)
            make.height.equalTo(24)
        }
        
        bgView.addSubview(bigImage)
        bigImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.width.equalTo(kScreenWidth - 28)
            make.top.equalTo(avatarImage.snp.bottom).offset(10)
            make.height.equalTo(bigImage.snp.width)
        }
        
        bgView.addSubview(imageOne)
        imageOne.snp.makeConstraints { make in
            make.left.equalTo(bigImage.snp.left).offset(8)
            make.bottom.equalTo(bigImage.snp.bottom).offset(-8)
            make.width.height.equalTo(54)
        }
        
        bgView.addSubview(imageTwo)
        imageTwo.snp.makeConstraints { make in
            make.left.equalTo(imageOne.snp.right).offset(4)
            make.bottom.equalTo(bigImage.snp.bottom).offset(-8)
            make.width.height.equalTo(54)
        }
        
        bgView.addSubview(imageThree)
        imageThree.snp.makeConstraints { make in
            make.left.equalTo(imageTwo.snp.right).offset(4)
            make.bottom.equalTo(bigImage.snp.bottom).offset(-8)
            make.width.height.equalTo(54)
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.width.equalTo(kScreenWidth - 60)
            make.top.equalTo(bigImage.snp.bottom).offset(15)
        }
        
        bgView.addSubview(likeBtn)
        likeBtn.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        bgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.width.equalTo(kScreenWidth - 28)
            make.top.equalTo(likeBtn.snp.bottom).offset(15)
        }
        
        bgView.addSubview(callBtn)
        callBtn.snp.makeConstraints { make in
            make.centerX.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.top).offset(106)
            make.width.height.equalTo(55)
        }
        
        view.addSubview(maskView)
        maskView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(maskViewH)
        }
        
        maskView.addSubview(unlockBtn)
        unlockBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 240, height: 55))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-95)
        }
    }
    
    func itemObservable() {
        spendDoldAlert.confirmObservable.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let userInfo = UserInfoManager.share.userInfo {
                if userInfo.coins < self.model.unlock_price {
                    // 充值
                    self.rechargeAlert.alertIn(self, animateType: .scale, completion: nil)
                } else {
                    // 解锁
                    self.buyAction()
                }
            }
        }).disposed(by: spendDoldAlert.rx.disposeBag)
        
        rechargeAlert.rechargeObservable.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSWalletViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        
        menuAlert.blockSuccessObservable.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
    
    func reloadData() {
        avatarImage.kf.setImage(with: URL(string: model.user_header), placeholder: UIImage(named: "mine_avatar_default"))
        nameLabel.text = model.nick_name
        
        if model.images.count > 0 {
            let item = model.images[0]
            bigImage.kf.setImage(with: URL(string: item))
            imageOne.layer.borderColor = UIColor.white.cgColor
            imageOne.layer.borderWidth = 1
            
            imageOne.isHidden = false
            imageOne.kf.setImage(with: URL(string: item))
        }
        
        if model.images.count > 1 {
            let item = model.images[1]
            
            imageTwo.isHidden = false
            imageTwo.kf.setImage(with: URL(string: item))
        }
        
        if model.images.count > 2 {
            let item = model.images[2]
            
            imageThree.isHidden = false
            imageThree.kf.setImage(with: URL(string: item))
        }
     
        titleLabel.text = model.title
        likeBtn.isSelected = model.is_praised
        likeBtn.setTitle("\(model.praise_num) likes", for: .normal)
        contentLabel.text = model.content
        
        if model.unlock_price > 0 {
            if let buyList = ADSConst.getUserDefaultsArrayData(with: ADSConst.userBuyList), buyList.contains(where: {$0 == self.model.id}) {
                maskView.isHidden = true
            } else {
                maskView.isHidden = false
            }
        } else {
            maskView.isHidden = true
        }
        
        unlockBtn.setTitle("\(model.unlock_price) coins to unlock", for: .normal)
        
        if self.model.is_followed {
            self.followBtn.setTitle("Followed", for: .normal)
        } else {
            self.followBtn.setTitle("Follow", for: .normal)
        }
        
        var contentHeight = model.content.calculateTextHeight(.systemFont(ofSize: 14), width: kScreenWidth - 28) + 530 + Float(kSafeBottomMargin)
        
        if contentHeight < Float(kScreenHeight - kNavHeight - 4) {
            contentHeight = Float(kScreenHeight - kNavHeight - 4)
        }
        
        bgView.contentSize = .init(width: kScreenWidth, height: Double(contentHeight))
    }
    
    func changeImage(with index: Int) {
        
        switch index {
        case 0:
            if model.images.count > 0 {
                let item = model.images[0]
                bigImage.kf.setImage(with: URL(string: item))
                
                imageOne.layer.borderColor = UIColor.white.cgColor
                imageTwo.layer.borderColor = UIColor.clear.cgColor
                imageThree.layer.borderColor = UIColor.clear.cgColor
            }
            
        case 1:
            if model.images.count > 1 {
                let item = model.images[1]
                bigImage.kf.setImage(with: URL(string: item))
                
                imageOne.layer.borderColor = UIColor.clear.cgColor
                imageTwo.layer.borderColor = UIColor.white.cgColor
                imageThree.layer.borderColor = UIColor.clear.cgColor
            }
            
        case 2:
            if model.images.count > 2 {
                let item = model.images[2]
                bigImage.kf.setImage(with: URL(string: item))
                
                imageOne.layer.borderColor = UIColor.clear.cgColor
                imageTwo.layer.borderColor = UIColor.clear.cgColor
                imageThree.layer.borderColor = UIColor.white.cgColor
            }
            
        default:
            break
        }
        
    }
    
    func likeAction() {
        let status = model.is_praised ? "0" : "1"
        httpProvider.request(.likeAction(model.id, status)) { result in
            switch result {
            case .success(_):
                self.model.is_praised = !self.model.is_praised
                if self.model.is_praised {
                    self.model.praise_num += 1
                } else {
                    self.model.praise_num -= 1
                }
                
                self.likeBtn.isSelected = self.model.is_praised
                self.likeBtn.setTitle("\(self.model.praise_num) likes", for: .normal)
            case .failure(_):
                print("")
            }
        }
    }
    
    func followAction() {
        
        var status: Int = 1
        status = model.is_followed ? 0 : 1
        
        let hud = ADSHUD.showHUD()
        httpProvider.request(.followAction("\(model.user_id)", status)) { result in
            hud.hide(animated: true)
            switch result {
            case .success(_):
                self.model.is_followed = !self.model.is_followed
                
                if self.model.is_followed {
                    self.followBtn.setTitle("Followed", for: .normal)
                } else {
                    self.followBtn.setTitle("Follow", for: .normal)
                }
                
                ADSHUD.showSuccess()
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
        }
        
    }
    
    func buyAction() {
        
        let name: String = "\(model.id)"
        let coins: String = "\(model.unlock_price)"
        
        let hud = ADSHUD.showHUD()
        httpProvider.request(.buy(name, coins)) { result in
            hud.hide(animated: true)
            switch result {
            case .success(_):
                self.maskView.isHidden = true
                ADSConst.setUserDefaultsArrayData(with: self.model.id, key: ADSConst.userBuyList)
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
        }
        
    }
    
}
