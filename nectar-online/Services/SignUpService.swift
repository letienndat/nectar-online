//
//  SignUpService.swift
//  nectar-online
//
//  Created by Macbook on 31/10/2024.
//

import Foundation

class SignUpService {
    private let session: URLSession
    
    init() {
        // Tạo URLSessionConfiguration và đặt thời gian chờ cho request
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // Thời gian chờ request
        configuration.timeoutIntervalForResource = 20 // Thời gian chờ tải tài nguyên
        
        session = URLSession(configuration: configuration)
    }
    
    func sendDataSignUp(data: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(Const.BASE_URL)/register") else {
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
            completion(false, error)
            return
        }
        
        // Tạo task để gửi request
        let task = self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Lỗi khi gửi request: \(error)")
                completion(false, error)
                return
            }
            
            // Kiểm tra response và status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"]))
                return
            }
            
            guard let data = data else {
                completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"]))
                return
            }
            
            do {
                let coder = JSONDecoder()
                let response = try coder.decode(Response<NullResponse>.self, from: data)
                
                if response.status == 0 {
                    completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message ?? "Error"]))
                    return
                } else if response.status == 1 {
                    completion(true, nil)
                }
            } catch {
                completion(false, error)
            }
        }
        // Thực thi task
        task.resume()
    }
}
