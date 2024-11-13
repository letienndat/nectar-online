//
//  AccountViewController.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import UIKit
import SDWebImage

class AccountViewController: UIViewController {
    
    private let viewNoLogin = UIView()
    private let viewLogin = UIView()
    let buttonConfirmNoLogin = ButtonView.createSystemButton(
        title: "Redirect To Signin",
        titleColor: UIColor(hex: "#FFF9FF"),
        titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
        backgroundColor: UIColor(hex: "#53B175"),
        borderRadius: 19
    )
    private let loading = AnimationLoadingView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let accountViewModel: AccountViewModel = AccountViewModel()
    private let avatar = UIImageView()
    private let labelUsername = UILabel()
    private let labelEmail = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupNav()
        self.setupView()
        self.setupLoadingOverlay()
        
        self.accountViewModel.hideRefreshing = { [weak self] in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
        }
        
        self.accountViewModel.hideLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = true
            self.loading.stopAnimation()
        }
        
        self.accountViewModel.showLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = false
            self.loading.startAnimation()
        }
        
        self.accountViewModel.showError = { [weak self] error in
            guard let self = self else { return }
            
            self.showErrorAlert(message: error, isReload: true, handleReload: { self.fetchData() })
        }
        
        self.accountViewModel.closureLogOutSuccess = { [weak self] in
            guard let self = self else { return }
            
            self.tabBarController?.selectedIndex = 0
            
            if let tabItems = self.tabBarController?.tabBar.items {
                let cartTabItem = tabItems[2]
                cartTabItem.badgeValue = nil
            }
            
            if let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController {
                if let homeScreenViewController = navigationController.viewControllers.first as? HomeScreenViewController {
                    homeScreenViewController.fetchData()
                }
            }
        }
        
        self.accountViewModel.closureLogOutFail = { [weak self] error in
            guard let self = self else { return }
            
            self.showErrorAlert(message: error, isReload: false, handleReload: nil)
        }
        
        self.accountViewModel.updateAccount = { [weak self] in
            guard let self = self else { return }
            
            loadImage(from: self.accountViewModel.account.image.imageUrl) {image in
                if let downloadedImage = image {
                    self.avatar.image = downloadedImage
                } else {
                    //
                }
            }
            self.labelUsername.text = self.accountViewModel.account.username
            self.labelEmail.text = self.accountViewModel.account.email
        }
        
        self.fetchData()
    }
    
    private func fetchData() {
        self.accountViewModel.fetchProfile()
    }
    
    // Hàm được gọi trước khi view xuất hiện trên màn hình
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if AppConfig.isLogin {
            self.viewLogin.isHidden = false
            self.viewNoLogin.isHidden = true
        } else {
            self.viewLogin.isHidden = true
            self.viewNoLogin.isHidden = false
        }
    }
    
    // Hàm được gọi trước khi view biến mất khỏi màn hình
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupNav() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        setupViewLogin()
        setupViewNoLigin()
    }
    
    private func setupViewLogin() {
        self.view.addSubview(viewLogin)
        
        viewLogin.isHidden = true
        
        viewLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewLogin.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            viewLogin.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            viewLogin.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewLogin.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        let scrollView = UIScrollView()
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshProductClassificaions(_:)), for: .valueChanged)
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        viewLogin.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: viewLogin.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: viewLogin.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: viewLogin.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: viewLogin.trailingAnchor),
        ])
        
        let subView = UIView()
        scrollView.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            subView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            subView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            subView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),
            subView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        let viewProfile = UIView()
        subView.addSubview(viewProfile)
        
        viewProfile.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewProfile.topAnchor.constraint(equalTo: subView.topAnchor, constant: 25),
            viewProfile.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewProfile.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            viewProfile.heightAnchor.constraint(equalToConstant: 64.32),
            viewProfile.widthAnchor.constraint(equalTo: subView.widthAnchor)
        ])
        
        loadImage(from: self.accountViewModel.account.image.imageUrl) {image in
            if let downloadedImage = image {
                self.avatar.image = downloadedImage
            } else {
                //
            }
        }
        avatar.contentMode = .scaleAspectFit
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 27
        viewProfile.addSubview(avatar)
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: viewProfile.topAnchor),
            avatar.leadingAnchor.constraint(equalTo: viewProfile.leadingAnchor, constant: 25),
            avatar.bottomAnchor.constraint(equalTo: viewProfile.bottomAnchor),
            
            avatar.widthAnchor.constraint(equalToConstant: 63.44),
            avatar.heightAnchor.constraint(equalToConstant: 64.32)
        ])
        
        let viewNameAndMail = UIView()
        viewProfile.addSubview(viewNameAndMail)
        
        viewNameAndMail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewNameAndMail.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 20.16),
            viewNameAndMail.trailingAnchor.constraint(greaterThanOrEqualTo: viewProfile.trailingAnchor, constant: -20),
            viewNameAndMail.centerYAnchor.constraint(equalTo: viewProfile.centerYAnchor),
            
            viewNameAndMail.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        labelUsername.text = self.accountViewModel.account.username
        labelUsername.font = UIFont(name: "Gilroy-Bold", size: 20)
        labelUsername.textColor = UIColor(hex: "#181725")
        labelUsername.numberOfLines = 1
        labelUsername.textAlignment = .left
        viewNameAndMail.addSubview(labelUsername)
        
        labelUsername.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelUsername.topAnchor.constraint(equalTo: viewNameAndMail.topAnchor),
            labelUsername.leadingAnchor.constraint(equalTo: viewNameAndMail.leadingAnchor),
            
            labelUsername.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        let iconChangeUsername = UIButton(type: .system)
        iconChangeUsername.setImage(UIImage(named: "icon-change-username"), for: .normal)
        iconChangeUsername.tintColor = UIColor(hex: "#53B175")
        viewNameAndMail.addSubview(iconChangeUsername)
        
        iconChangeUsername.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconChangeUsername.topAnchor.constraint(equalTo: viewNameAndMail.topAnchor),
            iconChangeUsername.leadingAnchor.constraint(equalTo: labelUsername.trailingAnchor, constant: 10.15),
            
            iconChangeUsername.widthAnchor.constraint(equalToConstant: 15),
            iconChangeUsername.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        labelEmail.text = self.accountViewModel.account.email
        labelEmail.font = UIFont(name: "Gilroy-Regular", size: 16)
        labelEmail.textColor = UIColor(hex: "#7C7C7C")
        labelEmail.numberOfLines = 1
        labelEmail.textAlignment = .left
        viewNameAndMail.addSubview(labelEmail)
        
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelEmail.topAnchor.constraint(equalTo: labelUsername.bottomAnchor, constant: 5),
            labelEmail.leadingAnchor.constraint(equalTo: viewNameAndMail.leadingAnchor),
            labelEmail.bottomAnchor.constraint(equalTo: viewNameAndMail.bottomAnchor),
        ])
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 1
        stackView.backgroundColor = UIColor(hex: "#E2E2E2")
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: viewProfile.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: subView.trailingAnchor)
        ])
        
        stackView.addArrangedSubview(UIView())
        
        accountViewModel.optionsViewAccount.forEach { option in
            
            let image = UIImage(named: option.icon) ?? UIImage()
            
            let title = UILabel()
            title.text = option.title
            title.font = UIFont(name: "Gilroy-Semibold", size: 18)
            title.textColor = UIColor(hex: "#181725")
            
            let optionInAccountView = OptionInAccountView(image: image, title: title)
            stackView.addArrangedSubview(optionInAccountView)
            
            optionInAccountView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                optionInAccountView.heightAnchor.constraint(equalToConstant: 62)
            ])
        }
        
        stackView.addArrangedSubview(UIView())
        
        let viewEmpty = UIView()
        subView.addSubview(viewEmpty)
        
        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            viewEmpty.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewEmpty.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            viewEmpty.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
        
        let buttonLogOut = ButtonView.createSystemButton(
            title: "Log Out",
            titleColor: UIColor(hex: "#53B175"),
            titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
            backgroundColor: UIColor(hex: "#F2F3F2"),
            borderRadius: 19
        )
        subView.addSubview(buttonLogOut)
        
        buttonLogOut.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonLogOut.topAnchor.constraint(equalTo: viewEmpty.bottomAnchor),
            buttonLogOut.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25),
            buttonLogOut.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25),
            buttonLogOut.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -24.45)
        ])
        
        buttonLogOut.addTarget(self, action: #selector(handleLogOut(_:)), for: .touchUpInside)
        
        let iconLogOut = UIImageView(image: UIImage(named: "icon-logout"))
        iconLogOut.tintColor = UIColor(hex: "#53B175")
        iconLogOut.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconLogOut.widthAnchor.constraint(equalToConstant: 18),
            iconLogOut.heightAnchor.constraint(equalToConstant: 18)
        ])
        buttonLogOut.leftView = iconLogOut
    }
    
    private func setupViewNoLigin() {
        self.view.addSubview(viewNoLogin)
        
        viewNoLogin.isHidden = true
        
        viewNoLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewNoLogin.topAnchor.constraint(equalTo: self.view.topAnchor),
            viewNoLogin.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            viewNoLogin.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewNoLogin.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        let viewContent = UIView()
        viewNoLogin.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: viewNoLogin.topAnchor),
            viewContent.leadingAnchor.constraint(equalTo: viewNoLogin.leadingAnchor, constant: 25),
            viewContent.trailingAnchor.constraint(equalTo: viewNoLogin.trailingAnchor, constant: -25),
        ])
        
        let labelContent = UILabel()
        labelContent.text = "Please login to use this feature!"
        labelContent.font = UIFont(name: "Gilroy-Medium", size: 16)
        labelContent.textColor = UIColor(hex: "#181725")
        labelContent.textAlignment = .center
        labelContent.numberOfLines = 0
        viewContent.addSubview(labelContent)
        
        labelContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelContent.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor),
            labelContent.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor),
            
            labelContent.leadingAnchor.constraint(greaterThanOrEqualTo: viewContent.leadingAnchor, constant: 30),
            labelContent.trailingAnchor.constraint(lessThanOrEqualTo: viewContent.trailingAnchor, constant: -30),
        ])
        
        viewNoLogin.addSubview(buttonConfirmNoLogin)
        buttonConfirmNoLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonConfirmNoLogin.leadingAnchor.constraint(equalTo: viewNoLogin.leadingAnchor, constant: 25),
            buttonConfirmNoLogin.trailingAnchor.constraint(equalTo: viewNoLogin.trailingAnchor, constant: -25),
            buttonConfirmNoLogin.topAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 20),
            buttonConfirmNoLogin.bottomAnchor.constraint(equalTo: viewNoLogin.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        buttonConfirmNoLogin.addTarget(self, action: #selector(handleConfirm(_:)), for: .touchUpInside)
    }
    
    private func setupLoadingOverlay() {
        view.addSubview(loading)
        
        // Cài đặt Auto Layout cho lớp phủ mờ để nó bao phủ toàn bộ view
        NSLayoutConstraint.activate([
            loading.topAnchor.constraint(equalTo: view.topAnchor),
            loading.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loading.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loading.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // Hiển thị lỗi
    private func showErrorAlert(message: String, isReload: Bool = false, handleReload: (() -> Void)?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        if isReload {
            alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { _ in
                handleReload?()
            }))
        }
        present(alert, animated: true)
    }
    
    // Hàm xử lý điều hướng tới màn hình đăng nhập
    @objc private func handleConfirm(_ sender: AnyObject) {
        HomeScreenViewController.redirectToSignin(for: self)
    }
    
    // Hàm xử lý khi refresh
    @objc private func refreshProductClassificaions(_ sender: AnyObject) {
        self.accountViewModel.fetchProfile(isRefresh: true)
    }
    
    // Hàm xử lý đăng xuất
    @objc private func handleLogOut(_ sender: AnyObject) {
        self.accountViewModel.logout()
    }
}
