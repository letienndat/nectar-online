//
//  MainTabViewController.swift
//  nectar-online
//
//  Created by Macbook on 06/11/2024.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    lazy var homeScreenService: HomeScreenService = HomeScreenService.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        self.selectedIndex = 0
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateCartBadge()
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
//            selectedViewController.tabBarItem.setTitleTextAttributes([
//                .font: UIFont(name: "Gilroy-Semibold", size: 12) ?? .systemFont(ofSize: 12),
//                .foregroundColor: UIColor(hex: "#53B175")
//            ], for: .normal)
            guard let viewControllers = viewControllers else { return }
            for viewController in viewControllers {
                if viewController == selectedViewController {
                    viewController.tabBarItem.setTitleTextAttributes([
                        .font: UIFont(name: "Gilroy-Semibold", size: 12) ?? .systemFont(ofSize: 12),
                        .foregroundColor: UIColor(hex: "#53B175")
                    ], for: .normal)
                    
                } else {
                    viewController.tabBarItem.setTitleTextAttributes([
                        .font: UIFont(name: "Gilroy-Semibold", size: 12) ?? .systemFont(ofSize: 12),
                        .foregroundColor: UIColor(hex: "#181725")
                    ], for: .normal)
                }
            }
        }
    }
    
    override var selectedViewController: UIViewController? { // Mark 2
        didSet {
            
            guard let viewControllers = viewControllers else { return }
            for viewController in viewControllers {
                if viewController == selectedViewController {
                    viewController.tabBarItem.setTitleTextAttributes([
                        .font: UIFont(name: "Gilroy-Semibold", size: 12) ?? .systemFont(ofSize: 12),
                        .foregroundColor: UIColor(hex: "#53B175")
                    ], for: .normal)
                    
                } else {
                    viewController.tabBarItem.setTitleTextAttributes([
                        .font: UIFont(name: "Gilroy-Semibold", size: 12) ?? .systemFont(ofSize: 12),
                        .foregroundColor: UIColor(hex: "#181725")
                    ], for: .normal)
                }
            }
        }
    }
    
    private func updateCartBadge() {
        if let tabItems = tabBar.items {
            let cartTabItem = tabItems[2]
            
            if AppConfig.isLogin {
                
                let token = getToken(for: Const.KEYCHAIN_TOKEN)
                
                homeScreenService.fetchTotalProductInCart(token: token) { [weak self] result in
                    guard let _ = self else { return }
                    
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let totalProductInCart):
                            let resShow: String = totalProductInCart > 99 ? "99+" : String(totalProductInCart)
                            cartTabItem.badgeValue = resShow
                            
                            cartTabItem.setBadgeTextAttributes([
                                .font: UIFont(name: "Gilroy-Semibold", size: 12) ?? .systemFont(ofSize: 12),
                                .foregroundColor: UIColor(hex: "#FFFFFF")
                            ], for: .normal)
                        case .failure(let error):
                            let error = error as NSError
                            if error.code == 401 {
                                cartTabItem.badgeValue = nil
                            } else {
                                cartTabItem.badgeValue = "0"
                                
                                cartTabItem.setBadgeTextAttributes([
                                    .font: UIFont(name: "Gilroy-Semibold", size: 12) ?? .systemFont(ofSize: 12),
                                    .foregroundColor: UIColor(hex: "#FFFFFF")
                                ], for: .normal)
                            }
                        }
                    }
                }
                
            } else {
                cartTabItem.badgeValue = nil
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
}

extension MainTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController), selectedIndex != 0 {
            if let tabItems = tabBarController.tabBar.items {
                let tabItem = tabItems[0]
                // Tạo một hình ảnh mới với màu sắc mong muốn
                if let originalImage = tabItem.image {
                    let tintedImage = originalImage.withTintColor(UIColor(hex: "#181725")).withRenderingMode(.alwaysOriginal)
                    // Đặt màu của biểu tượng của tabbar item Home khi không được chọn (tùy chọn)
                    tabItem.image = tintedImage
                }
            }
        }
    }
}
