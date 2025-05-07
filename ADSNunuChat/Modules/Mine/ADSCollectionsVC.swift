//
//  ADSCollectionsVC.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/8.
//

import UIKit

class ADSCollectionsVC: ADSBaseViewController {

    private var datas: [ADSHomeListModel] = []
    
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
        tab.register(ADSCollectionsCell.self, forCellReuseIdentifier: String(describing: ADSCollectionsCell.self))
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getData()
        // Do any additional setup after loading the view.
    }

}

extension ADSCollectionsVC {
    func setUpUI() {
        title = "My Collections"
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
        httpProvider.request(.likeList("1", "100", "1")) { result in
            ADSHUD.hidenHUD()
            
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
    }
}

extension ADSCollectionsVC: UITableViewDelegate, UITableViewDataSource {
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
