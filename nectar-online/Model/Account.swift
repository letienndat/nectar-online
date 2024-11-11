//
//  Account.swift
//  nectar-online
//
//  Created by Macbook on 11/11/2024.
//

import Foundation

class Account: Decodable {
    let image: Image
    let username: String
    let email: String
    
    init() {
        self.image = Image()
        self.username = ""
        self.email = ""
    }
    
    init(image: Image, username: String, email: String) {
        self.image = image
        self.username = username
        self.email = email
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        image = try container.decode(Image.self, forKey: .image)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case image = "image"
        case username = "username"
        case email = "email"
    }
}
