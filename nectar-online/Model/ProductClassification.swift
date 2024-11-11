//
//  ProductClassification.swift
//  nectar-online
//
//  Created by Macbook on 02/11/2024.
//

import Foundation

class ProductClassification: Decodable {
    var id: Int
    var name: String
    var products: [Product]
    
    init() {
        self.id = 0
        self.name = ""
        self.products = []
    }
    
    // Custom initializer
    init(id: Int, name: String, products: [Product]) {
        self.id = id
        self.name = name
        self.products = products
    }
    
    // Custom decoding initializer to conform to Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        products = try container.decode([Product].self, forKey: .products)
    }
    
    // Coding keys to map JSON keys to properties
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case products = "products"
    }
}
