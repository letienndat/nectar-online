//
//  UpdateQuantityProductInCartResponse.swift
//  nectar-online
//
//  Created by Macbook on 11/11/2024.
//

import Foundation

class UpdateQuantityProductInCartResponse: Decodable {
    let totalProduct: Int
    let totalPrice: Double
    let product: Product
    
    init(totalProduct: Int, totalPrice: Double, product: Product) {
        self.totalProduct = totalProduct
        self.totalPrice = totalPrice
        self.product = product
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalProduct = try container.decode(Int.self, forKey: .totalProduct)
        totalPrice = try container.decode(Double.self, forKey: .totalPrice)
        product = try container.decode(Product.self, forKey: .product)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case totalProduct = "total_product"
        case totalPrice = "total_price"
        case product = "product"
    }
}
