//
//  ProductFavoriteViewCell.swift
//  nectar-online
//
//  Created by Macbook on 11/11/2024.
//

import UIKit

class ProductFavoriteViewCell: UICollectionViewCell {
    
    private let subView = UIView()
    let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E2E2E2")
        return view
    }()
    
    var product: Product?
    var imageProduct: UIImageView
    var nameProduct: UILabel
    var piecePriceProduct: UILabel
    var priceProduct: UILabel
    var closureTapProduct: ((Product) -> Void)?
    
    let iconSubtract = UIButton(type: .system)
    let iconAdd = UIButton(type: .system)
    
    override init(frame: CGRect) {
        
        self.imageProduct = UIImageView()
        self.nameProduct = UILabel()
        self.piecePriceProduct = UILabel()
        self.priceProduct = UILabel()
        
        super.init(frame: frame)
        
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(bottomBorder)
        
        self.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            subView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            subView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        ])
        
        subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapProduct(_:))))
        
        let viewImage = UIView()
        subView.addSubview(viewImage)
        
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewImage.topAnchor.constraint(equalTo: subView.topAnchor),
            viewImage.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            
            viewImage.widthAnchor.constraint(lessThanOrEqualToConstant: 70),
            viewImage.heightAnchor.constraint(equalToConstant: 114.95 - 60)
        ])
        
        imageProduct.contentMode = .scaleAspectFit
        viewImage.addSubview(imageProduct)
        
        imageProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageProduct.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor),
            imageProduct.leadingAnchor.constraint(equalTo: viewImage.leadingAnchor),
            imageProduct.widthAnchor.constraint(lessThanOrEqualTo: viewImage.widthAnchor, constant: -20), // 20 padding
            imageProduct.heightAnchor.constraint(lessThanOrEqualTo: viewImage.heightAnchor),
        ])
        
        let viewContent = UIView()
        subView.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
            viewContent.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor),
            viewContent.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            viewContent.heightAnchor.constraint(equalToConstant: 41.83)
        ])
        
        let leftViewContent = UIView()
        viewContent.addSubview(leftViewContent)
        
        leftViewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftViewContent.topAnchor.constraint(equalTo: viewContent.topAnchor),
            leftViewContent.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            leftViewContent.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor)
        ])
        
        nameProduct.textAlignment = .left
        nameProduct.numberOfLines = 1
        leftViewContent.addSubview(nameProduct)
        
        nameProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameProduct.topAnchor.constraint(equalTo: leftViewContent.topAnchor),
            nameProduct.leadingAnchor.constraint(equalTo: leftViewContent.leadingAnchor)
        ])
        
        piecePriceProduct.textAlignment = .left
        piecePriceProduct.numberOfLines = 1
        leftViewContent.addSubview(piecePriceProduct)
        
        piecePriceProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            piecePriceProduct.topAnchor.constraint(equalTo: nameProduct.bottomAnchor, constant: 5.83),
            piecePriceProduct.bottomAnchor.constraint(equalTo: leftViewContent.bottomAnchor),
            piecePriceProduct.leadingAnchor.constraint(equalTo: leftViewContent.leadingAnchor)
        ])
        
        let rightViewContent = UIView()
        viewContent.addSubview(rightViewContent)
        
        rightViewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightViewContent.leadingAnchor.constraint(greaterThanOrEqualTo: leftViewContent.trailingAnchor, constant: 20),
            rightViewContent.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            rightViewContent.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor),
            
            rightViewContent.heightAnchor.constraint(equalToConstant: 27)
        ])
        
        priceProduct.textAlignment = .left
        priceProduct.numberOfLines = 1
        rightViewContent.addSubview(priceProduct)
        
        priceProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceProduct.leadingAnchor.constraint(equalTo: rightViewContent.leadingAnchor),
            priceProduct.centerYAnchor.constraint(equalTo: rightViewContent.centerYAnchor)
        ])
        
        let arrowRight = UIImageView(image: UIImage(named: "icon-arrow-right"))
        rightViewContent.addSubview(arrowRight)
        
        arrowRight.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowRight.leadingAnchor.constraint(equalTo: priceProduct.trailingAnchor, constant: 16),
            arrowRight.trailingAnchor.constraint(equalTo: rightViewContent.trailingAnchor),
            arrowRight.centerYAnchor.constraint(equalTo: rightViewContent.centerYAnchor),
            
            arrowRight.widthAnchor.constraint(equalToConstant: 8.4),
            arrowRight.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    // Hàm xử lý khi bấm vào sảm phẩm
    @objc private func handleTapProduct(_ sender: UITapGestureRecognizer) {
        self.closureTapProduct?(product!)
    }
}
