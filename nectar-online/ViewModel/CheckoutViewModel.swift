//
//  CheckoutViewModel.swift
//  nectar-online
//
//  Created by Macbook on 12/11/2024.
//

import Foundation

class CheckoutViewModel {
    private let checkoutService: CheckoutService!
    var totalCost: Double
    
    let optionsViewCheckout: [OptionViewCheckout] = [
        OptionViewCheckout(title: "Orders", textRight: "Select Method", imageRight: nil),
        OptionViewCheckout(title: "Pament", textRight: nil, imageRight: "payment-card"),
        OptionViewCheckout(title: "Promo Code", textRight: "Pick discount", imageRight: nil),
        OptionViewCheckout(title: "Total Cost", textRight: nil, imageRight: nil, isChange: true),
   ]
    
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?
    var showError: ((String) -> Void)?
    var closureOrderSuccess: (() -> Void)?
    var closureOrderFail: (() -> Void)?
    var closureNoAccess: (() -> Void)?
    
    init(checkoutService: CheckoutService! = CheckoutService()) {
        self.checkoutService = checkoutService
        self.totalCost = 0
    }
    
    func order() {
        self.showLoading?()

        let token: String? = getToken(for: Const.KEYCHAIN_TOKEN)

        self.checkoutService.order(token: token) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.hideLoading?()

                switch result {
                case .success(_):
                    self.closureOrderSuccess?()
                case .failure(_):
                    self.closureOrderFail?()
                }
            }
        }
    }
}

struct OptionViewCheckout {
    let title: String
    let textRight: String?
    let imageRight: String?
    var isChange: Bool = false
}
