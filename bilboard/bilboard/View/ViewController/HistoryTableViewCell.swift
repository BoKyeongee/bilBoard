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
        let startTime = historyData.startTime
        let endTime = historyData.endTime

        let index = startTime.index(startTime.startIndex, offsetBy: 10)
        let start = startTime[index..<startTime.endIndex]
        let end = endTime[index..<endTime.endIndex]
        
        let s = String(start)
        let e = String(end)
        
        return [s, e]
    }
    
    func trimUseDate(_ historyData: History) -> String {
        let data = historyData.useDate
        
        let index = data.index(data.startIndex, offsetBy: 10)
        let result = data[data.startIndex..<index]
        
        return String(result)
    }
  
    func setData(_ historyData: History) {
        let timeArray = trimTime(historyData)
        let startTime = timeArray[0]
        let endTime = timeArray[1]
        
        dateLabel.text = trimUseDate(historyData)
        startTimeLabel.text = "시작: " + startTime
        returnTimeLabel.text = "반납: " + endTime
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
