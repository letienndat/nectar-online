//
//  NumberViewController.swift
//  nectar-online
//
//  Created by Macbook on 20/10/2024.
//

import UIKit

class VerificationViewController: UIViewController {
    
    private let backgroundBlurView = BackgroundBlur()
    private let inputCode = UITextField()
    private let scrollView = UIScrollView()
    private let viewEmptyTop = UIView()
    private let viewContent = UIView()
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    private var viewEmptyTopBottonConstraint: NSLayoutConstraint?
    private var viewContentHeightAnchorConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Đăng ký thông báo khi bàn phím xuất hiện và ẩn đi
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Tạo UITapGestureRecognizer để phát hiện người dùng bấm ra ngoài view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeybroad))
        
        // Thêm gesture vào view cha
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
        configNav()
        configView()
    }
    
    func configNav() {
        // Tạo UIImage cho icon quay lại
        let backIcon = UIImage(named: "icon-back-nav")?.withRenderingMode(.alwaysTemplate)
        
        // Tùy chỉnh màu sắc cho icon
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "#181725")

        // Tạo UIButton cho nút quay lại tùy chỉnh
        let backButton = UIButton(type: .custom)
        backButton.setImage(backIcon, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 10, height: 18) // Kích thước icon

        // Tạo UIBarButtonItem từ UIButton
        let customBackButtonItem = UIBarButtonItem(customView: backButton)
        
        // Tạo UIBarButtonItem cho khoảng cách
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 25.0 - 10

        // Thiết lập item trái cho navigation bar
        self.navigationItem.leftBarButtonItems = [spacer, customBackButtonItem]

        // Xóa tiêu đề của nút quay lại
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func hideKeybroad() {
        self.view.endEditing(true)
    }
    
    // Hàm quay lại
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
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
    
    func configView() {
        view.backgroundColor = UIColor(hex: "#FCFCFC")
        
        backgroundBlurView.frame = view.bounds // Đặt kích thước cho blur background
        backgroundBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundBlurView)
        
        view.addSubview(scrollView)
        
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
        
        scrollView.addSubview(viewEmptyTop)
        
        viewEmptyTop.translatesAutoresizingMaskIntoConstraints = false
        viewEmptyTopBottonConstraint = viewEmptyTop.heightAnchor.constraint(equalToConstant: 65.19)
        NSLayoutConstraint.activate([
            viewEmptyTop.topAnchor.constraint(equalTo: scrollView.topAnchor),
            viewEmptyTop.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            viewEmptyTop.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            viewEmptyTop.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            viewEmptyTopBottonConstraint!
        ])
        
        scrollView.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        viewContentHeightAnchorConstraint = viewContent.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, constant: -65.19)
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: viewEmptyTop.bottomAnchor),
            viewContent.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 25),
            viewContent.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -25),
            viewContent.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            viewContent.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -50),
            viewContentHeightAnchorConstraint!
        ])
        
        let labelTitle = UILabel()
        labelTitle.text = "Enter your 4-digit code"
        labelTitle.textColor = UIColor(hex: "#181725")
        labelTitle.font = UIFont(name: "Gilroy-Semibold", size: 26)
        labelTitle.numberOfLines = 0
        viewContent.addSubview(labelTitle)

        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: viewContent.topAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            labelTitle.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            
            labelTitle.heightAnchor.constraint(equalToConstant: 29),
        ])

        let labelTitleInput = UILabel()
        labelTitleInput.text = "Code"
        labelTitleInput.textColor = UIColor(hex: "#7C7C7C")
        labelTitleInput.font = UIFont(name: "Gilroy-Semibold", size: 16)
        viewContent.addSubview(labelTitleInput)

        labelTitleInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitleInput.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 27.58),
            labelTitleInput.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            labelTitleInput.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            
            labelTitleInput.heightAnchor.constraint(equalToConstant: 29)
        ])

        let viewEnterCode = UIStackView()
        viewEnterCode.axis = .horizontal
        viewEnterCode.alignment = .top
        viewEnterCode.addBottomBorder(color: UIColor(hex: "#E2E2E2"), borderLineSize: 1)
        viewContent.addSubview(viewEnterCode)

        viewEnterCode.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEnterCode.topAnchor.constraint(equalTo: labelTitleInput.bottomAnchor, constant: 10),
            viewEnterCode.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            viewEnterCode.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            
            viewEnterCode.widthAnchor.constraint(equalTo: viewContent.widthAnchor),
            viewEnterCode.heightAnchor.constraint(equalToConstant: 39.55)
        ])
        
        inputCode.font = UIFont(name: "Gilroy-Medium", size: 18)
        inputCode.textColor = UIColor(hex: "#181725")
        inputCode.keyboardType = .phonePad
        inputCode.placeholder = "- - - -"
        viewEnterCode.addSubview(inputCode)

        inputCode.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputCode.leadingAnchor.constraint(equalTo: viewEnterCode.leadingAnchor),
            inputCode.widthAnchor.constraint(equalTo: viewEnterCode.widthAnchor),
            inputCode.heightAnchor.constraint(equalToConstant: 29)
        ])

        let viewEmpty = UIView()
        viewContent.addSubview(viewEmpty)

        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.topAnchor.constraint(equalTo: viewEnterCode.bottomAnchor),
            viewEmpty.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            viewEmpty.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),

            viewEmpty.widthAnchor.constraint(equalTo: viewContent.widthAnchor),
        ])

        let viewOption = UIView()
        viewContent.addSubview(viewOption)

        viewOption.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewOption.topAnchor.constraint(equalTo: viewEmpty.bottomAnchor),
            viewOption.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor),
            viewOption.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            viewOption.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),

            viewOption.widthAnchor.constraint(equalTo: viewContent.widthAnchor),
            viewOption.heightAnchor.constraint(equalToConstant: 67 + 30.3 + 20)
        ])
        
        let labelResendCode = UILabel()
        labelResendCode.text = "Resend Code"
        labelResendCode.textColor = UIColor(hex: "#53B175")
        labelResendCode.font = UIFont(name: "Gilroy-Medium", size: 18)
        viewOption.addSubview(labelResendCode)
        
        labelResendCode.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelResendCode.leadingAnchor.constraint(equalTo: viewOption.leadingAnchor),
            labelResendCode.centerYAnchor.constraint(equalTo: viewOption.centerYAnchor)
        ])

        let iconNextScreen = UIImageView()
        iconNextScreen.isUserInteractionEnabled = true
        iconNextScreen.image = UIImage(named: "icon-next-screen-enter-number-phone")
        viewOption.addSubview(iconNextScreen)

        iconNextScreen.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconNextScreen.topAnchor.constraint(equalTo: viewOption.topAnchor, constant: 20),
            iconNextScreen.trailingAnchor.constraint(equalTo: viewOption.trailingAnchor),
            iconNextScreen.bottomAnchor.constraint(equalTo: viewOption.bottomAnchor, constant: -30.3),
            
            iconNextScreen.widthAnchor.constraint(equalToConstant: 67),
            iconNextScreen.heightAnchor.constraint(equalToConstant: 67)
        ])
        
