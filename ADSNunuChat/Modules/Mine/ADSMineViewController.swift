//
//  ADSMineViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/27.
//

import UIKit
import RxSwift

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
        scro.contentSize = .init(width: kScreenWidth, height: 812 + 30.scale + kSafeBottomMargin)
        scro.contentInset = .init(top: 0, left: 0, bottom: 10.scale + kSafeBottomMargin, right: 0)
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
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSEditUserInfoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var nameLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "jadon"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lab.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSEditUserInfoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        return lab
    }()
    
    lazy var editBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "mine_edit"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSEditUserInfoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
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
    
    lazy var walletView: ADSADSMineWallteView = {
        let view = ADSADSMineWallteView()
        view.rx.tap().subscribe(onNext: {[weak self] item in
            guard let self = self else { return }
            let vc = ADSWalletViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        return view
    }()
    
    lazy var updateView: ADSMinePersonalUpdateView = {
        let view = ADSMinePersonalUpdateView()
        view.updateBlock = { [weak self] index in
            guard let self = self else { return }
            if index == 0 {
                let vc = ADSCollectionsVC()
                self.navigationController?.pushViewController(vc, animated: true)
            } else if index == 1 {
                
            } else if index == 2 {
                let vc = ADSMonentsVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return view
    }()
    
    lazy var toolView: ADSMineToolView = {
        let view = ADSMineToolView()
        view.addCorner(radius: 16)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabbar = self.tabBarController as? ADSTabBarViewController {
            tabbar.customTabbar.isHidden = false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabbar = self.tabBarController as? ADSTabBarViewController {
            tabbar.customTabbar.isHidden = true
        }
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
        
        scroll.addSubview(walletView)
        walletView.snp.makeConstraints { make in
            make.left.equalTo(13.scale)
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: kScreenWidth - 26.scale, height: 66))
        }
        
        scroll.addSubview(updateView)
        updateView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(walletView.snp.bottom).offset(21)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(115)
        }
        
        scroll.addSubview(toolView)
        toolView.snp.makeConstraints { make in
            make.left.equalTo(15.scale)
            make.top.equalTo(updateView.snp.bottom).offset(20)
            make.height.equalTo(64 * 4)
            make.width.equalTo(kScreenWidth - 30.scale)
        }
        
        
        toolView.itemSelectBlock = {[weak self] type in
            guard let self = self else { return }
            switch type {
            case .setting:
                let vc = ADSSettingViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case .blackList:
                let vc = ADSBlackListViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case .account:
                let vc = ADSAccountViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case .call:
                let vc = ADSCallRecordsVC()
                self.navigationController?.pushViewController(vc, animated: true)
            
            }
        }
    }
}
