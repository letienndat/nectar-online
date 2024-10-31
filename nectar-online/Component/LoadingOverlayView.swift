//
//  LoadingOverlayView.swift
//  nectar-online
//
//  Created by Macbook on 30/10/2024.
//

import UIKit

// Lớp phủ mờ
class LoadingOverlayView: UIView {
    
    // Loading Indicator
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLoadingOverlay()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLoadingOverlay() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5) // Màu đen mờ
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true // Ẩn lớp phủ lúc ban đầu
        
        self.addSubview(loadingIndicator)
        
        // Cài đặt Auto Layout cho lớp phủ mờ để nó bao phủ toàn bộ view
        NSLayoutConstraint.activate([
            // Đặt loading indicator ở giữa lớp phủ
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func showLoadingOverlay() {
        self.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingOverlay() {
        self.isHidden = true
        loadingIndicator.stopAnimating()
    }
}
