//
//  AppBoardViewController.swift
//  bilboard
//
//  Created by 박유경 on 2023/09/04.
//

import UIKit
import Foundation

class AppBoardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
        
    let ACTIVITY_NAME = "A_Picker"
    
    let arr = ["서울" , "대구", "부산", "부천"] // [피커 뷰에 표시될 리스트]
    let arr2 = ["킥보드1" , "킥보드2", "킥보드3", "싸제"]
    
    
    var choiceItem = "" { // [변수 값이 변경 되면 동시에 텍스트 필드 값 UI 업데이트 실시]
        didSet {
            self.tfAddress.text = self.choiceItem
        }
    }
    
    var pickerView : UIPickerView? = nil
    var toolBar : UIToolbar? = nil
    
    
    @IBOutlet weak var lbMy: UILabel!
    
    
    @IBOutlet weak var tfAddress: UITextField!
    
    
    @IBOutlet weak var tfAddressDetail: UITextField!
    
    
    
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
            self.tfAddress.tintColor = .clear // 틴트 색상
            self.tfAddress.layer.borderWidth = 1 // 테두리 굵기
            self.tfAddress.layer.borderColor = UIColor.black.cgColor // 테두리 색상
            self.tfAddress.text = "주소를 입력하세요." // 초기 텍스트 설정
            self.tfAddress.textAlignment = .center // 텍스트 정렬
            //self.textField.delegate = self // 딜리게이트 지정
            self.tfAddress.addTarget(self, action: #selector(self.textFieldTouchDown), for: .touchDown)
            
            // [피커 뷰 속성 설정 실시]
            self.pickerView = UIPickerView()
            self.tfAddress.inputView = self.pickerView // 피커 뷰를 텍스트 필드 inputMode 로 지정
            self.pickerView!.dataSource = self // 데이터 소스 설정
            self.pickerView!.delegate = self // 딜리게이트 지정
            

            
            // [툴바 설정 실시]
            self.toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 50))
            let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.choiceButton))
            self.toolBar!.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), button], animated: false)
            self.tfAddress.inputAccessoryView = self.toolBar
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
    

    
    
    
    
    
    // MARK: - [피커 뷰 딜리게이트 정의]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        /*
        print("")
        print("====================================")
        print("[\(self.ACTIVITY_NAME) >> titleForRow() :: 피커 뷰에 배열 리스트 명칭을 넘김]")
        print("====================================")
        print("")
        // */
        return self.arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("")
        print("====================================")
        print("[\(self.ACTIVITY_NAME) >> didSelectRow() :: 피커 뷰 목록 리스트 이동]")
        print("item :: \(self.arr[row])")
        print("====================================")
        print("")
        
        
        // [텍스트 필드 값을 바꿔주는 변수]
        self.choiceItem = self.arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        /*
        print("")
        print("====================================")
        print("[\(self.ACTIVITY_NAME) >> rowHeightForComponent() :: 피커 뷰 목록 높이 설정]")
        print("====================================")
        print("")
        // */
        return 60
    }
}
    
    
    
    
    
    
    
    
    
