//
//  AccountViewController.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import UIKit

class AccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let signInViewController = SignInViewController()
        signInViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Tùy chỉnh màu sắc cho icon
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "#181725")
        
        // Đặt tiêu đề nút quay lại là trống
        self.navigationController?.navigationBar.topItem?.title = ""
        
        self.navigationItem.title = ""
    }

    private func setupNav() {
        
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(hex: "#E5E5E5")
    }
}
