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
        
        //비밀번호 *로 표시
        pwTextField.isSecureTextEntry = true
        againPwTextField.isSecureTextEntry = true
        
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
    
    //==========================================================
    
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
    
    //==========================================================
    
    //눈 모양 버튼 눌렀을때 비밀번호 표시
    @IBAction func togglePwVisivility(_ sender: UIButton) {
        pwTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func toggleAgainPwVisivility(_ sender: UIButton) {
        againPwTextField.isSecureTextEntry.toggle()
    }
    
    //취소 버튼 누르면 다시 로그인 화면으로 나감
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //초기화 버튼 누르면 모든 칸이 비워짐
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
    
    //done 버튼 누르면 키보드 숨기기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //이메일 인증 버튼
    @IBAction func emailVerificationButton(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            // 에러 메시지를 사용자에게 보여주거나 다른 처리를 수행
            return
        }
        print("메일을 발송하였습니다")
        sendVerificationEmail(to: email)
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        //텍스트 필드 오류메세지
        var errorMessage = ""
        
        if nickNameTextField.text?.isEmpty == true || nickNameValidationText.textColor == .red {
            errorMessage += "닉네임을 올바르게 입력해주세요.\n"
        }
        
        if idTextField.text?.isEmpty == true || idValidationText.textColor == .red {
            errorMessage += "아이디를 올바르게 입력해주세요.\n"
        }
        
        if pwTextField.text?.isEmpty == true || pwValidationText.textColor == .red {
            errorMessage += "비밀번호를 올바르게 입력해주세요.\n"
        }
        
        if againPwTextField.text?.isEmpty == true || againPwValidationText.textColor == .red {
            errorMessage += "비밀번호 재확인을 올바르게 입력해주세요.\n"
        }
        if emailTextField.text?.isEmpty == true  {
            errorMessage += "이메일은 필수 입력란입니다.\n"
        }
        if emailNumberTextField.text?.isEmpty == true  {
            errorMessage += "이메일 인증이 필요합니다.\n"
        }
        
        
        if !errorMessage.isEmpty {
            showAlert(message: errorMessage)
            return
        }
        
        // 모든 유효성 검사를 통과한 경우, UserDefaults에 데이터 저장
        saveUserDataToUserDefaults()
        
        func saveUserDataToUserDefaults() {
            let userData: [String: String] = [
                "nickName": nickNameTextField.text!,
                "id": idTextField.text!,
                "password": pwTextField.text!,
                "email": emailTextField.text!
            ]
            
            UserDefaults.standard.setValue(userData, forKey: "userData")
        }
        
        
        self.performSegue(withIdentifier: "LoginViewController", sender: self)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
