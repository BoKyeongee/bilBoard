//
//  UIButton.swift
//  bilboard
//
//  Created by t2023-m0049 on 2023/09/07.
//

import UIKit

extension UIButton {
    func customizeButton() {
       // let mainColor = UIColor(named: "Main")
        let mainFont = UIFont(name: "regular", size: 14)
        // 배경색 설정
        self.backgroundColor = UIColor.red
        self.layer.cornerRadius = 20
        // 글자색 설정
        self.setTitleColor(UIColor.red, for: .normal)
        
        // 글꼴 설정
        self.titleLabel?.font = mainFont
        
    }
}
