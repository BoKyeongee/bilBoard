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

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var mapbox: NMFMapView!
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var registerDate: UILabel!
    @IBOutlet weak var address1: UILabel!
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
                marker.iconImage = NMFOverlayImage(name: "pin")
                marker.width = CGFloat(50)
                marker.height = CGFloat(75)
                marker.position = NMGLatLng(lat: lat, lng: lng)
                marker.captionColor = UIColor(named: "MainColor")!
                marker.captionText = "🛴 " + String(bilBoardInfos[i].boardID)
                marker.captionTextSize = 20
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
    
    func showMenu() {
        let edit = UIAction(title: "편집", image: UIImage(systemName: "pencil.line"),handler: { _ in self
            let editViewControllerID = UIStoryboard(name: "Profile", bundle: .none).instantiateViewController(identifier: "editViewControllerID") as! EditViewController
            self.navigationController?.pushViewController(editViewControllerID, animated: true)
        })
        let delete = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in self
            let popup = UIAlertController(title: "삭제 확인", message: "정말로 정보를 삭제하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let confirmDelete = UIAlertAction(title: "확인", style: .default) { [self] (_) in
                
                // 클릭 시 처리할 내용 (boardInfo 삭제)
                print("click trash")
            }
            popup.addAction(cancel)
            popup.addAction(confirmDelete)
            self.present(popup, animated: true)
        })
        
        let menu = UIMenu(title: "", options: .singleSelection, children: [edit, delete])
        
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
        
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
        showMenu()
    }

}
