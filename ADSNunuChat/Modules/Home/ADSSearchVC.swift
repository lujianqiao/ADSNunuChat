//
//  ADSSearchVC.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/13.
//

import UIKit

class ADSSearchVC: ADSBaseViewController {

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
        tab.register(ADSSearchResultCell.self, forCellReuseIdentifier: String(describing: ADSSearchResultCell.self))
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
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
    }
}


extension ADSSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ADSSearchResultCell.self)) as! ADSSearchResultCell
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
