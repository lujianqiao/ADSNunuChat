//
//  ADSCustomTabBar.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/27.
//

import UIKit
import SnapKit

class ADSCustomTabBar: UIView {

    var selectBlock:((_ type: ADSTabBarItem)->Void)?
    
    lazy var bgImage: UIImageView = {
        let image = UIImageView()
        image.image = .init(named: "tabbar_bg")
        return image
    }()
    
    lazy var homeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(.init(named: "tabbar_home"), for: .normal)
        btn.setImage(.init(named: "tabbar_home_select"), for: .selected)
        btn.addTarget(self, action: #selector(homeBtnAction(_:)), for: .touchDown)
        return btn
    }()
    
    lazy var messageBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(.init(named: "tabbar_message"), for: .normal)
        btn.setImage(.init(named: "tabbar_message_select"), for: .selected)
        btn.addTarget(self, action: #selector(messageBtnAction(_:)), for: .touchDown)

        return btn
    }()
    
    lazy var mineBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(.init(named: "tabbar_mine"), for: .normal)
        btn.setImage(.init(named: "tabbar_mine_select"), for: .selected)
        btn.addTarget(self, action: #selector(mineBtnAction(_:)), for: .touchDown)

        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(homeBtn)
        homeBtn.isSelected = true
        homeBtn.snp.makeConstraints { make in
            make.left.equalTo(44.scale)
            make.top.equalTo(7.scale)
            make.width.height.equalTo(40)
        }
        
        addSubview(messageBtn)
        messageBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(homeBtn)
            make.width.height.equalTo(40)
        }
        
        addSubview(mineBtn)
        mineBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(44.scale)
            make.top.equalTo(homeBtn)
            make.width.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ADSCustomTabBar {
    
    @objc func homeBtnAction(_ sender: UIButton) {
        sender.isSelected = true
        self.selectBlock?(.home)
        messageBtn.isSelected = false
        mineBtn.isSelected = false
    }
    
    @objc func messageBtnAction(_ sender: UIButton) {
        sender.isSelected = true
        self.selectBlock?(.story)
        homeBtn.isSelected = false
        mineBtn.isSelected = false
    }
    
    @objc func mineBtnAction(_ sender: UIButton) {
        sender.isSelected = true
        self.selectBlock?(.mine)
        homeBtn.isSelected = false
        messageBtn.isSelected = false
    }
}
