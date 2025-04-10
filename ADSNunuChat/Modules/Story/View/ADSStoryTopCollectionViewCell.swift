//
//  ADSStoryTopCollectionViewCell.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/17.
//

import UIKit
import Kingfisher

class ADSStoryTopCollectionViewCell: UICollectionViewCell {
    
    private var datas: [ADSHomeListModel] = []
    
    lazy var collection: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionHeadersPinToVisibleBounds = true
        let coll: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.showsVerticalScrollIndicator = false
        coll.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        coll.delegate = self
        coll.dataSource = self
        
        coll.register(ADSStoryTopCollectionViewItemCell.self, forCellWithReuseIdentifier: String(describing: ADSStoryTopCollectionViewItemCell.self))
        
        return coll
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(with data: [ADSHomeListModel]) {
        self.datas = data
        collection.reloadData()
    }
    
}



extension ADSStoryTopCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ADSStoryTopCollectionViewItemCell.self), for: indexPath) as! ADSStoryTopCollectionViewItemCell
        cell.reloadData(with: datas[indexPath.row])
        return cell
    }
    
    
}

extension ADSStoryTopCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 121, height: 146)
    }
    
        
    /// 动态设置每个分区的EdgeInsets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        } else {
            return .zero
        }
    }
    
    
    /// 每行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.scale
    }
    
    /// 每列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.scale
    }
    
    
}


class ADSStoryTopCollectionViewItemCell: UICollectionViewCell {
    
    private var data: ADSHomeListModel = ADSHomeListModel()
    
    lazy var bgView: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: 121, height: 146))
        view.addCorner(radius: 8)
        view.addGradientLayer(colors: [.init(hex: "#FFB3E3"), .white], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0, y: 1))
        return view
    }()
    
    lazy var avatarView: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: 61, height: 61))
        view.addGradientLayer(colors: [.init(hex: "#B6FFFF"), .init(hex: "#FFB7E2")], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0, y: 1))
        view.addCorner(radius: 30.5)
        return view
    }()
    
    lazy var avatarImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_avatar_default")
        image.addCorner(radius: 29.5)
        image.layer.borderColor = UIColor.clear.cgColor
        image.layer.borderWidth = 2
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = "Lucy Jordan"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var followBtn: ADSButton = {
        let btn: ADSButton = .init()
        btn.setBackgroundImage(.init(named: "story_follow_bg"), for: .normal)
        btn.setImage(UIImage(named: "story_follow_add"), for: .normal)
        btn.setTitle("Followed", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.spacingBetweenImageAndTitle = 4
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.followAction()
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(21)
            make.width.height.equalTo(61)
        }
        
        avatarView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(59)
        }
        
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(9)
        }
        
        bgView.addSubview(followBtn)
        followBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.size.equalTo(CGSize(width: 70, height: 20))
        }
    }
    
    func reloadData(with model: ADSHomeListModel) {
        self.data = model
        avatarImage.kf.setImage(with: URL(string: model.user_header), placeholder: UIImage(named: "mine_avatar_default"))
        nameLabel.text = model.nick_name
        
        followBtn.isHidden = model.is_self
        
        if model.is_followed {
            followBtn.setTitle("Followed", for: .normal)
        } else {
            followBtn.setTitle("Follow", for: .normal)
        }
        
        
    }
    
    func followAction() {
        
        var status: Int = 1
        status = data.is_followed ? 0 : 1
        
        let hud = ADSHUD.showHUD()
        httpProvider.request(.followAction("\(data.user_id)", status)) { result in
            hud.hide(animated: true)
            switch result {
            case .success(_):
                self.data.is_followed = !self.data.is_followed
                
                if self.data.is_followed {
                    self.followBtn.setTitle("Followed", for: .normal)
                } else {
                    self.followBtn.setTitle("Follow", for: .normal)
                }
                ADSHUD.showSuccess()
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
