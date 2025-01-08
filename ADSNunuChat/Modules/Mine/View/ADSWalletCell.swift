//
//  ADSWalletCell.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/6.
//

import UIKit

class ADSWalletCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    
    
    @IBOutlet weak var beansBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = .clear
        bgView.addCorner(radius: 20)
        
    }

}
