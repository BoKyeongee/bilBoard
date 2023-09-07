//
//  UILabel.swift
//  bilboard
//
//  Created by t2023-m0049 on 2023/09/07.
//

import UIKit

extension UILabel {
    func customizeLabel() {
        let mainColor = UIColor(named: "Main")
        let mainFont = UIFont(name: "Regular", size: 14)
        
        // 텍스트 색상 설정
        self.textColor = mainColor
        
        // 글꼴 설정
        self.font = mainFont
    }
}
