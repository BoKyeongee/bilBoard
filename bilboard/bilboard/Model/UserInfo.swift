//
//  UserInfo.swift
//  bilboard
//
//  Created by 남보경 on 2023/09/04.
//

import Foundation

struct UserInfo {
    
    init(nickname: String, userId: String, userPw: String, email: String, isUsing: Bool, isLogin: Bool, usageHistory: [History]?, bilBoardInfos: [BoardInfo]?, currentLat : Double, currentLng : Double, profileImgName: String?) {
    self.nickname = nickname
    self.userId = userId
    self.userPw = userPw
    self.email = email
    self.isUsing = isUsing
    self.isLogin = isLogin
    self.usageHistory = usageHistory
    self.bilBoardInfos = bilBoardInfos
    self.currentLat = currentLat
    self.currentLng = currentLng
    self.profileImgName = profileImgName
    }

    var nickname:String
    var userId: String
    var userPw: String
    var email: String
    var isUsing: Bool
    var isLogin: Bool
    var usageHistory:[History]?
    var bilBoardInfos:[BoardInfo]?
    var currentLat : Double //위도
    var currentLng : Double //경도
    var profileImgName: String?
}
