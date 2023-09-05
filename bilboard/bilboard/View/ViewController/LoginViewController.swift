//
//  LoginViewController.swift
//  bilboard
//
//  Created by 박유경 on 2023/09/04.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var logInIdValidationText: UILabel!
    @IBOutlet weak var logInPwValidationText: UILabel!
    @IBOutlet weak var logInIdTextField: UITextField!
    @IBOutlet weak var logInPwTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brandImage.image = UIImage(named: "BilBoard")

    }
    


}
//test
//test2
