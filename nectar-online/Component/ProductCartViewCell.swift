//
//  ProductCartViewCell.swift
//  nectar-online
//
//  Created by Macbook on 09/11/2024.
//

import UIKit

class ProductCartViewCell: UICollectionViewCell {
    
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
    var quantityProduct: UILabel
    var closureTapProduct: ((Product) -> Void)?
    var closureRemoveProduct: (() -> Void)?
    var closureSubtractOneQuantity: (() -> Void)?
    var closureAddOneQuantity: (() -> Void)?
    
    let iconSubtract = UIButton(type: .system)
    let iconAdd = UIButton(type: .system)
    
    override init(frame: CGRect) {
        
        self.imageProduct = UIImageView()
        self.nameProduct = UILabel()
        self.piecePriceProduct = UILabel()
        self.priceProduct = UILabel()
        self.quantityProduct = UILabel()
        
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
            
            viewImage.widthAnchor.constraint(lessThanOrEqualToConstant: 105),
            viewImage.heightAnchor.constraint(equalToConstant: 96.98)
        ])
        
        imageProduct.contentMode = .scaleAspectFit
        viewImage.addSubview(imageProduct)
        
        imageProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageProduct.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor),
            imageProduct.leadingAnchor.constraint(equalTo: viewImage.leadingAnchor),
            imageProduct.widthAnchor.constraint(lessThanOrEqualTo: viewImage.widthAnchor, constant: -25), // 25 padding
            imageProduct.heightAnchor.constraint(lessThanOrEqualTo: viewImage.heightAnchor),
            
            imageProduct.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor)
        ])
        
        let viewContent = UIView()
        subView.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: subView.topAnchor),
            viewContent.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
            viewContent.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor),
            viewContent.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
        ])
        
        nameProduct.textAlignment = .left
        nameProduct.numberOfLines = 0
        viewContent.addSubview(nameProduct)
        
        nameProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameProduct.topAnchor.constraint(equalTo: viewContent.topAnchor),
            nameProduct.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            nameProduct.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor, constant: -(14.16 + 10)),
            
            nameProduct.heightAnchor.constraint(greaterThanOrEqualToConstant: 14)
        ])
        
        piecePriceProduct.textAlignment = .left
        viewContent.addSubview(piecePriceProduct)
        
        piecePriceProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            piecePriceProduct.topAnchor.constraint(equalTo: nameProduct.bottomAnchor, constant: 5),
            piecePriceProduct.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            piecePriceProduct.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor)
        ])
        
        let iconRemoveProductInCart = UIButton(type: .system)
        iconRemoveProductInCart.setImage(UIImage(named: "icon-remove-product-in-cart"), for: .normal)
        iconRemoveProductInCart.backgroundColor = .clear
        iconRemoveProductInCart.tintColor = UIColor(hex: "#B3B3B3")
        viewContent.addSubview(iconRemoveProductInCart)
        
        iconRemoveProductInCart.addTarget(self, action: #selector(handleRemoveProductInCart(_:)), for: .touchUpInside)
        
        iconRemoveProductInCart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconRemoveProductInCart.topAnchor.constraint(equalTo: viewContent.topAnchor),
            iconRemoveProductInCart.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            
            iconRemoveProductInCart.widthAnchor.constraint(equalToConstant: 20),
            iconRemoveProductInCart.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let viewQuantityAndPrice = UIView()
        viewContent.addSubview(viewQuantityAndPrice)
        
        viewQuantityAndPrice.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewQuantityAndPrice.topAnchor.constraint(equalTo: piecePriceProduct.bottomAnchor, constant: 12),
            viewQuantityAndPrice.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            viewQuantityAndPrice.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            viewQuantityAndPrice.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor),
            
            viewQuantityAndPrice.heightAnchor.constraint(equalToConstant: 47.08)
        ])
        
        let viewQuantity = UIView()
        viewQuantityAndPrice.addSubview(viewQuantity)
        
        viewQuantity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewQuantity.topAnchor.constraint(equalTo: viewQuantityAndPrice.topAnchor),
            viewQuantity.bottomAnchor.constraint(equalTo: viewQuantityAndPrice.bottomAnchor),
            viewQuantity.leadingAnchor.constraint(equalTo: viewQuantityAndPrice.leadingAnchor),
        ])
        
        let viewSubtract = UIView()
        viewSubtract.layer.cornerRadius = 17
        viewSubtract.layer.borderWidth = 1
        viewSubtract.layer.borderColor = UIColor(hex: "#E2E2E2").cgColor
        viewQuantity.addSubview(viewSubtract)
        
        viewSubtract.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewSubtract.topAnchor.constraint(equalTo: viewQuantity.topAnchor),
            viewSubtract.bottomAnchor.constraint(equalTo: viewQuantity.bottomAnchor),
            viewSubtract.leadingAnchor.constraint(equalTo: viewQuantity.leadingAnchor),
            
            viewSubtract.widthAnchor.constraint(equalToConstant: 45.67)
        ])
        
        iconSubtract.setImage(UIImage(named: "icon-subtract"), for: .normal)
        iconSubtract.tintColor = UIColor(hex: "#B3B3B3")
        viewSubtract.addSubview(iconSubtract)
        
        iconSubtract.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconSubtract.leadingAnchor.constraint(equalTo: viewSubtract.leadingAnchor),
            iconSubtract.trailingAnchor.constraint(equalTo: viewSubtract.trailingAnchor),
            iconSubtract.topAnchor.constraint(equalTo: viewSubtract.topAnchor),
            iconSubtract.bottomAnchor.constraint(equalTo: viewSubtract.bottomAnchor),
        ])
        
        iconSubtract.addTarget(self, action: #selector(subtractOneQuantity(_:)), for: .touchUpInside)
        
        let viewNumberQuantity = UIView()
        viewQuantity.addSubview(viewNumberQuantity)
        
        viewNumberQuantity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewNumberQuantity.topAnchor.constraint(equalTo: viewQuantity.topAnchor),
            viewNumberQuantity.bottomAnchor.constraint(equalTo: viewQuantity.bottomAnchor),
            viewNumberQuantity.leadingAnchor.constraint(equalTo: viewSubtract.trailingAnchor),
        ])
        
        quantityProduct.text = "\(product?.quantity ?? 1)"
        quantityProduct.font = UIFont(name: "Gilroy-Semibold", size: 18)
        quantityProduct.textColor = UIColor(hex: "#181725")
        viewNumberQuantity.addSubview(quantityProduct)
        
        quantityProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quantityProduct.centerYAnchor.constraint(equalTo: viewNumberQuantity.centerYAnchor),
            
            quantityProduct.leadingAnchor.constraint(equalTo: viewNumberQuantity.leadingAnchor, constant: 17.45),
            quantityProduct.trailingAnchor.constraint(equalTo: viewNumberQuantity.trailingAnchor, constant: -17.45  )
        ])
        
        let viewAdd = UIView()
        viewAdd.layer.cornerRadius = 17
        viewAdd.layer.borderWidth = 1
        viewAdd.layer.borderColor = UIColor(hex: "#E2E2E2").cgColor
        viewQuantity.addSubview(viewAdd)
        
        viewAdd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewAdd.topAnchor.constraint(equalTo: viewQuantity.topAnchor),
            viewAdd.bottomAnchor.constraint(equalTo: viewQuantity.bottomAnchor),
            viewAdd.leadingAnchor.constraint(equalTo: viewNumberQuantity.trailingAnchor),
            viewAdd.trailingAnchor.constraint(equalTo: viewQuantity.trailingAnchor),
            
            viewAdd.widthAnchor.constraint(equalToConstant: 45.67)
        ])
        
        iconAdd.setImage(UIImage(named: "icon-add"), for: .normal)
        iconAdd.tintColor = UIColor(hex: "#53B175")
        viewAdd.addSubview(iconAdd)
        
        iconAdd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconAdd.leadingAnchor.constraint(equalTo: viewAdd.leadingAnchor),
            iconAdd.trailingAnchor.constraint(equalTo: viewAdd.trailingAnchor),
            iconAdd.topAnchor.constraint(equalTo: viewAdd.topAnchor),
            iconAdd.bottomAnchor.constraint(equalTo: viewAdd.bottomAnchor),
        ])
        
        iconAdd.addTarget(self, action: #selector(addOneQuantity(_:)), for: .touchUpInside)
        
        let viewEmpty = UIView()
        viewQuantityAndPrice.addSubview(viewEmpty)
        
        viewEmpty.backgroundColor = .red
        
        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.leadingAnchor.constraint(equalTo: viewQuantity.trailingAnchor),
            viewEmpty.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
        ])
        
        viewQuantityAndPrice.addSubview(priceProduct)
        priceProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceProduct.leadingAnchor.constraint(equalTo: viewEmpty.trailingAnchor),
            priceProduct.trailingAnchor.constraint(equalTo: viewQuantityAndPrice.trailingAnchor),
            priceProduct.centerYAnchor.constraint(equalTo: viewQuantityAndPrice.centerYAnchor)
        ])
    }
    
    // Hàm xử lý khi bấm vào sảm phẩm
    @objc private func handleTapProduct(_ sender: UITapGestureRecognizer) {
        self.closureTapProduct?(product!)
    }
    
    // Hàm xử lý khi bấm xoá sản phẩm trong giỏ hàng
    @objc private func handleRemoveProductInCart(_ sender: AnyObject) {
        self.closureRemoveProduct?()
    }
    
    // Hàm xử lý khi giảm số lượng
    @objc private func subtractOneQuantity(_ sender: AnyObject) {
        self.closureSubtractOneQuantity?()
    }
    
    // Cập nhật giao diện nút có thể trừ và không có thể trừ
    func canBeSubtracted(_ really: Bool) {
        if !really {
            iconSubtract.layer.borderColor = UIColor(hex: "#F0F0F0").cgColor
            iconSubtract.tintColor = UIColor(hex: "#B3B3B3")
            return
        }
        iconSubtract.layer.borderColor = UIColor(hex: "#E2E2E2").cgColor
        iconSubtract.tintColor = UIColor(hex: "#53B175")
    }
    
    // Hàm xử lý khi tăng số lượng
    @objc private func addOneQuantity(_ sender: AnyObject) {
        self.closureAddOneQuantity?()
    }
}
