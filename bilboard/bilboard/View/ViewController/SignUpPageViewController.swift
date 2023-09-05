//
//  SignUpPageViewController.swift
//  bilboard
//
//  Created by t2023-m0075 on 2023/09/04.
//

import UIKit

class SignUpPageViewController: UIViewController {


    @IBOutlet weak var nickNameValidationText: UILabel!
    @IBOutlet weak var idValidationText: UILabel!
    @IBOutlet weak var pwValidationText: UILabel!
    @IBOutlet weak var againPwValidationText: UILabel!
    @IBOutlet weak var emailTimeText: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var againPwTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailNumberTextField: UITextField!
    
    //유효성 검사 라벨들을 outlet collection 으로 묶어줌
    @IBOutlet var defaultHiddenCollection: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for label in defaultHiddenCollection {
            label.isHidden = true
        }
        
        
        //texttield마다 delegate 선언 -> 유효성 검사에 필요
        nickNameTextField.delegate = self
        idTextField.delegate = self
        pwTextField.delegate = self
        againPwTextField.delegate = self
        emailTextField.delegate = self
        emailNumberTextField.delegate = self
        
        //키보드를 done 버튼 생성
        nickNameTextField.returnKeyType = .done
        idTextField.returnKeyType = .done
        pwTextField.returnKeyType = .done
        againPwTextField.returnKeyType = .done
        emailTextField.returnKeyType = .done
        emailNumberTextField.returnKeyType = .done
        
        //키보드 이외의 화면 터치 시 키보드 내려감
        setupKeyboardDismissRecognizer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //=============================================================================================================================================================
    
    //nickname 유효성 검사 조건 설정 및 검사결과 표시
    
    @IBAction func nickNameTextFieldTyped(_ sender: UITextField) {
        
        nickNameValidationText.isHidden = false
        
        let minCount = 2
        let maxCount = 6
        let count = nickNameTextField.text!.count
        
        switch count {
        case 0:
            nickNameValidationText.text = "닉네임은 필수입력 정보입니다."
            nickNameValidationText.textColor = .red
        case 1..<minCount:
            nickNameValidationText.text = "닉네임은 2글자 이상이어야 합니다."
            nickNameValidationText.textColor = .red
        case minCount...maxCount:
            let idPattern = #"^[가-힣]{\#(minCount),\#(maxCount)}$"#
            let isVaildPattern = (nickNameTextField.text!.range(of: idPattern, options: .regularExpression) != nil)
            if isVaildPattern {
                nickNameValidationText.text = "조건에 맞는 닉네임"
                nickNameValidationText.isHidden = true
            } else {
                nickNameValidationText.text = "한글만 작성할 수 있습니다."
                nickNameValidationText.textColor = .red
            }
        default:
            nickNameValidationText.text = "닉네임은 6글자 이하이어야 합니다."
            nickNameValidationText.textColor = .red
        }
        
    }
    
    //id 유효성 검사 조건 설정 및 검사결과 표시
    @IBAction func idTextFieldTyped(_ sender: UITextField) {
        
        idValidationText.isHidden = false //label 보여주기
        
        let userWord = idTextField.text?.lowercased() //소문자변환
        idTextField.text = userWord //변환된 소문자로 바꿔주기
        
        let minCount = 5
        let maxCount = 12
        let count = userWord!.count
        
        switch count {
        case 0:
            idValidationText.text = "아이디는 필수입력 정보입니다."
            idValidationText.textColor = .red
        case 1..<minCount:
            idValidationText.text = "아이디는 5글자 이상이어야 합니다."
            idValidationText.textColor = .red
        case minCount...maxCount:
            let idPattern = "^[a-z0-9-_]{\(minCount),\(maxCount)}$"
            let isValidPattern = (userWord!.range(of: idPattern, options: .regularExpression) != nil)
            if isValidPattern {
                idValidationText.text = "조건에 맞는 아이디"
                idValidationText.isHidden = true
            } else {
                idValidationText.text = "소문자와 숫자만 사용할 수 있습니다."
                idValidationText.textColor = .red
            }
        default:
            idValidationText.text = "아이디는 5~12글자 사이이어야 합니다."
            idValidationText.textColor = .red
        }
        
        
    }
    
    //password 유효성 검사 조건 설정 및 검사 결과 표시
    @IBAction func passwordTextFieldTyped(_ sender: UITextField) {
        
        pwValidationText.isHidden = false
        
        let minCount = 8
        let maxCount = 16
        let count = pwTextField.text!.count
        
        switch count {
        case 0:
            pwValidationText.text = "비밀번호는 필수입력 정보입니다."
            pwValidationText.textColor = .red
            
        case 1..<minCount:
            pwValidationText.text = "비밀번호는 8글자 이상이어야 합니다."
            pwValidationText.textColor = .red
        case minCount...maxCount:
            let idPattern = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[\p{P}\p{S}])[A-Za-z\d\p{P}\p{S}]{\#(minCount),\#(maxCount)}$"#
            let isVaildPattern = (pwTextField.text!.range(of: idPattern, options: .regularExpression) != nil)
            if isVaildPattern {
                pwValidationText.text = "조건에 맞는 비밀번호"
                pwValidationText.isHidden = true
            } else {
                pwValidationText.text = "영어알파벳, 숫자, 특수문자가 필수로 입력되어야 합니다."
                pwValidationText.textColor = .red
            }
        default:
            pwValidationText.text = "비밀번호는 16글자 이하이어야 합니다."
            pwValidationText.textColor = .red
        }
    }
    
    //비밀번호 재확인 유효성 검사 조건 설정 및 검사 결과 실시
    @IBAction func againPwTextFieldTyped(_ sender: UITextField) {
        
        againPwValidationText.isHidden = false
        
        //입력된 패스워드와 재입력된 패스워드를 비교
        guard let password = pwTextField.text, let againPassword = againPwTextField.text else{
            return
        }
        
        if password == againPassword {
            againPwValidationText.text = "비밀번호가 일치합니다."
            againPwValidationText.textColor = .green
        } else {
            againPwValidationText.text = "비밀번호가 일치하지 않습니다."
            againPwValidationText.textColor = .red
        }
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        nickNameTextField.text = ""
        idTextField.text = ""
        pwTextField.text = ""
        againPwTextField.text = ""
        emailTextField.text = ""
        emailNumberTextField.text = ""
        
    }
    
    //텍스트 필드 입력 시 키보드 올라오는 기능
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let activeTextField = self.view.findFirstResponder() as? UITextField,
              (activeTextField == againPwTextField || activeTextField == emailTextField || activeTextField == emailNumberTextField) else {
            return
        }

        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //키보드 이외의 화면 터치 시 키보드 내려가는 기능
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

}

extension SignUpPageViewController: UITextFieldDelegate {
   
}
//UIView, 모든 하위 클래스에 findFirstResponder 메서드 추가
extension UIView {
    func findFirstResponder() -> UIView? {
        if isFirstResponder {
            return self
        }
        for subView in subviews {
            if let firstResponder = subView.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}
