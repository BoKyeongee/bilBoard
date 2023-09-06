//
//  BoardInfo.swift
//  bilboard
//
//  Created by 남보경 on 2023/09/04.
//

import Foundation

enum BoardTypes {
    case basic, premium
}

struct BoardInfo {
    init(address: String, boardType: BoardTypes, boardID: Int, registerTime: String, lat : Double, lng : Double) {
    self.address = address
    self.boardType = boardType
    self.boardID = boardID
    self.registerTime = registerTime
    self.lat = lat
    self.lng = lng
    }
    var address: String
    var boardType: BoardTypes
    var boardID: Int
    var registerTime: String
    var lat : Double
    var lng : Double
}
