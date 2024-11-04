//
//  Response.swift
//  nectar-online
//
//  Created by Macbook on 01/11/2024.
//

import Foundation

class Response<T: Decodable>: Decodable {
    let status: Int
    let message: String?
    let data: T?
    
    init(status: Int, message: String?, data: T?) {
        self.status = status
        self.message = message
        self.data = data
    }
}
