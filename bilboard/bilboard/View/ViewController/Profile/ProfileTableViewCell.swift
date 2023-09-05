//
//  ProfileTableViewCell.swift
//  bilboard
//
//  Created by t2023-m0055 on 2023/09/05.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "profileCell"

    @IBOutlet var logoutBtn: UIButton!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ userInfo: UserInfo) {
        nicknameLabel.text = profile.nickname
        emailLabel.text = profile.email
        
        switch userInfo.isUsing {
        case true:
            let status = "🛴 사용중"
            statusLabel.text = status
        case false:
            let status = "🫥 미사용중"
            statusLabel.text = status
        }
        
        // image url 받아서 띄우는 method 삽입 필요
        // alamofire package 필요
        // let url = profile.profileImageUrl
        // let imageName = loadImage(url)
        // profileImage.image = imageName
        
    }
    
}
