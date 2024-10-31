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
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
