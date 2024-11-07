//
//  ProductDetailService.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import Foundation

class ProductDetailService {
    
    private let session: URLSession
    
    init() {
        // Tạo URLSessionConfiguration và đặt thời gian chờ cho request
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // Thời gian chờ request
        configuration.timeoutIntervalForResource = 20 // Thời gian chờ tải tài nguyên
        
        session = URLSession(configuration: configuration)
    }
    
    func fetchProduct(id: Int, completion: @escaping (Result<Product, Error>) -> Void) {
        guard let url = URL(string: "\(Const.BASE_URL)/product-detail/\(id)") else {
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
                let response = try coder.decode(Response<Product>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    if let product = response.data {
                        completion(.success(product))
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not login"])))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
        // Thực thi task
        task.resume()
    }
    
    func favoriteProduct(token: String?, productId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let token = token else {
            AppConfig.isLogin = false
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token is empty"])))
            return
        }
        
        guard let url = URL(string: "\(Const.BASE_URL)/favorite-product/\(productId)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // Thêm token JWT vào header của request
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                    AppConfig.isLogin = false
                    completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access"])))
                    return
                }
                
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let coder = JSONDecoder()
                let response = try coder.decode(Response<FavoriteProductResponse>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    if let favoriteProductResponse = response.data {
                        // Yêu thích sản phẩm hoặc huỷ yêu thích sản phẩm (do đã yêu thích sản phẩm trước đó rồi
                        if favoriteProductResponse.isFavorite {
                            completion(.success(true))
                        } else {
                            completion(.success(false))
                        }
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
        // Thực thi task
        task.resume()
    }
    
    func ratingProduct(token: String?, data: [String: Int], completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let token = token else {
            AppConfig.isLogin = false
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token is empty"])))
            return
        }
        
        guard let url = URL(string: "\(Const.BASE_URL)/rating-product") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Thêm token JWT vào header của request
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Chuyển đổi dữ liệu sang JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            print("Error converting data to JSON:", error)
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Don't convert to JSON"])))
            return
        }
        
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
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                    AppConfig.isLogin = false
                    completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access"])))
                    return
                }
                
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let coder = JSONDecoder()
                let response = try coder.decode(Response<NullResponse>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    completion(.success(true))
                }
            } catch {
                completion(.failure(error))
            }
        }
        // Thực thi task
        task.resume()
    }
}
