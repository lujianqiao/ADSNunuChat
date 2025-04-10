//
//  ADSHomeViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/27.
//

import UIKit
import RxSwift
import MBProgressHUD

class ADSHomeViewController: ADSBaseViewController {

    private var datas: [ADSHomeListModel] = []
    
    lazy var bgImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        return image
    }()
    
    lazy var titleImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "home_title")
        return image
    }()
    
    lazy var addBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "home_add"), for: .normal)
        btn.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSPublishArticleVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        return btn
    }()
    
    lazy var searchView: ADSHomeSearchView = {
        let view = ADSHomeSearchView()
        view.enterField.isEnabled = false
        view.rx.tap().subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            let vc = ADSSearchVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        return view
    }()
    
    lazy var tableview: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.backgroundColor = .clear
        tab.contentInset = .init(top: 0, left: 0, bottom: kSafeBottomMargin + 90.scale, right: 0)
        tab.register(ADSCollectionsCell.self, forCellReuseIdentifier: String(describing: ADSCollectionsCell.self))
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    override var preferredNavigationBarHidden: Bool {true}
    
}

extension ADSHomeViewController {
    func setUpUI() {
        
        view.addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(titleImage)
        titleImage.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(kStatusBarHeight)
            make.size.equalTo(CGSize(width: 190, height: 38))
        }
        
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.top.equalTo(kStatusBarHeight)
            make.right.equalTo(-10)
            make.width.height.equalTo(44)
        }
        
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(titleImage.snp.bottom).offset(13)
            make.height.equalTo(46)
        }
        
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(4)
        }
    }
    
    func getData() {
        
        var hud: MBProgressHUD?
        if datas.count == 0 {
            hud = ADSHUD.showHUD()
        }
        
        httpProvider.request(.getMakeUpList("0", "1", "100", "0", nil)) { result in
            hud?.hide(animated: true)
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                guard let data = json["data"] as? [[String: Any]] else {return}
                guard let models = [ADSHomeListModel].deserialize(from: data) else {return}
                self.datas = models
                self.tableview.reloadData()
                
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
            
        }
        
        httpProvider.request(.getUserInfo(nil)) { result in
            
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                guard let data = json["data"] as? [String: Any] else {return}
                guard let model = ADSUserInfoModel.deserialize(from: data) else {return}
                UserInfoManager.share.userInfo = model
                
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
            
        }
    }
}


extension ADSHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ADSCollectionsCell.self)) as! ADSCollectionsCell
        cell.reloadData(with: datas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 264 + 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ADSStoryDetailVC()
        vc.model = datas[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
