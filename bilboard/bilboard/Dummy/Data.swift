//
//  Data.swift
//  bilboard
//
//  Created by 남보경 on 2023/09/04.
//

import Foundation

//class Data {
//    static let shared = Data()
//
//    private init() {}
//}



let history1 = History(historyID: 1, startTime: "2023-09-04 10:00:00", endTime: "2023-09-04 12:00:00", startLat: 37.123, startLong: 126.456, endLat: 37.456, endLong: 126.789, useDate: "2023-09-04", bilBoardID: 101)

let history2 = History(historyID: 2, startTime: "2023-09-05 14:30:00", endTime: "2023-09-05 16:30:00", startLat: 37.789, startLong: 127.123, endLat: 38.012, endLong: 127.456, useDate: "2023-09-05", bilBoardID: 102)

let boardInfo1 = BoardInfo(address: "서울시 강남구", boardType: BoardTypes.premium, boardID: 1001, registerTime: "2023-09-04 09:30:00", lat: 37.473736875300, lng : 126.7848168321)

let boardInfo2 = BoardInfo(address: "부산시 해운대구", boardType: BoardTypes.basic, boardID: 1002, registerTime: "2023-09-05 10:45:00",  lat: 37.482756874520, lng : 126.7674515520)

let boardInfo3 = BoardInfo(address: "부산시 해운대구", boardType: BoardTypes.basic, boardID: 1003, registerTime: "2023-09-05 10:45:00",  lat: 37.481778845776, lng : 126.79888278525)

let boardInfo4 = BoardInfo(address: "부산시 해운대구", boardType: BoardTypes.basic, boardID: 1004, registerTime: "2023-09-05 10:45:00",  lat: 37.481774875776, lng : 126.79543178525)




var profile = UserInfo(
    nickname: "노스크럼",
    userId: "bilboard1",
    userPw: "Bilboard1!",
    email: "example@email.com",
    isUsing: false,
    isLogin: false,
    profileImageUrl: nil,
    usageHistory: [history1,history2],
    bilBoardInfos: [boardInfo1,boardInfo2,boardInfo3,boardInfo4],
    currentLat: 37.481776875776,
    currentLng: 126.79742178525
)

var registeredUsers: [UserInfo] = [profile]



