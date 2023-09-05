//
//  History.swift
//  bilboard
//
//  Created by 남보경 on 2023/09/04.
//

import Foundation


struct History {
    
    init(historyID: Int, startTime: String, endTime: String, startLat: Double, startLong: Double, endLat: Double, endLong: Double, useDate: String, bilBoardID: Int) {
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
    var startLat: Double
    var startLong: Double
    var endLat: Double
    var endLong: Double
    var useDate: String
    var bilBoardID: Int
}
