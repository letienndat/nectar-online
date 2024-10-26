//
//  Extension.swift
//  nectar-online
//
//  Created by Macbook on 20/10/2024.
//

import UIKit

extension UIColor {
    
    // Hàm tạo UIColor với đối truyền vào là mã hex và alpha
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIView {

    enum BorderEdge {
        case top, left, bottom, right
    }

    // Tạo border (đường viền) cho view
    func addBorder(edges: [BorderEdge], color: UIColor = .red, margins: CGFloat = 0, borderLineSize: CGFloat = 1) {
        for edge in edges {
            let border = UIView()
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(border)
            
            switch edge {
            case .top:
                NSLayoutConstraint.activate([
                    border.topAnchor.constraint(equalTo: self.topAnchor),
                    border.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margins),
                    border.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margins),
                    border.heightAnchor.constraint(equalToConstant: borderLineSize)
                ])
                
            case .left:
                NSLayoutConstraint.activate([
                    border.topAnchor.constraint(equalTo: self.topAnchor, constant: margins),
                    border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margins),
                    border.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    border.widthAnchor.constraint(equalToConstant: borderLineSize)
                ])
                
            case .bottom:
                NSLayoutConstraint.activate([
                    border.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    border.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margins),
                    border.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margins),
                    border.heightAnchor.constraint(equalToConstant: borderLineSize)
                ])
                
            case .right:
                NSLayoutConstraint.activate([
                    border.topAnchor.constraint(equalTo: self.topAnchor, constant: margins),
                    border.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margins),
                    border.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    border.widthAnchor.constraint(equalToConstant: borderLineSize)
                ])
            }
        }
    }

    // Tìm UIView đang mở bàn phím
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}

// Extension UILabel để tìm vị trí kí tự tại vị trí chạm
extension UILabel {
    func indexOfAttributedTextCharacter(at point: CGPoint) -> Int {
        guard let attributedText = self.attributedText else { return NSNotFound }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: self.bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}
