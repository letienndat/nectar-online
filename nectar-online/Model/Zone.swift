//
//  Zone.swift
//  nectar-online
//
//  Created by Macbook on 30/10/2024.
//

import Foundation

class Zone: Decodable {
    let id: Int
    let name: String
    let areas: [Area]
    
    init() {
        self.id = 0
        self.name = ""
        self.areas = []
    }
    
    // Custom initializer
    init(id: Int, name: String, areas: [Area]) {
        self.id = id
        self.name = name
        self.areas = areas
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        areas = try container.decode([Area].self, forKey: .areas)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case areas = "areas"
    }
}

