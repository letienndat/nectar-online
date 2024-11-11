//
//  AccountViewModel.swift
//  nectar-online
//
//  Created by Macbook on 11/11/2024.
//

import Foundation

class AccountViewModel {
    private let accountService: AccountService!
    var account: Account = DataTest.account {
        didSet {
            self.updateAccount?()
        }
    }
    
     let optionsViewAccount: [OptionViewAccount] = [
        OptionViewAccount(icon: "icon-orders", title: "Orders"),
        OptionViewAccount(icon: "icon-my-details", title: "My Details"),
        OptionViewAccount(icon: "icon-delivery-address", title: "Delivery Address"),
        OptionViewAccount(icon: "icon-payment-methods", title: "Payment Methods"),
        OptionViewAccount(icon: "icon-promo-cord", title: "Promo Cord"),
        OptionViewAccount(icon: "icon-notifecations", title: "Notifecations"),
        OptionViewAccount(icon: "icon-help", title: "Help"),
        OptionViewAccount(icon: "icon-about", title: "About")
    ]
    
    var updateAccount: (() -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var hideRefreshing: (() -> Void)?
    var showError: ((String) -> Void)?
    var closureLogOutSuccess: (() -> Void)?
    var closureLogOutFail: ((String) -> Void)?
    var closureNoAccess: (() -> Void)?
    
    init(accountService: AccountService = AccountService()) {
        self.accountService = accountService
    }
    
    func fetchProfile(isRefresh: Bool = false) {
        if !isRefresh {
            self.showLoading?()
        }
        
        let token: String? = getToken(for: Const.KEYCHAIN_TOKEN)
        
        self.accountService.fetchProfile(token: token) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if !isRefresh {
                    self.hideLoading?()
                } else {
                    self.hideRefreshing?()
                }
                
                switch result {
                case .success(let account):
                    self.account = account
                case .failure(let error):
                    if !isRefresh {
                        self.showError?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func logout() {
        AppConfig.isLogin = false
        deleteToken(for: Const.KEYCHAIN_TOKEN)
        self.closureLogOutSuccess?()
        
//        self.showLoading?()
//
//        let token: String? = getToken(for: Const.KEYCHAIN_TOKEN)
//
//        self.accountService.logout(token: token) { [weak self] result in
//            guard let self = self else { return }
//
//            DispatchQueue.main.async {
//                self.hideLoading?()
//
//                switch result {
//                case .success(_):
//                    AppConfig.isLogin = false
//                    deleteToken(for: Const.KEYCHAIN_TOKEN)
//
//                    self.closureLogOutSuccess?()
//                case .failure(let error):
//                    self.closureLogOutFail?(error.localizedDescription)
//                }
//            }
//        }
    }
}

struct OptionViewAccount {
    let icon: String
    let title: String
}
