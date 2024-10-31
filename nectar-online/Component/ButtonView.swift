//
//  ButtonView.swift
//  nectar-online
//
//  Created by Macbook on 26/10/2024.
//

import UIKit

class ButtonView: UIButton {
    
    // Factory method để tạo button với type .system
    static func createSystemButton(
        title: String = "",
        titleColor: UIColor = .white,
        titleFont: UIFont? = UIFont.systemFont(ofSize: 16),
        backgroundColor: UIColor = .clear,
        borderRadius: CGFloat = 0
    ) -> ButtonView {
        let button = ButtonView(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = titleFont
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = borderRadius
        button.setupView()
        return button
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 67)
        ])
    }
}
