//
//  ProductDetailViewModel.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import Foundation

class ProductDetailViewModel {
    var productDetailService: ProductDetailService!
    var productDetail: ProductDetail = {
        let productDetail = ProductDetail()
        productDetail.quantity = 1
        productDetail.price = 4.99
        
        return productDetail
    }()
    var isFavorite: Bool = false {
        didSet {
            updateFavoriteIcon?()
        }
    }
    var updateFavoriteIcon: (() -> Void)?
    var updateQuantityView: (() -> Void)?
    var updateIconSubtract: (() -> Void)?
    var canSubtractQuantity: Bool = false {
        didSet {
            updateIconSubtract?()
        }
    }
    var stars: Int = 5 {
        didSet {
            updateStars?()
        }
    }
    var updateStars: (() -> Void)?
    
    init(productDetailService: ProductDetailService = ProductDetailService()) {
        self.productDetailService = productDetailService
    }
    
    func addOneQuantity() {
        productDetail.quantity += 1
        canSubtractQuantity = true
        updateQuantityView?()
    }
    
    func subtractOneQuantity() {
        productDetail.quantity -= 1
        if canSubtractQuantity {
            updateQuantityView?()
        }
        if productDetail.quantity == 1 {
            canSubtractQuantity = false
        }
    }
}
