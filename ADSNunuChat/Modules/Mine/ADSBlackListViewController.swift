//
//  ADSBlackListViewController.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/7.
//

import UIKit

class ADSBlackListViewController: ADSBaseViewController {

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
    
    lazy var tableview: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.register(ADSBlackListCell.self, forCellReuseIdentifier: String(describing: ADSBlackListCell.self))
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getData()
        // Do any additional setup after loading the view.
    }

}

extension ADSBlackListViewController {
    func setUpUI() {
        title = "Blacklist"
        view.addSubview(BGImage)
        BGImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kNavHeight + 4)
        }
        
        bgView.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(10)
        }
    }
    
    func getData() {
        ADSHUD.showHUD()
        httpProvider.request(.blockList("1", "100")) { result in
            ADSHUD.hidenHUD()
            
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any] else {return}
                guard let data = json["data"] as? [[String: Any]] else {return}
                guard let models = [ADSUserInfoModel].deserialize(from: data) else {return}
                self.datas = models
                self.tableview.reloadData()
                
            case .failure(_):
                ADSHUD.showText(text: "Data anomalies")
            }
        }
    }
    
    /// 取消拉黑
    func removeBlock(with ID: String) {
        httpProvider.request(.blockAction("\(ID)", "0")) { result in
            self.getData()
        }
    }
}


extension ADSBlackListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ADSBlackListCell.self)) as! ADSBlackListCell
        cell.reloadData(with: datas[indexPath.row])
        cell.removeBlock = {[weak self] userID in
            guard let self = self else { return }
            self.removeBlock(with: userID)
        }
        return cell
    }
    
}
