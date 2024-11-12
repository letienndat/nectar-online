//
//  OrderFailViewController.swift
//  nectar-online
//
//  Created by Macbook on 12/11/2024.
//

import UIKit

class OrderFailViewController: UIViewController {
    
    private let tabBarController_: UITabBarController
    private let closureDismissSupperView: (() -> Void)?
    
    init(tabBarController: UITabBarController, closureDismissSupperView: (() -> Void)?) {
        self.tabBarController_ = tabBarController
        self.closureDismissSupperView = closureDismissSupperView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeView)))
        
        let subView = UIView()
        subView.backgroundColor = UIColor(hex: "#FFFFFF")
        subView.layer.cornerRadius = 30
        subView.clipsToBounds = true
        view.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            subView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            
            subView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "icon-close"), for: .normal)
        closeButton.tintColor = UIColor(hex: "#181725")
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        subView.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25.2),
            closeButton.topAnchor.constraint(equalTo: subView.topAnchor, constant: 26.98),
            
            closeButton.widthAnchor.constraint(equalToConstant: 15.71),
            closeButton.heightAnchor.constraint(equalToConstant: 15.53)
        ])
        
        let imageOrderFail = UIImageView(image: UIImage(named: "image-order-fail"))
        imageOrderFail.contentMode = .scaleAspectFit
        subView.addSubview(imageOrderFail)
        
        imageOrderFail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageOrderFail.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 18.47),
            imageOrderFail.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            
            imageOrderFail.widthAnchor.constraint(equalToConstant: 222.35),
            imageOrderFail.heightAnchor.constraint(equalToConstant: 221.85)
        ])
        
        let labelTitle = UILabel()
        labelTitle.text = "Oops! Order Failed"
        labelTitle.font = UIFont(name: "Gilroy-Semibold", size: 28)
        labelTitle.textColor = UIColor(hex: "#181725")
        labelTitle.textAlignment = .center
        subView.addSubview(labelTitle)
        
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: imageOrderFail.bottomAnchor, constant: 49.18),
            labelTitle.centerXAnchor.constraint(equalTo: subView.centerXAnchor)
        ])
        
        let labelSubTitle = UILabel()
        labelSubTitle.text = "Something went tembly wrong."
        labelSubTitle.font = UIFont(name: "Gilroy-Medium", size: 16)
        labelSubTitle.textColor = UIColor(hex: "#7C7C7C")
        labelSubTitle.textAlignment = .center
        subView.addSubview(labelSubTitle)
        
        labelSubTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelSubTitle.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20.71),
            labelSubTitle.centerXAnchor.constraint(equalTo: subView.centerXAnchor)
        ])
        
        let buttonPleaseTryAgain = ButtonView.createSystemButton(
            title: "Please Try Again",
            titleColor: UIColor(hex: "#FFF9FF"),
            titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
            backgroundColor: UIColor(hex: "#53B175"),
            borderRadius: 19
        )
        subView.addSubview(buttonPleaseTryAgain)
        
        buttonPleaseTryAgain.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonPleaseTryAgain.topAnchor.constraint(equalTo: labelSubTitle.bottomAnchor, constant: 60.51),
            buttonPleaseTryAgain.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25.25),
            buttonPleaseTryAgain.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25.25),
        ])
        
        buttonPleaseTryAgain.addTarget(self, action: #selector(handlePleaseTryAgain(_:)), for: .touchUpInside)
        
        let buttonBackToHome = ButtonView.createSystemButton(
            title: "Back to home",
            titleColor: UIColor(hex: "#181725"),
            titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
            backgroundColor: .clear
        )
        subView.addSubview(buttonBackToHome)
        
        buttonBackToHome.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonBackToHome.topAnchor.constraint(equalTo: buttonPleaseTryAgain.bottomAnchor),
            buttonBackToHome.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25.25),
            buttonBackToHome.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25.25),
            buttonBackToHome.bottomAnchor.constraint(equalTo: subView.bottomAnchor)
        ])
        
        buttonBackToHome.addTarget(self, action: #selector(handleBackToHome(_:)), for: .touchUpInside)
    }

    // Hàm xử lý đóng modal
    @objc private func closeView() {
        dismiss(animated: false, completion: nil)
    }
    
    // Hàm xử lý khi bấm Please Try Again
    @objc private func handlePleaseTryAgain(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // Hàm xử lý khi bấm Back to home
    @objc private func handleBackToHome(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: {
            self.closureDismissSupperView?()
            
            self.tabBarController_.selectedIndex = 0
            
            if let navigationController = self.tabBarController_.viewControllers?[0] as? UINavigationController {
                if let homeScreenViewController = navigationController.viewControllers.first as? HomeScreenViewController {
                    homeScreenViewController.fetchData()
                }
            }
        })
    }
}
