//
//  HomeScreenViewModel.swift
//  nectar-online
//
//  Created by Macbook on 02/11/2024.
//

import Foundation

class HomeScreenViewModel {
    public static let shared: HomeScreenViewModel = HomeScreenViewModel()
    private let homeScreenService = HomeScreenService.shared
    var productClassifications: [ProductClassification] = DataTest.productClassifications {
        didSet {
            self.updateProductClassifications?()
        }
    }
    var updateProductClassifications: (() -> Void)?
    var location: Zone = DataTest.location {
        didSet {
            self.updateLocation?()
        }
    }
    var updateLocation: (() -> Void)?
    var banners: [Image] = DataTest.imageBanner {
        didSet {
            self.updateBanners?()
        }
    }
    var listProductSearch: [Product] = DataTest.listProductSearch {
        didSet {
            self.updateListProductSearch?()
        }
    }
    var updateListProductSearch: (() -> Void)?
    var updateBanners: (() -> Void)?
    var signUpSuccess: (() -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var hideRefreshing: (() -> Void)?
    var showError: ((String) -> Void)?
    var showErrorSearch: ((String) -> Void)?
    private var debounceTimer: DispatchWorkItem?
    private let debounceInterval: TimeInterval = 0.5  // thời gian trễ để thực hiện tìm kiếm
    
    func fetchLocation() {
        guard AppConfig.isLogin else { return }
        let token: String? = getToken(for: Const.KEYCHAIN_TOKEN)
        
        homeScreenService.fetchLocation(token: token) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let location):
                    self?.location = location
                case .failure(let error):
                    let _ = error
                }
            }
        }
    }
    
    func fetchBanner() {
        homeScreenService.fetchBanner { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let banners):
                    self?.banners = banners
                case .failure(let error):
                    let _ = error
                }
            }
        }
    }
    
    func fetchProductClassifications(reload: Bool = false) {
        if !reload {
            self.showLoading?()
        }
        
        homeScreenService.fetchProductClassifications { [weak self] result in
            DispatchQueue.main.async {
                if !reload {
                    self?.hideLoading?()
                } else {
                    self?.hideRefreshing?()
                }
                
                switch result {
                case .success(let productClassifications):
                    self?.productClassifications = productClassifications
                case .failure(let error):
                    if !reload {
                        self?.showError?(error.localizedDescription)
                    }
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
}
