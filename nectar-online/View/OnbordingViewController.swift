//
//  OnbordingViewController.swift
//  nectar-online
//
//  Created by Macbook on 19/10/2024.
//

import UIKit

class OnbordingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
    }

    func setupView() {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "background-welcome-screen.png")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        setupContentView()
    }
    
    func setupContentView() {
        let subView: UIView = UIView()
        subView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subView)
        
        NSLayoutConstraint.activate([
            subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90.84),
            subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.5),
            subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.5)
        ])
        
        let imageViewIcon: UIImageView = UIImageView()
        imageViewIcon.image = UIImage(named: "carrot-welcome-screen.svg")
        imageViewIcon.translatesAutoresizingMaskIntoConstraints = false
        subView.addSubview(imageViewIcon)
        
        NSLayoutConstraint.activate([
            imageViewIcon.topAnchor.constraint(equalTo: subView.topAnchor, constant: 0),
            imageViewIcon.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            imageViewIcon.widthAnchor.constraint(equalToConstant: 48.47),
            imageViewIcon.heightAnchor.constraint(equalToConstant: 56.36)
        ])
        
        // Tạo UILabel cho dòng văn bản đầu tiên
        let textWelcomeLine: UILabel = UILabel()
        textWelcomeLine.font = UIFont(name: "Gilroy-SemiBold", size: 48)
        textWelcomeLine.textColor = .white
        textWelcomeLine.textAlignment = .center // Canh giữa văn bản
        textWelcomeLine.backgroundColor = .clear
        textWelcomeLine.translatesAutoresizingMaskIntoConstraints = false
        textWelcomeLine.text = "Welcome to our store" // Nội dung văn bản
        textWelcomeLine.numberOfLines = 0

        subView.addSubview(textWelcomeLine)

        NSLayoutConstraint.activate([
            textWelcomeLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 73.5),
            textWelcomeLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -74.5),
            textWelcomeLine.topAnchor.constraint(equalTo: imageViewIcon.bottomAnchor, constant: 35.66),
        ])
        
        // Tạo UILabel cho dòng văn bản đầu tiên
        let textWelcomeSub: UILabel = UILabel()
        textWelcomeSub.font = UIFont(name: "Gilroy-Medium", size: 18)
        textWelcomeSub.textColor = UIColor(hex: "#FCFCFC", alpha: 0.7)
        textWelcomeSub.textAlignment = .center // Canh giữa văn bản
        textWelcomeSub.backgroundColor = .clear
        textWelcomeSub.translatesAutoresizingMaskIntoConstraints = false
        textWelcomeSub.text = "Ger your groceries in as fast as one hour" // Nội dung văn bản
        textWelcomeSub.numberOfLines = 0

        subView.addSubview(textWelcomeSub)

        NSLayoutConstraint.activate([
            textWelcomeSub.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            textWelcomeSub.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 0),
            textWelcomeSub.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 0),
            textWelcomeSub.topAnchor.constraint(equalTo: textWelcomeLine.bottomAnchor, constant: 19),
        ])
        let button: UIButton = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(UIColor(hex: "#FFF9FF"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-Semibold", size: 18)
        button.backgroundColor = UIColor(hex: "#53B175")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)

        subView.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: textWelcomeSub.bottomAnchor, constant: 19),
            button.heightAnchor.constraint(equalToConstant: 67),
            button.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: 0)
        ])
    }
    
    @objc func handleButton() {
        let signInViewController = SignInViewController()
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
    
    // Hàm được gọi khi ViewController xuất hiện
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Hàm được gọi trước khi ViewController biến mất
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeLeft, .landscapeRight]
    }
}
