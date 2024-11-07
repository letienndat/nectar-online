//
//  CartViewController.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import UIKit

class CartViewController: UIViewController {
    
    // Hàm được gọi khi view được thêm vào bộ nhớ
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
    }
    
    // Hàm được gọi trước khi view xuất hiện trên màn hình
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // Hàm được gọi khi view xuất hiện trên màn hình
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Hàm được gọi trước khi view biến mất khỏi màn hình
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // Hàm được gọi khi view biến mất khỏi màn hình
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    private func setupNav() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.navigationItem.title = "My Cart"
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        
    }
}
