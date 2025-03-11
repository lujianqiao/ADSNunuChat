//
//  ADSStoryDetailVC.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/17.
//

import UIKit

class ADSStoryDetailVC: ADSBaseViewController {

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
        return image
    }()
    
    lazy var imageTwo: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_avatar_default")
        image.contentMode = .scaleAspectFill
        image.addCorner(radius: 5)
        return image
    }()
    
    lazy var imageThree: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_avatar_default")
        image.contentMode = .scaleAspectFill
        image.addCorner(radius: 5)
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
        btn.setImage(UIImage(named: "story_like_select"), for: .normal)
        btn.setTitle("105 likes", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.spacingBetweenImageAndTitle = 4
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
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

}


extension ADSStoryDetailVC {
    func setUpUI() {
        
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
    }
}
