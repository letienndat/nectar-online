//
//  MainTabViewController.swift
//  nectar-online
//
//  Created by Macbook on 06/11/2024.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override var selectedIndex: Int { // Mark 1
        didSet {
            guard let selectedViewController = viewControllers?[selectedIndex] else { return }
            selectedViewController.tabBarItem.setTitleTextAttributes([
                .font: UIFont(name: "Gilroy-Semibold", size: 12)!,
                .foregroundColor: UIColor(hex: "#53B175")
            ], for: .normal)
        }
    }
    
    override var selectedViewController: UIViewController? { // Mark 2
        didSet {
            
            guard let viewControllers = viewControllers else { return }
            for viewController in viewControllers {
                if viewController == selectedViewController {
                    viewController.tabBarItem.setTitleTextAttributes([
                        .font: UIFont(name: "Gilroy-Semibold", size: 12)!,
                        .foregroundColor: UIColor(hex: "#53B175")
                    ], for: .normal)
                    
                } else {
                    viewController.tabBarItem.setTitleTextAttributes([
                        .font: UIFont(name: "Gilroy-Semibold", size: 12)!,
                        .foregroundColor: UIColor(hex: "#181725")
                    ], for: .normal)
                }
            }
        }
    }

}
