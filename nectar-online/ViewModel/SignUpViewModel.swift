//
//  SignUpViewModel.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import Foundation

class SignUpViewModel {
    private var signUpService: SignUpService!
    var signUpSuccess: (() -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var showError: ((String) -> Void)?
    
    init(signUpService: SignUpService = SignUpService()) {
        self.signUpService = signUpService
    }
    
    func sendDataSignUp(data: [String: Any]) {
        showLoading?()
        
        signUpService.sendDataSignUp(data: data) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.hideLoading?()
                if success {
                    self?.signUpSuccess?()
                } else {
                    self?.showError?(error?.localizedDescription ?? "Error")
                }
            }
        }
    }
}
