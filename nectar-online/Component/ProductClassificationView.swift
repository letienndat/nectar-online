//
//  ProductClassificationView.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import UIKit

class ProductClassificationView: UIView {
    
    private let labelTitle: UILabel
    private let viewsProduct: [UIView]
    
    init(labelTitle: UILabel, viewsProduct: [UIView]) {
        
        self.labelTitle = labelTitle
        self.viewsProduct = viewsProduct
        
        super.init(frame: .zero)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 298.05)
        ])
        
        self.addSubview(labelTitle)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: self.topAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            labelTitle.centerYAnchor.constraint(equalTo: labelTitle.centerYAnchor),
            
            labelTitle.heightAnchor.constraint(equalToConstant: 29)
        ])
        
        let buttonSeeAll = UIButton(type: .system)
        buttonSeeAll.setTitle("See all", for: .normal)
        buttonSeeAll.setTitleColor(UIColor(hex: "#53B175"), for: .normal)
        buttonSeeAll.titleLabel?.font = UIFont(name: "Gilroy-Semibold", size: 16)
        self.addSubview(buttonSeeAll)
        
        buttonSeeAll.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonSeeAll.topAnchor.constraint(equalTo: self.topAnchor),
            buttonSeeAll.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            buttonSeeAll.centerYAnchor.constraint(equalTo: buttonSeeAll.centerYAnchor),
            
            buttonSeeAll.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        buttonSeeAll.addTarget(self, action: #selector(handleSeeAll(_:)), for: .touchUpInside)
        
        let scrollViewProducts = UIScrollView()
        scrollViewProducts.bounces = false
        scrollViewProducts.delaysContentTouches = false
        scrollViewProducts.showsVerticalScrollIndicator = false
        scrollViewProducts.showsHorizontalScrollIndicator = false
        self.addSubview(scrollViewProducts)
        
        scrollViewProducts.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollViewProducts.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20),
            scrollViewProducts.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollViewProducts.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollViewProducts.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        let stackViewProducts = UIStackView()
        stackViewProducts.alignment = .center
        stackViewProducts.axis = .horizontal
        stackViewProducts.distribution = .fill
        stackViewProducts.spacing = 15.12
        scrollViewProducts.addSubview(stackViewProducts)
        
        stackViewProducts.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewProducts.topAnchor.constraint(equalTo: scrollViewProducts.topAnchor),
            stackViewProducts.bottomAnchor.constraint(equalTo: scrollViewProducts.bottomAnchor),
            stackViewProducts.leadingAnchor.constraint(equalTo: scrollViewProducts.leadingAnchor),
            stackViewProducts.trailingAnchor.constraint(equalTo: scrollViewProducts.trailingAnchor),
            
            stackViewProducts.widthAnchor.constraint(greaterThanOrEqualTo: scrollViewProducts.frameLayoutGuide.widthAnchor),
            stackViewProducts.heightAnchor.constraint(equalTo: scrollViewProducts.heightAnchor)
        ])
        
        let viewTopEmpty = UIView()
        stackViewProducts.addArrangedSubview(viewTopEmpty)
        
        viewTopEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewTopEmpty.widthAnchor.constraint(equalToConstant: 25 - stackViewProducts.spacing)
        ])
        
        viewsProduct.forEach {
            stackViewProducts.addArrangedSubview($0)
        }
        
        let viewEndEmpty = UIView()
        stackViewProducts.addArrangedSubview(viewEndEmpty)
        
        viewEndEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEndEmpty.widthAnchor.constraint(equalToConstant: 25 - stackViewProducts.spacing)
        ])
    }
    
    // Hàm xử lý khi bấm vào xem tất cả sản phẩm của mỗi danh mục (See all)
    @objc func handleSeeAll(_ sender: UIButton) {
        //
    }
}
