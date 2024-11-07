//
//  LoginService.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import Foundation

class LoginService {
    private let session: URLSession
    
    init() {
        // Tạo URLSessionConfiguration và đặt thời gian chờ cho request
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // Thời gian chờ request
        configuration.timeoutIntervalForResource = 20 // Thời gian chờ tải tài nguyên
        
        session = URLSession(configuration: configuration)
    }
    
    func sendDataLogin(data: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(Const.BASE_URL)/auth/login") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                let httpResponse = response as? HTTPURLResponse
                if httpResponse?.statusCode == 401 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Incorrect login information"])))
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
                let response = try coder.decode(Response<TokenResponse>.self, from: data)

                if response.status == 0 {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message ?? "Error"])))
                    return
                } else if response.status == 1 {
                    // Kiểm tra xem response.data có giá trị hay không
                    let loginResponse = response.data
                    
                    // Giả sử loginResponse có thuộc tính token
                    if let token = loginResponse?.token {
                        completion(.success(token))
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Token not found"])))
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
