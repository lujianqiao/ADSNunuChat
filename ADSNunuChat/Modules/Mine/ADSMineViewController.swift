//
//  ADSMineViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/27.
//

import UIKit

class ADSMineViewController: ADSBaseViewController {

    lazy var BGImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var scroll: UIScrollView = {
        let scro = UIScrollView()
        scro.showsVerticalScrollIndicator = false
        scro.showsHorizontalScrollIndicator = false
        scro.contentSize = .init(width: kScreenWidth, height: 812)
        return scro
    }()
    
    
    lazy var titleImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_title")
        return image
    }()
    
    lazy var avatarBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "mine_avatar_default"), for: .normal)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 2
        btn.addCorner(radius: 46)
        return btn
    }()
    
    lazy var nameLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "jadon"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lab
    }()
    
    lazy var editBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "mine_edit"), for: .normal)
        return btn
    }()
    
    lazy var IDLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "ID: 18097024712"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var followerLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Followers"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.rz.colorfulConfer { confer in
            confer.text("125")?.textColor(.black).font(.systemFont(ofSize: 16, weight: .bold))
            confer.text("  Followers")?.textColor(.black).font(.systemFont(ofSize: 14))
        }
        return lab
    }()
    
    lazy var followingLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Following"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.rz.colorfulConfer { confer in
            confer.text("159")?.textColor(.black).font(.systemFont(ofSize: 16, weight: .bold))
            confer.text("  Following")?.textColor(.black).font(.systemFont(ofSize: 14))
        }
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

    override var preferredNavigationBarHidden: Bool {true}

}

extension ADSMineViewController {
    func setUpUI() {
        view.addSubview(BGImage)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(scroll)
        scroll.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scroll.addSubview(titleImage)
        titleImage.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(10 + kStatusBarHeight)
            make.width.equalTo(153)
            make.height.equalTo(38)
        }
        
        scroll.addSubview(avatarBtn)
        avatarBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleImage.snp.bottom).offset(14)
            make.width.height.equalTo(92)
        }
        
        scroll.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarBtn.snp.bottom).offset(7)
        }
        
        scroll.addSubview(editBtn)
        editBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(4)
        }
        
        scroll.addSubview(IDLabel)
        IDLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
        }
        
        scroll.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(IDLabel.snp.bottom).offset(10)
            make.width.equalTo(1)
            make.height.equalTo(38)
        }
        
        scroll.addSubview(followerLabel)
        followerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(lineView)
            make.right.equalTo(lineView.snp.left).offset(-14)
        }
        
        scroll.addSubview(followingLabel)
        followingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(lineView)
            make.left.equalTo(lineView.snp.right).offset(14)
        }
    }
}
