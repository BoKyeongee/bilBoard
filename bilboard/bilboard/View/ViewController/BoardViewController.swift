//
//  BoardViewController.swift
//  bilboard
//
//  Created by 보경 on 2023/09/06.
//

import UIKit
import NMapsMap
import NMapsGeometry

class BoardViewController: UIViewController {

    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var registerDate: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var infoBox: UIView!
    @IBOutlet var mapView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeBox: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var topbar: UIView!
    
    func drawMap() -> UIView {
        mapView = NMFMapView(frame: view.frame)
        return mapView
    }
    
    func loadData() {
        let boardInfo = [boardInfo1, boardInfo2, boardInfo3, boardInfo4]
        let index = UserDefaults.standard.integer(forKey: "current")
        let data = boardInfo[index]
        
        idLabel.text = "🔎 ID #" + String(data.boardID)
        
        switch data.boardType {
        case BoardTypes.basic:
            typeLabel.text = "⭐️ basic ⭐️"
        case BoardTypes.premium:
            typeLabel.text = "👑 premium 👑"
        }
        
        typeBox.backgroundColor = UIColor(named: "MildPurple")
        typeBox.layer.cornerRadius = 14
        
        mapView.layer.cornerRadius = 20
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        loadData()
        drawMap()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
