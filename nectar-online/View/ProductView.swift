//
//  ProductView.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import UIKit

class ProductView: UIView {
    
    private let imageProduct: UIImage
    private let nameProduct: UILabel
    private let piecePriceProduct: UILabel
    private let priceProduct: UILabel

    init(imageProduct: UIImage, nameProduct: UILabel, piecePriceProduct: UILabel, priceProduct: UILabel) {
        
        self.imageProduct = imageProduct
        self.nameProduct = nameProduct
        self.piecePriceProduct = piecePriceProduct
        self.priceProduct = priceProduct
        
        super.init(frame: .zero)
        
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.borderColor = UIColor(hex: "#E2E2E2").cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 18
        self.backgroundColor = .clear
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 173.32),
            self.heightAnchor.constraint(equalToConstant: 248.51)
        ])
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapProduct(_:))))
        
        let viewImage = UIView()
        self.addSubview(viewImage)
        
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            viewImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            viewImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            viewImage.heightAnchor.constraint(equalToConstant: 115)
        ])
        
        let imageProductView = UIImageView(image: imageProduct)
        imageProductView.contentMode = .scaleAspectFit
        viewImage.addSubview(imageProductView)
        
        imageProductView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageProductView.centerXAnchor.constraint(equalTo: viewImage.centerXAnchor),
            imageProductView.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor),
            imageProductView.widthAnchor.constraint(lessThanOrEqualTo: viewImage.widthAnchor, constant: -40), // 20 + 20 padding
            imageProductView.heightAnchor.constraint(lessThanOrEqualTo: viewImage.heightAnchor, constant: -40) // 20 + 20 padding
        ])
        
        let viewContent = UIView()
        self.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: viewImage.bottomAnchor),
            viewContent.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15.54),
            viewContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            viewContent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
        ])
        
        nameProduct.textAlignment = .left
        viewContent.addSubview(nameProduct)
        
        nameProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameProduct.topAnchor.constraint(equalTo: viewContent.topAnchor),
            nameProduct.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            nameProduct.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor)
        ])
        
        piecePriceProduct.textAlignment = .left
        viewContent.addSubview(piecePriceProduct)
        
        piecePriceProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            piecePriceProduct.topAnchor.constraint(equalTo: nameProduct.bottomAnchor, constant: 5),
            piecePriceProduct.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            piecePriceProduct.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor)
        ])
        
        let viewPriceAndButtonAddCard = UIView()
        viewContent.addSubview(viewPriceAndButtonAddCard)
        
        viewPriceAndButtonAddCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewPriceAndButtonAddCard.topAnchor.constraint(equalTo: piecePriceProduct.bottomAnchor, constant: 20),
            viewPriceAndButtonAddCard.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            viewPriceAndButtonAddCard.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            
            viewPriceAndButtonAddCard.heightAnchor.constraint(lessThanOrEqualToConstant: 45.67)
        ])
        
        viewPriceAndButtonAddCard.addSubview(priceProduct)
        priceProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceProduct.leadingAnchor.constraint(equalTo: viewPriceAndButtonAddCard.leadingAnchor),
            priceProduct.centerYAnchor.constraint(equalTo: viewPriceAndButtonAddCard.centerYAnchor)
        ])
        
        let buttonAddToCard = UIButton()
        buttonAddToCard.setImage(UIImage(named: "button-add-to-card"), for: .normal)
        viewPriceAndButtonAddCard.addSubview(buttonAddToCard)
        
        buttonAddToCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonAddToCard.trailingAnchor.constraint(equalTo: viewPriceAndButtonAddCard.trailingAnchor),
            
            buttonAddToCard.widthAnchor.constraint(lessThanOrEqualToConstant: 45.67),
            buttonAddToCard.heightAnchor.constraint(lessThanOrEqualToConstant: 45.67)
        ])
        
        buttonAddToCard.addTarget(self, action: #selector(handleAddToCard(_:)), for: .touchUpInside)
    }
    
    // Hàm xử lý khi bấm thêm sản phẩm vào giỏ hàng
    @objc func handleAddToCard(_ sender: UIButton) {
        //
    }
    
    // Hàm xử lý khi bấm vào sảm phẩm
    @objc func handleTapProduct(_ sender: UITapGestureRecognizer) {
        //
    }
}
