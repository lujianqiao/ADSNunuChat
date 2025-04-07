//
//  ADSWalletTopView.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/6.
//

import UIKit

class ADSWalletTopView: UIView {

    lazy var imageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_wallte_big")
        return image
    }()
    
    lazy var beansLab: UILabel = {
        let lab: UILabel = .init()
        lab.text = "0"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(78)
        }
        
        addSubview(beansLab)
        beansLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
