//
//  CallAPI.swift
//  nectar-online
//
//  Created by Macbook on 30/10/2024.
//

import Foundation

class CallAPI {
    init() {
        self.fetchData()
    }
    
    private func fetchData() {
        let urlString = "http://192.168.0.103:8000/api/zones"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Lỗi gọi API:", error)
                return
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Dữ liệu JSON:", json)
                } catch {
                    print("Lỗi khi parse JSON:", error)
                }
            }
        }
        task.resume()
    }
}

let test = CallAPI()
