//
//  ProfileTableViewCell.swift
//  bilboard
//
//  Created by 보경 on 2023/09/05.
//

import UIKit



class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileBox: UIView!
    @IBOutlet weak var statusWrap: UIView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    func setData(_ userInfo: UserInfo) {
        nicknameLabel.text = profile.nickname
        emailLabel.text = profile.email
        
        // image url 받아서 띄우는 method 삽입 필요
        // alamofire package 필요
        // let url = profile.profileImageUrl
        // let imageName = loadImage(url)
        // profileImageView.image = imageName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
