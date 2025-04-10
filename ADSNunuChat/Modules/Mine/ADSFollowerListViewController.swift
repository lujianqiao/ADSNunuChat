//
//  ADSFollowerListViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/3/19.
//

import UIKit

class ADSFollowerListViewController: ADSBaseViewController {

    var type: Int = 0
    private var datas: [ADSUserInfoModel] = []
    
    lazy var BGImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.roundedCorners([.topLeft, .topRight], radius: 20)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleView: ADSFollowerListTitleView = {
        let view = ADSFollowerListTitleView.init(frame: .init(x: 0, y: 0, width: 170, height: 40))
        view.indexBlock = {[weak self] index in
            guard let self = self else { return }
            self.type = index
            self.getData()
        }
        return view
    }()
    
    lazy var tableview: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.backgroundColor = .clear
        tab.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tab.register(ADSSearchResultCell.self, forCellReuseIdentifier: String(describing: ADSSearchResultCell.self))
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getData()
        // Do any additional setup after loading the view.
    }

    
    

}

extension ADSFollowerListViewController {
    func setUpUI() {
        
        view.addSubview(BGImage)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kNavHeight + 4)
        }
        
        bgView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 170, height: 40))
        }
        
        titleView.refreshUI(with: self.type)
        
        bgView.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(10)
        }
        
    }
    
    func getData() {
        
        if type == 0 {
            getFollower()
        } else {
            getFollowing()
        }
        
        
        func getFollower() {
            httpProvider.request(.followerList("1", "100")) { result in
                
                switch result {
                case .success(let response):
                    guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                    guard let data = json["data"] as? [[String: Any]] else {return}
                    guard let datas = [ADSUserInfoModel].deserialize(from: data) else {return}
                    self.datas = datas
                    self.tableview.reloadData()
                    
                case .failure(_):
                    ADSHUD.showText(text: "Data anomalies")
                }
                
            }
        }
        
        func getFollowing() {
            httpProvider.request(.followingList("1", "100")) { result in
                
                switch result {
                case .success(let response):
                    guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                    guard let data = json["data"] as? [[String: Any]] else {return}
                    guard let datas = [ADSUserInfoModel].deserialize(from: data) else {return}
                    self.datas = datas
                    self.tableview.reloadData()
                    
                case .failure(_):
                    ADSHUD.showText(text: "Data anomalies")
                }
                
            }
        }
        
        
        
    }
    
}

extension ADSFollowerListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ADSSearchResultCell.self)) as! ADSSearchResultCell
        cell.reloadData(with: datas[indexPath.row])
        cell.addBtn.isHidden = type == 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
}
