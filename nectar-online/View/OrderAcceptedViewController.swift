//
//  OrderAcceptedViewController.swift
//  nectar-online
//
//  Created by Macbook on 12/11/2024.
//

import UIKit

class OrderAcceptedViewController: UIViewController {
    
    private let (blurTop, blurBottom) = BlurView.getBlur()
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
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        self.view.addSubview(blurTop)
        blurTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurTop.topAnchor.constraint(equalTo: view.topAnchor),
            blurTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurTop.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        self.view.addSubview(blurBottom)
        blurBottom.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurBottom.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        let viewTop = UIView()
        viewTop.backgroundColor = .clear
        view.addSubview(viewTop)
        
        viewTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewTop.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewTop.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            viewTop.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        
        let subView = UIView()
        viewTop.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: viewTop.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: viewTop.trailingAnchor),
            subView.centerYAnchor.constraint(equalTo: viewTop.centerYAnchor)
        ])
        
        let imageOrderSuccess = UIImageView(image: UIImage(named: "image-order-success"))
        imageOrderSuccess.contentMode = .scaleAspectFit
        subView.addSubview(imageOrderSuccess)
        
        imageOrderSuccess.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageOrderSuccess.topAnchor.constraint(equalTo: subView.topAnchor),
            imageOrderSuccess.centerXAnchor.constraint(equalTo: subView.centerXAnchor, constant: -16),
            
            imageOrderSuccess.widthAnchor.constraint(equalToConstant: 269.08),
            imageOrderSuccess.heightAnchor.constraint(equalToConstant: 240.31)
        ])
        
        let labelTitle = UILabel()
        labelTitle.text = "Your Order has been accepted"
        labelTitle.font = UIFont(name: "Gilroy-Semibold", size: 28)
        labelTitle.textColor = UIColor(hex: "#181725")
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .center
        
        // Tạo NSMutableParagraphStyle để cài đặt line height
        let paragraphStyleTitle = NSMutableParagraphStyle()
        paragraphStyleTitle.lineSpacing = 5 // Khoảng cách giữa các dòng (line height)
        paragraphStyleTitle.alignment = .center
        
        // Tạo NSAttributedString với đoạn text và paragraphStyle
        let attributedStringTitle = NSMutableAttributedString(string: labelTitle.text!)
        attributedStringTitle.addAttribute(.paragraphStyle, value: paragraphStyleTitle, range: NSRange(location: 0, length: attributedStringTitle.length))
        
        // Gán NSAttributedString vào UILabel
        labelTitle.attributedText = attributedStringTitle
        
        subView.addSubview(labelTitle)
        
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: imageOrderSuccess.bottomAnchor, constant: 66.67),
            labelTitle.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 74.41),
            labelTitle.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -74.41),
            labelTitle.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
        ])
        
        let labelSubTitle = UILabel()
        labelSubTitle.text = "Your items has been placcd and is on it’s way to being processed"
        labelSubTitle.font = UIFont(name: "Gilroy-Medium", size: 16)
        labelSubTitle.textColor = UIColor(hex: "#7C7C7C")
        labelSubTitle.numberOfLines = 0
        labelSubTitle.textAlignment = .center
        
        // Tạo NSMutableParagraphStyle để cài đặt line height
        let paragraphStyleSubTitle = NSMutableParagraphStyle()
        paragraphStyleSubTitle.lineSpacing = 5 // Khoảng cách giữa các dòng (line height)
        paragraphStyleSubTitle.alignment = .center
        
        // Tạo NSAttributedString với đoạn text và paragraphStyle
        let attributedStringSubTitle = NSMutableAttributedString(string: labelSubTitle.text!)
        attributedStringSubTitle.addAttribute(.paragraphStyle, value: paragraphStyleSubTitle, range: NSRange(location: 0, length: attributedStringSubTitle.length))
        
        // Gán NSAttributedString vào UILabel
        labelSubTitle.attributedText = attributedStringSubTitle
        
        subView.addSubview(labelSubTitle)
        
        labelSubTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelSubTitle.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20),
            labelSubTitle.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 67.91),
            labelSubTitle.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -67.91),
            labelSubTitle.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
            labelSubTitle.centerXAnchor.constraint(equalTo: subView.centerXAnchor)
        ])
        
        let buttonTrackOrder = ButtonView.createSystemButton(
            title: "Track Order",
            titleColor: UIColor(hex: "#FFF9FF"),
            titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
            backgroundColor: UIColor(hex: "#53B175"),
            borderRadius: 19
        )
        self.view.addSubview(buttonTrackOrder)
        
        buttonTrackOrder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonTrackOrder.topAnchor.constraint(equalTo: viewTop.bottomAnchor),
            buttonTrackOrder.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            buttonTrackOrder.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
        ])
        
        buttonTrackOrder.addTarget(self, action: #selector(handleTrackOrder(_:)), for: .touchUpInside)
        
        let buttonBackToHome = ButtonView.createSystemButton(
            title: "Back to home",
            titleColor: UIColor(hex: "#181725"),
            titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
            backgroundColor: .clear
        )
        self.view.addSubview(buttonBackToHome)
        
        buttonBackToHome.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonBackToHome.topAnchor.constraint(equalTo: buttonTrackOrder.bottomAnchor),
            buttonBackToHome.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            buttonBackToHome.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            buttonBackToHome.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -28.5)
        ])
        
        buttonBackToHome.addTarget(self, action: #selector(handleBackToHome(_:)), for: .touchUpInside)
    }
    
    // Hàm xử lý Track Order
    @objc private func handleTrackOrder(_ sender: AnyObject) {
        //
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
