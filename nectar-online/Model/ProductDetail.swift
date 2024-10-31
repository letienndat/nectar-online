//
//  ProductDetail.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import Foundation

class ProductDetail {
    var price: Double {
        didSet {
            if price < 0 {
                price = 0
            }
        }
    }
    
    var quantity: UInt {
        didSet {
            if quantity < 1 {
                quantity = 1
            }
        }
    }
    
    init() {
        self.quantity = 1
        self.price = 0
    }
}
