//
//  SelectLocationService.swift
//  nectar-online
//
//  Created by Macbook on 30/10/2024.
//

import Foundation

class SelectLocationService {
    private let session: URLSession
    
    init() {
        // Tạo URLSessionConfiguration và đặt thời gian chờ cho request
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // Thời gian chờ request
        configuration.timeoutIntervalForResource = 20 // Thời gian chờ tải tài nguyên
        
        session = URLSession(configuration: configuration)
    }
    
    func fetchZones(completion: @escaping (Result<[Zone], Error>) -> Void) {
        let urlString = "\(Const.BASE_URL)/zones"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = self.session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let coder = JSONDecoder()
                let zones = try coder.decode([Zone].self, from: data)
                completion(.success(zones))
            } catch {
                completion(.failure(error))
            }
        }
        // Thực thi task
        task.resume()
    }
}
