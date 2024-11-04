//
//  GroupProduct.swift
//  nectar-online
//
//  Created by Macbook on 01/11/2024.
//

import Foundation

class CategoryProduct: Decodable {
    var id: Int
    var name: String
    var color: String
    var image: Image
    
    init(id: Int, name: String, color: String, image: Image) {
        self.id = id
        self.name = name
        self.color = color
        self.image = image
    }
    
    // Custom decoding initializer to conform to Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        color = try container.decode(String.self, forKey: .color)
        image = try container.decode(Image.self, forKey: .image)
    }
    
    // Coding keys to map JSON keys to properties
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case color = "color"
        case image = "image"
    }
}
