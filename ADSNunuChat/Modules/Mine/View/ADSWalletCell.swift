//
//  ADSWalletCell.swift
//  ADSNunuChat
//
//  Created by lujianqiao on 2025/1/6.
//

import UIKit

class ADSWalletCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var beansValueLab: UILabel!
    
    @IBOutlet weak var beansBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = .clear
        bgView.addCorner(radius: 20)
        
    }
    
    func reloadData(with model: ADSRechargeModel) {
        beansValueLab.text = model.coins
        beansBtn.setTitle(model.money, for: .normal)
    }

}
