//
//  FavoritesViewModel.swift
//  nectar-online
//
//  Created by Macbook on 11/11/2024.
//

import Foundation

class FavoriteViewModel {
    private let favoriteService: FavoriteService!
    private let homeScreenService: HomeScreenService = HomeScreenService.shared
    var productFavorites: [Product] = DataTest.productFavorites {
        didSet {
            self.updateProductFavorites?()
        }
    }
    
    var updateProductFavorites: (() -> Void)?
    var closureAddProductToCartSuccess: ((Int) -> Void)?
    var closureAddProductToCartFail: ((String) -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var hideRefreshing: (() -> Void)?
    var showError: ((String) -> Void)?
    var closureNoAccess: (() -> Void)?
    
    init(favoriteService: FavoriteService = FavoriteService()) {
        self.favoriteService = favoriteService
    }
    
    func fetchProductFavorites(isRefresh: Bool = false) {
        if !isRefresh {
            self.showLoading?()
        }
        
        let token: String? = getToken(for: Const.KEYCHAIN_TOKEN)
        
        self.favoriteService.fetchProductFavorites(token: token) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if !isRefresh {
                    self.hideLoading?()
                } else {
                    self.hideRefreshing?()
                }
                
                switch result {
                case .success(let productFavorites):
                    self.productFavorites = productFavorites
                case .failure(let error):
                    if !isRefresh {
                        self.showError?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func addProductsToCart(data: [[String: Any]]) {
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
