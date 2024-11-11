//
//  OptionInAccountView.swift
//  nectar-online
//
//  Created by Macbook on 11/11/2024.
//

import UIKit

class OptionInAccountView: UIView {
    
    let image: UIImageView
    let title: UILabel
    
    init(image: UIImage, title: UILabel) {
        self.image = UIImageView(image: image)
        self.title = title
        
        super.init(frame: .zero)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(hex: "#FFFFFF")
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 62)
        ])
        
        let subView = UIView()
        self.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            subView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            subView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            subView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        image.contentMode = .scaleAspectFit
        subView.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            image.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            
            image.widthAnchor.constraint(equalToConstant: 20),
            image.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        title.textAlignment = .left
        subView.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: subView.centerYAnchor)
        ])
        
        let arrowRight = UIImageView(image: UIImage(named: "icon-arrow-right"))
        subView.addSubview(arrowRight)
        
        arrowRight.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowRight.leadingAnchor.constraint(greaterThanOrEqualTo: title.trailingAnchor, constant: 20),
            arrowRight.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            arrowRight.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            
            arrowRight.widthAnchor.constraint(equalToConstant: 8.4),
            arrowRight.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
}
