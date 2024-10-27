//
//  CustomTabBar.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import UIKit

class CustomTabBar: UITabBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Bo tròn hai góc trên
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]  // Bo góc trên trái và trên phải
        self.layer.masksToBounds = false
        
        // Tạo shadow
        self.layer.shadowColor = UIColor(hex: "#555E58", alpha: 1).cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 2, height: -5)
        self.layer.shadowRadius = 15
        
        // Đổi màu nền của tab bar
        self.backgroundColor = UIColor(hex: "#FFFFFF")
    }

}
