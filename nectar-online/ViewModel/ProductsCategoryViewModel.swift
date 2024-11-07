//
//  TypeExploreViewModel.swift
//  nectar-online
//
//  Created by Macbook on 01/11/2024.
//

import Foundation

class ProductsCategoryViewModel {
    private let productsCategoryService: ProductsCategoryService!
    private let homeScreenService: HomeScreenService = HomeScreenService.shared
    var listProductCategory: [Product] = DataTest.listProductCategory {
        didSet {
            self.updateListProductCategory?()
        }
    }
    var updateListProductCategory: (() -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var hideRefreshing: (() -> Void)?
    var showError: ((String) -> Void)?
    var closureAddProductToCartSuccess: ((Int) -> Void)?
    var closureAddProductToCartFail: ((String) -> Void)?
    var closureNoAccess: (() -> Void)?
    
    init(productsCategoryService: ProductsCategoryService = ProductsCategoryService()) {
        self.productsCategoryService = productsCategoryService
    }
    
    func fetchListProductCategory(id: Int, isRefresh: Bool = false) {
        if !isRefresh {
            self.showLoading?()
        }
        
        productsCategoryService.fetchListProductCategory(id: id) { [weak self] result in
            DispatchQueue.main.async {
                if !isRefresh {
                    self?.hideLoading?()
                } else {
                    self?.hideRefreshing?()
                }
                
                switch result {
                case .success(let listProductCategory):
                    self?.listProductCategory = listProductCategory
                case .failure(let error):
                    if !isRefresh {
                        self?.showError?(error.localizedDescription)
                    }
                    break
                }
            }
        }
    }
    
    func addProductToCart(data: [[String: Any]]) {
        
        let token = getToken(for: Const.KEYCHAIN_TOKEN)
        
        self.homeScreenService.addProductToCart(token: token, data: data) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let countProduct):
                    self.closureAddProductToCartSuccess?(countProduct)
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
