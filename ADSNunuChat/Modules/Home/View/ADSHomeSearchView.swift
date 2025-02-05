//
//  ADSHomeSearchView.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/10.
//

import UIKit

class ADSHomeSearchView: UIView {

    lazy var bgImage: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "home_search_bg")
        return image
    }()
    
    lazy var enterField: UITextField = {
        let field: UITextField = .init()
        field.placeholder = "search"
        field.font = UIFont.systemFont(ofSize: 14)
        
        
        let leftView = UIView(frame: .init(x: 0, y: 0, width: 40, height: 16))
        
        let image = UIImageView(frame: .init(x: 6, y: 0, width: 16, height: 16))
        image.image = .init(named: "home_search_icon")
        leftView.addSubview(image)
        
        field.leftView = leftView
        field.leftViewMode = .always
        
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(enterField)
        enterField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
