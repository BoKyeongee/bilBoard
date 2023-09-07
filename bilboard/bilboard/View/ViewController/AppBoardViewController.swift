// AppBoardViewController.swift
// bilboard
//
// Created by 박유경 on 2023/09/04.
//
import UIKit
import Foundation
import NMapsMap
import SnapKit
class AppBoardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 let Btn = UIColor(named: "Main")
 let ACTIVITY_NAME = "A_Picker"
 let arr = ["서울 자곡로 102" , "대구 안심로 261 ", "제주시 오등동 1100로", "부천시 중동로 22번길 64"] // [피커 뷰에 표시될 리스트]
 let arr2 = ["basic", "premium"]
 var choiceItem = "" { // [변수 값이 변경 되면 동시에 텍스트 필드 값 UI 업데이트 실시]
  didSet {
   self.tfAddress.text = self.choiceItem
  }
 }
 var choiceItem2 = "" { // [변수 값이 변경 되면 동시에 텍스트 필드 값 UI 업데이트 실시]
  didSet {
   self.tfType.text = self.choiceItem2
  }
 }
 var pickerView : UIPickerView? = nil
 var pickerViewType : UIPickerView?
 var toolBar : UIToolbar? = nil
 @IBOutlet weak var lbMy: UILabel!
 @IBOutlet weak var tfAddress: UITextField!
 @IBOutlet weak var tfType: UITextField!
 @IBOutlet weak var btnRegister: UIButton!
 override func viewDidLoad() {
  super.viewDidLoad()
  print("")
  print("====================================")
  print("[\(self.ACTIVITY_NAME) >> viewDidLoad() :: 뷰 로드 실시]")
  print("====================================")
  print("")
  // [뷰 정의 및 초기화 함수 호출]
  self.setView()
  // self.btnRegister.layer.cornerRadius(50)
 }
 // MARK: - [뷰 로드 완료]
 override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
  print("")
  print("====================================")
  print("[\(self.ACTIVITY_NAME) >> viewWillAppear() :: 뷰 로드 완료]")
  print("====================================")
  print("")
 }
 // MARK: - [뷰 화면 표시]
 override func viewDidAppear(_ animated: Bool) {
  super.viewDidAppear(animated)
  print("")
  print("====================================")
  print("[\(self.ACTIVITY_NAME) >> viewDidAppear() :: 뷰 화면 표시]")
  print("====================================")
  print("")
 }
 // MARK: - [뷰 정지 상태]
 override func viewWillDisappear(_ animated: Bool) {
  super.viewWillDisappear(animated)
  print("")
  print("====================================")
  print("[\(self.ACTIVITY_NAME) >> viewWillDisappear() :: 뷰 정지 상태]")
  print("====================================")
  print("")
 }
 // MARK: - [뷰 종료 상태]
 override func viewDidDisappear(_ animated: Bool) {
  super.viewDidDisappear(animated)
  print("")
  print("====================================")
  print("[\(self.ACTIVITY_NAME) >> viewDidDisappear() :: 뷰 종료 상태]")
  print("====================================")
  print("")
 }
 @objc func textFieldTouchDown() {
  print("")
  print("====================================")
  print("[\(self.ACTIVITY_NAME) >> textFieldTouchDown() :: 텍스트 필드 터치 이벤트 발생]")
  print("====================================")
  print("")
 }
 // MARK: - [테스트 메인 함수 정의 실시]
 func setView() {
  print("")
  print("====================================")
  print("[\(self.ACTIVITY_NAME) >> setView() :: 화면 설정 수행 실시]")
  print("====================================")
  print("")
  // [비동기 처리 수행]
  DispatchQueue.main.async {
   // [텍스트 필드 속성 설정 실시]
   //self.tfAddress.tintColor = .clear // 틴트 색상
   //self.tfAddress.layer.borderWidth = 0.5 // 테두리 굵기
   //self.tfAddress.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상
   //self.tfType.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상
   //self.tfAddress.layer.cornerRadius = 50
   //self.tfType.layer.cornerRadius = 50
   self.tfAddress.text = "" // 초기 텍스트 설정
   self.tfAddress.textAlignment = .left// 텍스트 정렬
   //self.textField.delegate = self // 딜리게이트 지정
   self.tfAddress.addTarget(self, action: #selector(self.textFieldTouchDown), for: .touchDown)
   // [피커 뷰 속성 설정 실시]
   self.pickerView = UIPickerView()
   self.tfAddress.inputView = self.pickerView // 피커 뷰를 텍스트 필드 inputMode 로 지정
   self.pickerView!.dataSource = self // 데이터 소스 설정
   self.pickerView!.delegate = self // 딜리게이트 지정
   //
   self.pickerViewType = UIPickerView()
   self.tfType.inputView = self.pickerViewType
   self.pickerViewType?.dataSource = self
   self.pickerViewType!.delegate = self
   // "tfAddress"에 대한 툴바 설정
   self.toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 50))
   let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.choiceButton))
   self.toolBar!.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), button], animated: false)
   self.tfAddress.inputAccessoryView = self.toolBar
   self.toolBar?.backgroundColor = .darkGray
   // "tfType"에 대한 툴바 설정
   self.toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 50))
   let buttonType = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.choiceButtonType))
   self.toolBar!.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), buttonType], animated: false)
   self.tfType.inputAccessoryView = self.toolBar
   self.toolBar?.backgroundColor = .darkGray
  }
 }
 // MARK: - [툴바 클릭 이벤트]
 @objc func choiceButton() {
  print("")
  print("====================================")
  print("[\(self.ACTIVITY_NAME) >> choiceButton() :: 툴바 버튼 클릭 이벤트 수행]")
  print("====================================")
  print("")
  // [선택] 클릭 시 데이터를 textfield 에 입력 후 입력창 내리기
  let row = self.pickerView!.selectedRow(inComponent: 0)
  self.pickerView!.selectRow(row, inComponent: 0, animated: false)
  self.tfAddress.text = self.arr[row]
  self.tfAddress.resignFirstResponder()
 }
 @objc func choiceButtonType() {
  print("")
  print("====================================")
  print("[\(self.ACTIVITY_NAME) >> choiceButtonType() :: 툴바 버튼 클릭 이벤트 수행]")
  print("====================================")
  print("")
  // "선택"을 클릭하면 데이터를 텍스트 필드에 입력한 다음 입력 창을 닫습니다.
  let row = self.pickerViewType!.selectedRow(inComponent: 0)
  self.pickerViewType!.selectRow(row, inComponent: 0, animated: false)
  self.tfType.text = self.arr2[row]
  self.tfType.resignFirstResponder()
 }
 // MARK: - [피커 뷰 딜리게이트 정의]
 func numberOfComponents(in pickerView: UIPickerView) -> Int {
  return 1
 }
 func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
  if pickerView === self.pickerView {
   return self.arr.count // tfAddress에 대한 데이터 개수
  } else if pickerView === pickerViewType {
   return self.arr2.count // tfType에 대한 데이터 개수
  } else {
   return 0
  }
 }
 func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
  if pickerView === self.pickerView {
   return self.arr[row] // tfAddress에 대한 데이터
  } else if pickerView === pickerViewType {
   return self.arr2[row] // tfType에 대한 데이터
  } else {
   return nil
  }
 }
 func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
  if pickerView === self.pickerView {
   self.choiceItem = self.arr[row] // tfAddress의 선택된
  } else if pickerView === pickerViewType {
   self.choiceItem2 = self.arr2[row] // tfType의 선택된 값
  }
  print(row)
 }
 func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
  /*
   print("")
   print("====================================")
   print("[\(self.ACTIVITY_NAME) >> rowHeightForComponent() :: 피커 뷰 목록 높이 설정]")
   print("====================================")
   print("")
   // */
  return 50
 }
 @IBAction func btnRegister(_ sender: Any) {
  print(tfAddress.text)
  var latitude = 0.0
  var longitude = 0.0
  if let address = tfAddress.text, !address.isEmpty {
   print("if let address")
   AddressDecoder.getGeocodeAddress(query: address) { [weak self] result in
    guard let self = self else {return}
    switch result {
    case .success(let geocode):
     if let firstAddress = geocode.addresses.first {
      latitude = Double(firstAddress.latitude)!
      longitude = Double(firstAddress.longitude)!
      DispatchQueue.main.async{ [weak self] in
       guard let self = self else {return }
       if profile.bilBoardInfos == nil {
        profile.bilBoardInfos = []
       }
       let boardID = (profile.bilBoardInfos?.count ?? 0) + 1
       if tfType.text == "basic" {
        profile.bilBoardInfos!.append(BoardInfo(address: tfAddress.text!, boardType: .basic, boardID: boardID, registerTime: Date().GetCurrentTime(), lat: latitude, lng: longitude))
       } else if tfType.text == "premium" {
        profile.bilBoardInfos!.append(BoardInfo(address: tfAddress.text!, boardType: .premium, boardID: boardID, registerTime: Date().GetCurrentTime(), lat: latitude, lng: longitude))
       }
       showAlert(title: "우리들의 성공", message: "을 위하여")
      }
      print(latitude)
      print(longitude)
      // 주소를 찾아 위도와 경도를 얻어왔지만, 지도 이동 부분을 비활성화
      // 주소를 찾아도 지도 이동을 원하지 않으면 아무것도 추가하지 않아도 됩니다.
     } else {
      DispatchQueue.main.async{ [weak self] in
       guard let self = self else {return }
       // 주소를 찾을 수 없을 경우 경고 표시
       showAlert(title: "에러", message: "주소를 찾을 수 없습니다")
      }
     }
    case .failure(let error):
     DispatchQueue.main.async{ [weak self] in
      guard let self = self else {return }
      // 주소 디코딩 중에 오류가 발생한 경우 오류 알림 표시
      showAlert(title: "에러", message: "주소 디코딩 오류: \(error.localizedDescription)")
     }
    }
   }
   //textField.resignFirstResponder()
  }
 }
}
