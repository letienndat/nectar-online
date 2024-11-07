//
//  AccountViewController.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupNav()
        self.setupView()
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
        
        viewLogin.backgroundColor = .blue
        
        viewLogin.isHidden = true
        
        viewLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewLogin.topAnchor.constraint(equalTo: self.view.topAnchor),
            viewLogin.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            viewLogin.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewLogin.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
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
    
    @objc private func handleConfirm(_ sender: AnyObject) {
        HomeScreenViewController.redirectToSignin(for: self)
    }
}
