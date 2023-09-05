//
//  MapPageViewController.swift
//  bilboard
//
//  Created by 박유경 on 2023/09/04.
//

import UIKit
import NMapsMap
import SnapKit
import CoreLocation
class MapPageViewController: UIViewController {
    
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
    
    //지도에서 위치 확인 라벨
    lazy var mapTitleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "가운데 정렬할 텍스트"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        return titleLabel
    }()
    //목표 KM, 경로 탐색 및 취소 버튼
    lazy var goalView: UIView = {
        let view = UIView()
        let backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 20.0
        
        let goalLabel = UILabel()
        goalLabel.text = "목적지까지"
        goalLabel.textColor = .gray
        goalLabel.font = UIFont.systemFont(ofSize: 20)
        goalLabel.numberOfLines = 2
        
        view.addSubview(goalLabel)
        
        goalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        let kmLabel = UILabel()
        kmLabel.text = "10 km 남음"
        kmLabel.textColor = .gray
        kmLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        view.addSubview(kmLabel)
        kmLabel.snp.makeConstraints {
            $0.top.equalTo(goalLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(20)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        let buttonWidth: CGFloat = 60
        let buttonHeight: CGFloat = 40
        
        let searchPathButton = UIButton()
        searchPathButton.backgroundColor = .gray
        searchPathButton.layer.cornerRadius = 10
        searchPathButton.addTarget(self, action: #selector(onSearchPathButtonTapped), for: .touchUpInside)
        searchPathButton.setTitle("탐색", for: .normal)
        searchPathButton.snp.makeConstraints {
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
        }
        
        let cancelButton = UIButton()
        cancelButton.backgroundColor = .gray
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(onCancelButtonTapped), for: .touchUpInside)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
        }
        
        stackView.addArrangedSubview(searchPathButton)
        stackView.addArrangedSubview(cancelButton)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(kmLabel.snp.top)
            $0.leading.equalTo(kmLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-5)
            $0.height.equalTo(buttonHeight)
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
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 위쪽 모서리만 라운드 처리
        
        let IsUsed = false // 하드코딩
        
         let circleView = UIView()
         circleView.backgroundColor = IsUsed ? .red : .green //하드코딩
         circleView.layer.cornerRadius = 10
         view.addSubview(circleView)
         
         circleView.snp.makeConstraints {
             $0.leading.equalToSuperview().offset(20)
             $0.top.equalToSuperview().offset(20)
             $0.width.equalTo(20)
             $0.height.equalTo(20)
         }
        
         let statusLabel = UILabel()
         statusLabel.text = IsUsed ? "탑승 중" : "탑승 중 아님" //하드코딩
         statusLabel.textColor = .black
         statusLabel.font = UIFont.systemFont(ofSize: 20)
         view.addSubview(statusLabel)
         
         statusLabel.snp.makeConstraints {
             $0.top.equalTo(circleView.snp.top)
             $0.leading.equalTo(circleView.snp.trailing).offset(5)
         }
        
        let usingTimeLabel = UILabel()
        usingTimeLabel.text = "이용시간 :" + "10분"
        usingTimeLabel.textColor = .black
        usingTimeLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(usingTimeLabel)
        
        usingTimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(20)
            $0.width.equalToSuperview().multipliedBy(0.3)
            $0.height.equalTo(20)
        }
        
        let rideOrReturnButton = UIButton()
        rideOrReturnButton.backgroundColor = .gray
        rideOrReturnButton.layer.cornerRadius = 10
        rideOrReturnButton.addTarget(self, action: #selector(onRideOrReturnButtonTapped), for: .touchUpInside)
        rideOrReturnButton.setTitle("탑승하기", for: .normal)
        
        view.addSubview(rideOrReturnButton)
        rideOrReturnButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom).offset(-10)
            $0.height.equalToSuperview().multipliedBy(0.3)
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        return view
    }()
    
    lazy var locationManager : CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    var currentLocationCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DispatchQueue.main.async{ [weak self] in
//            guard let self = self else {return}
//            let memoWriteVC = MapPageInfoController()
//            memoWriteVC.modalPresentationStyle = .custom
//            memoWriteVC.transitioningDelegate = self
//
//            if let presentationController = memoWriteVC.presentationController as? UISheetPresentationController {
//                presentationController.detents = [.medium()]
//            }
//            present(memoWriteVC, animated: true, completion: nil)
//
//        }
        setupLayout()
        setupLocationManagerConfig()
        setupCurrentUserLocationInfo(UserCurrentlat: profile.currentLat, userCurrentlng: profile.currentLng)
    }
    func setupLocationManagerConfig(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func setupCurrentUserLocationInfo(UserCurrentlat : Double, userCurrentlng : Double){
        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat:UserCurrentlat, lng:userCurrentlng)))
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: UserCurrentlat, lng: userCurrentlng)
        marker.captionColor = UIColor.blue
        marker.captionHaloColor = UIColor(red: 200.0/255.0, green: 1, blue: 1, alpha: 1)
        marker.captionText = "현위치"
        marker.captionTextSize = 20
        marker.mapView = mapView
    }
    @objc func onSearchPathButtonTapped(){
        print("onSearchPathButtonTapped")
    }
    @objc func onCancelButtonTapped(){
        print("onCancelButtonTapped")
    }
    @objc func onBackToOriginButtonTapped(){
        if let latitude = currentLocationCoordinate?.latitude, let longitude = currentLocationCoordinate?.longitude {
            mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat:latitude, lng:longitude)))        } else {
        }
        
        //print("onBackToOriginButton")
    }
    @objc func onZoomInButtonTapped(){
        mapView.moveCamera(NMFCameraUpdate.withZoomIn())
    }
    @objc func onZoomOutButtonTapped(){
        mapView.moveCamera(NMFCameraUpdate.withZoomOut())
    }
    @objc func onRideOrReturnButtonTapped(){
        print("onRideOrReturnButtonTapped")
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
        //        if let goalLabel = goalView.subviews.first as? UILabel {
        //            goalLabel.text = "ZZ"
        //        }
    }
}


extension MapPageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationCoordinate = CLLocationCoordinate2D(latitude: profile.currentLat, longitude: profile.currentLng)
        print(locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

class MapPageInfoController : UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .gray
        
        modalPresentationStyle = .overCurrentContext
    }
}
class BottomSheetPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }

        let height: CGFloat = 200
        let yPosition = containerView.bounds.height - height
        return CGRect(x: 0, y: yPosition, width: containerView.bounds.width, height: height)
    }
}

extension MapPageViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}


