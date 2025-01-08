//
//  ADSWalletViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/6.
//

import UIKit
import RxSwift

class ADSWalletViewController: ADSBaseViewController {

    lazy var BGImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var navBar: ADSSignInNavBar = {
        let bar = ADSSignInNavBar(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        bar.backgroundColor = .clear
        bar.titleLabel.text = "My wallet"
        return bar
    }()
    
    lazy var topView: ADSWalletTopView = {
        let view = ADSWalletTopView(frame: CGRect(x: 0, y: 0, width: 345.scale, height: 80.scale))
        view.addGradientLayer(colors: [.init(hex: "#A5FFFD"), .white, .init(hex: "#FFAFE2")], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 0))
        view.addCorner(radius: 20)
        return view
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        flowLayout.scrollDirection = .vertical
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "ADSWalletCell", bundle: nil), forCellWithReuseIdentifier: "ADSWalletCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override var preferredNavigationBarHidden: Bool {true}

}

extension ADSWalletViewController {
    func setUpUI() {
        
        view.addSubview(BGImage)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kNavHeight)
        }
        
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(50)
            make.size.equalTo(CGSize(width: 345.scale, height: 80.scale))
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(33)
        }
    }
}


// MARK: UICollectionViewDataSource
extension ADSWalletViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADSWalletCell", for: indexPath)
        return cell
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ADSWalletViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105.scale, height: 131.scale)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    /// 动态设置每个分区的EdgeInsets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15.scale, bottom: 0, right: 15.scale)
    }
    /// 每行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.scale
    }
    /// 每列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.scale
    }
}
