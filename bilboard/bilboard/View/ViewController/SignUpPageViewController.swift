//
//  SignUpPageViewController.swift
//  bilboard
//
//  Created by t2023-m0075 on 2023/09/04.
//

import UIKit
import SwiftSMTP

class SignUpPageViewController: UIViewController, UITextFieldDelegate {
    
    
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
    @IBOutlet weak var verificationButton: UIButton!
    
    
    //유효성 검사 라벨들을 outlet collection 으로 묶어줌
    @IBOutlet var defaultHiddenCollection: [UILabel]!
    
    //타이머 변수 지정
    var timer: Timer?
    var seconds: Int = 180 //타이머를 진행할 총 초수
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for label in defaultHiddenCollection {
            label.isHidden = true
        }
        emailTimeText.isHidden = true
        
        //자동완성 비활성화
        nickNameTextField.autocorrectionType = .no
        idTextField.autocorrectionType = .no
        
        //비밀번호 *로 표시
        pwTextField.isSecureTextEntry = true
        againPwTextField.isSecureTextEntry = true
        
        //강력한 암호 사용 추천 비활성화
        pwTextField.passwordRules = nil
        againPwTextField.passwordRules = nil
        
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
        
        //타이머
        emailTimeText.text = timeString(time:TimeInterval(seconds))
        
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
        emailNumberTextField.isHidden = false
        emailTimeText.isHidden = false
        verificationButton.isHidden = false
        emailTimeText.isHidden = true
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
       
        //이메일 형식에 대한 유효성 검사
        guard let email = emailTextField.text, isValidEmail(email) else {
                // 유효하지 않은 이메일 형식에 대한 처리 (예: 알림을 보여주기)
            let alert = UIAlertController(title: "오류", message: "유효하지 않은 이메일 형식입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    present(alert, animated: true)
                print("유효하지 않은 이메일 형식입니다.")
                return
            }
        
        //smtp 로직
        let smtp = SMTP(hostname: "smtp.gmail.com", email: "user3rum@gmail.com", password: "ciihfefuexaihugu")
        
        let from = Mail.User(name:"BilBoard", email: "user3rum@gmail.com")
        let to = Mail.User(name: "User", email: emailTextField.text!)
        
        let code = "\(Int.random(in: 100000...999999))"
        
        let mail = Mail(from: from, to: [to], subject: "[BILBOARD] E-MAIL VERIFICATION", text: "인증번호 \(code) \n" + "APP으로 돌아가 인증번호를 입력해주세요.")
        
        smtp.send(mail) { error in
            if let error = error {
                print("전송에 실패하였습니다.: \(error)")
            } else {
                print("전송에 성공하였습니다!")
                UserDefaults.standard.set(code, forKey: "emailVerificationCode")
            }
        }
        emailTimeText.isHidden = false
        
        //타이머
        if timer == nil {
            //타이머 시작
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
        }
        
    }
    //이메일 형식에 대한 유효성 검사
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @objc func updateTimerLabel() {
        if seconds > 0 {
            seconds -= 1
            emailTimeText.text = timeString(time: TimeInterval(seconds))
        } else {
            timer?.invalidate()
            timer = nil
            verificationButton.isEnabled = false
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
        checkVerificationCode()
        
    }
    
    func checkVerificationCode() {
        guard let userInputCode = emailNumberTextField.text else {
            return
        }
        
        if let savedCode = UserDefaults.standard.string(forKey: "emailVerificationCode"), savedCode == userInputCode {
            showAlert(title: "성공",message: "인증에 성공하였습니다!")
            
            emailTimeText.isHidden = true
            emailNumberTextField.isHidden = true
            verificationButton.isHidden = true
        } else {
            showAlert(title: "오류", message: "인증번호가 일치하지 않습니다.")
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        //텍스트 필드 오류메세지
        var errorMessage: String?

        if nickNameTextField.text?.isEmpty == true || nickNameValidationText.textColor == .red {
            errorMessage = "닉네임을 올바르게 입력해주세요."
        } else if idTextField.text?.isEmpty == true || idValidationText.textColor == .red {
            errorMessage = "아이디를 올바르게 입력해주세요."
        } else if pwTextField.text?.isEmpty == true || pwValidationText.textColor == .red {
            errorMessage = "비밀번호를 올바르게 입력해주세요."
        } else if againPwTextField.text?.isEmpty == true || againPwValidationText.textColor == .red {
            errorMessage = "비밀번호 재확인을 올바르게 입력해주세요."
        } else if emailTextField.text?.isEmpty == true {
            errorMessage = "이메일은 필수 입력란입니다."
        } else if emailNumberTextField.text?.isEmpty == true || emailNumberTextField.isHidden == false {
            errorMessage = "이메일 인증이 필요합니다."
        }

        if let message = errorMessage {
            showAlert(message: message)
            return
        }
        
       
    
        let userData: [String: Any] = [
            "nickName": nickNameTextField.text!,
            "id": idTextField.text!,
            "password": pwTextField.text!,
            "email": emailTextField.text!,
            "currentLat": 37.481776875776,
            "currentLng": 126.79742178525
        ]
        
        func saveUserDataToUserDefaults() {
           
        
            // userdefaults 에 딕셔너리 저장을 위해 NSCoding 프로토콜 변환
            UserDefaults.standard.set(nickNameTextField.text, forKey: "nickname")
            UserDefaults.standard.set(idTextField.text, forKey: "id")
            UserDefaults.standard.set(pwTextField.text, forKey: "password")
            UserDefaults.standard.set(emailTextField.text, forKey: "email")
            UserDefaults.standard.set(37.481776875776, forKey: "currentLat")
            UserDefaults.standard.set(126.79742178525, forKey: "currentLng")
            
        
            UserDefaults.standard.set(userData, forKey: "userData")
            
            
        }
        
        showAlert(message: "회원가입이 완료되었습니다.", completion: {
            // 모든 유효성 검사를 통과한 경우, UserDefaults에 데이터 저장
            saveUserDataToUserDefaults()
            // 현재 뷰 컨트롤러를 닫음
            self.dismiss(animated: true, completion: nil)
            
        })
        
        print("회원가입이 완료되었습니다. \(userData)")
    }
    
    // 회원가입 정보 입력에 대한 alert message
    func showAlert(title: String? = "오류", message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
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
