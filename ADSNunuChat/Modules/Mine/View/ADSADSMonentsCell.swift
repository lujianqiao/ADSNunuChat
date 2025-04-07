//
//  ADSADSMonentsCell.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/8.
//

import UIKit
import Kingfisher

class ADSADSMonentsCell: UICollectionViewCell {
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCorner(radius: 8)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    lazy var atavarImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_account")
        return image
    }()
    
    lazy var contentLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Discover the secrets to flawless…"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 2
        return lab
    }()
    
    lazy var deleteBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "mine_delete"), for: .normal)
        return btn
    }()
    
    lazy var numBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "mine_like"), for: .normal)
        btn.setTitle("100", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(atavarImage)
        atavarImage.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(4)
            make.height.equalTo(atavarImage.snp.width)
        }
        
        bgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(4)
            make.top.equalTo(atavarImage.snp.bottom).offset(10)
        }
        
        bgView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(8)
            make.width.height.equalTo(30)
        }
        
        bgView.addSubview(numBtn)
        numBtn.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(8)
        }
    }
    
    func reloadData(with model: ADSHomeListModel) {
        atavarImage.kf.setImage(with: URL(string: model.user_header), placeholder: UIImage(named: "mine_account"))
        contentLabel.text = model.content
        numBtn.setTitle("\(model.praise_num)", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
