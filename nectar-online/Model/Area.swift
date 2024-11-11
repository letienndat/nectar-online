//
//  Area.swift
//  nectar-online
//
//  Created by Macbook on 30/10/2024.
//

import Foundation

class Area: Decodable {
    let id: Int
    let name: String
    
    init() {
        self.id = 0
        self.name = ""
    }
    
    // Custom initializer
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

