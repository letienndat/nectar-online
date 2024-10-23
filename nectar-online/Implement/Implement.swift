//
//  Implement.swift
//  nectar-online
//
//  Created by Macbook on 23/10/2024.
//

import UIKit

class DeletableTextField: UITextField {

    // Closure để bắt sự kiện xóa
    var onDeleteBackward: (() -> Void)?

    override func deleteBackward() {
        super.deleteBackward()

        // Gọi closure khi người dùng nhấn nút xóa
        onDeleteBackward?()
    }
}
