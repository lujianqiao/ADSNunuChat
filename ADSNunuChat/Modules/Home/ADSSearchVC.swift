//
//  ADSSearchVC.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/13.
//

import UIKit

class ADSSearchVC: ADSBaseViewController {

    private var datas: [ADSHomeListModel] = []
    
    lazy var bgImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_vc_bg")
        return image
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.roundedCorners([.topLeft, .topRight], radius: 20)
        view.backgroundColor = .white
        return view
    }()
    
    lazy var searchView: ADSHomeSearchView = {
        let view = ADSHomeSearchView()
        return view
    }()
    
    lazy var tableview: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.backgroundColor = .clear
        tab.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tab.register(ADSCollectionsCell.self, forCellReuseIdentifier: String(describing: ADSCollectionsCell.self))
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.enterField.becomeFirstResponder()
    }

}

extension ADSSearchVC {
    func setUpUI() {
        view.addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(kNavHeight + 4)
        }
        
        bgView.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(19)
            make.height.equalTo(46)
        }
        
        bgView.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(10)
        }
        
        searchView.enterField.rx.text.orEmpty.subscribe(onNext: {[weak self] text in
            guard let self = self else { return }
            self.requestData(with: text)
        }).disposed(by: rx.disposeBag)
    }
    
    func requestData(with keywords: String) {
        guard keywords.isEmpty == false else {
            datas = []
            tableview.reloadData()
            return
        }
        httpProvider.request(.getMakeUpList("0", "1", "100", "0", nil, keywords)) { result in
            
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


extension ADSSearchVC: UITableViewDelegate, UITableViewDataSource {
    
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
