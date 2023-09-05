//
//  AppBoardViewController.swift
//  bilboard
//
//  Created by 박유경 on 2023/09/04.
//

import UIKit


class AppBoardViewController : UIViewController{
    
    
    @IBOutlet weak var lbMy: UILabel!
    
    
    @IBOutlet weak var tfAddress: UITextField!
    
    
    @IBOutlet weak var tfAddressDetail: UITextField!
    
    
    
    @IBOutlet weak var tfType: UITextField!
    
    
    
    @IBOutlet weak var btnRegister: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.btnRegister.layer.cornerRadius(50)
        
        
    }
    
    
    
    
    
    
    @IBAction func btnRegister(_ sender: Any) {
        
        //버튼 누르면 데이터 전송
    }
    
    
    
    
    
    
    
}
