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
import Alamofire
import SwiftyJSON

protocol UpdateData: AnyObject {
    func updateData(_ newBoardInfo: BoardInfo)
}

class EditViewController: UIViewController, UpdateAddress {
    
    var delegate: UpdateData?
    var tempData: [String:Any] = [:]
    
    func updateAddress(_ newAddress: String) {
        addressLabel.text = newAddress
        tempData.updateValue(newAddress, forKey: "roadAddress")
    }

    @IBOutlet weak var detailAddressField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var addressBtn: UIButton!
    
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
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        // 데이터 저장
        // 주소 -> 좌표 decoding 필요
        let index = UserDefaults.standard.integer(forKey: "current")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strCurrentDate = formatter.string(from: Date())
        let type = tempData["type"] as! BoardTypes
        var originData = profile.bilBoardInfos![index]
        print(originData)
        
        if detailAddressField.text != nil {
            // let array = tempData["coordinate"] as! [Double]
            let detailAddress: String = detailAddressField.text!
            let address = tempData["roadAddress"] as! String + " \(detailAddress)"
            print(address)
            print(tempData)
            // lat, lng 새 좌표로 변경 필요
            let newInfo = BoardInfo(address: address ,boardType: type, boardID: originData.boardID, registerTime: strCurrentDate, lat: originData.lat, lng: originData.lng)
            print(newInfo)
            originData = newInfo
            print(originData)
            delegate?.updateData(newInfo)
            profile.bilBoardInfos![index] = newInfo
            self.navigationController?.popViewController(animated: true)
            return
        }
//        let array = tempData["coordinate"] as! [Double]
        let address = tempData["roadAddress"] as! String
        print(tempData)
        print(address)
        // 여기도 lat, lng 변경 필요
        let newInfo = BoardInfo(address: address ,boardType: type, boardID: originData.boardID, registerTime: strCurrentDate, lat: originData.lat, lng: originData.lng)
        originData = newInfo
        print(newInfo)
        delegate?.updateData(newInfo)
        profile.bilBoardInfos![index] = newInfo
        self.navigationController?.popViewController(animated: true)
        return
    }
//    func toPosition(_ address: String) {
//        AddressDecoder.getGeocodeAddress(query: address) { [weak self] result in
//            guard let self = self else {return}
//            switch result {
//            case .success(let geocode):
//                if let firstAddress = geocode.addresses.first {
//                    let latitude = firstAddress.latitude
//                    let longitude = firstAddress.longitude
//                    print(latitude)
//                    print(longitude)
//                    let array = [latitude, longitude]
//                    DispatchQueue.main.async{ [weak self] in
//                        guard let self = self else {return }
//                        print(array)
//                        tempData.updateValue(array, forKey: "coordinate")
//                    }
//                } else {
//
//                    DispatchQueue.main.async{ [weak self] in
//                        guard let self = self else {return }
//                        showAlert(title: "에러", message: "주소를 찾을 수 없습니다")
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async{ [weak self] in
//                    guard let self = self else {return }
//                    showAlert(title: "에러", message: "주소 디코딩 오류: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    @IBAction func findAddress(_ sender: Any) {
        let findAddressVC = KakaoZipWebViewController()
        findAddressVC.delegate = self
        present(findAddressVC, animated: true)
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMenu()
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
            print("guard 안: \(address)")

            self.delegate?.updateAddress(address)
            self.dismiss(animated: true, completion: nil)
            return
        }
        previousVC.addressLabel.text = address
        print("guard 밖: \(address)")

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

