//
//  ADSWalletViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/6.
//

import UIKit
import RxSwift

class ADSWalletViewController: ADSBaseViewController {

    var datas: [ADSRechargeModel] = []
    
    lazy var BGImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        image.contentMode = .scaleAspectFill
        return image
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
        getData()
        // Do any additional setup after loading the view.
    }
    
//    override var preferredNavigationBarHidden: Bool {true}

}

extension ADSWalletViewController {
    func setUpUI() {
        
        title = "My wallet"
        
        view.addSubview(BGImage)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(kNavHeight + 50)
            make.size.equalTo(CGSize(width: 345.scale, height: 80.scale))
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(33)
        }
    }
    
    func getData() {
        
        if let userInfoModel = UserInfoManager.share.userInfo {
            topView.beansLab.text = "\(userInfoModel.coins)"
        }
        
        ADSHUD.showHUD()
        httpProvider.request(.getRechargeList) { result in
            
            ADSHUD.hidenHUD()
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                guard let data = json["data"] as? [[String: Any]] else {return}
                guard let models = [ADSRechargeModel].deserialize(from: data) else {return}
                self.datas = models
                self.collectionView.reloadData()
                
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
            
        }
    }
    
    func getUserInfo() {
        
        httpProvider.request(.getUserInfo(nil)) { result in
            
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                guard let data = json["data"] as? [String: Any] else {return}
                guard let model = ADSUserInfoModel.deserialize(from: data) else {return}
                UserInfoManager.share.userInfo = model
                self.topView.beansLab.text = "\(model.coins)"
                
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
            
        }
    }
    
    
    func rechargeAction(with model: ADSRechargeModel) {
        // TODO: -充值
        ADSHUD.showHUD(showView: self.view)
        ADSIAPNewManager.shared.payAction(productId: model.purchase_id) { productId, receipt, transaction in
            ADSHUD.hidenHUD()
            
            // 拿到购买凭证
            guard let transactionIdentifier = transaction.transactionIdentifier else {return}
            httpProvider.request(.verifyPurchaseProof(productId, receipt, transactionIdentifier, "2")) { result in
               
                switch result {
                case .success(let response):
                    guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                    guard let code = json["code"] as? Int else {return}
                    if code == 1 {
                        // 验证通过
                        ADSHUD.showText(text: "Purchase Success", showView: self.view)
                        self.getUserInfo()
                    }
                case .failure(_):
                    ADSHUD.showText(text: "Data anomalies")
                }
            }
        } failed: { error in
            ADSHUD.hidenHUD()
            ADSHUD.showText(text: error.localizedDescription)
        } canceled: {
            ADSHUD.hidenHUD()
        }
    }
}


// MARK: UICollectionViewDataSource
extension ADSWalletViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADSWalletCell", for: indexPath) as! ADSWalletCell
        cell.reloadData(with: datas[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = datas[indexPath.row]
        rechargeAction(with: model)
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
        return 13.scale
    }
    /// 每列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 13.scale
    }
}
