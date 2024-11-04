//
//  HomeScreenService.swift
//  nectar-online
//
//  Created by Macbook on 02/11/2024.
//

import Foundation

class HomeScreenService {
    public static let shared = HomeScreenService()
    private let session: URLSession
    
    init() {
        // Tạo URLSessionConfiguration và đặt thời gian chờ cho request
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // Thời gian chờ request
        configuration.timeoutIntervalForResource = 20 // Thời gian chờ tải tài nguyên
        
        session = URLSession(configuration: configuration)
    }
    
    func fetchProductClassifications(completion: @escaping (Result<[ProductClassification], Error>) -> Void) {
        guard let url = URL(string: "\(Const.BASE_URL)/product-classifications") else {
            return
        }
        
        // Tạo task để gửi request
        let task = self.session.dataTask(with: url) { data, response, error in
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
                let response = try coder.decode(Response<[ProductClassification]>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    completion(.success(response.data ?? []))
                }
            } catch {
                completion(.failure(error))
            }
        }
        // Thực thi task
        task.resume()
    }
    
    func fetchLocation(token: String?, completion: @escaping (Result<Zone, Error>) -> Void) {
        guard let url = URL(string: "\(Const.BASE_URL)/user-location") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        print(token ?? "Null")
        
        // Thêm token JWT vào header của request
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        
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
                let response = try coder.decode(Response<Zone>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    if let zone = response.data {
                        completion(.success(zone))
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
    
    func fetchBanner(completion: @escaping (Result<[Image], Error>) -> Void) {
        guard let url = URL(string: "\(Const.BASE_URL)/banners") else {
            return
        }
        
        // Tạo task để gửi request
        let task = self.session.dataTask(with: url) { data, response, error in
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
                let response = try coder.decode(Response<[Image]>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    completion(.success(response.data ?? []))
                }
            } catch {
                completion(.failure(error))
            }
        }
        // Thực thi task
        task.resume()
    }
    
    func search(keyword: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "\(Const.BASE_URL)/search?keyword=\(keyword)") else {
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
                let response = try coder.decode(Response<[Product]>.self, from: data)
                
                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fail"])))
                    return
                } else if response.status == 1 {
                    if let products = response.data {
                        completion(.success(products))
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
}
