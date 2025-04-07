//
//  ADSBlackListCell.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/7.
//

import UIKit
import Kingfisher

class ADSBlackListCell: UITableViewCell {

    var removeBlock: ((String) -> Void)?
    
    private var model: ADSUserInfoModel = .init()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.addCorner(radius: 10)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var avatarImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_avatar_default")
        image.addCorner(radius: 23)
        return image
    }()
    
    lazy var namelabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Oven"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return lab
    }()
    
    lazy var IDLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "ID: 13U8982"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    
    lazy var removeBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setTitle("Remove", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        btn.addCorner(radius: 18)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let block = self.removeBlock {
                block("\(self.model.user_id)")
            }
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(5)
            make.height.equalTo(64).priority(.low)
        }
        
        bgView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.width.height.equalTo(46)
        }
        
        bgView.addSubview(namelabel)
        namelabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImage.snp.right).offset(10)
            make.top.equalTo(14)
        }
        
        bgView.addSubview(IDLabel)
        IDLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImage.snp.right).offset(10)
            make.bottom.equalTo(-14)
        }
        
        bgView.addSubview(removeBtn)
        removeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.size.equalTo(CGSize(width: 80, height: 36))
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
    
    func reloadData(with model: ADSUserInfoModel) {
        self.model = model
        avatarImage.kf.setImage(with: URL(string: model.user_header), placeholder: UIImage(named: "mine_avatar_default"))
        namelabel.text = model.nick_name
        IDLabel.text = "ID: \(model.user_id)"
    }

}
