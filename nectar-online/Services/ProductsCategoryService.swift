//
//  TypeExploreService.swift
//  nectar-online
//
//  Created by Macbook on 01/11/2024.
//

import Foundation

class ProductsCategoryService {
    
    private let session: URLSession
    
    init() {
        // Tạo URLSessionConfiguration và đặt thời gian chờ cho request
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // Thời gian chờ request
        configuration.timeoutIntervalForResource = 20 // Thời gian chờ tải tài nguyên
        
        session = URLSession(configuration: configuration)
    }
    
    func fetchListProductCategory(id: Int, completion: @escaping (Result<ProductCategory, Error>) -> Void) {
        guard let url = URL(string: "\(Const.BASE_URL)/product/category/\(id)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Tạo task để gửi request
        let task = self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Lỗi khi gửi request: \(error)")
                completion(.failure(error))
                return
            }
            
            // Kiểm tra response và status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let coder = JSONDecoder()
                let response = try coder.decode(Response<ProductCategory>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    completion(.success(response.data ?? ProductCategory()))
                }
            } catch {
                completion(.failure(error))
                
                print(error)
            }
        }
        // Thực thi task
        task.resume()
    }
}
