//
//  MapPageViewController.swift
//  bilboard
//
//  Created by 박유경 on 2023/09/04.
//

import UIKit
import NMapsMap
import SnapKit
extension MapPageViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let address = textField.text, !address.isEmpty {
            AddressDecoder.getGeocodeAddress(query: address) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let geocode):
                    if let firstAddress = geocode.addresses.first {
                        let latitude = firstAddress.latitude
                        let longitude = firstAddress.longitude
                        print(latitude)
                        print(longitude)
                        DispatchQueue.main.async{ [weak self] in
                            guard let self = self else {return }
                            mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat:Double(latitude)!, lng:Double(longitude)!)))
                        }
                    } else {
                        
                        DispatchQueue.main.async{ [weak self] in
                            guard let self = self else {return }
                            showAlert(title: "에러", message: "주소를 찾을 수 없습니다")
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async{ [weak self] in
                        guard let self = self else {return }
                        showAlert(title: "에러", message: "주소 디코딩 오류: \(error.localizedDescription)")
                    }
                }
            }
            textField.resignFirstResponder()
        }
        return true
    }
}


class MapPageViewController: UIViewController, NMFMapViewTouchDelegate {
    //주소 텍스트 필드
    lazy var addressTextField: UITextField = {
        let textField = UITextField()
        let searchIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        searchIconView.image = UIImage(systemName: "magnifyingglass")
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.borderStyle = .none
        textField.leftView = searchIconView
        textField.leftViewMode = .always
        textField.placeholder = "검색하고자 하는 지역명을 입력해주세요"
        textField.autocorrectionType = .no
        textField.keyboardType = .default // 여기를 .default로 변경
        textField.delegate = self
        return textField
    }()
    //주소 입력
    lazy var addressTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "지도에서 위치 확인"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return titleLabel
    }()
    
    //목표 KM, 경로 탐색 및 취소 버튼
    lazy var goalView: UIView = {
        let view = UIView()
        if let customColor = UIColor(named: "MainColor") {
            view.backgroundColor = customColor
        } else {
            let backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
            view.backgroundColor = backgroundColor
        }
        view.layer.cornerRadius = 20.0
        
        let goalLabel = UILabel()
        goalLabel.text = "목적지 : 팀스파르타"
        goalLabel.textColor = .white
        goalLabel.font = UIFont.systemFont(ofSize: 20)
        goalLabel.numberOfLines = 2
        
        view.addSubview(goalLabel)
        
        goalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        let kmLabel = UILabel()
        kmLabel.text = "달려가는 중..0%"
        kmLabel.textColor = .white
        kmLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        view.addSubview(kmLabel)
        kmLabel.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 60
        
        let searchPathButton = UIButton()
        if let customColor = UIColor(named: "MainColor") {
            searchPathButton.backgroundColor = customColor
        } else {
            searchPathButton.backgroundColor = .gray
        }
        searchPathButton.layer.borderWidth = 2
        searchPathButton.layer.borderColor = UIColor.white.cgColor
        searchPathButton.layer.cornerRadius = 10
        searchPathButton.addTarget(self, action: #selector(onSearchPathButtonTapped), for: .touchUpInside)
        searchPathButton.setTitle("탐색", for: .normal)
        searchPathButton.snp.makeConstraints {
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
        }
        
        stackView.addArrangedSubview(searchPathButton)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.top)
            $0.leading.equalTo(goalLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(buttonHeight)
            $0.width.equalTo(buttonWidth)
        }
        return view
        
    }()
    //원래위치로 버튼
    lazy var backToOriginButton : UIButton = {
        let backToOriginButton = UIButton()
        backToOriginButton.setImage(UIImage(named: "backtoorigin"), for: .normal)
        backToOriginButton.backgroundColor = .clear
        backToOriginButton.layer.cornerRadius = 10
        backToOriginButton.addTarget(self, action: #selector(onBackToOriginButtonTapped), for: .touchUpInside)
        return backToOriginButton
    }()
    //줌인 버튼
    lazy var zoomInButton : UIButton = {
        let zoomInButton = UIButton()
        zoomInButton.setImage(UIImage(named: "zoomin"), for: .normal)
        zoomInButton.backgroundColor = .clear
        zoomInButton.layer.cornerRadius = 10
        zoomInButton.addTarget(self, action: #selector(onZoomInButtonTapped), for: .touchUpInside)
        return zoomInButton
    }()
    //줌아웃 버튼
    lazy var zoomOutButton : UIButton = {
        let zoomOutButton = UIButton()
        zoomOutButton.setImage(UIImage(named: "zoomout"), for: .normal)
        zoomOutButton.backgroundColor = .clear
        zoomOutButton.layer.cornerRadius = 10
        zoomOutButton.addTarget(self, action: #selector(onZoomOutButtonTapped), for: .touchUpInside)
        return zoomOutButton
    }()
    //맵뷰
    lazy var mapView : NMFMapView = {
        let mapView = NMFMapView(frame: view.frame)
        return mapView
    }()
    
    //하단 뷰
    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 위쪽 모서리만 라운드 처리
        
        let circleView = UIView()
        circleView.backgroundColor =  .red
        circleView.layer.cornerRadius = 10
        view.addSubview(circleView)
        
        circleView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
            $0.width.equalTo(20)
            $0.height.equalTo(20)
        }
        
        let statusLabel = UILabel()
        
        statusLabel.text = "탑승중 아님"
        statusLabel.textColor = .black
        statusLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(circleView.snp.top)
            $0.leading.equalTo(circleView.snp.trailing).offset(5)
        }
        
        let usingTimeLabel = UILabel()
        usingTimeLabel.text = ""
        usingTimeLabel.textColor = .black
        usingTimeLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(usingTimeLabel)
        
        usingTimeLabel.snp.makeConstraints {
            $0.trailing.equalTo(view.snp.trailing).offset(10)
            $0.top.equalToSuperview().offset(20)
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalTo(20)
        }
        
        let rideOrReturnButton = UIButton()
        rideOrReturnButton.backgroundColor = .red
        rideOrReturnButton.layer.cornerRadius = 10
        rideOrReturnButton.addTarget(self, action: #selector(onRideOrReturnButtonTapped), for: .touchUpInside)
        
        if let customColor = UIColor(named: "MainColor") {
            rideOrReturnButton.backgroundColor = customColor
        } else {
            rideOrReturnButton.backgroundColor = .gray
        }
        rideOrReturnButton.setTitle("탑승하기", for: .normal)
        rideOrReturnButton.isEnabled = false
        
        let disabledColor = UIColor(named: "MildPurple")

        
        rideOrReturnButton.setTitleColor(.gray, for: .disabled)
        rideOrReturnButton.backgroundColor = disabledColor
        view.addSubview(rideOrReturnButton)
        rideOrReturnButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom).offset(-22)
            $0.height.equalToSuperview().multipliedBy(0.4)
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        return view
    }()
    
    lazy var locationManager : CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    var isMarkerTouched = false
    var timerSeconds = 0
    var usingTimer : Timer?
    var pathMoveTimer : Timer?
    var returnLocationCoordinate : NMGLatLng?
    var markerList : [NMFMarker] = []
    var currentMarker : NMFMarker?
    var touchedMarker : NMFMarker?
    var goal = NMGLatLng(lat: 37.5023270, lng: 127.0444447) //경로 추적시 팀 스파르타 위도 경도 하드코딩
    var pathLatLng: [NMGLatLng] = []
    var additionalMarker : [NMFMarker] = []
    var pathOverlay = NMFPath()
    var bMovePathSimulationStart = false
    var currentIndex = 1
    var userHistory : History?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUserInfo(isUsing : profile.isUsing)
        setupLocationManagerConfig()
        setupCurrentUserLocationInfo(UserCurrentlat: profile.currentLat, userCurrentlng: profile.currentLng)
        setupDummyNullModel()
        setupDummyMarkers(UserCurrentlat: profile.currentLat, userCurrentlng: profile.currentLng)


    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //setupDummyMarkers(UserCurrentlat: profile.currentLat, userCurrentlng: profile.currentLng)
        }
    
    func setupDummyNullModel()
    {
        if profile.usageHistory == nil{
            userHistory = History(historyID: 1, startTime: Date().GetCurrentTime(), endTime: Date().GetCurrentTime(), startLat: 0, startLong: 0, endLat: 0, endLong: 0, useDate: Date().GetCurrentTime(), bilBoardID: 100)
        }
        
        else{
            let historyLength = profile.usageHistory!.count
            let history = profile.usageHistory![historyLength - 1]
            userHistory = History(historyID: history.historyID + 1, startTime: Date().GetCurrentTime(), endTime: Date().GetCurrentTime(), startLat: 0, startLong: 0, endLat: 0, endLong : 0, useDate: Date().GetCurrentTime(), bilBoardID: history.bilBoardID + 1)
            userHistory?.historyID = history.historyID + 1
            userHistory?.bilBoardID = history.bilBoardID + 1
        }
    }
    
    func updateMiddelUI(){
        let goalLabel = goalView.subviews[1] as? UILabel
        let stackView = goalView.subviews[2] as? UIStackView
        let searchPathButton = stackView?.subviews[0] as? UIButton
        if currentIndex > 1
        {
            if bMovePathSimulationStart == true{
                let percent: String
                if currentIndex >= pathLatLng.count - 1{
                    percent = "100"
                } else {
                    percent = "\(Int((Double(currentIndex) / Double(pathLatLng.count)) * 100))"
                }
                if Int(percent)! == 100{
                    goalLabel!.text = "목적지에 도착!"
                    pathMoveTimer?.invalidate()
                    pathMoveTimer = nil
                    pathOverlay.mapView = nil
                    searchPathButton?.isHidden = true
                }
                else{
                    goalLabel!.text = "달려가는 중.." + percent + "%"
                }
            }else{
              
            }
        }
        if currentIndex >= 0 && currentIndex <= pathLatLng.count {
            mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: pathLatLng[currentIndex].lat, lng: pathLatLng[currentIndex].lng)))
            currentMarker?.position = NMGLatLng(lat: pathLatLng[currentIndex].lat, lng: pathLatLng[currentIndex].lng)
        }else{
            pathLatLng = []
        }
    }
    
    func updateBomttomUI(){
        let circleView = bottomView.subviews[0] as UIView
        let statusLabel = bottomView.subviews[1] as? UILabel
        let rideOrReturnButton = bottomView.subviews[3] as? UIButton

        if profile.isUsing == false{
            circleView.backgroundColor = .red
            statusLabel?.text = "탑승중 아님"
            let customColor = UIColor(named: "MildPurple")
            rideOrReturnButton?.backgroundColor = customColor
            rideOrReturnButton?.setTitleColor(.white, for: .normal)
            rideOrReturnButton?.setTitle("탑승하기", for: .normal)
        }
        else{
            circleView.backgroundColor = .green
            let customColor = UIColor(named: "MildPurple")
            statusLabel?.text = "탑승중"
            rideOrReturnButton?.backgroundColor = customColor
            rideOrReturnButton?.setTitleColor(.white, for: .normal)
            rideOrReturnButton?.setTitle("반납하기", for: .normal)
        }
    }
    func setupUserInfo(isUsing : Bool){
        profile.isLogin = true
        profile.isUsing = isUsing
    }
    func setupDummyMarkers(UserCurrentlat: Double, userCurrentlng: Double) {
        if let bilBoardInfos = profile.bilBoardInfos {
            for i in 0..<bilBoardInfos.count {
                let lat = bilBoardInfos[i].lat
                let lng = bilBoardInfos[i].lng
                let marker = NMFMarker()
                marker.iconTintColor = UIColor.blue
                marker.position = NMGLatLng(lat: lat, lng: lng)
                marker.captionColor = UIColor.blue
                marker.captionHaloColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                marker.captionText = "퀵보드 대여 가능"
                marker.captionTextSize = 20
                markerList.append(marker)
                marker.mapView = mapView
            }
        }
    }
    
    func setupLocationManagerConfig(){
        mapView.touchDelegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        if profile.isUsing {
            rideOrReturnEnabled(enabled: true)
            returnLocationCoordinate = NMGLatLng(lat: latlng.lat, lng: latlng.lng)
            updateBomttomUI()
            let rideOrReturnButton = bottomView.subviews[3] as? UIButton
            let customColor = UIColor(named: "MainColor")
            rideOrReturnButton?.backgroundColor = customColor
            rideOrReturnButton?.setTitleColor(.white, for: .normal)
        } else {
            let closestMarker = findClosestMarker(to: latlng)
            if let marker = closestMarker {
                isMarkerTouched = true
                rideOrReturnEnabled(enabled: true)
                touchedMarker = marker
                let rideOrReturnButton = bottomView.subviews[3] as? UIButton
                let customColor = UIColor(named: "MainColor")
                rideOrReturnButton?.backgroundColor = customColor
                rideOrReturnButton?.setTitleColor(.white, for: .normal)
            } else {
                print("인접한 마커가 없습니다.")
            }
            //updateBomttomUI()
        }
    }
    @objc func onRideOrReturnButtonTapped(){
        let goalLabel = goalView.subviews[1] as? UILabel
        let stackView = goalView.subviews[2] as? UIStackView
        let searchPathButton = stackView?.subviews[0] as? UIButton
        pathMoveTimer?.invalidate()
        pathMoveTimer = nil
        if isMarkerTouched {
            
            for additionalmarker in additionalMarker{
                let findMarker = findClosestAdditionalMarker(to: NMGLatLng(lat: touchedMarker!.position.lat, lng: touchedMarker!.position.lng))
                if findMarker != nil{
                    findMarker!.mapView = nil
                }
            }
            
            handleMarkerTouched()
            startTimer()
            goalView.isHidden = false//추가
            searchPathButton?.isHidden = false
            searchPathButton?.setTitle("탐색", for: .normal)
            profile.isUsing = true
            userHistory?.startTime = Date().GetCurrentTime()
            userHistory?.startLat = currentMarker!.position.lat
            userHistory?.startLong = currentMarker!.position.lng
        
        } else {
            profile.isUsing = false
            handleNoMarkerTouched()
            endTimer()
            goalView.isHidden = true
            pathLatLng = []
            pathOverlay.mapView = nil
            currentIndex = 0
            goalLabel!.text = "달려가기(0%)"
            userHistory?.endTime = Date().GetCurrentTime()
            userHistory?.endLat = currentMarker!.position.lat
            userHistory?.endLong = currentMarker!.position.lng
            if profile.usageHistory == nil{
                profile.usageHistory = []
            }
            profile.usageHistory?.append(userHistory!)
            print("count -> \(profile.usageHistory?.count)")
            
            
            let marker = NMFMarker()
            marker.iconTintColor = UIColor.blue
            marker.position = NMGLatLng(lat: currentMarker!.position.lat + 0.000000002, lng: currentMarker!.position.lng + 0.000000002)
            marker.captionColor = UIColor.blue
            marker.captionHaloColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            marker.captionText = "퀵보드 대여 가능"
            marker.captionTextSize = 20
            marker.mapView = mapView
            additionalMarker.append(marker)
        }
    }
    func startTimer(){
        usingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkTimer), userInfo: nil, repeats: true)
    }
    func endTimer(){
        let timerLabel = bottomView.subviews[2] as? UILabel
        if let timerLabel = timerLabel{
            timerLabel.text = ""
        }
        timerSeconds = 0
        usingTimer?.invalidate()
    }
    
    @objc func checkTimer(){
        timerSeconds = timerSeconds + 1
        let timerLabel = bottomView.subviews[2] as? UILabel
        if let timerLabel = timerLabel{
            if timerSeconds < 60{
                timerLabel.text = "이용시간 : \(timerSeconds)초"
            }else{
                timerLabel.text = "이용시간 : \(timerSeconds / 60)분 \(timerSeconds % 60)초"
            }
        }
    }
    func convertPathTolatLatLng(pathDetail : [RouteDetail]){
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            for i in 0..<pathDetail.count {
                let pathDetail = pathDetail[i]
                for j in 0..<pathDetail.path.count {
                    let pathXY = pathDetail.path[j]
                    pathLatLng.append(NMGLatLng(lat: pathXY[1], lng: pathXY[0]))
                }
            }
            drawRoutePath()
        }
    }
    func drawRoutePath(){
        if pathLatLng.count != 0 {
            pathOverlay = NMFPath()
            pathOverlay.path = NMGLineString(points: pathLatLng)
            pathOverlay.color = .red
            pathOverlay.width = 3
            DispatchQueue.main.async{ [weak self] in
                guard let self = self else {return}
                pathOverlay.mapView = mapView
            }
        }
    }
    
    func findRouteAndDraw() {
        let start = "\(currentMarker!.position.lng),\(currentMarker!.position.lat)"
        let goal = "\(goal.lng),\(goal.lat)"
        
        AddressDecoder.getDirectionRouteData(startCoordinate: start, goalCoordinate: goal) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let routeData):
                convertPathTolatLatLng(pathDetail: routeData.route.traoptimal)
            case .failure(let error):
                DispatchQueue.main.async{ [weak self] in
                    guard let self = self else {return }
                    showAlert(title: "에러", message: "경로 추적 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func handleMarkerTouched() {

        guard let touchedMarker = touchedMarker else {
            return
        }
        removeMarkerAndMoveCamera(to: NMGLatLng(lat: touchedMarker.position.lat, lng: touchedMarker.position.lng))
        
        profile.isUsing = true
        isMarkerTouched = false

        if let index = markerList.firstIndex(of: touchedMarker) {
            
            markerList.remove(at: index)
            print(markerList.count)
            print("마커 삭제 완료")
        }
        
        currentMarker?.mapView = nil
        currentMarker = touchedMarker
        setupCurrentUserLocationInfo(UserCurrentlat: touchedMarker.position.lat, userCurrentlng: touchedMarker.position.lng)
        
        updateBomttomUI()
        rideOrReturnEnabled(enabled: true)
        findRouteAndDraw()
    }
    
    func handleNoMarkerTouched() {
        guard let coordinate = returnLocationCoordinate else {
            return
        }
        createMarker(at: coordinate)
        mapView.setNeedsDisplay()
        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)))
        
        profile.isUsing = false
        isMarkerTouched = true
        
        currentMarker?.mapView = nil
        currentMarker?.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lng)
        
        updateBomttomUI()
        rideOrReturnEnabled(enabled: false)
    }
    
    func rideOrReturnEnabled(enabled : Bool)
    {

        
        let rideOrReturnButton = bottomView.subviews[3] as? UIButton
        if enabled{
            let customColor = UIColor(named: "MainColor")
            rideOrReturnButton?.backgroundColor = customColor
            rideOrReturnButton?.setTitleColor(.white, for: .normal)
            rideOrReturnButton?.isEnabled = enabled
        }else{
            let customColor = UIColor(named: "MildPurple")
            rideOrReturnButton?.backgroundColor = customColor
            rideOrReturnButton?.setTitleColor(.gray, for: .disabled)
            rideOrReturnButton?.isEnabled = enabled
        }
    }
    
    func findClosestMarker(to targetLatLng: NMGLatLng) -> NMFMarker? {
        var closerMarker: NMFMarker? = nil
        let maxDistance: CLLocationDistance = 150.0
        for marker in markerList {
            let markerLocation = CLLocation(latitude: marker.position.lat, longitude: marker.position.lng)
            let targetLocation = CLLocation(latitude: targetLatLng.lat, longitude: targetLatLng.lng)
            let distance = markerLocation.distance(from: targetLocation)
            if distance < maxDistance {
                closerMarker = marker
                break
            }
        }
        return closerMarker
    }
    func findClosestAdditionalMarker(to targetLatLng: NMGLatLng) -> NMFMarker? {
        var closerMarker: NMFMarker? = nil
        let maxDistance: CLLocationDistance = 150.0
        for marker in additionalMarker {
            let markerLocation = CLLocation(latitude: marker.position.lat, longitude: marker.position.lng)
            let targetLocation = CLLocation(latitude: targetLatLng.lat, longitude: targetLatLng.lng)
            let distance = markerLocation.distance(from: targetLocation)
            if distance < maxDistance {
                closerMarker = marker
                break
            }
        }
        return closerMarker
    }
    
    func setupCurrentUserLocationInfo(UserCurrentlat : Double, userCurrentlng : Double){
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: UserCurrentlat, lng: userCurrentlng)
        marker.captionColor = UIColor.blue
        marker.captionHaloColor = UIColor(red: 200.0/255.0, green: 1, blue: 1, alpha: 1)
        marker.captionText = "현위치"
        marker.captionTextSize = 20
        marker.width = 30
        marker.height = 30
        marker.mapView = mapView
        currentMarker = marker
        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat:UserCurrentlat, lng:userCurrentlng)))
    }
    @objc func onSearchPathButtonTapped(){
        let stackView = goalView.subviews[2] as? UIStackView
        let searchPathButton = stackView?.subviews[0] as? UIButton
        if bMovePathSimulationStart == false{
            pathMoveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(simulationTimer), userInfo: nil, repeats: true)
            bMovePathSimulationStart = true
            searchPathButton!.setTitle("취소", for: .normal)
        }else{
            pathMoveTimer?.invalidate()
            bMovePathSimulationStart = false
            searchPathButton!.setTitle("탐색", for: .normal)
        }
    }
    @objc func simulationTimer(){
        currentIndex += 20
        if currentIndex >= pathLatLng.count - 1 {
            currentIndex = pathLatLng.count - 1
        }
        updateMiddelUI()
    }
    
    @objc func onBackToOriginButtonTapped(){
        if let latitude = currentMarker?.position.lat, let longitude = currentMarker?.position.lng{
            mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat : latitude, lng :longitude))
            )}else{ return}
    }
    @objc func onZoomInButtonTapped(){
        mapView.moveCamera(NMFCameraUpdate.withZoomIn())
    }
    @objc func onZoomOutButtonTapped(){
        mapView.moveCamera(NMFCameraUpdate.withZoomOut())
    }
    
    func createMarker(at coordinate: NMGLatLng) {
        let marker = NMFMarker()
        marker.position = coordinate
        marker.captionColor = UIColor.blue
        marker.captionHaloColor = UIColor(red: 200.0/255.0, green: 1, blue: 1, alpha: 1)
        marker.captionText = "현위치"
        marker.captionTextSize = 20
        marker.width = 30
        marker.height = 30
        marker.mapView = mapView
        markerList.append(marker)
    }

    func removeMarkerAndMoveCamera(to position: NMGLatLng) {
        for marker in markerList {
            if (marker.position.lat == position.lat) && (marker.position.lng == position.lng)
            {
                marker.mapView = nil
                if let touchedMarker = touchedMarker {
                    touchedMarker.mapView = nil
                    mapView.moveCamera(NMFCameraUpdate(scrollTo: position))
                }
            }
            if (currentMarker?.position.lat == marker.position.lat) && (currentMarker?.position.lng == marker.position.lng )
            {
                marker.mapView = nil
                if let touchedMarker = touchedMarker {
                    touchedMarker.mapView = nil
                    mapView.moveCamera(NMFCameraUpdate(scrollTo: position))
                }
            }
        }
    }
    
    func setupLayout() {
        [mapView,addressTitleLabel, addressTextField, goalView,backToOriginButton,zoomInButton,zoomOutButton,bottomView].forEach(view.addSubview)
        mapView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        addressTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.width.equalToSuperview().multipliedBy(0.6)
        }
        addressTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(addressTitleLabel.snp.bottom).offset(20)
            $0.height.equalToSuperview().multipliedBy(0.05)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
        }
        goalView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(addressTextField.snp.bottom).offset(20)
            $0.leading.equalTo(addressTextField.snp.leading)
            $0.trailing.equalTo(addressTextField.snp.trailing)
            $0.height.equalToSuperview().multipliedBy(0.14)
        }
        backToOriginButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(goalView.snp.trailing)
            $0.width.equalToSuperview().multipliedBy(0.05)
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
        zoomInButton.snp.makeConstraints {
            $0.top.equalTo(backToOriginButton.snp.bottom).offset(10)
            $0.trailing.equalTo(backToOriginButton.snp.trailing)
            $0.width.equalToSuperview().multipliedBy(0.05)
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
        zoomOutButton.snp.makeConstraints {
            $0.top.equalTo(zoomInButton.snp.bottom).offset(10)
            $0.trailing.equalTo(zoomInButton.snp.trailing)
            $0.width.equalToSuperview().multipliedBy(0.05)
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
        bottomView.snp.makeConstraints{
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalToSuperview().multipliedBy(0.15)
        }
        goalView.isHidden = true
    }
}

extension MapPageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentMarker = NMFMarker(position: NMGLatLng(lat: profile.currentLat, lng: profile.currentLng))
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



