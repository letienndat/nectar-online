//
//  RemoveProductInCartResponse.swift
//  nectar-online
//
//  Created by Macbook on 11/11/2024.
//

import Foundation

class RemoveProductInCartResponse: Decodable {
    let totalProduct: Int
    let totalPrice: Double
    
    init(totalProduct: Int, totalPrice: Double) {
        self.totalProduct = totalProduct
        self.totalPrice = totalPrice
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalProduct = try container.decode(Int.self, forKey: .totalProduct)
        totalPrice = try container.decode(Double.self, forKey: .totalPrice)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case totalProduct = "total_product"
        case totalPrice = "total_price"
    }
}
