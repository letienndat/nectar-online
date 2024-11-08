//
//  AnimationLoadingView.swift
//  nectar-online
//
//  Created by Macbook on 08/11/2024.
//

import UIKit

class AnimationLoadingView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    private let circleA = UIView()
    private let circleB = UIView()
    private let circleC = UIView()
    private lazy var circles = [circleA, circleB, circleC]

    var isAnimating = false // Trạng thái của animation

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true // Ẩn view khi khởi tạo
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        circles.forEach {
            $0.layer.cornerRadius = 10 / 2
            $0.layer.masksToBounds = true
            $0.backgroundColor = UIColor(hex: "#53B175")
            stackView.addArrangedSubview($0)
            $0.widthAnchor.constraint(equalToConstant: 10).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        }
    }

    func startAnimation() {
//        guard !isAnimating else { return }
        isAnimating = true
        isHidden = false // Hiển thị view khi bắt đầu animation
        animate()
    }

    func stopAnimation() {
        guard isAnimating else { return }
        isAnimating = false

        // Dừng tất cả animation và ẩn view
        circles.forEach { $0.layer.removeAllAnimations() }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0 // Ẩn view dần
        }) { _ in
            self.isHidden = true // Ẩn hoàn toàn khi animation kết thúc
            self.alpha = 1 // Đặt lại alpha để sẵn sàng cho lần hiển thị tiếp theo
        }
    }

    private func animate() {
        let jumpDuration: Double = 0.20
        let delayDuration: Double = 0.2
        let totalDuration: Double = delayDuration + jumpDuration * 2

        let jumpRelativeDuration: Double = jumpDuration / totalDuration
        let jumpRelativeTime: Double = delayDuration / totalDuration
        let fallRelativeTime: Double = (delayDuration + jumpDuration) / totalDuration

        for (index, circle) in circles.enumerated() {
            let delay = jumpDuration * 2 * TimeInterval(index) / TimeInterval(circles.count)
            UIView.animateKeyframes(withDuration: totalDuration, delay: delay, options: [.repeat], animations: {
                UIView.addKeyframe(withRelativeStartTime: jumpRelativeTime, relativeDuration: jumpRelativeDuration) {
                    // Sử dụng transform để di chuyển hình tròn
                    circle.transform = CGAffineTransform(translationX: 0, y: -15)
                }
                UIView.addKeyframe(withRelativeStartTime: fallRelativeTime, relativeDuration: jumpRelativeDuration) {
                    // Đặt lại transform để đưa hình tròn về vị trí ban đầu
                    circle.transform = .identity
                }
            })
        }
    }
}
