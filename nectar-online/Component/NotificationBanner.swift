//
//  NotificationBanner.swift
//  nectar-online
//
//  Created by Macbook on 11/11/2024.
//

import UIKit

class NotificationBanner {
    private var bannerView: UIView!
    private var bannerLabel: UILabel!
    private var bannerHeight: CGFloat = 50
    private var displayDuration: Double = 2.0

    init(message: String, duration: Double = 2.0) {
        self.displayDuration = duration

        bannerView = UIView()
        bannerView.backgroundColor = UIColor(hex: "#53B175")
        bannerView.layer.cornerRadius = 10
        bannerView.clipsToBounds = true

        bannerLabel = UILabel()
        bannerLabel.text = message
        bannerLabel.textColor = UIColor(hex: "#FFF9FF")
        bannerLabel.font = UIFont.boldSystemFont(ofSize: 14)
        bannerLabel.textAlignment = .center
        bannerView.addSubview(bannerLabel)

        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            
            keyWindow.addSubview(bannerView)
            bannerView.frame = CGRect(x: keyWindow.frame.width,
                                      y: 50,
                                      width: keyWindow.frame.width - 40,
                                      height: bannerHeight)
            bannerLabel.frame = bannerView.bounds.insetBy(dx: 10, dy: 5)
        }
    }

    func show() {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.bannerView.frame.origin.x = 20
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: self.displayDuration, options: .curveEaseIn, animations: {
                self.bannerView.frame.origin.x = keyWindow.frame.width
            }) { _ in
                self.bannerView.removeFromSuperview()
            }
        }
    }
}
