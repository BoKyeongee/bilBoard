//
//  HistoryTableViewCell.swift
//  bilboard
//
//  Created by 보경 on 2023/09/06.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {


    @IBOutlet weak var historyContentBox: UIView!
    @IBOutlet weak var historyCellBox: UIView!
    @IBOutlet weak var returnTimeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func trimTime(_ historyData: History) -> [String] {
        var startTime = historyData.startTime
        var endTime = historyData.endTime

        let index = startTime.index(startTime.startIndex, offsetBy: 11)
        let start = startTime[index..<startTime.endIndex]
        let end = endTime[index..<endTime.endIndex]

        let s = String(start)
        let e = String(end)

        return [s, e]
    }
    
//    func getUserTime(_ historyData: History) -> String {
//        let timeArray = trimTime(historyData)
//
//        let startTime = timeArray[0]
//        let endTime = timeArray[1]
//
//        // 시간 빼기
//
//        return "총 00분 소요"
//    }
    
    func setData(_ historyData: History) {
        // let historyID = historyData.historyID
        let timeArray = trimTime(historyData)
        let startTime = timeArray[0]
        let endTime = timeArray[1]
        
        dateLabel.text = historyData.useDate
        startTimeLabel.text = "시작: " + startTime
        returnTimeLabel.text = "반납: " + endTime
//        usedTimeLabel.text = getUserTime(historyData)
//        locateSummaryLabel.text =
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
