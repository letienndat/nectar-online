//
//  Cart.swift
//  nectar-online
//
//  Created by Macbook on 10/11/2024.
//

import Foundation

class Cart: Decodable {
    var totalPrice: Double {
        didSet {
            self.updateTotalPrice?()
        }
    }
    var products: [Product] = [] {
        didSet {
            self.updateProducts?()
        }
    }
    
    var updateTotalPrice: (() -> Void)?
    var updateProducts: (() -> Void)?
    
    init() {
        self.totalPrice = 0
        self.products = []
    }
    
    // Custom initializer
    init(totalPrice: Double, products: [Product]) {
        self.totalPrice = totalPrice
        self.products = products
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalPrice = try container.decode(Double.self, forKey: .totalPrice)
        products = try container.decode([Product].self, forKey: .products)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case products = "products"
    }
    
    // Phương thức cập nhật thủ công
    func updateCart(totalPrice: Double, products: [Product]) {
        self.totalPrice = totalPrice
        self.products = products
    }
}
