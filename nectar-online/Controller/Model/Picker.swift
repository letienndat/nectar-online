//
//  Picker.swift
//  nectar-online
//
//  Created by Macbook on 30/10/2024.
//

import Foundation

class Picker {
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    convenience init(from zone: Zone) {
        self.init(id: String(zone.id), name: zone.name)
    }
    
    convenience init(from area: Area) {
        self.init(id: String(area.id), name: area.name)
    }
}
