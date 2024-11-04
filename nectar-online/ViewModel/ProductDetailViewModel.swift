//
//  ProductDetailViewModel.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import Foundation

class ProductDetailViewModel {
    var productDetailService: ProductDetailService!
    var product: Product? {
        didSet {
            self.loadProduct?()
        }
    }
    var loadProduct: (() -> Void)?
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
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var hideRefreshing: (() -> Void)?
    var showError: ((String) -> Void)?
    
    init(productDetailService: ProductDetailService = ProductDetailService()) {
        self.productDetailService = productDetailService
    }
    
    func addOneQuantity() {
        product?.quantity += 1
        canSubtractQuantity = true
        updateQuantityView?()
    }
    
    func subtractOneQuantity() {
        product?.quantity -= 1
        if canSubtractQuantity {
            updateQuantityView?()
        }
        if product?.quantity == 1 {
            canSubtractQuantity = false
        }
    }
    
    func fetchProduct(id: Int, isRefresh: Bool = false) {
        if !isRefresh {
            self.showLoading?()
        }
        
        productDetailService.fetchProduct(id: id) { [weak self] result in
            DispatchQueue.main.async {
                if !isRefresh {
                    self?.hideLoading?()
                } else {
                    self?.hideRefreshing?()
                }
                switch result {
                case .success(let product):
                    self?.product = product
                case .failure(let error):
                    let _ = error
                }
            }
        }
    }
}
