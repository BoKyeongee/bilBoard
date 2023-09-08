//
//  CollectionViewCell.swift
//  bilboard
//
//  Created by 보경 on 2023/09/06.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeWrap: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    func setData(_ boardInfo: BoardInfo) {
        idLabel.text = "🔍 ID: " + String(boardInfo.boardID)
        
        switch boardInfo.boardType {
        case BoardTypes.basic:
            typeLabel.text = "⭐️ basic ⭐️"
        case BoardTypes.premium:
            typeLabel.text = "👑 premium 👑"
        }
        
        addressLabel.text = boardInfo.address
    }
}
