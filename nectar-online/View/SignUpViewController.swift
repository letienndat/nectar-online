//
//  SignUpViewController.swift
//  nectar-online
//
//  Created by Macbook on 26/10/2024.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let (blurTop, blurBottom) = BlurView.getBlur()
    private let scrollView = UIScrollView()
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    private let labelTermsAndPolices: UILabel = UILabel()
    private lazy var formControlUsername = {
        return FormControllView(label: "Username", typeInput: .text, placeholder: "Enter your username")
    }()
    private lazy var formControlEmail = {
        return FormControllView(label: "Email", typeInput: .email, placeholder: "Enter your email", check: true)
    }()
    private lazy var formControlPassword = {
        return FormControllView(label: "Password", typeInput: .password, placeholder: "Enter your password")
    }()
    private let loading = AnimationLoadingView()
    private let selectLocationViewModel = SelectLocationViewModel.shared
    private let signUpViewModel = SignUpViewModel()
    private let loginViewModel = LoginViewModel.shared

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
        setupLoadingOverlay()
        
        signUpViewModel.showLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = false
            self.loading.startAnimation()
        }
        
        signUpViewModel.hideLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = true
            self.loading.stopAnimation()
        }
        
        signUpViewModel.showError = { [weak self] error in
            guard let self = self else { return }
            
            self.showErrorAlert(message: error)
        }
        
        signUpViewModel.signUpSuccess = { [weak self] in
            guard let self = self else { return }
            
            self.signUpSuccess()
        }
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
        title.text = "Sign Up"
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
        descriptionTitle.text = "Enter your credentials to continue"
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
        
        viewForm.addSubview(formControlUsername)

        formControlUsername.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formControlUsername.topAnchor.constraint(equalTo: viewForm.topAnchor),
            formControlUsername.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            formControlUsername.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),

            formControlUsername.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        viewForm.addSubview(formControlEmail)

        formControlEmail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formControlEmail.topAnchor.constraint(equalTo: formControlUsername.bottomAnchor, constant: 30),
            formControlEmail.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            formControlEmail.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),

            formControlEmail.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        viewForm.addSubview(formControlPassword)

        formControlPassword.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formControlPassword.topAnchor.constraint(equalTo: formControlEmail.bottomAnchor, constant: 30),
            formControlPassword.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            formControlPassword.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),

            formControlPassword.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        // Tạo NSAttributedString với các đoạn chữ có thể bấm vào
        let textTermsAndPolices = "By continuing you agree to our Terms of Service and Privacy Policy."
        let attributedText = NSMutableAttributedString(string: textTermsAndPolices)
        
        // Tạo paragraph style để cài đặt line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        
        // Thêm letter spacing 5%
        let letterSpacing = 0.05 * (UIFont(name: "Gilroy-Medium", size: 14)!.pointSize)
        
        // Định dạng toàn bộ văn bản
        attributedText.addAttributes([
            .foregroundColor: UIColor(hex: "#030303"),
            .font: UIFont(name: "Gilroy-Medium", size: 14)!,
            .paragraphStyle: paragraphStyle,
            .kern: letterSpacing
        ], range: NSRange(location: 0, length: textTermsAndPolices.count))
        
        // Định dạng và xác định phạm vi của "Terms of Service"
        let termsRange = (textTermsAndPolices as NSString).range(of: "Terms of Service")
        attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#53B175"), range: termsRange)
        
        // Định dạng và xác định phạm vi của "Privacy Policy"
        let privacyRange = (textTermsAndPolices as NSString).range(of: "Privacy Policy")
        attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#53B175"), range: privacyRange)
        
        // Cài đặt cho UILabel
        labelTermsAndPolices.attributedText = attributedText
        labelTermsAndPolices.numberOfLines = 0
        labelTermsAndPolices.isUserInteractionEnabled = true
        labelTermsAndPolices.translatesAutoresizingMaskIntoConstraints = false
        viewForm.addSubview(labelTermsAndPolices)
        
        NSLayoutConstraint.activate([
            labelTermsAndPolices.topAnchor.constraint(equalTo: formControlPassword.bottomAnchor, constant: 20),
            labelTermsAndPolices.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            labelTermsAndPolices.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),
            
            labelTermsAndPolices.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        // Thêm UITapGestureRecognizer cho UILabel
        let tapGestureLabelTermsAndPolices = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureLabelTermsAndPolices(_:)))
        labelTermsAndPolices.addGestureRecognizer(tapGestureLabelTermsAndPolices)
        
        let button = ButtonView.createSystemButton(
            title: "Sign Up",
            titleColor: UIColor(hex: "#FFF9FF"),
            titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
            backgroundColor: UIColor(hex: "#53B175"),
            borderRadius: 19
        )
        viewForm.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: labelTermsAndPolices.bottomAnchor, constant: 30),
            button.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),
            
            button.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        button.addTarget(self, action: #selector(handleSignup(_:)), for: .touchUpInside)
        
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
        labelQuestion.text = "Already have an account?"
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
        buttonRedirect.setTitle("Login", for: .normal)
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
        
        buttonRedirect.addTarget(self, action: #selector(handleRedirectSignin(_:)), for: .touchUpInside)
        
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
    
    // Xử lý sự kiện khi bấm vào đăng ký
    @objc func handleSignup(_ sender: UIButton) {
        
        guard let idZone = selectLocationViewModel.idZone,
              let idArea = selectLocationViewModel.idArea
        else {
            showErrorAlert(message: "Unable to recognize area!")
            return
        }
        
        guard let username = formControlUsername.formInput.text, !username.isEmpty else {
            showErrorAlert(message: "Invalid username format!")
            return
        }
        
        guard let email = formControlEmail.formInput.text, !email.isEmpty, Validate.validate(type: .email, string: email) else {
            showErrorAlert(message: "Invalid email format!")
            return
        }
        
        guard let password = formControlPassword.formInput.text, !password.isEmpty, Validate.validate(type: .password, string: password) else {
            showErrorAlert(message: "Invalid password format!")
            return
        }
        
        let data: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "zone_id": idZone,
            "area_id": idArea
        ]
        
        signUpViewModel.sendDataSignUp(data: data)
    }
    
    // Hàm xử lý khi đăng ký thành công
    private func signUpSuccess() {
        loginViewModel.showLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = false
            self.loading.startAnimation()
        }
        
        loginViewModel.hideLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = true
            self.loading.stopAnimation()
        }
        
        loginViewModel.showError = { [weak self] error in
            guard let self = self else { return }
            
            self.showErrorAlert(message: error)
        }
        
        loginViewModel.loginSuccess = { [weak self] in
            guard let self = self else { return }
            
            self.loginSuccess()
        }
        
        guard let email = formControlEmail.formInput.text, !email.isEmpty, Validate.validate(type: .email, string: email),
              let password = formControlPassword.formInput.text, !password.isEmpty, Validate.validate(type: .password, string: password)
        else { return }
        
        let data: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        loginViewModel.sendDataLogin(data: data)
    }
    
    // Hàm xử lý khi login thành công
    private func loginSuccess() {
        // Pop về màn hình gốc của UINavigationController bên trong tab Home
        self.tabBarController?.selectedIndex = 0
        
        if let homeNavController = self.tabBarController?.viewControllers?[0] as? UINavigationController {
            homeNavController.popToRootViewController(animated: true)
            if let homeScreenViewController = homeNavController.viewControllers.first as? HomeScreenViewController {
                homeScreenViewController.fetchData()
            }
        }
    }
    
    // Hiển thị lỗi
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Xử lý sự kiện khi bấm vào label điều khoản và chính sách
    @objc private func handleTapGestureLabelTermsAndPolices(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        let fullText = labelTermsAndPolices.text!
        let termsRange = (fullText as NSString).range(of: "Terms of Service")
        let privacyRange = (fullText as NSString).range(of: "Privacy Policy")

        let tapLocation = gesture.location(in: label)
        let index = labelTermsAndPolices.indexOfAttributedTextCharacter(at: tapLocation)

        // Kiểm tra xem đoạn nào được nhấn
        if NSLocationInRange(index, termsRange) {
            animateTextHighlight(in: label, range: termsRange) {
                self.handleTermsTapped()
            }
        } else if NSLocationInRange(index, privacyRange) {
            animateTextHighlight(in: label, range: privacyRange) {
                self.handlePrivacyTapped()
            }
        }
    }
    
    // Tạo hiệu ứng bấm vào label cho giống như bấm vào button (type system)
    private func animateTextHighlight(in label: UILabel, range: NSRange, completion: @escaping () -> Void) {
        guard let attributedText = label.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        
        // Thay đổi tạm thời màu đoạn nhấn
        attributedText.addAttribute(.foregroundColor, value: UIColor.gray, range: range)
        label.attributedText = attributedText

        // Đợi một chút rồi khôi phục màu và gọi completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#53B175"), range: range)
            label.attributedText = attributedText
            completion()
        }
    }
    
    // Hàm xử lý sự kiện khi bấm vào "Terms of Service"
    private func handleTermsTapped() {
        //
    }
    
    // Hàm xử lý sự kiện khi bấm vào "Privacy Policy"
    private func handlePrivacyTapped() {
        //
    }
    
    // Hàm xử lý điều hướng sang màn hình đăng nhập
    @objc func handleRedirectSignin(_ sender: UIButton) {
        let logInViewController = LogInViewController()
        logInViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.setViewControllers([logInViewController], animated: true)
    }
    
    // Hàm được gọi ngay trước khi ViewController xuất hiện
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if loading.isAnimating {
            loading.startAnimation()
        }
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
