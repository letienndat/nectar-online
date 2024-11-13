//
//  CheckoutViewController.swift
//  nectar-online
//
//  Created by Macbook on 12/11/2024.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    private let tabBarController_: UITabBarController
    private var subView: UIView!
    private let loading = AnimationLoadingView()
    private let checkoutViewModel = CheckoutViewModel()
    
    init(tabBarController: UITabBarController, totalPrice: Double) {
        self.tabBarController_ = tabBarController
        self.checkoutViewModel.totalCost = totalPrice
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupLoadingOverlay()
        
        self.checkoutViewModel.hideLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = true
            self.loading.stopAnimation()
        }
        
        self.checkoutViewModel.showLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = false
            self.loading.startAnimation()
        }
        
        self.checkoutViewModel.showError = { [weak self] error in
            guard let self = self else { return }
            
            self.showErrorAlert(message: error, handleReload: nil)
        }
        
        self.checkoutViewModel.closureNoAccess = { [weak self] in
            guard let self = self else { return }
            
            // Tạo view controller của thông báo đăng nhập
            let notifyRequireLoginViewController = NotifyRequireLoginViewController(content: "Your session has expired. Please login to use this feature!")
            
            // Bọc nó trong UINavigationController
            let navController = UINavigationController(rootViewController: notifyRequireLoginViewController)
            
            // Tùy chọn hiển thị modally
            navController.modalPresentationStyle = .overFullScreen
            navController.modalTransitionStyle = .crossDissolve
            
            // Trình bày modally để nó chồng lên tabBar
            self.present(navController, animated: true, completion: nil)
        }
        
        self.checkoutViewModel.closureOrderSuccess = { [weak self] in
            guard let self = self else { return }
            
            let orderAcceptedViewController = OrderAcceptedViewController(tabBarController: self.tabBarController_) {
                self.dismiss(animated: false, completion: nil)
            }
            orderAcceptedViewController.modalPresentationStyle = .overFullScreen
            self.present(orderAcceptedViewController, animated: false, completion: nil)
        }
        
        self.checkoutViewModel.closureOrderFail = { [weak self] in
            guard let self = self else { return }
            
            let orderFailViewController = OrderFailViewController(tabBarController: self.tabBarController_) {
                self.dismiss(animated: false, completion: nil)
            }
            orderFailViewController.modalPresentationStyle = .overFullScreen
            self.present(orderFailViewController, animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Sử dụng DispatchQueue để delay animation, đảm bảo animation được thực thi sau khi view đã hiển thị
        DispatchQueue.main.async {
            self.slideUpWhiteView()
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeCheckout))
        view.addGestureRecognizer(tapGesture)
        
        subView = UIView()
        subView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 520.5))
        subView.backgroundColor = UIColor(hex: "#FFFFFF")
        subView.layer.cornerRadius = 30
        subView.clipsToBounds = true
        view.addSubview(subView)
        
        subView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        
        let viewHeader = UIView()
        subView.addSubview(viewHeader)
        
        viewHeader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewHeader.topAnchor.constraint(equalTo: subView.topAnchor),
            viewHeader.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25),
            viewHeader.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25),
            
            viewHeader.heightAnchor.constraint(equalToConstant: 89)
        ])
        
        let titleHeader = UILabel()
        titleHeader.text = "Checkout"
        titleHeader.font = UIFont(name: "Gilroy-Semibold", size: 24)
        titleHeader.textColor = UIColor(hex: "181725")
        titleHeader.textAlignment = .left
        titleHeader.numberOfLines = 1
        viewHeader.addSubview(titleHeader)
        
        titleHeader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleHeader.leadingAnchor.constraint(equalTo: viewHeader.leadingAnchor),
            titleHeader.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor)
        ])
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "icon-close"), for: .normal)
        closeButton.tintColor = UIColor(hex: "#181725")
        closeButton.addTarget(self, action: #selector(closeCheckout), for: .touchUpInside)
        viewHeader.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: viewHeader.trailingAnchor),
            closeButton.centerYAnchor.constraint(equalTo: viewHeader.centerYAnchor),
            
            closeButton.widthAnchor.constraint(equalToConstant: 15.71),
            closeButton.heightAnchor.constraint(equalToConstant: 15.53)
        ])
        
        let line = UIView()
        line.backgroundColor = UIColor(hex: "#E2E2E2", alpha: 0.7)
        subView.addSubview(line)
        
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: viewHeader.bottomAnchor),
            line.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 1
        stackView.backgroundColor = UIColor(hex: "#E2E2E2", alpha: 0.7)
        subView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: line.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25)
        ])
        
        self.checkoutViewModel.optionsViewCheckout.forEach { option in
            
            let title = UILabel()
            title.text = option.title
            title.font = UIFont(name: "Gilroy-Semibold", size: 18)
            title.textColor = UIColor(hex: "#7C7C7C")
            
            if option.isChange {
                let rightView = UILabel()
                rightView.text = "$" + String(format: "%.2f", self.checkoutViewModel.totalCost)
                rightView.font = UIFont(name: "Gilroy-Semibold", size: 16)
                rightView.textColor = UIColor(hex: "#181725")
                
                let optionInCheckoutView = OptionInCheckoutView(title: title, rightView: rightView)
                stackView.addArrangedSubview(optionInCheckoutView)
            }
            
            if let textRight = option.textRight {
                let rightView = UILabel()
                rightView.text = textRight
                rightView.font = UIFont(name: "Gilroy-Semibold", size: 16)
                rightView.textColor = UIColor(hex: "#181725")
                
                let optionInCheckoutView = OptionInCheckoutView(title: title, rightView: rightView)
                stackView.addArrangedSubview(optionInCheckoutView)
            } else if let imageRight = option.imageRight {
                let rightView = UIImageView(image: UIImage(named: imageRight))
                
                let optionInCheckoutView = OptionInCheckoutView(title: title, rightView: rightView)
                stackView.addArrangedSubview(optionInCheckoutView)
            }
        }
        
        stackView.addArrangedSubview(UIView())
        
        let textAgreeTermsAndConditions = """
        By placing an order you agree to our
        Terms And Conditions
        """
        let attributedText = NSMutableAttributedString(string: textAgreeTermsAndConditions)
        
        // Tạo paragraph style để cài đặt line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        
        // Thêm letter spacing 5%
        let letterSpacing = 0.05 * (UIFont(name: "Gilroy-Semibold", size: 14)!.pointSize)
        
        // Định dạng toàn bộ văn bản
        attributedText.addAttributes([
            .foregroundColor: UIColor(hex: "#7C7C7C"),
            .font: UIFont(name: "Gilroy-Medium", size: 14)!,
            .paragraphStyle: paragraphStyle,
            .kern: letterSpacing
        ], range: NSRange(location: 0, length: textAgreeTermsAndConditions.count))
        
        // Định dạng và xác định phạm vi của "Terms of Service"
        let termsRange = (textAgreeTermsAndConditions as NSString).range(of: "Terms")
        attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#181725"), range: termsRange)
        attributedText.addAttribute(.font, value: UIFont(name: "Gilroy-Semibold", size: 14) ?? .boldSystemFont(ofSize: 14), range: termsRange)
        
        // Định dạng và xác định phạm vi của "Privacy Policy"
        let conditionsRange = (textAgreeTermsAndConditions as NSString).range(of: "Conditions")
        attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#181725"), range: conditionsRange)
        attributedText.addAttribute(.font, value: UIFont(name: "Gilroy-Semibold", size: 14) ?? .systemFont(ofSize: 14), range: conditionsRange)
        
        attributedText.addAttribute(.font, value: UIFont(name: "Gilroy-Semibold", size: 14) ?? .boldSystemFont(ofSize: 14), range: termsRange)
        
        // Cài đặt cho UILabel
        let labelAgreeTermsAndConditions = UILabel()
        labelAgreeTermsAndConditions.attributedText = attributedText
        labelAgreeTermsAndConditions.numberOfLines = 0
        subView.addSubview(labelAgreeTermsAndConditions)
        
        labelAgreeTermsAndConditions.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelAgreeTermsAndConditions.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            labelAgreeTermsAndConditions.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25),
            labelAgreeTermsAndConditions.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25)
        ])
        
        let buttonPlaceOrder = ButtonView.createSystemButton(
            title: "Place Order",
            titleColor: UIColor(hex: "#FFF9FF"),
            titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
            backgroundColor: UIColor(hex: "#53B175"),
            borderRadius: 19
        )
        subView.addSubview(buttonPlaceOrder)
        
        buttonPlaceOrder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonPlaceOrder.topAnchor.constraint(equalTo: labelAgreeTermsAndConditions.bottomAnchor, constant: 26.5),
            buttonPlaceOrder.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25),
            buttonPlaceOrder.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25),
            buttonPlaceOrder.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -30)
        ])
        
        buttonPlaceOrder.addTarget(self, action: #selector(handlePlaceOrder(_:)), for: .touchUpInside)
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
    
    func slideUpWhiteView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.subView.frame.origin.y = UIScreen.main.bounds.height - self.subView.frame.height
        }, completion: nil)
    }

    @objc private  func closeCheckout() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func handlePlaceOrder(_ sender: AnyObject) {
        self.checkoutViewModel.checkout()
    }
}
