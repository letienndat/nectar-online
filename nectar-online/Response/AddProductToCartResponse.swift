//
//  AddProductToCartResponse.swift
//  nectar-online
//
//  Created by Macbook on 07/11/2024.
//

import Foundation

class AddProductToCartResponse: Decodable {
    let totalProduct: Int
    
    // Custom initializer
    init(totalProduct: Int) {
        self.totalProduct = totalProduct
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalProduct = try container.decode(Int.self, forKey: .totalProduct)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case totalProduct = "total_product"
    }
}
