//
//  ProfileCollectionViewCell.swift
//  bilboard
//
//  Created by t2023-m0055 on 2023/09/05.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "boardCollectionCell"

    @IBOutlet var boardAddressLabel: UILabel!
    @IBOutlet var boardTypeLabel: UILabel!
    @IBOutlet var boardIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(_ boardInfo: BoardInfo) {
        boardIDLabel.text = String(boardInfo.boardID)
        
        switch boardInfo.boardType {
        case BoardTypes.basic :
            let type = "💛 basic"
            boardTypeLabel.text = type
        case BoardTypes.premium :
            let type = "👑 premium"
            boardTypeLabel.text = type
        }
        
        boardAddressLabel.text = boardInfo.address
    }

}
