//
//  ConfigApp.swift
//  nectar-online
//
//  Created by Macbook on 02/11/2024.
//

import Foundation

// Biến toàn cục để lưu trạng thái lần đầu mở ứng dụng
struct AppConfig {
    static var isFirstLaunch: Bool {
        get {
            // Kiểm tra nếu giá trị chưa được lưu, mặc định là true
            if UserDefaults.standard.object(forKey: "isFirstLaunch") == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: "isFirstLaunch")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFirstLaunch")
        }
    }
    
    static var isLogin: Bool {
        get {
            // Kiểm tra nếu giá trị chưa được lưu, mặc định là true
            if UserDefaults.standard.object(forKey: "isLogin") == nil {
                return false
            }
            return UserDefaults.standard.bool(forKey: "isLogin")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLogin")
        }
    }
}
