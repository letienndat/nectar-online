//
//  SelectLocationViewModel.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import Foundation

class SelectLocationViewModel {
    static let shared = SelectLocationViewModel()
    private var selectLocationService: SelectLocationService!
    var zones: [Zone]?// = DataTest.zones
    var updateUI: (() -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var hideRefreshing: (() -> Void)?
    var showError: ((String) -> Void)?
    var idZone: Int?
    var idArea: Int?
    
    init (selectLocationService: SelectLocationService = SelectLocationService()) {
        self.selectLocationService = selectLocationService
    }
    
    func fetchData(isRefresh: Bool = false) {
        if !isRefresh {
            self.showLoading?()
        }
        
        selectLocationService.fetchZones { [weak self] result in
            DispatchQueue.main.async {
                if !isRefresh {
                    self?.hideLoading?()
                } else {
                    self?.hideRefreshing?()
                }
                
                switch result {
                case .success(let zones):
                    self?.zones = zones
                    self?.updateUI?()
                case .failure(let error):
                    if !isRefresh {
                        self?.showError?(error.localizedDescription)
                    }
                }
            }
        }
    }
}
