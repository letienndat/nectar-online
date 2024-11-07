//
//  FavoriteProduct.swift
//  nectar-online
//
//  Created by Macbook on 07/11/2024.
//

import Foundation

class FavoriteProductResponse: Decodable {
    let isFavorite: Bool
    
    // Custom initializer
    init(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case isFavorite = "is_favorite"
    }
}
