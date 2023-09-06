//
//  ProfileCustomHeader.swift
//  bilboard
//
//  Created by 보경 on 2023/09/06.
//

import UIKit

class ProfileCustomHeader: UITableViewHeaderFooterView {
    
    static let identifier = "profileHeader"

    let button = UIButton()
    let title = UILabel()

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configureContents()
        }
            
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureContents() {
            button.translatesAutoresizingMaskIntoConstraints = false
            title.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(title)
            contentView.addSubview(button)
        
            NSLayoutConstraint.activate([
                title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                title.widthAnchor.constraint(equalToConstant: 30),
                title.heightAnchor.constraint(equalToConstant: 30),
                title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                // Center the label vertically, and use it to fill the remaining
                // space in the header view.
                button.heightAnchor.constraint(equalToConstant: 30),
                button.leadingAnchor.constraint(equalTo: title.trailingAnchor,
                                               constant: 8),
                button.trailingAnchor.constraint(equalTo:
                                                    contentView.layoutMarginsGuide.trailingAnchor),
                button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

class CustomHeader: UITableViewHeaderFooterView {
    
    static let identifier = "customHeader"
    let title = UILabel()

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configureContents()
        }
            
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configureContents() {
            title.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(title)
        
            NSLayoutConstraint.activate([
                title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                title.widthAnchor.constraint(equalToConstant: 30),
                title.heightAnchor.constraint(equalToConstant: 30),
                title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
        ])
    }
}
