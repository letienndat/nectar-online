//
//  NumberViewController.swift
//  nectar-online
//
//  Created by Macbook on 20/10/2024.
//

import UIKit

class VerificationViewController: UIViewController, UITextFieldDelegate {
    
    private let (blurTop, blurBottom) = Blur.getBlur()
    private let inputCode = UITextField()
    private let scrollView = UIScrollView()
    private let viewEmptyTop = UIView()
    private let viewContent = UIView()
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    private var viewEmptyTopBottonConstraint: NSLayoutConstraint?
    private var inputCodes: [CustomTextField] = []
    private let inputsCount = 4
    private let iconNextScreen = UIImageView()

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
    
    func setupNav() {
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
    
    func setupView() {
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
            blurBottom.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
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
            subView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            subView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            subView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            subView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        subView.addSubview(viewEmptyTop)
        
        viewEmptyTop.translatesAutoresizingMaskIntoConstraints = false
        viewEmptyTopBottonConstraint = viewEmptyTop.heightAnchor.constraint(equalToConstant: 65.19)
        NSLayoutConstraint.activate([
            viewEmptyTop.topAnchor.constraint(equalTo: subView.topAnchor),
            viewEmptyTop.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewEmptyTop.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            viewEmptyTop.widthAnchor.constraint(equalTo: subView.widthAnchor),
            viewEmptyTopBottonConstraint!
        ])
        
        subView.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: viewEmptyTop.bottomAnchor),
            viewContent.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25),
            viewContent.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25),
            viewContent.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
            
            viewContent.widthAnchor.constraint(equalTo: subView.widthAnchor, constant: -50),
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
        viewEnterCode.distribution = .fill
        viewEnterCode.spacing = 5
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
        
        for i in 0..<inputsCount {
            inputCodes.append(CustomTextField())
            inputCodes[i].font = UIFont(name: "Gilroy-Medium", size: 18)
            inputCodes[i].textColor = UIColor(hex: "#181725")
            inputCodes[i].keyboardType = .phonePad
            inputCodes[i].placeholder = "-"
            inputCodes[i].textAlignment = .center
            inputCodes[i].delegate = self
            viewEnterCode.addArrangedSubview(inputCodes[i])
            
            if i == 0 {
                inputCodes[i].isUserInteractionEnabled = true
            } else {
                inputCodes[i].isUserInteractionEnabled = false
            }
            
            inputCodes[i].tintColor = .clear

            inputCodes[i].translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                inputCodes[i].widthAnchor.constraint(equalToConstant: 20),
                inputCodes[i].heightAnchor.constraint(equalToConstant: 29)
            ])
            
            inputCodes[i].onDeleteBackward = {
                self.hideButtonNextScreen()
                if i == 0 {
                    print("Cleared")
                } else {
                    self.inputCodes[i].isUserInteractionEnabled = false
                    self.inputCodes[i - 1].isUserInteractionEnabled = true
                    self.inputCodes[i - 1].becomeFirstResponder()
                }
            }
        }
        
        inputCodes.first?.becomeFirstResponder()
        
        let viewEmptyStackViewCode = UIView()
        viewEmptyStackViewCode.setContentHuggingPriority(.defaultLow, for: .horizontal)
        viewEmptyStackViewCode.setContentHuggingPriority(.defaultLow, for: .horizontal)
        viewEnterCode.addArrangedSubview(viewEmptyStackViewCode)
        
        viewEmptyStackViewCode.translatesAutoresizingMaskIntoConstraints = false
        viewEmptyStackViewCode.heightAnchor.constraint(equalTo: viewEnterCode.heightAnchor).isActive = true
        
        let viewOverlay = UIView()
        viewEnterCode.addSubview(viewOverlay)
        
        viewOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewOverlay.centerXAnchor.constraint(equalTo: viewEnterCode.centerXAnchor),
            viewOverlay.centerYAnchor.constraint(equalTo: viewEnterCode.centerYAnchor),
            viewOverlay.heightAnchor.constraint(equalTo: viewEnterCode.heightAnchor),
            viewOverlay.widthAnchor.constraint(equalTo: viewEnterCode.widthAnchor)
        ])
        
        viewOverlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapViewOverlayInputCode(_:))))

        let viewEmpty = UIView()
        viewContent.addSubview(viewEmpty)

        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.topAnchor.constraint(equalTo: viewEnterCode.bottomAnchor),
            viewEmpty.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            viewEmpty.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),

            viewEmpty.widthAnchor.constraint(equalTo: viewContent.widthAnchor),
        ])

        let viewOption = UIStackView()
        viewOption.axis = .horizontal
        viewOption.alignment = .center
        viewOption.distribution = .fill
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
        viewOption.addArrangedSubview(labelResendCode)
        
        labelResendCode.isUserInteractionEnabled = true
        labelResendCode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleResendCode(_:))))
        
        let viewEmptyOption = UIView()
        viewOption.addArrangedSubview(viewEmptyOption)
        
        viewEmptyOption.backgroundColor = .brown
        
        viewEmptyOption.setContentHuggingPriority(.defaultLow, for: .horizontal)
        viewEmptyOption.setContentHuggingPriority(.defaultLow, for: .horizontal)

        iconNextScreen.isUserInteractionEnabled = true
        iconNextScreen.image = UIImage(named: "icon-next-screen-enter-number-phone")
        viewOption.addArrangedSubview(iconNextScreen)
        
        iconNextScreen.isHidden = true

        iconNextScreen.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconNextScreen.widthAnchor.constraint(equalToConstant: 67),
            iconNextScreen.heightAnchor.constraint(equalToConstant: 67)
        ])
        
        iconNextScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapContinue(_:))))
    }
    
    // Hàm xử lý gửi lại code
    @objc func handleResendCode(_ sender: UITapGestureRecognizer) {
        // Xử lý gửi lại code
    }
    
    // Xử lý sự kiện khi bấm vào overlay của view input code
    @objc func tapViewOverlayInputCode(_ gesture: UITapGestureRecognizer) {
        if let _ = view.findFirstResponder() {
            // Pass
        } else {
            for input in inputCodes {
                if input.isUserInteractionEnabled {
                    input.becomeFirstResponder()
                    break
                }
            }
        }
    }
    
    // Xử lý chuyển sang màn hình tiếp theo
    @objc func tapContinue(_ gesture: UITapGestureRecognizer) {
        // Viết code ở đây
        self.navigationController?.pushViewController(SelectLocationViewController(), animated: true)
    }
    
    // Hàm được gọi khi input có sự thay đổi ký tự
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Lấy nội dung sau khi thay đổi
        let currentText = textField.text ?? ""
        let _ = (currentText as NSString).replacingCharacters(in: range, with: string)
        if !string.isEmpty {
            if let number = Int(string) {
                let index = inputCodes.firstIndex(of: textField as! CustomTextField)
                if index! == inputsCount - 1 {
                    // Nhập xong code
                    showButtonNextScreen()
                    inputCodes[index!].resignFirstResponder()
                } else {
                    textField.isUserInteractionEnabled = false
                    inputCodes[index! + 1].isUserInteractionEnabled = true
                    inputCodes[index! + 1].becomeFirstResponder()
                }
                
                if textField.text!.count == 1 && Int(textField.text!) != nil {
                    if index! == inputsCount - 1 {
                        // Nhập xong code
                    } else {
                        inputCodes[index! + 1].text = number.description
                        
                        if index! + 1 == inputsCount - 1 {
                            // Nhập xong code
                            inputCodes[index! + 1].resignFirstResponder()
                            showButtonNextScreen()
                        }
                    }
                } else if textField.text!.count == 0 && textField.text!.isEmpty {
                    textField.text = number.description
                }
            } else {
                return false
            }
        }

        return true
    }
    
    func hideButtonNextScreen() {
        iconNextScreen.isHidden = true
    }
    
    func showButtonNextScreen() {
        iconNextScreen.isHidden = false
    }
    
    // Hàm được gọi khi người dùng nhập vào input
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = nil // Hủy chọn khi bắt đầu nhập
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
    }
    
    func setupPortraitLayout() {
        if let oldConstraintViewEmptyTopBotton = viewEmptyTopBottonConstraint {
            oldConstraintViewEmptyTopBotton.isActive = false
        }
        viewEmptyTopBottonConstraint = viewEmptyTop.heightAnchor.constraint(equalToConstant: 65.19)
        viewEmptyTopBottonConstraint?.isActive = true
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