//        iconNextScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapContinue(_:))))
    }
    
    @objc func tapContinue(_ sender: UITapGestureRecognizer) {
        let verificationViewController = VerificationViewController()
        self.navigationController?.pushViewController(verificationViewController, animated: true)
    }
    
    // Hàm được gọi ngay trước khi ViewController xuất hiện
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Kiểm tra hướng ban đầu khi view được tải
        if UIDevice.current.orientation.isLandscape {
            // Thiết bị đang xoay ngang
            setupLandscapeLayout()
        } else {
            // Thiết bị đang xoay dọc
            setupPortraitLayout()
        }
        
        inputCode.becomeFirstResponder()
    }
    
    // Hàm được gọi ngay sau khi view đã được hiển thị trên màn hình
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Kiểm tra hướng ban đầu khi view được tải
        if UIDevice.current.orientation.isLandscape {
            // Thiết bị đang xoay ngang
            setupLandscapeLayout()
        } else {
            // Thiết bị đang xoay dọc
            setupPortraitLayout()
        }
    }
    
    // Hàm được gọi trước khi ViewController biến mất
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupLandscapeLayout() {
        if let oldConstraintViewEmptyTopBotton = viewEmptyTopBottonConstraint {
            oldConstraintViewEmptyTopBotton.isActive = false
        }
        viewEmptyTopBottonConstraint = viewEmptyTop.heightAnchor.constraint(equalToConstant: 20)
        viewEmptyTopBottonConstraint?.isActive = true
        
        if let oldConstraintViewContentHeightAnchor = viewContentHeightAnchorConstraint {
            oldConstraintViewContentHeightAnchor.isActive = false
        }
        viewContentHeightAnchorConstraint = viewContent.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, constant: -20)
        viewContentHeightAnchorConstraint?.isActive = true
    }
    
    func setupPortraitLayout() {
        if let oldConstraintViewEmptyTopBotton = viewEmptyTopBottonConstraint {
            oldConstraintViewEmptyTopBotton.isActive = false
        }
        viewEmptyTopBottonConstraint = viewEmptyTop.heightAnchor.constraint(equalToConstant: 65.19)
        viewEmptyTopBottonConstraint?.isActive = true
        
        if let oldConstraintViewContentHeightAnchor = viewContentHeightAnchorConstraint {
            oldConstraintViewContentHeightAnchor.isActive = false
        }
        viewContentHeightAnchorConstraint = viewContent.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor, constant: -65.19)
        viewContentHeightAnchorConstraint?.isActive = true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeRight, .landscapeLeft]
    }
    
    // Sửa layout lại khi quay ngang màn hình
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { context in
            // Kiểm tra nếu xoay sang ngang hay dọc
            if size.width > size.height {
                // Xoay ngang
                self.setupLandscapeLayout()
            } else {
                // Xoay dọc
                self.setupPortraitLayout()
            }
        })
    }
    
    deinit {
        // Hủy đăng ký thông báo khi không còn sử dụng
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
