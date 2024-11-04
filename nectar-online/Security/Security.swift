//
//  Security.swift
//  nectar-online
//
//  Created by Macbook on 02/11/2024.
//

import Foundation
import Security

func saveToken(token: String, for account: String) {
    let data = token.data(using: .utf8)!
    
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account,
        kSecValueData as String: data
    ]
    
    // Xóa token cũ nếu có
    SecItemDelete(query as CFDictionary)
    
    // Lưu token mới
    SecItemAdd(query as CFDictionary, nil)
}

func getToken(for account: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account,
        kSecReturnData as String: kCFBooleanTrue!,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    if status == errSecSuccess {
        if let data = item as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        }
    }
    
    return nil
}

func deleteToken(for account: String) {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account
    ]
    SecItemDelete(query as CFDictionary)
}
