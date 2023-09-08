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



let history1 = History(historyID: 1, startTime: "2023-09-04 10:00", endTime: "2023-09-04 12:00", startLat: 37.123, startLong: 126.456, endLat: 37.456, endLong: 126.789, useDate: "2023-09-04", bilBoardID: 101)

let history2 = History(historyID: 2, startTime: "2023-09-05 14:30", endTime: "2023-09-05 16:30", startLat: 37.789, startLong: 127.123, endLat: 38.012, endLong: 127.456, useDate: "2023-09-05", bilBoardID: 102)

let boardInfo1 = BoardInfo(address: "부천시 중동", boardType: BoardTypes.premium, boardID: 1001, registerTime: "2023-09-04 09:30", lat: 37.49426290218334, lng : 126.77814658950003)

let boardInfo2 = BoardInfo(address: "서울시 강남구", boardType: BoardTypes.basic, boardID: 1002, registerTime: "2023-09-05 10:45",  lat: 37.495138607717315, lng : 126.770793665122)

let boardInfo3 = BoardInfo(address: "성남시 분당구", boardType: BoardTypes.basic, boardID: 1003, registerTime: "2023-09-05 15:23",  lat: 37.35969929901283, lng : 127.10578995996839)

let boardInfo4 = BoardInfo(address: "성남시 분당구", boardType: BoardTypes.basic, boardID: 1004, registerTime: "2023-09-06 08:51",  lat: 37.359679443897335, lng : 127.10782174834425)

let boardInfo5 = BoardInfo(address: "성남시 분당구", boardType: BoardTypes.basic, boardID: 1005, registerTime: "2023-09-06 10:51",  lat: 37.35785215498576, lng : 127.10583251774915)

let boardInfo6 = BoardInfo(address: "서울시 송파구", boardType: BoardTypes.basic, boardID: 1006, registerTime: "2023-09-03 19:22",  lat: 37.51378649397107, lng : 127.10057777242226)

let boardInfo7 = BoardInfo(address: "서울시 송파구", boardType: BoardTypes.basic, boardID: 1007, registerTime: "2023-09-05 15:31",  lat: 37.51461319215112, lng : 127.10315782680941)

let boardInfo8 = BoardInfo(address: "서울시 송파구", boardType: BoardTypes.basic, boardID: 1008, registerTime: "2023-09-08 13:55",  lat: 37.51568260689407, lng : 127.10629253536733)

let boardInfo9 = BoardInfo(address: "서울시 송파구", boardType: BoardTypes.basic, boardID: 1009, registerTime: "2023-09-09 21:11",  lat: 37.51568260689407, lng : 127.10629253536733)

let boardInfo10 = BoardInfo(address: "부천시 중동", boardType: BoardTypes.basic, boardID: 1010, registerTime: "2023-09-05 06:27",  lat: 37.504155118747676, lng : 126.7660500148417)

let boardInfo11 = BoardInfo(address: "부천시 중동", boardType: BoardTypes.basic, boardID: 1011, registerTime: "2023-09-06 21:34",  lat: 37.50430538999483, lng : 126.76459060924529)

let boardInfo12 = BoardInfo(address: "부천시 중동", boardType: BoardTypes.basic, boardID: 1012, registerTime: "2023-09-06 11:33",  lat: 37.505289539943995, lng : 126.76112674024522)


var profile = UserInfo(
    nickname: "노스크럼",
    userId: "bilboard1",
    userPw: "Bilboard1!",
    email: "example@email.com",
    isUsing: false,
    isLogin: false,
    usageHistory: [history1, history2],
    bilBoardInfos: [boardInfo1, boardInfo2, boardInfo3, boardInfo4, boardInfo5, boardInfo6, boardInfo7, boardInfo8,boardInfo9, boardInfo10, boardInfo11, boardInfo12],
    currentLat: 37.49906045305895,
    currentLng: 126.76517251537199,
    profileImgName: "profile-pic"
)

var registeredUsers: [UserInfo] = [profile]



