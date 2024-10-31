//
//  LoginViewModel.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import Foundation

class LoginViewModel {
    static let shared = LoginViewModel()
    private var loginService: LoginService!
    var loginSuccess: (() -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var showError: ((String) -> Void)?
    
    init(loginService: LoginService = LoginService()) {
        self.loginService = loginService
    }
    
    func sendDataLogin(data: [String: Any]) {
        showLoading?()
        
        loginService.sendDataLogin(data: data) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.hideLoading?()
                if success {
                    self?.loginSuccess?()
                } else {
                    self?.showError?(error?.localizedDescription ?? "Error")
                }
            }
        }
    }
}
