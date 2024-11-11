//
//  ButtonView.swift
//  nectar-online
//
//  Created by Macbook on 26/10/2024.
//

import UIKit

class ButtonView: UIButton {
    
    var leftView: UIView? {
        didSet {
            setupSideView(leftView, isLeft: true)
        }
    }
    
    var rightView: UIView? {
        didSet {
            setupSideView(rightView, isLeft: false)
        }
    }

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
    
    private func setupSideView(_ sideView: UIView?, isLeft: Bool) {
        guard let sideView = sideView else { return }
        
        addSubview(sideView)
        sideView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints cho sideView
        let sideInset: CGFloat = 22.5  // khoảng cách giữa view và cạnh button
        if isLeft {
            NSLayoutConstraint.activate([
                sideView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideInset),
                sideView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                sideView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideInset),
                sideView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        // Cập nhật layout của title để tránh bị che
        if let configuration = self.configuration {
            var updatedConfig = configuration
            if isLeft {
                updatedConfig.contentInsets.leading += sideView.frame.width + sideInset
            } else {
                updatedConfig.contentInsets.trailing += sideView.frame.width + sideInset
            }
            self.configuration = updatedConfig
        }
    }
}
