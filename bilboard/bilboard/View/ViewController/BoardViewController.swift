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

    @IBOutlet weak var mapbox: NMFMapView!
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var registerDate: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var infoBox: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeBox: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var topbar: UIView!
    var markerList : [NMFMarker] = []
    var projectionList : [NMFProjection] = []
    
    func setupMarkerList(_ profile: UserInfo) {
        if let bilBoardInfos = profile.bilBoardInfos {
            for i in 0..<bilBoardInfos.count {
                let lat = bilBoardInfos[i].lat
                let lng = bilBoardInfos[i].lng
                let marker = NMFMarker()
                marker.iconTintColor = UIColor.blue
                marker.position = NMGLatLng(lat: lat, lng: lng)
                marker.captionColor = UIColor.blue
                marker.captionHaloColor = .red
                marker.captionText = String(bilBoardInfos[i].boardID)
                marker.captionTextSize = 15
                markerList.append(marker)
            }
        }
    }
    
    func setupMarker(_ markerList: [NMFMarker]) {
        let index = UserDefaults.standard.integer(forKey: "current")
        let marker = markerList[index]
        
        return marker.mapView = mapbox
    }
    
    func loadMap(_ boardInfo: [BoardInfo]) {
        let index = UserDefaults.standard.integer(forKey: "current")
        
        let lat = profile.bilBoardInfos![index].lat
        let lng = profile.bilBoardInfos![index].lng
        view.addSubview(mapbox)
        setupMarkerList(profile)
        setupMarker(markerList)
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .easeIn
        mapbox.moveCamera(cameraUpdate)
    }
    
    func loadData() {
        let index = UserDefaults.standard.integer(forKey: "current")
        idLabel.text = "🔎 ID #" + String(profile.bilBoardInfos![index].boardID)
        
        switch profile.bilBoardInfos![index].boardType {
        case BoardTypes.basic:
            typeLabel.text = "⭐️ basic ⭐️"
        case BoardTypes.premium:
            typeLabel.text = "👑 premium 👑"
        }
        
        typeBox.backgroundColor = UIColor(named: "MildPurple")
        typeBox.layer.cornerRadius = 14
        
        mapbox.layer.cornerRadius = 20
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        loadMap(profile.bilBoardInfos!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        loadMap(profile.bilBoardInfos!)
        
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
