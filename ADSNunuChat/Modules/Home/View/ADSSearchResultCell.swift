//
//  ADSSearchResultCell.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/17.
//

import UIKit
import Kingfisher

class ADSSearchResultCell: UITableViewCell {

    lazy var bgView: UIView = {
        let view = UIView()
        view.addCorner(radius: 10)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    lazy var avatarImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_avatar_default")
        image.addCorner(radius: 5)
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Albert"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lab
    }()
    
    lazy var IDImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "home_search_id")
        return image
    }()
    
    lazy var IDLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "FWEOIF213HSOF"
        lab.textColor = .init(hex: "#969696")
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var addBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "home_search_add"), for: .normal)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
        
        bgView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(5)
            make.width.height.equalTo(40)
        }
        
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImage.snp.right).offset(15)
            make.top.equalTo(5)
        }
        
        bgView.addSubview(IDImage)
        IDImage.snp.makeConstraints { make in
            make.left.equalTo(avatarImage.snp.right).offset(15)
            make.bottom.equalTo(-4)
            make.width.height.equalTo(16)
        }
        
        bgView.addSubview(IDLabel)
        IDLabel.snp.makeConstraints { make in
            make.centerY.equalTo(IDImage)
            make.left.equalTo(IDImage.snp.right).offset(4)
        }
        
        bgView.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.width.height.equalTo(30)
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
    
    func reloadData(with data: ADSUserInfoModel) {
        avatarImage.kf.setImage(with: URL(string: data.user_header), placeholder: UIImage(named: "mine_avatar_default"))
        nameLabel.text = data.nick_name
        IDLabel.text = "\(data.user_id)"
    }

}
