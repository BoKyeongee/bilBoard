//
//  ProfileViewController.swift
//  bilboard
//
//  Created by 박유경 on 2023/09/04.
//

import UIKit
import Foundation

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var historyData = profile.usageHistory
    var historyHardDummy = [history1, history2]
    var userInfo = profile
    
    // section 개수 반환
    func numberOfSections(in tableView: UITableView) -> Int {3}
    
    // section header 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {50}

    // section title 반환
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sections = ["프로필 정보", "나의 킥보드", "이용내역"]
            return sections[section]
        }
    
    // 각 section 당 cell 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2: return historyData?.count ?? 0
            default: return 1
        }
    }
    
    // cell 높이 반환
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 120
        case 1: return 100
            case 2: return 120
            default:return 100
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as? ProfileTableViewCell else {return UITableViewCell()}
                profileCell.setData(userInfo)
            switch userInfo.isUsing {
            case true:
                profileCell.statusLabel.text = "🛴 사용중"
                profileCell.statusWrap.backgroundColor = UIColor(named: "UsingColor")
                profileCell.statusWrap.layer.cornerRadius = 12
                
            case false:
                
                profileCell.statusLabel.text = "🫥 미사용중"
                profileCell.statusWrap.backgroundColor = .secondarySystemBackground
                profileCell.statusWrap.layer.cornerRadius = 12
            }
            profileCell.selectionStyle = .none
            profileCell.profileBox.backgroundColor = UIColor(named: "MainColor")
            profileCell.profileBox.layer.cornerRadius = 20
            profileCell.emailLabel.textColor = .white
            profileCell.nicknameLabel.textColor = .white
            
            return profileCell
        case 1:
            guard let collectionCell = tableView.dequeueReusableCell(withIdentifier: "collectionCell") as? CollectionTableViewCell else {return UITableViewCell()}
            
            collectionCell.selectionStyle = .none
            
            return collectionCell
        case 2:
            guard let historyCell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? HistoryTableViewCell else {return UITableViewCell()}
            historyCell.setData(historyData?[indexPath.row] ?? historyHardDummy[indexPath.row])
            
            historyCell.selectionStyle = .none
            historyCell.historyCellBox.backgroundColor = UIColor(named: "MainColor")
            historyCell.historyCellBox.layer.cornerRadius = 20
            historyCell.dateLabel.textColor = .white
            historyCell.locateSummaryLabel.textColor = .white
            
            historyCell.historyContentBox.backgroundColor = UIColor(named: "MildPurple")
            historyCell.historyContentBox.layer.cornerRadius = 15
            
            
            return historyCell
        default:
            return UITableViewCell()
        }
    }


    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // tableView 줄 없앰
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
}


}
