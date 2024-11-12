//
//  OptionInCheckoutView.swift
//  nectar-online
//
//  Created by Macbook on 12/11/2024.
//

import UIKit

class OptionInCheckoutView: UIView {
    
    let title: UILabel
    let rightView: UIView
    
    init(title: UILabel, rightView: UIView) {
        self.title = title
        self.rightView = rightView
        
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
            subView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            subView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        title.textAlignment = .left
        subView.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            title.centerYAnchor.constraint(equalTo: subView.centerYAnchor)
        ])
        
        if rightView is UILabel {
            (rightView as! UILabel).numberOfLines = 1
            (rightView as! UILabel).textAlignment = .right
        } else if rightView is UIImageView {
            (rightView as! UIImageView).contentMode = .scaleAspectFit
        }
        
        subView.addSubview(rightView)
        rightView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightView.leadingAnchor.constraint(greaterThanOrEqualTo: title.trailingAnchor, constant: 20),
            rightView.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
        ])
        
        let arrowRight = UIImageView(image: UIImage(named: "icon-arrow-right"))
        subView.addSubview(arrowRight)
        
        arrowRight.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowRight.leadingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: 15),
            arrowRight.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            arrowRight.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            
            arrowRight.widthAnchor.constraint(equalToConstant: 8.4),
            arrowRight.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
}
