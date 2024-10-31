//
//  BlurView.swift
//  nectar-online
//
//  Created by Macbook on 20/10/2024.
//

import UIKit

class BlurTop: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        let imageBackgroundTopView = UIImageView()
        imageBackgroundTopView.image = UIImage(named: "background-top-blur")
        imageBackgroundTopView.alpha = 0.25
        addSubview(imageBackgroundTopView)

        imageBackgroundTopView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageBackgroundTopView.widthAnchor.constraint(equalTo: widthAnchor),
            imageBackgroundTopView.heightAnchor.constraint(equalToConstant: 136.35 + 44),
            imageBackgroundTopView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBackgroundTopView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBackgroundTopView.topAnchor.constraint(equalTo: topAnchor)
        ])

        let backgoundTopView = UIView()
        backgoundTopView.backgroundColor = UIColor(hex: "#FCFCFC", alpha: 0.85)
        addSubview(backgoundTopView)

        // Tạo một hiệu ứng mờ
        let blurEffectTop = UIBlurEffect(style: .light) // Chọn kiểu mờ (light, extraLight, dark)
        let blurEffectViewTop = UIVisualEffectView(effect: blurEffectTop)

        // Thiết lập kích thước cho UIVisualEffectView
        blurEffectViewTop.frame = backgoundTopView.bounds
        blurEffectViewTop.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Để UIVisualEffectView tự động điều chỉnh kích thước

        // Thêm UIVisualEffectView vào
        backgoundTopView.addSubview(blurEffectViewTop)

        backgoundTopView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgoundTopView.widthAnchor.constraint(equalTo: widthAnchor),
            backgoundTopView.heightAnchor.constraint(equalToConstant: 233.1),
            backgoundTopView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgoundTopView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgoundTopView.topAnchor.constraint(equalTo: topAnchor),
            
            heightAnchor.constraint(equalTo: backgoundTopView.heightAnchor)
        ])
    }
}

class BlurBottom: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        let imageBackgroundBottomView = UIImageView()
        imageBackgroundBottomView.image = UIImage(named: "background-bottom-blur")
        imageBackgroundBottomView.alpha = 0.75
        addSubview(imageBackgroundBottomView)
        
        imageBackgroundBottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageBackgroundBottomView.widthAnchor.constraint(equalTo: widthAnchor),
            imageBackgroundBottomView.heightAnchor.constraint(equalToConstant: 167.95),
            imageBackgroundBottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBackgroundBottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBackgroundBottomView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let backgoundBottomView = UIView()
        backgoundBottomView.backgroundColor = UIColor(hex: "#FEFEFE", alpha: 0.55)
        addSubview(backgoundBottomView)

        // Tạo một hiệu ứng mờ
        let blurEffectBottom = UIBlurEffect(style: .light) // Chọn kiểu mờ (light, extraLight, dark)
        let blurEffectViewBottom = UIVisualEffectView(effect: blurEffectBottom)

        // Thiết lập kích thước cho UIVisualEffectView
        blurEffectViewBottom.frame = backgoundBottomView.bounds
        blurEffectViewBottom.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Để UIVisualEffectView tự động điều chỉnh kích thước

        // Thêm UIVisualEffectView vào
        backgoundBottomView.addSubview(blurEffectViewBottom)

        backgoundBottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgoundBottomView.widthAnchor.constraint(equalTo: widthAnchor),
            backgoundBottomView.heightAnchor.constraint(equalToConstant: 302.76),
            backgoundBottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgoundBottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgoundBottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            heightAnchor.constraint(equalTo: backgoundBottomView.heightAnchor)
        ])
    }
}

class BlurView {
    static func getBlur() -> (BlurTop, BlurBottom) {
        return (BlurTop(), BlurBottom())
    }
}
