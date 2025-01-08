//
//  ADSMineToolView.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/3.
//

import UIKit

enum ADSMineToolViewType {
    case call
    case account
    case blackList
    case setting
}

class ADSMineToolView: UIView {

    let datas: [ADSMineToolViewType] = [.call, .account, .blackList, .setting]
    
    var itemSelectBlock: ((ADSMineToolViewType) -> ())?
    
    lazy var tableview: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.rowHeight = 64
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.isScrollEnabled = false
        tab.register(ADSMineToolCell.self, forCellReuseIdentifier: String(describing: ADSMineToolCell.self))
        return tab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ADSMineToolView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ADSMineToolCell.self)) as? ADSMineToolCell
        cell?.reloadData(with: datas[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = datas[indexPath.row]
        if let block = itemSelectBlock {
            block(item)
        }
    }
    
}


class ADSMineToolCell: UITableViewCell {
    
    lazy var leftImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "")
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = ""
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var rightImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "mine_arrow_black")
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(leftImage)
        leftImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.width.height.equalTo(20)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftImage.snp.right).offset(16)
        }
        
        contentView.addSubview(rightImage)
        rightImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.width.height.equalTo(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(with type: ADSMineToolViewType) {
        switch type {
        case .call:
            leftImage.image = .init(named: "mine_call")
            titleLabel.text = "call records"
        case .account:
            leftImage.image = .init(named: "mine_account")
            titleLabel.text = "My account"
        case .blackList:
            leftImage.image = .init(named: "mine_black_list")
            titleLabel.text = "Blacklist"
        case .setting:
            leftImage.image = .init(named: "mine_setting")
            titleLabel.text = "Settings"
        
        }
    }
    
}
