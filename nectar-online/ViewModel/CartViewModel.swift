//
//  CartViewModel.swift
//  nectar-online
//
//  Created by Macbook on 09/11/2024.
//

import Foundation

class CartViewModel {
    private let cartService: CartService!
    var cart: Cart? = Cart()
    var updateProducts: (() -> Void)?
    var updateTotalPrice: ((Double) -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var hideRefreshing: (() -> Void)?
    var showError: ((String) -> Void)?
    var closureNoAccess: (() -> Void)?
    var closureChangeQuantity: ((Int, Int, Int, Double) -> Void)?
    var closureRemoveProduct: ((Int) -> Void)?
    
    init(cartService: CartService = CartService()) {
        self.cartService = cartService
        
        self.cart?.updateTotalPrice = { [weak self] in
            guard let self = self else { return }
            
            self.updateTotalPrice?(self.cart?.totalPrice ?? 0)
        }
        
        self.cart?.updateProducts = { [weak self] in
            guard let self = self else { return }
            
            self.updateProducts?()
        }
    }
    
    func fetchCart(isRefresh: Bool = false) {
        if !isRefresh {
            self.showLoading?()
        }
        
        let token: String? = getToken(for: Const.KEYCHAIN_TOKEN)
        
        self.cartService.fetchCart(token: token) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if !isRefresh {
                    self.hideLoading?()
                } else {
                    self.hideRefreshing?()
                }
                
                switch result {
                case .success(let cart):
                    self.cart?.updateCart(totalPrice: cart.totalPrice, products: cart.products)
                case .failure(let error):
                    if !isRefresh {
                        self.showError?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func changeQuantity(data: [String: Int]) {
        
        let productId = data["product_id"]!
        
        guard let quantity = self.cart?.products.first(where: { $0.id == productId })?.quantity else { return }
        guard let method = data.values.first else { return }
        if method == 0 && quantity <= 1 { return }
        
        self.showLoading?()
        
        let token: String? = getToken(for: Const.KEYCHAIN_TOKEN)
        
        self.cartService.changeQuantity(token: token, data: data) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.hideLoading?()

                switch result {
                case .success(let updateQuantityResponse):

                    if self.cart != nil {
                        let productViewModel = self.cart!.products.first(where: { $0.id == productId })
                        let productFromServer = updateQuantityResponse.product

                        guard let productViewModel = productViewModel else { return }

                        guard productId == productFromServer.id, productViewModel.id == productFromServer.id else { return }

                        productViewModel.quantity = productFromServer.quantity
                        self.cart?.totalPrice = updateQuantityResponse.totalPrice

                        self.closureChangeQuantity?(productId, method, productFromServer.quantity, productViewModel.price)
                    }
                case .failure(let error):
                    self.showError?(error.localizedDescription)
                }
            }
        }
    }
    
    func removeProduct(data: [String: Int]) {
        
        self.showLoading?()
        
        let productId = data["product_id"]!
        
        let token: String? = getToken(for: Const.KEYCHAIN_TOKEN)
        
        self.cartService.removeProduct(token: token, data: data) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.hideLoading?()

                switch result {
                case .success(let cart):

                    if self.cart != nil {
                        let index = self.cart?.products.firstIndex(where: { $0.id == productId })
                        self.cart?.products.remove(at: index ?? -1)

                        self.cart?.totalPrice = cart.totalPrice

                        self.closureRemoveProduct?(index ?? -1)
                    }
                case .failure(let error):
                    self.showError?(error.localizedDescription)
                }
            }
        }
    }
}
