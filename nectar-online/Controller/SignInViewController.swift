import UIKit

class SignInViewController: UIViewController {
    
    private let (blurTop, blurBottom) = BlurView.getBlur()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#FCFCFC")
    
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(hex: "#FCFCFC")
        
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delaysContentTouches = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // Constraints cho scrollView để nó chiếm toàn bộ màn hình
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
            subView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            subView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            subView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            subView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        let imageTop = UIImageView()
        imageTop.image = UIImage(named: "background-top-login.png")
        imageTop.contentMode = .scaleAspectFit
        subView.addSubview(imageTop)
        
        imageTop.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageTop.topAnchor.constraint(equalTo: subView.topAnchor),
            imageTop.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            imageTop.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
                
            imageTop.heightAnchor.constraint(equalTo: imageTop.widthAnchor, multiplier: (imageTop.image?.size.height ?? 1.0) / (imageTop.image?.size.width ?? 1.0))
        ])
        
        let contentView = UIView()
        contentView.backgroundColor = .clear
        subView.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: imageTop.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 24.53),
            contentView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -24.53)
        ])

        let labelTitle = UILabel()
        labelTitle.text = "Get your groceries with nectar"
        labelTitle.font = UIFont(name: "Gilroy-SemiBold", size: 26)
        labelTitle.textColor = UIColor(hex: "#030303")
        labelTitle.numberOfLines = 2

        // Tạo NSMutableParagraphStyle để cài đặt line height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 14 // Khoảng cách giữa các dòng (line height)

        // Tạo NSAttributedString với đoạn text và paragraphStyle
        let attributedString = NSMutableAttributedString(string: labelTitle.text!)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        // Gán NSAttributedString vào UILabel
        labelTitle.attributedText = attributedString

        contentView.addSubview(labelTitle)

        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelTitle.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -167.3),
            
            labelTitle.heightAnchor.constraint(equalToConstant: 63)
        ])

        let phoneNumberView = UIView()
        phoneNumberView.backgroundColor = .clear
        phoneNumberView.addBorder(edges: [.bottom], color: UIColor(hex: "#E2E2E2"), borderLineSize: 1)
        contentView.addSubview(phoneNumberView)
        
        // Thêm UITapGestureRecognizer
        let tapGesturePhoneNumberView = UITapGestureRecognizer(target: self, action: #selector(handleTapPhoneNumberView))
        phoneNumberView.addGestureRecognizer(tapGesturePhoneNumberView)

        phoneNumberView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneNumberView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 30.61),
            phoneNumberView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            phoneNumberView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            phoneNumberView.heightAnchor.constraint(equalToConstant: 39.55)
        ])

        let countryIcon = UIImageView()
        countryIcon.image = UIImage(named: "icon-country")
        phoneNumberView.addSubview(countryIcon)

        countryIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countryIcon.widthAnchor.constraint(equalToConstant: 33.97),
            countryIcon.topAnchor.constraint(equalTo: phoneNumberView.topAnchor),
            countryIcon.bottomAnchor.constraint(equalTo: phoneNumberView.bottomAnchor, constant: -15),
            countryIcon.leadingAnchor.constraint(equalTo: phoneNumberView.leadingAnchor)
        ])

        let codeCountry = UILabel()
        codeCountry.text = "+880"
        codeCountry.font = UIFont(name: "Gilroy-Medium", size: 18)
        codeCountry.textColor = UIColor(hex: "#030303")
        phoneNumberView.addSubview(codeCountry)

        codeCountry.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            codeCountry.topAnchor.constraint(equalTo: phoneNumberView.topAnchor, constant: 0.85),
            codeCountry.leadingAnchor.constraint(equalTo: countryIcon.trailingAnchor, constant: 12.02),
            codeCountry.bottomAnchor.constraint(equalTo: phoneNumberView.bottomAnchor, constant: -(10.55 + 4.45))
        ])

        let labelOrConnect = UILabel()
        labelOrConnect.text = "Or connect with social media"
        labelOrConnect.font = UIFont(name: "Gilroy-Semibold", size: 14)
        labelOrConnect.textColor = UIColor(hex: "#828282")
        contentView.addSubview(labelOrConnect)

        labelOrConnect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelOrConnect.topAnchor.constraint(equalTo: phoneNumberView.bottomAnchor, constant: 40),
            labelOrConnect.centerXAnchor.constraint(equalTo: phoneNumberView.centerXAnchor),
            
            labelOrConnect.heightAnchor.constraint(equalToConstant: 17)
        ])

        let buttonContinueWithGoogle = UIButton(type: .system)

        // Tạo cấu hình button
        var configButtonGoogle = UIButton.Configuration.filled()
        configButtonGoogle.baseBackgroundColor = UIColor(hex: "#5383EC")
        configButtonGoogle.baseForegroundColor = UIColor(hex: "#FCFCFC") // Màu chữ

        // Thiết lập tiêu đề và font
        var titleAttributesButtonGoogle = AttributedString("Continue with Google")
        titleAttributesButtonGoogle.font = UIFont(name: "Gilroy-Semibold", size: 18) // Font tùy chỉnh
        configButtonGoogle.attributedTitle = titleAttributesButtonGoogle

        // Thêm biểu tượng vào cấu hình
        if let iconGoogle = UIImage(named: "icon-google")?.withRenderingMode(.alwaysTemplate) {
            configButtonGoogle.image = iconGoogle
            configButtonGoogle.imagePlacement = .leading // Đặt biểu tượng bên trái tiêu đề
            configButtonGoogle.imagePadding = 25 // Khoảng cách giữa biểu tượng và tiêu đề
        }

        // Áp dụng cấu hình vào button
        buttonContinueWithGoogle.configuration = configButtonGoogle
        buttonContinueWithGoogle.layer.cornerRadius = 19
        buttonContinueWithGoogle.layer.masksToBounds = true

        contentView.addSubview(buttonContinueWithGoogle)
        
        buttonContinueWithGoogle.addTarget(self, action: #selector(handleSiginWithGoogle), for: .touchUpInside)

        buttonContinueWithGoogle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonContinueWithGoogle.topAnchor.constraint(equalTo: labelOrConnect.bottomAnchor, constant: 37.8),
            buttonContinueWithGoogle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonContinueWithGoogle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonContinueWithGoogle.heightAnchor.constraint(equalToConstant: 67)
        ])

        let buttonContinueWithFacebook = UIButton(type: .system)

        // Tạo cấu hình button
        var configButtonFacebook = UIButton.Configuration.filled()
        configButtonFacebook.baseBackgroundColor = UIColor(hex: "#4A66AC")
        configButtonFacebook.baseForegroundColor = UIColor(hex: "#FCFCFC") // Màu chữ

        // Thiết lập tiêu đề và font
        var titleAttributesButtonFacebook = AttributedString("Continue with Facebook")
        titleAttributesButtonFacebook.font = UIFont(name: "Gilroy-Semibold", size: 18) // Font tùy chỉnh
        configButtonFacebook.attributedTitle = titleAttributesButtonFacebook

        // Thêm biểu tượng vào cấu hình
        if let iconFacebook = UIImage(named: "icon-facebook")?.withRenderingMode(.alwaysTemplate) {
            configButtonFacebook.image = iconFacebook
            configButtonFacebook.imagePlacement = .leading // Đặt biểu tượng bên trái tiêu đề
            configButtonFacebook.imagePadding = 25 // Khoảng cách giữa biểu tượng và tiêu đề
        }

        // Áp dụng cấu hình vào button
        buttonContinueWithFacebook.configuration = configButtonFacebook
        buttonContinueWithFacebook.layer.cornerRadius = 19
        buttonContinueWithFacebook.layer.masksToBounds = true

        contentView.addSubview(buttonContinueWithFacebook)
        
        buttonContinueWithFacebook.addTarget(self, action: #selector(handleSiginWithFacebook), for: .touchUpInside)

        buttonContinueWithFacebook.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonContinueWithFacebook.topAnchor.constraint(equalTo: buttonContinueWithGoogle.bottomAnchor, constant: 20),
            buttonContinueWithFacebook.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -90.42),
            buttonContinueWithFacebook.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonContinueWithFacebook.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            buttonContinueWithFacebook.heightAnchor.constraint(equalToConstant: 67)
        ])
        
        let viewEmptyEnd = UIView()
        subView.addSubview(viewEmptyEnd)

        viewEmptyEnd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmptyEnd.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewEmptyEnd.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
            viewEmptyEnd.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewEmptyEnd.trailingAnchor.constraint(equalTo: subView.trailingAnchor),

            viewEmptyEnd.widthAnchor.constraint(equalTo: subView.widthAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Hàm được gọi trước khi ViewController xuất hiện
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Hàm được gọi trước khi ViewController biến mất
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // Hàm xử lý đăng nhập bằng tài khoản Google
    @objc func handleSiginWithGoogle() {
//        print("Login with Google")
    }
    
    // Hàm xử lý đăng nhập bằng tài khoản Facebook
    @objc func handleSiginWithFacebook() {
//        print("Login with Facebook")
    }
    
    @objc func handleTapPhoneNumberView() {
        self.navigationController?.pushViewController(NumberViewController(), animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscapeRight, .landscapeLeft]
    }
}
