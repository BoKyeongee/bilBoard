//
//  EditViewController.swift
//  bilboard
//
//  Created by 보경 on 2023/09/09.
//

import UIKit
import WebKit
import NMapsMap
import NMapsGeometry

class EditViewController: UIViewController, UpdateAddress {
    var tempData: [String:Any] = [:]
    
    func updateAddress(_ newAddress: String) {
        addressLabel.text = newAddress
        tempData.updateValue(newAddress, forKey: "roadAddress")
    }
    

    @IBOutlet weak var detailAddressField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapbox: NMFMapView!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var addressBtn: UIButton!
    
    var markerList : [NMFMarker] = []
    var projectionList : [NMFProjection] = []
    
    func showMenu() {
        let basic = UIAction(title: "⭐️ basic", image: UIImage(systemName: "checkmark.circle"),handler: { _ in self
            self.tempData.updateValue(BoardTypes.basic, forKey: "type")
            self.typeBtn.setTitle("⭐️ basic", for: .normal)
        })
        let premium = UIAction(title: "👑 premium", image: UIImage(systemName: "star.circle"),handler: { _ in self
            self.tempData.updateValue(BoardTypes.premium, forKey: "type")
            self.typeBtn.setTitle("👑 premium", for: .normal)
        })
        
        let menu = UIMenu(title: "BilBoard의 타입 선택", options: .displayInline, children: [basic, premium])
        
        typeBtn.menu = menu
        typeBtn.showsMenuAsPrimaryAction = true
    }
    
    func setupMarker(_ boardInfo: BoardInfo) {
        let marker = NMFMarker()
        let lat = boardInfo.lat
        let lng = boardInfo.lng
        marker.iconImage = NMFOverlayImage(name: "pin")
        marker.width = CGFloat(50)
        marker.height = CGFloat(75)
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.captionColor = UIColor(named: "MainColor")!
        marker.captionText = "🛴 " + String(boardInfo.boardID)
        marker.captionTextSize = 20
        marker.mapView = mapbox
    }
    
    func loadMap(_ boardInfo: BoardInfo) {
        let lat = boardInfo.lat
        let lng = boardInfo.lng
        view.addSubview(mapbox)
        setupMarker(boardInfo)
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .easeIn
        mapbox.moveCamera(cameraUpdate)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        // 저장 코드 구현
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func findAddress(_ sender: Any) {
        let findAddressVC = KakaoZipWebViewController()
        findAddressVC.delegate = self
        present(findAddressVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = UserDefaults.standard.integer(forKey: "current")
        showMenu()
        loadMap(profile.bilBoardInfos![index])
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

}

protocol UpdateAddress: AnyObject {
    func updateAddress(_ newAddress: String)
}

class KakaoZipWebViewController: UIViewController {
    
    var delegate: UpdateAddress?
    
    // MARK: - Properties
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    var address = ""

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        indicator.stopAnimating()
    }

    // MARK: - UI
    private func configureUI() {
        view.backgroundColor = .white
        setAttributes()
        setContraints()
    }

    private func setAttributes() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self

        guard let url = URL(string: "https://bokyeongee.github.io/bilBoard/"),
            let webView = webView
            else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
    }
    
    private func setContraints() {
            guard let webView = webView else { return }
            view.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false

            webView.addSubview(indicator)
            indicator.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
            ])
        }
}

extension KakaoZipWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            address = data["roadAddress"] as? String ?? ""
            
        }
        guard let previousVC = presentingViewController as? EditViewController else {
            self.delegate?.updateAddress(address)
            self.dismiss(animated: true, completion: nil)
            return
        }
        previousVC.addressLabel.text = address
        
        self.delegate?.updateAddress(address)
        self.dismiss(animated: true, completion: nil)
    }
}

extension KakaoZipWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
