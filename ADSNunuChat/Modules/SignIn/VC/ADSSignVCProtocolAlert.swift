//
//  ADSSignVCProtocolAlert.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2024/12/26.
//

import UIKit

class ADSSignVCProtocolAlert: UIViewController {

    lazy var bgImageView: UIImageView = {
        let image: UIImageView = .init()
        image.image = UIImage(named: "sign_in_protocol_bg")
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let lab: UILabel = .init()
        lab.text = ADSConst.AppDisplayName
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lab
    }()
    
    lazy var contentTextView: UITextView = {
        let text = UITextView()
        text.textColor = .black
        text.font = .systemFont(ofSize: 14, weight: .medium)
        text.isEditable = false
        text.backgroundColor = .clear
        text.text = "End User License Agreement (\(ADSConst.AppDisplayName)) \n\n 1. Acknowledgement This End-User License Agreement („\(ADSConst.AppDisplayName)“) is a legal agreement between you and Aiken Bab. This agreement is between You and Aiken Bab only, and not Apple Inc. („Apple“). Aiken Bab, not Apple is solely responsible for the Spark-Video iOS App and their content. Although Apple is not a party to this agreement, Apple has the right to enforce this agreement against you as a third party beneficiary relating to your use of the Spark-Video iOS App. \n\n 2. Scope of License Aiken Bab grants you a limited, non-exclusive, non-transferrable , revocable license to use the Spark-Video iOS Apps for your personal"
        return text
    }()
    
    lazy var agreeBtn: UIButton = {
        let btn: UIButton = .init()
        btn.setImage(UIImage(named: "Agree"), for: .normal)
        btn.setBackgroundImage(.init(named: "agree_bg"), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(CGSize(width: kScreenWidth, height: 518.scale)).priority(.low)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
        }
        
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(-130)
        }
        
        view.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-kSafeBottomMargin - 40)
            make.size.equalTo(CGSize(width: 272.scale, height: 56.scale))
        }
        // Do any additional setup after loading the view.
    }
    

}

// MARK: 弹窗协议
extension ADSSignVCProtocolAlert: ADSAlertViewAnimator {}
