//
//  UITextField.swift
//  bilboard
//
//  Created by t2023-m0049 on 2023/09/07.
//

import UIKit

extension UITextField {
    func customizeTextField() {
        let mainColor = UIColor(named: "Main")
        let mainFont = UIFont(name: "Regular", size: 14)
        
        // 배경색 설정
        self.backgroundColor = mainColor
        
        // 텍스트 색상 설정
        self.textColor = UIColor.white
        
        // 글꼴 설정
        self.font = mainFont
    }
}
