//
//  NotifyRequireLogin.swift
//  nectar-online
//
//  Created by Macbook on 07/11/2024.
//

import UIKit

class NotifyRequireLogin: UIView {
    let title: String
    let buttonConfirm = UIButton(type: .system)
    let buttonClose = UIButton(type: .system)

    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5) // Màu đen mờ
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true // Ẩn lớp phủ lúc ban đầu
        
        let viewContent = UIView()
        self.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            viewContent.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            viewContent.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 30),
            viewContent.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -30),
            
            viewContent.widthAnchor.constraint(lessThanOrEqualToConstant: self.frame.width - 60)
        ])
        
        let viewTitle = UIView()
        viewContent.addSubview(viewTitle)
        
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: viewContent.topAnchor),
            viewTitle.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            viewTitle.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
        ])
        
        let labelTitle = UILabel()
        labelTitle.text = title
        labelTitle.font = UIFont(name: "Gilroy-Medium", size: 16)
    }
}
