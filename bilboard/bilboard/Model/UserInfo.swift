//
//  UserInfo.swift
//  bilboard
//
//  Created by 남보경 on 2023/09/04.
//

import Foundation

struct UserInfo {
    
    init(nickname: String, userId: String, userPw: String, email: String, isUsing: Bool, isLogin: Bool, profileImageUrl: String?, usageHistory: [History]?, bilBoardInfos: [BoardInfo]?) {
    self.nickname = nickname
    self.userId = userId
    self.userPw = userPw
    self.email = email
    self.isUsing = isUsing
    self.isLogin = isLogin
    self.profileImageUrl = profileImageUrl
    self.usageHistory = usageHistory
    self.bilBoardInfos = bilBoardInfos
    }
    
    
    var nickname:String
    var userId: String
    var userPw: String
    var email: String
    var isUsing: Bool
    var isLogin: Bool
    var profileImageUrl:String?
    var usageHistory:[History]?
    var bilBoardInfos:[BoardInfo]?
}
