//
//  GroupProductViewModel.swift
//  nectar-online
//
//  Created by Macbook on 01/11/2024.
//

import Foundation

class ExploreViewModel {
    private let exploreService: ExploreService!
    private let homeScreenService = HomeScreenService.shared
    var listCategoryProduct: [CategoryProduct] = [] {
        didSet {
            self.updateListCategoryProduct?()
        }
    }
    var updateListCategoryProduct: (() -> Void)?
    var listProductSearch: [Product] = [] {
        didSet {
            self.updateListProductSearch?()
        }
    }
    var updateListProductSearch: (() -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var hideRefreshing: (() -> Void)?
    var showError: ((String) -> Void)?
    var showErrorSearch: ((String) -> Void)?
    var closureAddProductToCartSuccess: ((Int) -> Void)?
    var closureAddProductToCartFail: ((String) -> Void)?
    var closureNoAccess: (() -> Void)?
    private var debounceTimer: DispatchWorkItem?
    private let debounceInterval: TimeInterval = 0.5  // thời gian trễ để thực hiện tìm kiếm
    
    init(exploreService: ExploreService = ExploreService()) {
        self.exploreService = exploreService
    }
    
    func fetchCategoryProduct(isRefresh: Bool = false) {
        if !isRefresh {
            self.showLoading?()
        }
        
        exploreService.fetchCategoryProduct { [weak self] result in
            DispatchQueue.main.async {
                if !isRefresh {
                    self?.hideLoading?()
                } else {
                    self?.hideRefreshing?()
                }
                
                switch result {
                case .success(let listCategoryProduct):
                    self?.listCategoryProduct = listCategoryProduct
                case .failure(let error):
                    if !isRefresh {
                        self?.showError?(error.localizedDescription)
                    }
                    break
                }
            }
        }
    }
    
    // Hàm tìm kiếm sản phẩm
    func searchProduct(keyword: String) {
        // Hủy yêu cầu trước đó nếu có
        debounceTimer?.cancel()

        // Tạo yêu cầu mới sau khoảng thời gian `debounceInterval`
        let request = DispatchWorkItem { [weak self] in
            self?.fetchProducts(keyword: keyword)
        }

        // Lưu lại yêu cầu và lên lịch thực hiện
        debounceTimer = request
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: request)
    }
    
    func fetchProducts(keyword: String) {
        
        homeScreenService.search(keyword: keyword) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.listProductSearch = products
                case .failure(let error):
                    self?.showErrorSearch?(error.localizedDescription)
                }
            }
        }
    }
    
    func testSearch(keyword: String) {
        self.listProductSearch = DataTest.listProductSearch.filter { product in
            return product.name.lowercased().trimmingCharacters(in: .whitespaces).contains(keyword.lowercased().trimmingCharacters(in: .whitespaces))
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
