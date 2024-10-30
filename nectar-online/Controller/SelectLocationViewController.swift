//
//  SelectLocationViewController.swift
//  nectar-online
//
//  Created by Macbook on 24/10/2024.
//

import UIKit

class SelectLocationViewController: UIViewController {
    
    private let (blurTop, blurBottom) = BlurView.getBlur()
    private let scrollView = UIScrollView()
    private var scrollViewBottomConstraint: NSLayoutConstraint?
    private lazy var formControlZone: FormControllView = {
        return FormControllView(label: "Your Zone", typeInput: .select, options: [], placeholder: "Types of your zone")
    }()
    private lazy var formControlArea: FormControllView = {
        return FormControllView(label: "Your Area", typeInput: .select, options: [], placeholder: "Types of your area")
    }()
    private var zones: [Zone] = [] // = DataTest.zones
    private var idZone: Int? = nil
    private var idArea: Int? = nil
    private let loadingOverlay = LoadingOverlayView()

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
        fetchData()
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
        
        let viewIllustrationLocation = UIView()
        subView.addSubview(viewIllustrationLocation)
        
        viewIllustrationLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewIllustrationLocation.topAnchor.constraint(equalTo: subView.topAnchor),
            viewIllustrationLocation.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewIllustrationLocation.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            viewIllustrationLocation.widthAnchor.constraint(equalTo: subView.widthAnchor)
        ])
        
        let imageIllustrationLocation = UIImageView()
        imageIllustrationLocation.image = UIImage(named: "illustration-location")
        viewIllustrationLocation.addSubview(imageIllustrationLocation)
        
        imageIllustrationLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageIllustrationLocation.centerXAnchor.constraint(equalTo: viewIllustrationLocation.centerXAnchor),
            imageIllustrationLocation.topAnchor.constraint(equalTo: viewIllustrationLocation.topAnchor, constant: 44.97),
            
            imageIllustrationLocation.widthAnchor.constraint(equalToConstant: 224.69),
            imageIllustrationLocation.heightAnchor.constraint(equalToConstant: 170.69)
        ])
        
        let titleIllustrationLocation = UILabel()
        titleIllustrationLocation.text = "Select Your Location"
        titleIllustrationLocation.font = UIFont(name: "Gilroy-Semibold", size: 26)
        titleIllustrationLocation.textColor = UIColor(hex: "#181725")
        titleIllustrationLocation.textAlignment = .center
        viewIllustrationLocation.addSubview(titleIllustrationLocation)
        
        titleIllustrationLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleIllustrationLocation.topAnchor.constraint(equalTo: imageIllustrationLocation.bottomAnchor, constant: 40.15),
            titleIllustrationLocation.leadingAnchor.constraint(equalTo: viewIllustrationLocation.leadingAnchor),
            titleIllustrationLocation.trailingAnchor.constraint(equalTo: viewIllustrationLocation.trailingAnchor),
            
            titleIllustrationLocation.heightAnchor.constraint(equalToConstant: 29)
        ])
        
        let descriptionIllustrationLocation = UILabel()
        descriptionIllustrationLocation.text = "Swithch on your location to stay in tune with what’s happening in your area"
        descriptionIllustrationLocation.font = UIFont(name: "Gilroy-Medium", size: 16)
        descriptionIllustrationLocation.textColor = UIColor(hex: "#7C7C7C")
        descriptionIllustrationLocation.numberOfLines = 3

        // Tạo NSMutableParagraphStyle để cài đặt line height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5 // Khoảng cách giữa các dòng (line height)
        paragraphStyle.alignment = .center

        // Tạo NSAttributedString với đoạn text và paragraphStyle
        let attributedString = NSMutableAttributedString(string: descriptionIllustrationLocation.text!)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        // Gán NSAttributedString vào UILabel
        descriptionIllustrationLocation.attributedText = attributedString
        
        viewIllustrationLocation.addSubview(descriptionIllustrationLocation)
        
        descriptionIllustrationLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionIllustrationLocation.topAnchor.constraint(equalTo: titleIllustrationLocation.bottomAnchor, constant: 15),
            descriptionIllustrationLocation.bottomAnchor.constraint(equalTo: viewIllustrationLocation.bottomAnchor),
            descriptionIllustrationLocation.leadingAnchor.constraint(equalTo: viewIllustrationLocation.leadingAnchor),
            descriptionIllustrationLocation.trailingAnchor.constraint(equalTo: viewIllustrationLocation.trailingAnchor),
            
            descriptionIllustrationLocation.heightAnchor.constraint(equalToConstant: 57)
        ])
        
        let viewForm = UIView()
        subView.addSubview(viewForm)
        
        viewForm.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewForm.topAnchor.constraint(equalTo: viewIllustrationLocation.bottomAnchor, constant: 89.35),
            viewForm.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewForm.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            viewForm.widthAnchor.constraint(equalTo: subView.widthAnchor),
        ])
        
        viewForm.addSubview(formControlZone)
        
        formControlZone.handleSelectOption = {
            self.idZone = Int($0) ?? nil
            self.reloadOptionsArea(idOption: Int($0) ?? nil)
        }

        formControlZone.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formControlZone.topAnchor.constraint(equalTo: viewForm.topAnchor),
            formControlZone.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            formControlZone.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),

            formControlZone.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        viewForm.addSubview(formControlArea)
        
        formControlArea.handleSelectOption = {
            self.idArea = Int($0) ?? nil
        }

        formControlArea.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formControlArea.topAnchor.constraint(equalTo: formControlZone.bottomAnchor, constant: 30),
            formControlArea.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            formControlArea.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),

            formControlArea.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        let button = ButtonView.createSystemButton(
            title: "Submit",
            titleColor: UIColor(hex: "#FFF9FF"),
            titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
            backgroundColor: UIColor(hex: "#53B175"),
            borderRadius: 19
        )
        viewForm.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: formControlArea.bottomAnchor, constant: 40.35),
            button.bottomAnchor.constraint(equalTo: viewForm.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: viewForm.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: viewForm.trailingAnchor),
            
            button.widthAnchor.constraint(equalTo: viewForm.widthAnchor)
        ])
        
        button.addTarget(self, action: #selector(handleSubmit(_:)), for: .touchUpInside)
        
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
        view.addSubview(loadingOverlay)
        
        // Cài đặt Auto Layout cho lớp phủ mờ để nó bao phủ toàn bộ view
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // Cập nhật lại danh sách của area
    func reloadOptionsArea(idOption: Int?) {
        guard let idOption = idOption else {
            return
        }
        formControlArea.updateOptions(newOptions: self.zones.first { $0.id == idOption }?.areas.map { Picker(from: $0) } ?? [])
    }
    
    // Gọi API lấy dữ liệu zones và areas từ server
    private func fetchData() {
        self.loadingOverlay.handleUserInteraction = {
            self.view.isUserInteractionEnabled = false
        }
        self.loadingOverlay.showLoadingOverlay()
        
        SelectLocationService.shared.fetchZones { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingOverlay.handleUserInteraction = {
                    self?.view.isUserInteractionEnabled = true
                }
                self?.loadingOverlay.hideLoadingOverlay()
                
                switch result {
                case .success(let zones):
                    print(zones)
                    self?.zones = zones
                    // Update UI
                    self?.updateUI()
                case .failure(let error):
                    print("Fail: \(error)")
                    self?.showErrorAlert(message: "Không thể lấy dữ liệu từ server!")
                }
            }
        }
    }
    
    // Cập nhật danh sách zone và area lên picker
    private func updateUI() {
        formControlZone.updateOptions(newOptions: self.zones.map { Picker(from: $0) })
        formControlArea.updateOptions(newOptions: self.zones.first?.areas.map { Picker(from: $0) } ?? [])
        
        if zones.count > 0 {
            self.idZone = 0
            if let area = zones.first?.areas, area.count > 0 {
                self.idArea = 0
            }
        }
    }
    
    // Hiển thị lỗi
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Xử lý sự kiện khi bấm vào button submit
    @objc func handleSubmit(_ sender: UIButton) {
        guard let idZone = idZone, let idArea = idArea else {
            self.showErrorAlert(message: "Gửi dữ liệu thất bại, không thể tiếp tục!")
            return
        }
        
        self.loadingOverlay.handleUserInteraction = {
            self.view.isUserInteractionEnabled = false
        }
        self.loadingOverlay.showLoadingOverlay()
        
        let data: [String: Any] = [
            "idZone": idZone,
            "idArea": idArea
        ]
        
        SelectLocationService.shared.sendData(data: data) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.loadingOverlay.handleUserInteraction = {
                    self?.view.isUserInteractionEnabled = true
                }
                self?.loadingOverlay.hideLoadingOverlay()
                
                if success {
                    print("Gửi dữ liệu thành công!")
                    self?.navigationController?.setViewControllers([LogInViewController()], animated: true)
                } else {
                    print(error?.localizedDescription ?? "Error")
                    self?.showErrorAlert(message: "Gửi dữ liệu thất bại, không thể tiếp tục!")
                }
            }
        }
    }
    
    // Hàm được gọi ngay trước khi ViewController xuất hiện
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
