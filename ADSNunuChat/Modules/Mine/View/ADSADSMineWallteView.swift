//
//  ADSADSMineWallteView.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/2.
//

import UIKit

class ADSADSMineWallteView: UIView {

    lazy var BGImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_wallte_bg")
        return image
    }()
    
    lazy var leftImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_wallte_left")
        return image
    }()
    
    lazy var titleImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_wallte_title")
        return image
    }()
    
    lazy var valueBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setImage(UIImage(named: "mine_wallte_arrow"), for: .normal)
        btn.setTitle("150 coins", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        btn.positionStyle = .right
        btn.spacingBetweenImageAndTitle = 4
        btn.backgroundColor = .black
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(BGImage)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(leftImage)
        leftImage.snp.makeConstraints { make in
            make.left.equalTo(18)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(62)
        }
        
        addSubview(titleImage)
        titleImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(85)
            make.height.equalTo(16)
            make.left.equalTo(leftImage.snp.right).offset(5)
        }
        
        addSubview(valueBtn)
        valueBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-8)
            make.width.equalTo(130)
            make.height.equalTo(46)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
