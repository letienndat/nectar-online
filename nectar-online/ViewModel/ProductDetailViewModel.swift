//
//  ProductDetailViewModel.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import Foundation

class ProductDetailViewModel {
    var productDetailService: ProductDetailService!
    private let homeScreenService: HomeScreenService = HomeScreenService.shared
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
    var closureFavoriteProductSuccess: ((Bool) -> Void)?
    var closureFavoriteProductFail: ((String) -> Void)?
    var closureNoAccess: (() -> Void)?
    var closureAddProductToCartSuccess: ((Int) -> Void)?
    var closureAddProductToCartFail: ((String) -> Void)?
    var closureRatingProductSuccess: ((Double, Int) -> Void)?
    var closureRatingProductFail: ((String) -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var hideRefreshing: (() -> Void)?
    var showError: ((String) -> Void)?
    var ratingTemp: Int = 0
    
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
    
    func favoriteProduct(productId: Int) {
        self.showLoading?()
        
        let token = getToken(for: Const.KEYCHAIN_TOKEN)
        
        self.productDetailService.favoriteProduct(token: token, productId: productId) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.hideLoading?()
                
                switch result {
                case .success(let isFavorite):
                    self.closureFavoriteProductSuccess?(isFavorite)
                case .failure(let error):
                    let error = error as NSError
                    if error.code == 401 {
                        self.closureNoAccess?()
                    } else {
                        self.closureFavoriteProductFail?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func ratingProduct(data: [String: Int]) {
        self.showLoading?()
        
        let token = getToken(for: Const.KEYCHAIN_TOKEN)
        
        self.productDetailService.ratingProduct(token: token, data: data) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.hideLoading?()
                
                switch result {
                case .success(let ratingResponse):
                    self.closureRatingProductSuccess?(ratingResponse.review, ratingResponse.rating)
                case .failure(let error):
                    let error = error as NSError
                    if error.code == 401 {
                        self.closureNoAccess?()
                    } else {
                        self.closureRatingProductFail?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func addProductToCart(data: [[String: Any]]) {
        self.showLoading?()
        
        let token = getToken(for: Const.KEYCHAIN_TOKEN)
        
        self.homeScreenService.addProductToCart(token: token, data: data) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.hideLoading?()
                
                switch result {
                case .success(let totalProduct):
                    self.closureAddProductToCartSuccess?(totalProduct)
                case .failure(let error):
                    let error = error as NSError
                    if error.code == 401 {
                        self.closureNoAccess?()
                    } else {
                        self.closureAddProductToCartFail?(error.localizedDescription)
                    }
                }
            }
        }
    }
}
