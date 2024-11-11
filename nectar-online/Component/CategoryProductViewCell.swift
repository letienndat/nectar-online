//
//  GroupProductViewCell.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import UIKit

class CategoryProductViewCell: UICollectionViewCell {
    
    var id: Int
    var imageView: UIImageView
    var title: UILabel

    override init(frame: CGRect) {
        self.id = 0
        self.imageView = UIImageView()
        self.title = UILabel()
        
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 18
        
        let viewImage = UIView()
        self.addSubview(viewImage)
        
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            viewImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            viewImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            viewImage.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        imageView.contentMode = .scaleAspectFit
        viewImage.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: viewImage.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: viewImage.widthAnchor, constant: -40), // 20 + 20 padding
            imageView.heightAnchor.constraint(lessThanOrEqualTo: viewImage.heightAnchor, constant: -40) // 20 + 20 padding
        ])
        
        let viewContent = UIView()
        self.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: viewImage.bottomAnchor),
            viewContent.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15.54),
            viewContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            viewContent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
        
        title.textAlignment = .center
        title.numberOfLines = 0
        viewContent.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: viewContent.topAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: viewContent.leadingAnchor),
            title.trailingAnchor.constraint(greaterThanOrEqualTo: viewContent.trailingAnchor),
            title.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor)
        ])
    }
}
