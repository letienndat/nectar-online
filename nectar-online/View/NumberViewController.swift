//
//  NumberViewController.swift
//  nectar-online
//
//  Created by Macbook on 20/10/2024.
//

import UIKit

class NumberViewController: UIViewController, UITextFieldDelegate {
    
    private let (blurTop, blurBottom) = BlurView.getBlur()
    private let inputCodeCountry = DeletableTextField()
    private let inputMobileNumber = DeletableTextField()
    private var beforeMobileNumber: String! = ""
    private let scrollView = UIScrollView()
    private let viewEmptyTop = UIView()
    private let viewContent = UIView()
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    private var viewEmptyTopBottonConstraint: NSLayoutConstraint?
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
        
        // Do any additional setup after loading the view.
        setupNav()
        setupView()
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
            viewContent.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewContent.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            viewContent.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
            
            viewContent.widthAnchor.constraint(equalTo: subView.widthAnchor)
        ])
        
        let labelTitle = UILabel()
        labelTitle.text = "Enter your mobile number"
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
        labelTitleInput.text = "Mobile Number"
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

        let viewEnterMobilePhone = UIStackView()
        viewEnterMobilePhone.axis = .horizontal
        viewEnterMobilePhone.alignment = .top
        viewEnterMobilePhone.addBorder(edges: [.bottom], color: UIColor(hex: "#E2E2E2"), borderLineSize: 1)
        viewContent.addSubview(viewEnterMobilePhone)

        viewEnterMobilePhone.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEnterMobilePhone.topAnchor.constraint(equalTo: labelTitleInput.bottomAnchor, constant: 10),
            viewEnterMobilePhone.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            viewEnterMobilePhone.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            
            viewEnterMobilePhone.widthAnchor.constraint(equalTo: viewContent.widthAnchor),
            viewEnterMobilePhone.heightAnchor.constraint(equalToConstant: 39.55)
        ])

        let iconCountry = UIImageView()
        iconCountry.image = UIImage(named: "icon-country")
        viewEnterMobilePhone.addSubview(iconCountry)

        iconCountry.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconCountry.leadingAnchor.constraint(equalTo: viewEnterMobilePhone.leadingAnchor),
            iconCountry.widthAnchor.constraint(equalToConstant: 33.97),
            iconCountry.heightAnchor.constraint(equalToConstant: 23.7)
        ])

        inputCodeCountry.font = UIFont(name: "Gilroy-Medium", size: 18)
        inputCodeCountry.textColor = UIColor(hex: "#181725")
        inputCodeCountry.text = "+880"
        inputCodeCountry.keyboardType = .numberPad
        inputCodeCountry.placeholder = "+000"
        inputCodeCountry.delegate = self
        viewEnterMobilePhone.addSubview(inputCodeCountry)

        inputCodeCountry.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputCodeCountry.leadingAnchor.constraint(equalTo: iconCountry.trailingAnchor, constant: 12.02),
            inputCodeCountry.widthAnchor.constraint(equalToConstant: 45),
            inputCodeCountry.heightAnchor.constraint(equalToConstant: 29)
        ])
        inputCodeCountry.addTarget(self, action: #selector(handleInput(_:)), for: .editingChanged)

        inputMobileNumber.font = UIFont(name: "Gilroy-Medium", size: 18)
        inputMobileNumber.textColor = UIColor(hex: "#181725")
        inputMobileNumber.keyboardType = .numberPad
        inputMobileNumber.delegate = self
        inputMobileNumber.placeholder = "Your mobile number"
        viewEnterMobilePhone.addSubview(inputMobileNumber)

        inputMobileNumber.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputMobileNumber.leadingAnchor.constraint(equalTo: inputCodeCountry.trailingAnchor, constant: 2),
            inputMobileNumber.trailingAnchor.constraint(equalTo: viewEnterMobilePhone.trailingAnchor),
            inputMobileNumber.heightAnchor.constraint(equalToConstant: 29)
        ])
        inputMobileNumber.addTarget(self, action: #selector(handleInput(_:)), for: .editingChanged)

        inputMobileNumber.onDeleteBackward = {
            // Nếu inputMobileNumber không có giá trị thì chuyển focus sang inputCodeCountry
            if self.inputMobileNumber.text?.isEmpty == true && self.beforeMobileNumber.isEmpty {
                self.inputCodeCountry.becomeFirstResponder()
                self.moveCursorToEnd(textField: self.inputCodeCountry)
            }

            if self.beforeMobileNumber.count == 1 {
                self.beforeMobileNumber = ""
            }
        }

        let viewEmpty = UIView()
        viewContent.addSubview(viewEmpty)

        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.topAnchor.constraint(equalTo: viewEnterMobilePhone.bottomAnchor),
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
        
        let viewEmptyOption = UIView()
        viewOption.addArrangedSubview(viewEmptyOption)
        
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
    
    // Hàm xử lý sự kiện text của input bị thay đổi
    @objc func handleInput(_ sender: DeletableTextField) {
        if !inputCodeCountry.text!.replacingOccurrences(of: "+", with: "").isEmpty && !inputMobileNumber.text!.isEmpty {
            showButtonNextScreen()
        } else {
            hideButtonNextScreen()
        }
    }
    
    // Hàm xử lý khi chuyển màn hình mới khi bấm vào iconNextScreen
    @objc func tapContinue(_ sender: UITapGestureRecognizer) {
        self.navigationController?.pushViewController(VerificationViewController(), animated: true)
    }
    
    func hideButtonNextScreen() {
        iconNextScreen.isHidden = true
    }
    
    func showButtonNextScreen() {
        iconNextScreen.isHidden = false
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
    }
    
    // Hàm được gọi ngay sau khi view đã được hiển thị trên màn hình
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Hiển thị bàn phím nhập cho số điện thoại
        inputMobileNumber.becomeFirstResponder()
        
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // Hàm được gọi ngay sau khi ViewController biến mất
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // Phương thức delegate để xử lý xóa ký tự
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == inputCodeCountry {
            let currentText = textField.text ?? ""

            // Tính toán văn bản mới sau khi thay đổi
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // Không cho phép xóa nếu dấu '+' là ký tự đầu tiên

            // Nếu con trỏ đang ở vị trí đầu tiên
            if let cursorPosition = textField.selectedTextRange?.start {
                let cursorIndex = textField.offset(from: textField.beginningOfDocument, to: cursorPosition)

                // Ngăn không cho di chuyển con trỏ đến vị trí đầu tiên (trước dấu '+')
                if cursorIndex == 0 {
                    // Nếu người dùng nhập số ở vị trí đầu tiên, chuyển số đó xuống cuối chuỗi
                    if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
                        if (currentText.count < 4) {
                            textField.text = currentText + string
                            moveCursorToEnd(textField: textField)
                            return false
                        } else {
                            // Chuyển ký tự số đó sang input điện thoại
                            inputMobileNumber.text = (inputMobileNumber.text ?? "") + string
                            
                            // Chuyển focus sang input số điện thoại
                            inputMobileNumber.becomeFirstResponder()
                            
                            return false // Ngăn không cho nhập thêm vào input mã quốc gia
                        }
                    }
                    // Di chuyển con trỏ về vị trí cuối cùng của chuỗi nếu không nhập ký tự hợp lệ
                    DispatchQueue.main.async {
                        self.moveCursorToEnd(textField: textField)
                    }
                    return false
                }
                
                if updatedText.count > 4 {
                    // Chuyển ký tự số đó sang input điện thoại
                    inputMobileNumber.text = (inputMobileNumber.text ?? "") + string
                    
                    // Chuyển focus sang input số điện thoại
                    inputMobileNumber.becomeFirstResponder()
                    
                    handleInput(inputMobileNumber)
                    
                    return false // Ngăn không cho nhập thêm vào input mã quốc gia
                }
                
                // Chỉ cho phép nhập số (0-9) và không cho phép dấu '+'
                let allowedCharacters = CharacterSet(charactersIn: "0123456789")
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet) && !updatedText.isEmpty
            }
        }
        if textField == inputMobileNumber {
            // Lấy chuỗi hiện tại của textField
            beforeMobileNumber = textField.text ?? ""
        }

        // Chỉ cho phép nhập số (0-9) và không cho phép dấu '+'
        let allowedCharacters = CharacterSet(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    // Hàm để di chuyển con trỏ đến cuối chuỗi
    func moveCursorToEnd(textField: UITextField) {
        DispatchQueue.main.async {
            if let endPosition = textField.position(from: textField.endOfDocument, offset: 0) {
                textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
            }
        }
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
    
    // Hàm cấu hình cho phép xoay theo chiều nào
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
        // Loại bỏ observer khi không còn cần thiết để tránh leak bộ nhớ
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: inputMobileNumber)
        
        // Hủy đăng ký thông báo khi không còn sử dụng
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
