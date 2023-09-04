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
    
    init(address: String, boardType: BoardTypes, boardID: Int, registerTime: String) {
    self.address = address
    self.boardType = boardType
    self.boardID = boardID
    self.registerTime = registerTime
    }
    
    var address: String
    var boardType: BoardTypes
    var boardID: Int
    var registerTime: String
}
