//
//  SignIn.swift
//  nectar-online
//
//  Created by Macbook on 02/11/2024.
//

import Foundation

class TokenResponse: Decodable {
    let token: String
    
    // Custom initializer
    init(token: String) {
        self.token = token
    }
    
    // Decodable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
    }
    
    // Coding keys to match JSON keys
    private enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}
