//
//  TypeExploreViewModel.swift
//  nectar-online
//
//  Created by Macbook on 01/11/2024.
//

import Foundation

class ProductsCategoryViewModel {
    private let productsCategoryService: ProductsCategoryService!
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
}
