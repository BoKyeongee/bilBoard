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

let profile = UserInfo(
    nickname: "노스크럼",
    userId: "importantMorning",
    userPw: "Shtmzmfja7&",
    email: "example@email.com",
    isUsing: false,
    isLogin: false,
    profileImageUrl: nil,
    usageHistory: nil,
    bilBoardInfos: nil,
    currentLat: 37.42,
    currentLng: 126.766
)

let history1 = History(historyID: 1, startTime: "2023-09-04 10:00:00", endTime: "2023-09-04 12:00:00", startLat: 37.123, startLong: 126.456, endLat: 37.456, endLong: 126.789, useDate: "2023-09-04", bilBoardID: 101)

let history2 = History(historyID: 2, startTime: "2023-09-05 14:30:00", endTime: "2023-09-05 16:30:00", startLat: 37.789, startLong: 127.123, endLat: 38.012, endLong: 127.456, useDate: "2023-09-05", bilBoardID: 102)

let boardInfo1 = BoardInfo(address: "서울시 강남구", boardType: BoardTypes.premium, boardID: 1001, registerTime: "2023-09-04 09:30:00")

let boardInfo2 = BoardInfo(address: "부산시 해운대구", boardType: BoardTypes.basic, boardID: 1002, registerTime: "2023-09-05 10:45:00")
