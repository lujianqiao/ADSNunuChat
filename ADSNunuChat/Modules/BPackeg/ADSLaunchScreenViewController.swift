//
//  ADSLaunchScreenViewController.swift
//  ADSNunuChat
//  
//  Created by _.
//  Copyright © 2025/7/8 _. All rights reserved.
//

import UIKit

class ADSLaunchScreenViewController: UIViewController {

    lazy var imageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "launch")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }
}
