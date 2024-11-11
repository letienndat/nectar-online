//
//  Banner.swift
//  nectar-online
//
//  Created by Macbook on 02/11/2024.
//

import Foundation

class Image: Decodable {
    var id: Int
    var title: String
    var imageUrl: String
    
    init() {
        self.id = 0
        self.title = ""
        self.imageUrl = ""
    }
    
    init(id: Int, title: String, imageUrl: String) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case imageUrl = "image_url"
    }
}
