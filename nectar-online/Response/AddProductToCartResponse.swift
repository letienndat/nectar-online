//
//  AddProductToCartResponse.swift
//  nectar-online
//
//  Created by Macbook on 07/11/2024.
//

import Foundation

class AddProductToCartResponse: Decodable {
    let countProduct: Int
    
    // Custom initializer
    init(countProduct: Int) {
        self.countProduct = countProduct
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        countProduct = try container.decode(Int.self, forKey: .countProduct)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case countProduct = "count_product"
    }
}
