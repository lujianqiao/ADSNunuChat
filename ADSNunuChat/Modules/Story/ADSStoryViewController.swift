//
//  ADSStoryViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/27.
//

import UIKit

class ADSStoryViewController: ADSBaseViewController {

    private var datas: [ADSHomeListModel] = []
    
    lazy var bgImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        return image
    }()
    
    lazy var titleImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "story_title")
        return image
    }()
    
    lazy var addBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "home_add"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSPublishArticleVC()
            vc.type = .storyDetail
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var collection: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        let coll: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
        coll.backgroundColor = .clear
        coll.showsHorizontalScrollIndicator = false
        coll.showsVerticalScrollIndicator = false
        coll.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: kSafeBottomMargin + 90.scale, right: 20)
        
        coll.delegate = self
        coll.dataSource = self
        
        coll.register(ADSStoryTopCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ADSStoryTopCollectionViewCell.self))
        coll.register(ADSStoryTitleCell.self, forCellWithReuseIdentifier: String(describing: ADSStoryTitleCell.self))
        coll.register(ADSStoryItemCell.self, forCellWithReuseIdentifier: String(describing: ADSStoryItemCell.self))
        
        return coll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    override var preferredNavigationBarHidden: Bool {true}

}

extension ADSStoryViewController {
    func setUpUI() {
        
        view.addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(titleImage)
        titleImage.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(kStatusBarHeight + 10)
            make.size.equalTo(CGSize(width: 200, height: 38))
        }
        
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.top.equalTo(kStatusBarHeight)
            make.right.equalTo(-10)
            make.width.height.equalTo(44)
        }
        
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleImage.snp.bottom).offset(10)
        }
    }
    
    func getData() {
        httpProvider.request(.getDressList("0", "1", "100", nil)) { result in
            
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                guard let data = json["data"] as? [[String: Any]] else {return}
                guard let models = [ADSHomeListModel].deserialize(from: data) else {return}
                self.datas = models
                self.collection.reloadData()
                
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
            
        }
    }
    
}


extension ADSStoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return datas.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ADSStoryTopCollectionViewCell.self), for: indexPath) as! ADSStoryTopCollectionViewCell
            cell.reloadData(with: datas)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ADSStoryTitleCell.self), for: indexPath) as! ADSStoryTitleCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ADSStoryItemCell.self), for: indexPath) as! ADSStoryItemCell
            cell.reloadData(with: datas[indexPath.row])
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let vc = ADSStoryDetailVC()
            vc.type = .storyDetail
            vc.model = datas[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}

extension ADSStoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return .init(width: kScreenWidth, height: 146)
        } else if indexPath.section == 1 {
            return .init(width: kScreenWidth, height: 48)
        } else {
            return .init(width: 160.scale, height: 254.scale)
        }
    }
    
        
    /// 动态设置每个分区的EdgeInsets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return UIEdgeInsets(top: 0, left: 2.scale, bottom: 0, right: 2.scale)
        } else {
            return .zero
        }
    }
    
    
    /// 每行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.scale
    }
    
    /// 每列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.scale
    }
    
    
    
    
}
