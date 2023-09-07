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
        
        guard profile.profileImgName != nil else {
            profileImageView.image = UIImage(named: "default-profile")
            return
        }
        
        profileImageView.image = UIImage(named: profile.profileImgName!)
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
