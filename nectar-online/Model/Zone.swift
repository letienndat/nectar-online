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
    
    init(id: Int, name: String, areas: [Area]) {
        self.id = id
        self.name = name
        self.areas = areas
    }
}
