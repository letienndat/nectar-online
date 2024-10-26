//
//  HomeScreenViewController.swift
//  nectar-online
//
//  Created by Macbook on 26/10/2024.
//

import UIKit

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
    }

    private func setupNav() {
        
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(hex: "#E5E5E5")
    }
}
