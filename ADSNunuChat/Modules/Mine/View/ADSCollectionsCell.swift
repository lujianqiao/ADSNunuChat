//
//  ADSCollectionsCell.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/8.
//

import UIKit

class ADSCollectionsCell: UITableViewCell {

    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.addCorner(radius: 10)
        return view
    }()
    
    lazy var avatarImageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_avatar_default")
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "alix"
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 14, weight: .black)
        return lab
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCorner(radius: 10)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "makeup"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return lab
    }()
    
    lazy var contentLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Neutral tones are getting more…"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.numberOfLines = 2
        return lab
    }()
    
    lazy var reportBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "mine_report"), for: .normal)
        btn.setTitle("Report", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        return btn
    }()
    
    lazy var likeBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "mine_like _1"), for: .normal)
        btn.setTitle("Like", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(7.5)
        }
        
        bgView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(7)
            make.right.equalTo(-12)
            make.width.height.equalTo(36)
        }
        
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.right.equalTo(avatarImageView.snp.left).offset(-8)
        }
        
        bgView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview().inset(2)
            make.height.equalTo(216)
        }
        
        bottomView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.right.equalTo(-10)
            make.width.equalTo(134)
        }
        
        bottomView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.right.equalTo(-10)
            make.width.equalTo(134)
        }
        
        bottomView.addSubview(likeBtn)
        likeBtn.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.equalTo(117)
        }
        
        bottomView.addSubview(reportBtn)
        reportBtn.snp.makeConstraints { make in
            make.centerY.equalTo(likeBtn)
            make.right.equalTo(likeBtn.snp.left).offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
