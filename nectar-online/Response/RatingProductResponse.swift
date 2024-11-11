//
//  RatingProductResponse.swift
//  nectar-online
//
//  Created by Macbook on 11/11/2024.
//

import Foundation

class RatingProductResponse: Decodable {
    let review: Double
    let rating: Int
    
    init() {
        self.review = 0
        self.rating = 0
    }
    
    // Custom initializer
    init(review: Double, rating: Int) {
        self.review = review
        self.rating = rating
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        review = try container.decode(Double.self, forKey: .review)
        rating = try container.decode(Int.self, forKey: .rating)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case review = "review"
        case rating = "rating"
    }
}
