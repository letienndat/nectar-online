//
//  SceneDelegate.swift
//  nectar-online
//
//  Created by Macbook on 19/10/2024.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Khởi tạo UIWindow với kích thước của windowScene
        window = UIWindow(windowScene: windowScene)
        
        AppConfig.isLogin = true
        saveToken(token: "â", for: Const.KEYCHAIN_TOKEN)
        
        if AppConfig.isLogin {
            let appService = AppService()
            let token: String? = getToken(for: Const.KEYCHAIN_TOKEN)
            
            appService.fetchCheckToken(token: token) { [weak self] result in
                guard
                    let _ = self
                else { return }
                
                switch result {
                case .success(let token):
                    saveToken(token: token, for: Const.KEYCHAIN_TOKEN)
                case .failure(_):
                    break
                }
            }
        }
        
        // Tạo ViewController đầu tiên và gán làm rootViewController
        var rootViewController: UIViewController
        if AppConfig.isFirstLaunch {
            rootViewController = OnbordingViewController()
        } else {
            // Tạo nav cho tab Home Screen
            let homeScreenViewController = HomeScreenViewController()
            let homeScreenNavigationController = UINavigationController(rootViewController: homeScreenViewController)
            
            // Tạo nav cho tab Explore
            let exploreViewController = ExploreViewController()
            let exploreNavigationController = UINavigationController(rootViewController: exploreViewController)
            
            // Tạo nav cho tab cart
            let cartViewController = CartViewController()
            let cartNavigationController = UINavigationController(rootViewController: cartViewController)
            
            // Tạo nav cho tab Favorite
            let favoriteViewController = FavoriteViewController()
            let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
            
            // Tạo nav cho tab Accounnt
            let accountViewController = AccountViewController()
            let accountNavigationController = UINavigationController(rootViewController: accountViewController)
            
            // Thiết lập icon cho các tab
            homeScreenNavigationController.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(named: "icon-tab-bar-shop"), tag: 0)
            exploreNavigationController.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "icon-tab-bar-explore"), tag: 1)
            cartNavigationController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(named: "icon-tab-bar-cart"), tag: 2)
            favoriteNavigationController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(named: "icon-tab-bar-favorite"), tag: 3)
            accountNavigationController.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "icon-tab-bar-account"), tag: 4)
            
            // Tùy chỉnh màu của icon cho các trạng thái
            UITabBar.appearance().tintColor = UIColor(hex: "#53B175")   // Màu khi được chọn
            UITabBar.appearance().unselectedItemTintColor = UIColor(hex: "#181725") // Màu mặc định
            
            // Tùy chỉnh font và màu của tab bar item
            // Lúc bình thường (item bar chưa được chọn)
            let normalAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Gilroy-Semibold", size: 12)!,
                .foregroundColor: UIColor(hex: "#181725")
            ]

            // Lúc được chọn (item bar được chọn)
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Gilroy-Semibold", size: 12)!,
                .foregroundColor: UIColor(hex: "#53B175")
            ]
            
            // Áp dụng các thuộc tính tùy chỉnh cho mỗi tab bar item
            UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
            
            // Tạo UITabBarController và thêm các UINavigationController vào đó
            let tabBarController = MainTabViewController()
            tabBarController.setViewControllers([
                homeScreenNavigationController,
                exploreNavigationController,
                cartNavigationController,
                favoriteNavigationController,
                accountNavigationController
            ], animated: true)
            
            tabBarController.setValue(CustomTabBar(), forKey: "tabBar")
            
            // Mặc định chọn tab đầu tiên
            tabBarController.selectedIndex = 0
            
            // Đặt tabBarController làm rootViewController mới
            rootViewController = tabBarController
        }
        let navigationController = CustomNavigationController(rootViewController: rootViewController)
        navigationController.setNavigationBarHidden(true, animated: true)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarted.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarted (see `application:didDiscartSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

