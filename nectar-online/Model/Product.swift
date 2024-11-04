//
//  Product.swift
//  nectar-online
//
//  Created by Macbook on 01/11/2024.
//

import Foundation

class Product: Decodable {
    let id: Int
    let name: String
    var quantity: UInt = 1 {
        didSet {
            if quantity == 0 {
                quantity = 1
            }
        }
    }
    let description: String
    let unitOfMeasure: String
    var price: Double {
        didSet {
            if price < 0 {
                price = 0
            }
        }
    }
    let nutrients: String
    var rating: Int {
        didSet {
            self.updateRating?()
        }
    }
    let sold: Int
    let stock: Int
    let categoryId: Int
    let thumbnail: Image
    let images: [Image]
    
    var updateRating: (() -> Void)?
    
    // Custom initializer matching all properties
    init(id: Int, name: String, quantity: UInt = 1, description: String, unitOfMeasure: String, price: Double, nutrients: String, rating: Int, sold: Int, stock: Int, categoryId: Int, thumbnail: Image, images: [Image]) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.description = description
        self.unitOfMeasure = unitOfMeasure
        self.price = price
        self.nutrients = nutrients
        self.rating = rating
        self.sold = sold
        self.stock = stock
        self.categoryId = categoryId
        self.thumbnail = thumbnail
        self.images = images
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        quantity = try container.decode(UInt.self, forKey: .quantity)
        description = try container.decode(String.self, forKey: .description)
        unitOfMeasure = try container.decode(String.self, forKey: .unitOfMeasure)
        price = try container.decode(Double.self, forKey: .price)
        nutrients = try container.decode(String.self, forKey: .nutrients)
        rating = try container.decode(Int.self, forKey: .rating)
        sold = try container.decode(Int.self, forKey: .sold)
        stock = try container.decode(Int.self, forKey: .stock)
        categoryId = try container.decode(Int.self, forKey: .categoryId)
        thumbnail = try container.decode(Image.self, forKey: .thumbnail)
        images = try container.decode([Image].self, forKey: .images)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case quantity = "quantity"
        case description = "description"
        case unitOfMeasure = "unit_of_measure"
        case price = "price"
        case nutrients = "nutrients"
        case rating = "rating"
        case sold = "sold"
        case stock = "stock"
        case categoryId = "category_id"
        case thumbnail = "thumbnail"
        case images = "images"
    }
}
