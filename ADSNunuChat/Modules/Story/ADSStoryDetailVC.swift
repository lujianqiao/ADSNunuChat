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
    }
}
