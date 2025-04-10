//
//  ADSFollowerListTitleView.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/19.
//

import UIKit

class ADSFollowerListTitleView: UIView {

    var indexBlock: ((Int) -> Void)?
    
    lazy var followerBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Followers", for: .normal)
        btn.setTitleColor(.init(hex: "#6A6A6A"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.addTarget(self, action: #selector(followerBtnAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var followingBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Following", for: .normal)
        btn.setTitleColor(.init(hex: "#6A6A6A"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        btn.addTarget(self, action: #selector(followingBtnAction), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(followerBtn)
        followerBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 40))
        }
        
        addSubview(followingBtn)
        followingBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 40))
            make.left.equalTo(followerBtn.snp.right).offset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func followerBtnAction() {
        followerBtn.isSelected = true
        followerBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        
        followingBtn.isSelected = false
        followingBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        
        if let block = indexBlock {
            block(0)
        }
    }
    
    @objc func followingBtnAction() {
        followerBtn.isSelected = false
        followerBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        
        followingBtn.isSelected = true
        followingBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        
        if let block = indexBlock {
            block(1)
        }
    }
    
    func refreshUI(with type: Int) {
        if type == 0 {
            followerBtn.isSelected = true
            followerBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            
            followingBtn.isSelected = false
            followingBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        } else {
            followerBtn.isSelected = false
            followerBtn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            
            followingBtn.isSelected = true
            followingBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        }
    }
}
