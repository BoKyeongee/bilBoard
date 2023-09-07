//
//  LoginViewController.swift
//  bilboard
//
//  Created by 박유경 on 2023/09/04.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var logInIdTextField: UITextField!
    @IBOutlet weak var logInPwTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // 메인 사진
        brandImage.image = UIImage(named: "BilBoard")
        
        //비밀번호 *로 표시
        logInPwTextField.isSecureTextEntry = true
        
        //키보드 done 버튼 생성
        logInIdTextField.returnKeyType = .done
        logInPwTextField.returnKeyType = .done
        
        //delegate 선언
        logInIdTextField.delegate = self
        logInPwTextField.delegate = self
        
        //화면 밖 터치 시 키보드 숨기기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        
        guard let username = logInIdTextField.text, let password = logInPwTextField.text else {
            return
        }
        //model 파일과 비교
        
        for userInfo in registeredUsers {
            if profile.userId == username && profile.userPw == password {
                performSegue(withIdentifier: "MapPageViewController", sender: self)
                return
            }
        }
        
        // 유저디폴트와 비교
        if let savedUsername = UserDefaults.standard.string(forKey: "savedUsername"),
           let savedPassword = UserDefaults.standard.string(forKey: "savedPassword"),
           savedUsername == username && savedPassword == password {
            print("로그인 되었습니다.")
            performSegue(withIdentifier: "MapPageViewController", sender: self)
            return
        }
        
        //로그인 실패 메세지
        let alert = UIAlertController(title: "오류", message: "아이디 또는 비밀번호를 다시 확인해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    //키보드 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //done 버튼 누르면 키보드 숨기기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
