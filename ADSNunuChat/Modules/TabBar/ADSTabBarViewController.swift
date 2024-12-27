//
//  ADSTabBarViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/25.
//

import UIKit


class ADSTabBarViewController: UITabBarController {

    lazy var customTabbar: ADSCustomTabBar = {
        let bar = ADSCustomTabBar()
        return bar
    }()
    
    let tabbarItemVC: [ADSTabBarItem] = [.home, .story, .mine]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isHidden = true
        view.addSubview(customTabbar)
        customTabbar.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(35.scale)
            make.bottom.equalToSuperview().inset(30.scale + kSafeBottomMargin)
            make.height.equalTo(50.scale)
        }
        
        tabbarItemVC.forEach {[weak self] item in
            guard let self = self else {return}
            self.addChild(item.tabbarItemVC)
        }
        
        customTabbar.selectBlock = {[weak self] type in
            guard let self = self else {return}
            switch type {
            case .home:
                self.selectedIndex = 0
            case .story:
                self.selectedIndex = 1
            case .mine:
                self.selectedIndex = 2
            }
        }
        // Do any additional setup after loading the view.
    }
    
}



enum ADSTabBarItem {
    
    case home
    case story
    case mine
    
    var tabbarItemVC: ADSNavigationController {
        
        switch self {
        case .home:
            let vc = ADSHomeViewController()
            return ADSNavigationController(rootViewController: vc)
        case .story:
            let vc = ADSStoryViewController()
            return ADSNavigationController(rootViewController: vc)
        case .mine:
            let vc = ADSMineViewController()
            return ADSNavigationController(rootViewController: vc)
        
        }
        
    }
    
}
