//
//  FormControlView.swift
//  nectar-online
//
//  Created by Macbook on 25/10/2024.
//

import UIKit

class FormControllView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    private let formLabel: UILabel
    private let formInput: UITextField
    private let typeInput: TypeFormInput
    private var options: [Picker]
    private let check: Bool
    private let checkMarkImageView = UIImageView()
    var handleSelectOption: ((String) -> Void)?
    
    init(label: String = "", typeInput: TypeFormInput = .text, options: [Picker] = [], placeholder: String = "", check: Bool = false) {
        // Khởi tạo các thuộc tính bắt buộc trước
        self.formLabel = UILabel()
        self.formLabel.text = label
        
        if typeInput == .select {
            self.formInput = CustomTextField()
        } else {
            self.formInput = UITextField()
        }
        self.formInput.placeholder = placeholder
        self.typeInput = typeInput
        
        self.options = options
        
        self.check = check
        
        // Gọi super.init sau khi các thuộc tính đã được gán giá trị
        super.init(frame: .zero)
        
        switch typeInput {
        case .text:
            // Không cần làm gì thêm vì formInput đã là UITextField
            break
        case .email:
            self.formInput.keyboardType = .emailAddress
        case .password:
            self.formInput.isSecureTextEntry = true
        case .select:
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            self.formInput.inputView = picker
            self.formInput.text = options.first?.name
        }
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Setup view
        self.backgroundColor = .clear
        self.addBorder(edges: [.bottom], color: UIColor(hex: "#E2E2E2"), borderLineSize: 1)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 78.55).isActive = true
        
        // Setup label
        self.formLabel.font = UIFont(name: "Gilroy-Semibold", size: 16)
        self.formLabel.textColor = UIColor(hex: "#7C7C7C")
        self.formLabel.textAlignment = .left
        self.addSubview(self.formLabel)
        
        self.formLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.formLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.formLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.formLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.formLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.formLabel.heightAnchor.constraint(equalToConstant: 29)
        ])
        
        // Setup input
        self.formInput.font = UIFont(name: "Gilroy-Medium", size: 18)
        self.formInput.textColor = UIColor(hex: "#181725")
        
        self.formInput.attributedPlaceholder = NSAttributedString(
            string: self.formInput.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#B1B1B1")]
        )
        self.addSubview(formInput)
        
        switch self.typeInput {
        case .text:
            //
            
            break
        case .email:
            self.formInput.autocapitalizationType = .none
            
            if check {
                self.formInput.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
                
                checkMarkImageView.image = UIImage(systemName: "checkmark")
                checkMarkImageView.tintColor = UIColor(hex: "#53B175")
                checkMarkImageView.contentMode = .scaleAspectFit
                checkMarkImageView.isHidden = true
                
                self.formInput.rightView = checkMarkImageView
                self.formInput.rightViewMode = .always
            }
        case .password:
            // Tắt tự động viết hoa
            self.formInput.autocapitalizationType = .none
            
            let eyeButton = UIButton(type: .system)
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            eyeButton.tintColor = UIColor(hex: "#7C7C7C")
            eyeButton.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            
            self.formInput.rightView = eyeButton
            self.formInput.rightViewMode = .always
        case .select:
            self.formInput.delegate = self
            
            // Tạo Toolbar với nút Done
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            // Tạo nút flexible space để đẩy nút "Done" sang bên phải
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
            toolbar.setItems([flexibleSpace, doneButton], animated: true)
            self.formInput.inputAccessoryView = toolbar
            
            let arrowDownImage = UIImageView(image: UIImage(systemName: "chevron.down"))
            arrowDownImage.tintColor = UIColor(hex: "#7C7C7C")
            arrowDownImage.contentMode = .scaleAspectFit
            
            self.formInput.rightView = arrowDownImage
            self.formInput.rightViewMode = .always
        }
        
        self.formInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.formInput.topAnchor.constraint(equalTo: self.formLabel.bottomAnchor, constant: 10),
            self.formInput.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.55),
            self.formInput.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.formInput.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.formInput.heightAnchor.constraint(equalToConstant: 29),
            self.formInput.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    // Hàm xử lý khi bấm vào nút Done trong UIPickerView
    @objc func doneTapped() {
        self.formInput.resignFirstResponder()
    }
    
    // Hàm xử lý ẩn/hiện mật khẩu
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        // Đổi trạng thái hiển thị mật khẩu
        self.formInput.isSecureTextEntry.toggle()
        
        // Đổi biểu tượng mắt
        let eyeImageName = self.formInput.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: eyeImageName), for: .normal)
    }
    
    // Hàm cập nhật danh sách options của UIPickerView
    func updateOptions(newOptions: [Picker]) {
        if let picker = self.formInput.inputView as? UIPickerView {
            self.options = newOptions
            picker.reloadAllComponents()
            picker.selectRow(0, inComponent: 0, animated: false)
            self.formInput.text = options.first?.name
        }
    }
    
    // Hàm xử lý ẩn/hiện tích kiểm tra email
    @objc private func emailDidChange() {
        let resultCheckMail = Validate.validate(type: .email, string: self.formInput.text ?? "")
        
        if resultCheckMail {
            self.checkMarkImageView.isHidden = false // Hiện dấu tích
        } else {
            self.checkMarkImageView.isHidden = true // Ẩn dấu tích
        }
    }
    
    // MARK: - UIPickerViewDataSource
    
    // Số lượng cột trong Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Số lượng hàng trong Picker (bằng với số lượng phần tử trong mảng options)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    // Nội dung của mỗi hàng trong Picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row].name
    }
    
    // Xử lý sự kiện khi người dùng chọn một hàng trong Picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !options.isEmpty {
            self.formInput.text = options[row].name
            self.handleSelectOption?(options[row].id)
        }
    }
}

enum TypeFormInput {
    case text
    case email
    case password
    case select
}
