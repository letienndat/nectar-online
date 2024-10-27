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

class PaddedTextField: UITextField {
    var leftPadding: CGFloat = 0
    var rightPadding: CGFloat = 0
    var leftViewPadding: CGFloat = 0
    var rightViewPadding: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // Tính toán padding cho leftView và nội dung văn bản
        let leftInset = leftPadding + (leftView?.frame.width ?? 0) + leftViewPadding
        let rightInset = rightPadding + (rightView?.frame.width ?? 0) + rightViewPadding
        
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        // Sử dụng cùng một logic cho trạng thái chỉnh sửa
        return textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        // Đảm bảo placeholder cũng có padding
        return textRect(forBounds: bounds)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        // Tính toán vị trí cho leftView để có padding
        var leftViewRect = CGRect.zero
        if let leftView = leftView {
            leftViewRect.size = leftView.sizeThatFits(bounds.size)
            leftViewRect.origin = CGPoint(x: leftPadding, y: (bounds.height - leftViewRect.height) / 2) // Căn giữa theo chiều dọc
        }
        return leftViewRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        // Tính toán vị trí cho rightView tương tự
        var rightViewRect = CGRect.zero
        if let rightView = rightView {
            rightViewRect.size = rightView.sizeThatFits(bounds.size)
            rightViewRect.origin = CGPoint(x: bounds.width - rightViewRect.width - rightPadding, y: (bounds.height - rightViewRect.height) / 2) // Căn giữa theo chiều dọc
        }
        return rightViewRect
    }
}
