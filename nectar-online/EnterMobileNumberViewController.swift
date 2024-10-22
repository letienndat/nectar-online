//
//  EnterMobileNumberViewController.swift
//  nectar-online
//
//  Created by Macbook on 20/10/2024.
//

import UIKit

class EnterMobileNumberViewController: UIViewController, UITextFieldDelegate {
    
    private let backgroundBlurView = BackgroundBlur()
    private let inputCodeCountry = UITextField()
    private let inputMobileNumber = DeletableTextField()
    private var beforeMobileNumber: String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Đăng ký thông báo khi bàn phím xuất hiện và ẩn đi
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

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
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // Hàm quay lại
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // Lấy thông tin về bàn phím
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            // Cập nhật kích thước của stackView
            UIView.animate(withDuration: 0.3) {
                self.view.frame.size.height = self.view.frame.height - keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // Khôi phục kích thước ban đầu cho stackView
        UIView.animate(withDuration: 0.3) {
            self.view.frame.size.height = self.view.frame.height
            self.view.layoutIfNeeded()
        }
    }
    
    func configView() {
        view.backgroundColor = UIColor(hex: "#FCFCFC")
        
        backgroundBlurView.frame = view.bounds // Đặt kích thước cho blur background
//        backgroundBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundBlurView)
        
        let scrollView = UIScrollView()
        scrollView.frame = view.frame
        view.addSubview(scrollView)
        
        let stackViewContent = UIStackView()
        stackViewContent.axis = .vertical
        stackViewContent.alignment = .leading
        scrollView.addSubview(stackViewContent)
        
        stackViewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewContent.topAnchor.constraint(equalTo: view.topAnchor, constant: 140.02),
            stackViewContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            stackViewContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            stackViewContent.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let labelTitle = UILabel()
        labelTitle.text = "Enter your mobile number"
        labelTitle.textColor = UIColor(hex: "#181725")
        labelTitle.font = UIFont(name: "Gilroy-Semibold", size: 26)
        labelTitle.numberOfLines = 0
        stackViewContent.addSubview(labelTitle)
        
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.heightAnchor.constraint(equalToConstant: 29).isActive = true
        
        let labelTitleInput = UILabel()
        labelTitleInput.text = "Mobile Number"
        labelTitleInput.textColor = UIColor(hex: "#7C7C7C")
        labelTitleInput.font = UIFont(name: "Gilroy-Semibold", size: 16)
        stackViewContent.addSubview(labelTitleInput)

        labelTitleInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitleInput.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 27.58)
        ])
        
        let viewEnterMobilePhone = UIStackView()
        viewEnterMobilePhone.axis = .horizontal
        viewEnterMobilePhone.alignment = .top
        viewEnterMobilePhone.addBottomBorder(color: UIColor(hex: "#E2E2E2"), borderLineSize: 1)
        stackViewContent.addSubview(viewEnterMobilePhone)
        
        viewEnterMobilePhone.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEnterMobilePhone.topAnchor.constraint(equalTo: labelTitleInput.bottomAnchor, constant: 10),
            viewEnterMobilePhone.widthAnchor.constraint(equalTo: stackViewContent.widthAnchor),
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
        inputCodeCountry.keyboardType = .phonePad
        inputCodeCountry.placeholder = "+000"
        inputCodeCountry.delegate = self
        viewEnterMobilePhone.addSubview(inputCodeCountry)
        
        inputCodeCountry.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputCodeCountry.leadingAnchor.constraint(equalTo: iconCountry.trailingAnchor, constant: 12.02),
            inputCodeCountry.widthAnchor.constraint(equalToConstant: 45),
            inputCodeCountry.heightAnchor.constraint(equalToConstant: 29)
        ])
        
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
        
        let iconNextScreen = UIImageView()
        iconNextScreen.image = UIImage(named: "icon-next-screen-enter-number-phone")
        stackViewContent.addSubview(iconNextScreen)
        
        iconNextScreen.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconNextScreen.trailingAnchor.constraint(equalTo: stackViewContent.trailingAnchor),
            iconNextScreen.bottomAnchor.constraint(equalTo: stackViewContent.bottomAnchor, constant: -30.3),
            iconNextScreen.widthAnchor.constraint(equalToConstant: 67),
            iconNextScreen.heightAnchor.constraint(equalToConstant: 67)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
                    
                    return false // Ngăn không cho nhập thêm vào input mã quốc gia
                }
                
                return !updatedText.isEmpty
            }
        }
        if textField == inputMobileNumber {
            // Lấy chuỗi hiện tại của textField
            beforeMobileNumber = textField.text ?? ""
            
            return true
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
    
    deinit {
        // Loại bỏ observer khi không còn cần thiết để tránh leak bộ nhớ
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: inputMobileNumber)
    }
}

class DeletableTextField: UITextField {

    // Closure để bắt sự kiện xóa
    var onDeleteBackward: (() -> Void)?

    override func deleteBackward() {
        super.deleteBackward()

        // Gọi closure khi người dùng nhấn nút xóa
        onDeleteBackward?()
    }
}
