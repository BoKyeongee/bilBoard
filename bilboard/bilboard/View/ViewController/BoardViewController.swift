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
    @IBOutlet weak var registerDate: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeBox: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var topbar: UIView!
    
    var projectionList : [NMFProjection] = []
    
    func loadMap(_ boardInfo: BoardInfo) {
        let lat = boardInfo.lat
        let lng = boardInfo.lng
        view.addSubview(mapbox)
        let marker = NMFMarker()
        marker.iconImage = NMFOverlayImage(name: "pin")
        marker.width = CGFloat(50)
        marker.height = CGFloat(75)
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.captionColor = UIColor(named: "MainColor")!
        marker.captionText = "🛴 " + String(boardInfo.boardID)
        marker.captionTextSize = 20
        marker.mapView = mapbox
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .easeIn
        mapbox.moveCamera(cameraUpdate)
    }
    
    func showMenu() {
        let edit = UIAction(title: "편집", image: UIImage(systemName: "pencil.line"),handler: { _ in
            let editViewControllerID = UIStoryboard(name: "Profile", bundle: .none).instantiateViewController(identifier: "editViewControllerID") as! EditViewController
            self.navigationController?.pushViewController(editViewControllerID, animated: true)
        })
        let delete = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in
            let popup = UIAlertController(title: "삭제 확인", message: "정말로 정보를 삭제하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let confirmDelete = UIAlertAction(title: "확인", style: .default) { _ in
                // 클릭 시 처리할 내용 (boardInfo 삭제)
                print("click trash")
                let index = UserDefaults.standard.integer(forKey: "current")
                profile.bilBoardInfos!.remove(at: index)
                self.navigationController?.popViewController(animated: true)
            }
            popup.addAction(cancel)
            popup.addAction(confirmDelete)
            self.present(popup, animated: true)
        })
        
        let menu = UIMenu(title: "", options: .singleSelection, children: [edit, delete])
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
        
    }
    
    func loadData(_ boardInfo: BoardInfo) {
        idLabel.text = "🔎 ID #" + String(boardInfo.boardID)
        
        switch boardInfo.boardType {
        case BoardTypes.basic:
            typeLabel.text = "⭐️ basic ⭐️"
        case BoardTypes.premium:
            typeLabel.text = "👑 premium 👑"
        }
        address.text = boardInfo.address
        registerDate.text = boardInfo.registerTime
        typeBox.backgroundColor = UIColor(named: "MildPurple")
        typeBox.layer.cornerRadius = 14
        mapbox.layer.cornerRadius = 20
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let index = UserDefaults.standard.integer(forKey: "current")

        loadData(profile.bilBoardInfos![index])
        loadMap(profile.bilBoardInfos![index])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = UserDefaults.standard.integer(forKey: "current")

        loadData(profile.bilBoardInfos![index])
        loadMap(profile.bilBoardInfos![index])
        showMenu()
    }
}
