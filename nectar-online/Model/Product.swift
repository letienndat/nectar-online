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
    var quantity: Int = 1 {
        didSet {
            if quantity < 1 {
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
    var review: Double {
        didSet {
            self.updateReview?()
        }
    }
    var rating: Int {
        didSet {
            self.updateRating?()
        }
    }
    let sold: Int
    let stock: Int
    var isFavorite: Bool = false
    let category: Category
    let thumbnail: Image
    let images: [Image]
    
    var updateReview: (() -> Void)?
    var updateRating: (() -> Void)?
    
    init() {
        self.id = 0
        self.name = ""
        self.quantity = 0
        self.description = ""
        self.unitOfMeasure = ""
        self.price = 0
        self.nutrients = ""
        self.review = 0
        self.rating = 0
        self.sold = 0
        self.stock = 0
        self.isFavorite = false
        self.category = Category()
        self.thumbnail = Image()
        self.images = []
    }
    
    // Custom initializer matching all properties
    init(id: Int, name: String, quantity: Int = 1, description: String, unitOfMeasure: String, price: Double, nutrients: String, review: Double, rating: Int, sold: Int, stock: Int, isFavorite: Bool = false, category: Category, thumbnail: Image, images: [Image]) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.description = description
        self.unitOfMeasure = unitOfMeasure
        self.price = price
        self.nutrients = nutrients
        self.review = review
        self.rating = rating
        self.sold = sold
        self.stock = stock
        self.isFavorite = isFavorite
        self.category = category
        self.thumbnail = thumbnail
        self.images = images
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity) ?? 1
        description = try container.decode(String.self, forKey: .description)
        unitOfMeasure = try container.decode(String.self, forKey: .unitOfMeasure)
        price = try container.decode(Double.self, forKey: .price)
        nutrients = try container.decode(String.self, forKey: .nutrients)
        review = try container.decode(Double.self, forKey: .review)
        rating = try container.decode(Int.self, forKey: .rating)
        sold = try container.decode(Int.self, forKey: .sold)
        stock = try container.decode(Int.self, forKey: .stock)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        category = try container.decode(Category.self, forKey: .category)
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
        case review = "review"
        case rating = "rating"
        case sold = "sold"
        case stock = "stock"
        case isFavorite = "is_favorite"
        case category = "category"
        case thumbnail = "thumbnail"
        case images = "images"
    }
}

class Category: Decodable {
    let id: Int
    let name: String
    
    init() {
        self.id = 0
        self.name = ""
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
