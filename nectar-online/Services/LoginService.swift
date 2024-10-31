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
    
    func sendDataLogin(data: [String: Any], completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(Const.BASE_URL)/login") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Chuyển đổi dữ liệu sang JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            print("Lỗi khi chuyển đổi dữ liệu sang JSON:", error)
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
            
            // Kiểm tra phản hồi từ server
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(true, nil)
            } else {
                let responseError = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
                completion(false, responseError)
            }
        }
        // Thực thi task
        task.resume()
    }
}
