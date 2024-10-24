//
//  Implement.swift
//  nectar-online
//
//  Created by Macbook on 23/10/2024.
//

import UIKit

class DeletableTextField: UITextField, UITextFieldDelegate {

    // Closure để bắt sự kiện xóa
    var onDeleteBackward: (() -> Void)?

    override func deleteBackward() {
        super.deleteBackward()

        // Gọi closure khi người dùng nhấn nút xóa
        onDeleteBackward?()
    }
}

class CustomTextField: UITextField, UITextFieldDelegate {

    // Closure để bắt sự kiện xóa
    var onDeleteBackward: (() -> Void)?

    override func deleteBackward() {
        super.deleteBackward()

        // Gọi closure khi người dùng nhấn nút xóa
        onDeleteBackward?()
    }
    
    // Ngăn chọn văn bản
    override var selectedTextRange: UITextRange? {
        get {
            return nil // Không cho phép chọn văn bản
        }
        set {
            // Không làm gì cả
        }
    }

    // Ngăn các hành động chọn
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false // Không cho phép bất kỳ hành động nào
    }
    
    // Ngăn không cho chọn văn bản khi người dùng nhấn
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Bỏ chọn văn bản khi bắt đầu chỉnh sửa
        textField.selectedTextRange = nil
    }
}
