//
//  LogInViewController.swift
//  nectar-online
//
//  Created by Macbook on 26/10/2024.
//

import UIKit

class LogInViewController: UIViewController {
    
    private let (blurTop, blurBottom) = BlurView.getBlur()
    private let scrollView = UIScrollView()
    private var scrollViewBottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Đăng ký thông báo khi bàn phím xuất hiện và ẩn đi
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Tạo UITapGestureRecognizer để phát hiện người dùng bấm ra ngoài view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeybroad))
        
        // Thêm gesture vào view cha
        self.view.addGestureRecognizer(tapGesture)

        setupNav()
        setupView()
    }
    
    @objc func hideKeybroad() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // Lấy thông tin về bàn phím
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            // Cập nhật kích thước của scrollView
            UIView.animate(withDuration: 0.3) {
                // Gỡ bỏ ràng buộc cũ nếu có
                if let oldConstraint = self.scrollViewBottomConstraint {
                    oldConstraint.isActive = false
                }

                // Tạo và lưu ràng buộc mới
                self.scrollViewBottomConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardHeight)
                self.scrollViewBottomConstraint?.isActive = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // Khôi phục kích thước ban đầu cho scrollView
        UIView.animate(withDuration: 0.3) {
            // Gỡ bỏ ràng buộc cũ nếu có
            if let oldConstraint = self.scrollViewBottomConstraint {
                oldConstraint.isActive = false
            }

            // Tạo và lưu ràng buộc mới
            self.scrollViewBottomConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            self.scrollViewBottomConstraint?.isActive = true
        }
    }
    
    private func setupNav() {
        // Tùy chỉnh màu sắc cho icon
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "#181725")
        
        // Đặt tiêu đề nút quay lại là trống
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(hex: "#FCFCFC")
        
        view.addSubview(scrollView)
        
        scrollView.bounces = false
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollViewBottomConstraint!,
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        scrollView.insertSubview(blurTop, at: 0)
        blurTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurTop.topAnchor.constraint(equalTo: view.topAnchor),
            blurTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurTop.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        scrollView.insertSubview(blurBottom, at: 1)
        blurBottom.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurBottom.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        let subView = UIView()
        subView.backgroundColor = .clear
        scrollView.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            subView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            subView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25),
            subView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            subView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -50),
            subView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        let viewTitle = UIView()
        subView.addSubview(viewTitle)
        
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: subView.topAnchor),
            viewTitle.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewTitle.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            viewTitle.widthAnchor.constraint(equalTo: subView.widthAnchor)
        ])
        
        let icon = UIImageView()
        icon.image = UIImage(named: "icon-top-login-signup")
        viewTitle.addSubview(icon)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: viewTitle.centerXAnchor),
            icon.topAnchor.constraint(equalTo: viewTitle.topAnchor, constant: 28.42),
            
            icon.widthAnchor.constraint(equalToConstant: 47.84),
            icon.heightAnchor.constraint(equalToConstant: 55.64)
        ])
        
        let title = UILabel()
        title.text = "Loging"
        title.font = UIFont(name: "Gilroy-Semibold", size: 26)
        title.textColor = UIColor(hex: "#181725")
        title.textAlignment = .left
        viewTitle.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 100.21),
            title.leadingAnchor.constraint(equalTo: viewTitle.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: viewTitle.trailingAnchor),
            
            title.heightAnchor.constraint(equalToConstant: 29)
        ])
        
        let descriptionTitle = UILabel()
        descriptionTitle.text = "Enter your emails and password"
        descriptionTitle.font = UIFont(name: "Gilroy-Medium", size: 16)
        descriptionTitle.textColor = UIColor(hex: "#7C7C7C")
        descriptionTitle.textAlignment = .left
        viewTitle.addSubview(descriptionTitle)
        
        descriptionTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 15),
            descriptionTitle.bottomAnchor.constraint(equalTo: viewTitle.bottomAnchor),
            descriptionTitle.leadingAnchor.constraint(equalTo: viewTitle.leadingAnchor),
            descriptionTitle.trailingAnchor.constraint(equalTo: viewTitle.trailingAnchor),
            
            descriptionTitle.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        let viewForm = UIView()
        subView.addSubview(viewForm)
        
        viewForm.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewForm.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 40),
            viewForm.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewForm.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            viewForm.widthAnchor.constraint(equalTo: subView.widthAnchor),
        ])
        
        let formControlEmail = FormControllView(label: "Email", typeInput: .email, placeholder: "Enter your email")
        viewForm.addSubview(formControlEmail)

        formControlEmail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formControlEmail.topAnchor.constraint(equalTo: viewForm.topAnchor),
            formControlEmail.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            formControlEmail.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),

            formControlEmail.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        let formControlPassword = FormControllView(label: "Password", typeInput: .password, placeholder: "Enter your password")
        viewForm.addSubview(formControlPassword)

        formControlPassword.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formControlPassword.topAnchor.constraint(equalTo: formControlEmail.bottomAnchor, constant: 30),
            formControlPassword.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            formControlPassword.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),

            formControlPassword.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        let buttonForgotPassword = UIButton(type: .system)
        buttonForgotPassword.backgroundColor = .clear
        buttonForgotPassword.setTitle("Forgot Password?", for: .normal)
        buttonForgotPassword.setTitleColor(UIColor(hex: "#181725"), for: .normal)
        buttonForgotPassword.titleLabel?.font = UIFont(name: "Gilroy-Semibold", size: 14)
        buttonForgotPassword.titleLabel?.textAlignment = .left
        viewForm.addSubview(buttonForgotPassword)
        
        buttonForgotPassword.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonForgotPassword.topAnchor.constraint(equalTo: formControlPassword.bottomAnchor, constant: 20),
            buttonForgotPassword.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),
            
            buttonForgotPassword.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        buttonForgotPassword.addTarget(self, action: #selector(handleForgotPassword(_:)), for: .touchUpInside)
        
        let button = ButtonView.createSystemButton(
            title: "Loging",
            titleColor: UIColor(hex: "#FFF9FF"),
            titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
            backgroundColor: UIColor(hex: "#53B175"),
            borderRadius: 19
        )
        viewForm.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: buttonForgotPassword.bottomAnchor, constant: 30),
            button.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),
            
            button.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        button.addTarget(self, action: #selector(handleLogin(_:)), for: .touchUpInside)
        
        let viewQuestionRedirect = UIView()
        viewForm.addSubview(viewQuestionRedirect)
        
        viewQuestionRedirect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewQuestionRedirect.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 25),
            viewQuestionRedirect.bottomAnchor.constraint(equalTo: viewForm.bottomAnchor),
            viewQuestionRedirect.centerXAnchor.constraint(equalTo: viewForm.centerXAnchor),
            
            viewQuestionRedirect.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        let labelQuestion = UILabel()
        labelQuestion.text = "Don’t have an account?"
        labelQuestion.textAlignment = .right
        labelQuestion.font = UIFont(name: "Gilroy-Semibold", size: 14)
        labelQuestion.textColor = UIColor(hex: "#181725")
        viewQuestionRedirect.addSubview(labelQuestion)
        
        labelQuestion.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelQuestion.topAnchor.constraint(equalTo: viewQuestionRedirect.topAnchor),
            labelQuestion.bottomAnchor.constraint(equalTo: viewQuestionRedirect.bottomAnchor),
            labelQuestion.leadingAnchor.constraint(equalTo: viewQuestionRedirect.leadingAnchor),
            
            labelQuestion.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        let buttonRedirect = UIButton(type: .system)
        buttonRedirect.backgroundColor = .clear
        buttonRedirect.setTitle("Signup", for: .normal)
        buttonRedirect.setTitleColor(UIColor(hex: "#53B175"), for: .normal)
        buttonRedirect.titleLabel?.font = UIFont(name: "Gilroy-Semibold", size: 14)
        buttonRedirect.titleLabel?.textAlignment = .left
        viewQuestionRedirect.addSubview(buttonRedirect)
        
        buttonRedirect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonRedirect.topAnchor.constraint(equalTo: viewQuestionRedirect.topAnchor),
            buttonRedirect.bottomAnchor.constraint(equalTo: viewQuestionRedirect.bottomAnchor),
            buttonRedirect.leadingAnchor.constraint(equalTo: labelQuestion.trailingAnchor, constant: 5),
            buttonRedirect.trailingAnchor.constraint(equalTo: viewQuestionRedirect.trailingAnchor),

            buttonRedirect.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        buttonRedirect.addTarget(self, action: #selector(handleRedirectSignup(_:)), for: .touchUpInside)
        
        let viewEmpty = UIView()
        subView.addSubview(viewEmpty)
        
        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.topAnchor.constraint(equalTo: viewForm.bottomAnchor),
            viewEmpty.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
            viewEmpty.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewEmpty.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            viewEmpty.widthAnchor.constraint(equalTo: subView.widthAnchor),
            viewEmpty.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
    }
    
    // Xử lý sự kiện khi bấm vào đăng nhập
    @objc func handleLogin(_ sender: UIButton) {
        
        // Tạo nav cho tab Home Screen
        let homeScreenViewController = HomeScreenViewController()
        let homeScreenNavigationController = UINavigationController(rootViewController: homeScreenViewController)
        
        // Tạo nav cho tab Explore
        let exploreViewController = ExploreViewController()
        let exploreNavigationController = UINavigationController(rootViewController: exploreViewController)
        
        // Tạo nav cho tab Card
        let cardViewController = CardViewController()
        let cardNavigationController = UINavigationController(rootViewController: cardViewController)
        
        // Tạo nav cho tab Favorite
        let favoriteViewController = FavoriteViewController()
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        
        // Tạo nav cho tab Accounnt
        let accountViewController = AccountViewController()
        let accountNavigationController = UINavigationController(rootViewController: accountViewController)
        
        // Thiết lập icon cho các tab
        homeScreenNavigationController.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(named: "icon-tab-bar-shop"), tag: 0)
        exploreNavigationController.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "icon-tab-bar-explore"), tag: 1)
        cardNavigationController.tabBarItem = UITabBarItem(title: "Card", image: UIImage(named: "icon-tab-bar-card"), tag: 2)
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
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([
            homeScreenNavigationController,
            exploreNavigationController,
            cardNavigationController,
            favoriteNavigationController,
            accountNavigationController
        ], animated: true)
        
        tabBarController.setValue(CustomTabBar(), forKey: "tabBar")
        
        // Mặc định chọn tab đầu tiên
        // BUG: Nếu select index mặc định = 0 thì sẽ không select vào icon tab bar Shop nên để tạm sang 1 (ExploreView), viewDidLoad của ExploreViewController sẽ select lại index = 0
        tabBarController.selectedIndex = 1
        
        // Đặt tabBarController làm rootViewController mới
        self.navigationController?.setViewControllers([tabBarController], animated: true)
    }
    
    // Hàm xử lý quên mật khẩu
    @objc func handleForgotPassword(_ sender: UIButton) {
        //
    }
    
    // Hàm xử lý điều hướng sang màn hình đăng ký
    @objc func handleRedirectSignup(_ sender: UIButton) {
        self.navigationController?.setViewControllers([SignUpViewController()], animated: true)
    }
    
    // Hàm được gọi ngay trước khi ViewController xuất hiện
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Hàm được gọi trước khi ViewController biến mất
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // Hàm cấu hình cho phép xoay theo chiều nào
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeRight, .landscapeLeft]
    }
    
    deinit {
        // Hủy đăng ký thông báo khi không còn sử dụng
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
