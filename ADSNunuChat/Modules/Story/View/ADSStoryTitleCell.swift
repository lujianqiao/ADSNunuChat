//
//  ADSStoryTitleCell.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/17.
//

import UIKit

class ADSStoryTitleCell: UICollectionViewCell {
    
    lazy var titleImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_title_cell")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.addSubview(titleImage)
        titleImage.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 58, height: 14))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
