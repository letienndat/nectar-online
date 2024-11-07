//
//  NotifyRequireLoginViewController.swift
//  nectar-online
//
//  Created by Macbook on 07/11/2024.
//

import UIKit

class NotifyRequireLoginViewController: UIViewController {
    let content: String
    let buttonConfirm = ButtonView.createSystemButton(
        title: "Redirect To Signin",
        titleColor: UIColor(hex: "#FFF9FF"),
        titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
        backgroundColor: UIColor(hex: "#53B175"),
        borderRadius: 19
    )
    var closureHandleConfirm: (() -> Void)?

    init(content: String) {
        self.content = content
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupNav()
        self.setupView()
    }
    
    private func setupNav() {
        self.title = "Notification"
        self.view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        // Thêm nút đóng
        let closeButton = UIBarButtonItem(image: UIImage(named: "icon-close"), style: .plain, target: self, action: #selector(handleClose(_:)))
        closeButton.tintColor = UIColor(hex: "#181725")
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        let viewContent = UIView()
        self.view.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: self.view.topAnchor),
            viewContent.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            viewContent.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
        ])
        
        let labelContent = UILabel()
        labelContent.text = content
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
        
        self.view.addSubview(buttonConfirm)
        buttonConfirm.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonConfirm.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            buttonConfirm.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            buttonConfirm.topAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 20),
            buttonConfirm.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        buttonConfirm.addTarget(self, action: #selector(handleConfirm(_:)), for: .touchUpInside)
    }
    
    @objc private func handleClose(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleConfirm(_ sender: AnyObject) {
        self.closureHandleConfirm?()
        self.dismiss(animated: true)
    }
}
