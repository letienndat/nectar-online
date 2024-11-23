//
//  CartService.swift
//  nectar-online
//
//  Created by Macbook on 09/11/2024.
//

import Foundation

class CartService {
    
    private let session: URLSession
    
    init() {
        // Tạo URLSessionConfiguration và đặt thời gian chờ cho request
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // Thời gian chờ request
        configuration.timeoutIntervalForResource = 20 // Thời gian chờ tải tài nguyên
        
        session = URLSession(configuration: configuration)
    }
    
    func fetchCart(token: String?, completion: @escaping (Result<Cart ,Error>) -> Void) {
        guard let token = token else {
            AppConfig.isLogin = false
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token is empty"])))
            return
        }
        
        guard let url = URL(string: "\(Const.BASE_URL)/basket") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let coder = JSONDecoder()
                let response = try coder.decode(Response<Cart>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    let cart: Cart = response.data ?? Cart(totalPrice: 0, products: [])
                    completion(.success(cart))
                }
            } catch {
                completion(.failure(error))
            }
        }
        // Thực thi task
        task.resume()
    }
    
    func changeQuantity(token: String?, data: [String: Int], completion: @escaping (Result<UpdateQuantityProductInCartResponse ,Error>) -> Void) {
        guard let token = token else {
            AppConfig.isLogin = false
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token is empty"])))
            return
        }
        
        guard let url = URL(string: "\(Const.BASE_URL)/basket") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
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
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let coder = JSONDecoder()
                let response = try coder.decode(Response<UpdateQuantityProductInCartResponse>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    let updateQuantityProductInCartResponse: UpdateQuantityProductInCartResponse = response.data ?? UpdateQuantityProductInCartResponse(totalProduct: 0, totalPrice: 0, product: Product())
                    completion(.success(updateQuantityProductInCartResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }
        // Thực thi task
        task.resume()
    }
    
    func removeProduct(token: String?, data: [String: Int], completion: @escaping (Result<RemoveProductInCartResponse ,Error>) -> Void) {
        guard let token = token else {
            AppConfig.isLogin = false
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token is empty"])))
            return
        }
        
        guard let url = URL(string: "\(Const.BASE_URL)/basket") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let coder = JSONDecoder()
                let response = try coder.decode(Response<RemoveProductInCartResponse>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    let removeProductInCartResponse: RemoveProductInCartResponse = response.data ?? RemoveProductInCartResponse(totalProduct: 0, totalPrice: 0)
                    completion(.success(removeProductInCartResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }
        // Thực thi task
        task.resume()
    }
}
