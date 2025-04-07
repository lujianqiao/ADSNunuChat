//
//  ADSStoryItemCell.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/17.
//

import UIKit
import Kingfisher

class ADSStoryItemCell: UICollectionViewCell {
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.addCorner(radius: 8)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.5
        return view
    }()
    
    lazy var photoImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_avatar_default")
        image.addCorner(radius: 8)
        return image
    }()
    
    lazy var desLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Discover the secrets to flawless…"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 2
        return lab
    }()
    
    lazy var avatarImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_avatar_default")
        image.addCorner(radius: 13)
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Alice"
        lab.textColor = .init(hex: "#7B7B7B")
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    lazy var likeBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setImage(UIImage(named: "story_like_normal"), for: .normal)
        btn.setImage(.init(named: "story_like_select"), for: .selected)
        btn.setTitle("109", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.spacingBetweenImageAndTitle = 4
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(photoImage)
        photoImage.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(4)
            make.right.equalTo(-4)
            make.height.equalTo(160)
        }
        
        bgView.addSubview(desLabel)
        desLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.equalTo(photoImage.snp.bottom).offset(10)
        }
        
        bgView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.bottom.equalTo(-10)
            make.width.height.equalTo(26)
        }
        
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImage)
            make.left.equalTo(avatarImage.snp.right).offset(8)
        }
        
        bgView.addSubview(likeBtn)
        likeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImage)
            make.right.equalTo(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(with model: ADSHomeListModel) {
        if let image = model.images.first {
            photoImage.kf.setImage(with: URL(string: image), placeholder: UIImage(named: "story_avatar_default"))
        }
        desLabel.text = model.title
        
        avatarImage.kf.setImage(with: URL(string: model.user_header), placeholder: UIImage(named: "mine_avatar_default"))
        
        nameLabel.text = model.nick_name
        
        likeBtn.setTitle("\(model.praise_num)", for: .normal)
    }
    
}
