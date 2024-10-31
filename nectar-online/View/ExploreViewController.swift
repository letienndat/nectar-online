//
//  ExploreViewController.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import UIKit

class ExploreViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
    }

    private func setupNav() {
        // BUG: Nếu select index mặc định = 0 thì sẽ không select vào icon tab bar Shop nên để tạm sang 1 (ExploreView), viewDidLoad của ExploreViewController sẽ select lại index = 0
        self.tabBarController?.selectedIndex = 0
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(hex: "#E5E5E5")
    }
}
