//
//  Account.swift
//  nectar-online
//
//  Created by Macbook on 11/11/2024.
//

import Foundation

class Account: Decodable {
    let username: String
    let email: String
    
    init() {
        self.username = ""
        self.email = ""
    }
    
    init(image: Image, username: String, email: String) {
        self.username = username
        self.email = email
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case email = "email"
    }
}
