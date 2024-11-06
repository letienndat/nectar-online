//
//  CheckboxButton.swift
//  nectar-online
//
//  Created by Macbook on 05/11/2024.
//

import UIKit

class CheckboxButton: UIButton {
    // Hình ảnh cho trạng thái checked và unchecked
    let checkedImage = UIImage(named: "checkbox-button-checked")
    let uncheckedImage = UIImage(named: "checkbox-button-unchecked")
    
    var handleTapCheck: ((Bool) -> Void)?
    
    // Thiết lập ban đầu cho checkbox
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        self.setImage(uncheckedImage, for: .normal)
        self.setImage(checkedImage, for: .selected)
        self.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
    }
    
    @objc private func toggleCheckbox() {
        self.isSelected.toggle()
        self.setImage(isSelected ? checkedImage : uncheckedImage, for: .normal)
        self.handleTapCheck?(self.isSelected)
    }
}
