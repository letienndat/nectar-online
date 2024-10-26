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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        .null
    }
}
