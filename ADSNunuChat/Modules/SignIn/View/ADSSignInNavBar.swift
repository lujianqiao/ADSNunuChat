//
//  ADSSignInNavBar.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/20.
//

import UIKit
import SnapKit

class ADSSignInNavBar: UIView {

    lazy var backBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(.image("nav_back"), for: .normal)
        return btn
    }()
    
    lazy var rightBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage.image("nav_menu_white"), for: .normal)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = ""
        lab.textColor = .init(hex: "#0C092A")
        lab.font = .systemFont(ofSize: 17, weight: .semibold)
        lab.textAlignment = .center
        return lab
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(kStatusBarHeight)
            make.width.height.equalTo(44)
        }
        
        addSubview(rightBtn)
        rightBtn.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.top.equalTo(kStatusBarHeight)
            make.width.height.equalTo(44)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(backBtn.snp.right).offset(16)
            make.right.equalTo(rightBtn.snp.left).offset(-16)
            make.top.equalTo(kStatusBarHeight)
            make.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
