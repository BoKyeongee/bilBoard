//
//  History.swift
//  bilboard
//
//  Created by 남보경 on 2023/09/04.
//

import Foundation


struct History {
    
    init(historyID: Int, startTime: String, endTime: String, startLat: Float, startLong: Float, endLat: Float, endLong: Float, useDate: String, bilBoardID: Int) {
    self.historyID = historyID
    self.startTime = startTime
    self.endTime = endTime
    self.startLat = startLat
    self.startLong = startLong
    self.endLat = endLat
    self.endLong = endLong
    self.useDate = useDate
    self.bilBoardID = bilBoardID
    }
    
    var historyID: Int
    var startTime: String
    var endTime: String
    var startLat: Float
    var startLong: Float
    var endLat: Float
    var endLong: Float
    var useDate: String
    var bilBoardID: Int
}
