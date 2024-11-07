//
//  HomeScreenViewController.swift
//  nectar-online
//  
//  Created by Macbook on 26/10/2024.
//

import UIKit
import ImageSlideshow

class HomeScreenViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    private let loadingOverlay = LoadingOverlayView()
    private let viewLocation = UIView()
    private let labelLocation = UILabel()
    private let viewSlideShow = UIView()
    private let slideShow = ImageSlideshow()
    private var imageSources: [ImageSource] = []
    private let inputSearch = PaddedTextField()
    private let iconClear = UIImageView(image: UIImage(named: "icon-clear-input"))
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private let stackViewContent = UIStackView()
    private let homeScreenViewModel = HomeScreenViewModel.shared
    private lazy var gridCollectionProductSearch: UICollectionView = {
        // Khởi tạo UICollectionView với layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCellView.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private let subView = UIView()
    private var subViewBottomConstraint: NSLayoutConstraint?
    private var debounceWorkItem: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppConfig.isFirstLaunch {
            AppConfig.isFirstLaunch = false
        }
        
        self.view.overrideUserInterfaceStyle = .dark
        
        // Đăng ký thông báo khi bàn phím xuất hiện và ẩn đi
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Tạo UITapGestureRecognizer để phát hiện người dùng bấm ra ngoài view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeybroad))
        
        // Thêm gesture vào view cha
        self.view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
        setupLoadingOverlay()
        
        self.homeScreenViewModel.hideRefreshing = { [weak self] in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
        }
        
        self.homeScreenViewModel.hideLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = true
            self.loadingOverlay.hideLoadingOverlay()
        }
        
        self.homeScreenViewModel.showLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = false
            self.loadingOverlay.showLoadingOverlay()
        }
        
        self.homeScreenViewModel.showError = { [weak self] error in
            guard let self = self else { return }
            
            self.showErrorAlert(message: error, isReload: true, handleReload: { self.fetchData() })
        }
        
        self.homeScreenViewModel.updateProductClassifications = { [weak self] in
            if let _ = self {
                
            }
        }
        
        self.homeScreenViewModel.updateLocation = { [weak self] in
            var loc: [String] = []
            if let area = self?.homeScreenViewModel.location.areas.first?.name {
                loc.append(area)
            }
            if let zone = self?.homeScreenViewModel.location.name {
                loc.append(zone)
            }
            self?.labelLocation.text = loc.joined(separator: ", ")
            self?.viewLocation.isHidden = false
        }
        
        self.homeScreenViewModel.updateBanners = { [weak self] in
            self?.imageSources = []
            
            let dispatchGroup = DispatchGroup() // Tạo DispatchGroup
            
            self?.homeScreenViewModel.banners.forEach { banner in
                // Bắt đầu một task mới trong DispatchGroup
                dispatchGroup.enter()
                loadImage(from: banner.imageUrl) { image in
                    if let downloadedImage = image {
                        self?.imageSources.append(ImageSource(image: downloadedImage))
                    } else {
                        //
                    }
                    // Thông báo rằng task đã hoàn thành
                    dispatchGroup.leave()
                }
            }
            
            // Khi tất cả các task đã hoàn thành
            dispatchGroup.notify(queue: .main) {
                self?.slideShow.setImageInputs(self?.imageSources ?? [])
                if !(self?.imageSources.isEmpty)! {
                    self?.viewSlideShow.isHidden = false
                }
            }
        }
        
        self.homeScreenViewModel.updateProductClassifications = { [weak self] in

            self?.homeScreenViewModel.productClassifications.forEach { productClassification in
                let labelTitleType = UILabel()
                labelTitleType.text = productClassification.name
                labelTitleType.font = UIFont(name: "Gilroy-Semibold", size: 24)
                labelTitleType.textColor = UIColor(hex: "#181725")

                var viewsProduct: [ProductView] = []
                productClassification.products.forEach { product in
                    let imageProduct = UIImage(named: product.thumbnail.imageUrl)

                    let nameProduct = UILabel()
                    nameProduct.text = product.name
                    nameProduct.font = UIFont(name: "Gilroy-Bold", size: 16)
                    nameProduct.textColor = UIColor(hex: "#181725")

                    let piecePriceProduct = UILabel()
                    piecePriceProduct.text = product.unitOfMeasure
                    piecePriceProduct.font = UIFont(name: "Gilroy-Medium", size: 14)
                    piecePriceProduct.textColor = UIColor(hex: "#7C7C7C")

                    let priceProduct = UILabel()
                    priceProduct.text = "$\(product.price)"
                    priceProduct.font = UIFont(name: "Gilroy-Semibold", size: 18)
                    priceProduct.textColor = UIColor(hex: "#181725")

                    let viewProduct = ProductView(idProduct: product.id,imageProduct: imageProduct!, nameProduct: nameProduct, piecePriceProduct: piecePriceProduct, priceProduct: priceProduct)
                    
                    viewProduct.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        viewProduct.widthAnchor.constraint(equalToConstant: 173.32),
                        viewProduct.heightAnchor.constraint(equalToConstant: 248.51)
                    ])
                    
                    viewProduct.closureAddToCart = { _ in
                        // Thêm sản phẩm vào giỏ hàng
                    }
                    
                    viewProduct.closureTapProduct = { id in
                        // Xem chi tiết sản phẩm
                        let productDetailtViewController = ProductDetailViewController(product: product)
                        productDetailtViewController.hidesBottomBarWhenPushed = true
                        self?.navigationController?.pushViewController(productDetailtViewController, animated: true)
                    }

                    viewsProduct.append(viewProduct)
                }

                let productClassficationView = ProductClassificationView(labelTitle: labelTitleType, viewsProduct: viewsProduct)
                self?.stackViewContent.addArrangedSubview(productClassficationView)
            }
            
            self?.stackViewContent.isHidden = false
        }
        
        self.homeScreenViewModel.updateListProductSearch = { [weak self] in
            guard let self = self else { return }
            
            self.gridCollectionProductSearch.reloadData()
        }
        
        self.homeScreenViewModel.showErrorSearch = { [weak self] error in
            guard let _ = self else { return }
            
//            self.showErrorAlert(message: error, handleReload: nil)
        }
        
        self.homeScreenViewModel.closureAddProductToCartSuccess = { [weak self] countProduct in
            guard let _ = self else { return }
            
            // Cập nhật lại số sản phẩm hiện có trong giỏ ở icon tabbar cart
        }
        
        self.homeScreenViewModel.closureAddProductToCartFail = { [weak self] _ in
            guard let self = self else { return }
            
            self.showErrorAlert(message: "Sorry, there was an error adding the product to the cart. Please try again later!", handleReload: nil)
        }
        
        self.homeScreenViewModel.closureNoAccess = { [weak self] in
            guard let self = self else { return }
            
            SessionManager.shared.indexTabbarView = 0
            
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
        
        self.fetchData()
    }
    
    private func fetchData() {
        homeScreenViewModel.fetchBanner()
//        homeScreenViewModel.fetchProductClassifications()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // Lấy thông tin về bàn phím
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            // Cập nhật kích thước của subView
            UIView.animate(withDuration: 0.3) {
                // Gỡ bỏ ràng buộc cũ nếu có
                if let oldConstraint = self.subViewBottomConstraint {
                    oldConstraint.isActive = false
                }

                // Tạo và lưu ràng buộc mới
                self.subViewBottomConstraint = self.subView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardHeight)
                self.subViewBottomConstraint?.isActive = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // Khôi phục kích thước ban đầu cho subView
        UIView.animate(withDuration: 0.3) {
            // Gỡ bỏ ràng buộc cũ nếu có
            if let oldConstraint = self.subViewBottomConstraint {
                oldConstraint.isActive = false
            }

            // Tạo và lưu ràng buộc mới
            self.subViewBottomConstraint = self.subView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            self.subViewBottomConstraint?.isActive = true
        }
    }
    
    // Hàm được gọi khi ViewController sắp được thêm vào màn hình
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        homeScreenViewModel.fetchLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // Hàm được gọi khi ViewController chuẩn bị xoá khỏi màn hình
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func hideKeybroad() {
        self.view.endEditing(true)
    }

    private func setupNav() {
        // Đặt font cho title trong navigation bar
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Gilroy-Bold", size: 20)!, // Thay đổi kiểu font, kích cỡ và trọng lượng theo ý muốn
            .foregroundColor: UIColor(hex: "#181725") // Màu chữ cho title
        ]

        // Áp dụng thuộc tính cho toàn bộ navigation bar
        UINavigationBar.appearance().titleTextAttributes = attributes

        // Hoặc áp dụng cho một navigation bar cụ thể trong view controller hiện tại
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        view.addSubview(subView)
        
        subView.translatesAutoresizingMaskIntoConstraints = false
        subViewBottomConstraint = subView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            subViewBottomConstraint!,
        ])
        
        let stackViewTop = UIStackView()
        stackViewTop.axis = .vertical
        stackViewTop.distribution = .fill
        stackViewTop.alignment = .center
        stackViewTop.spacing = 20
        subView.addSubview(stackViewTop)

        stackViewTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewTop.topAnchor.constraint(equalTo: subView.topAnchor, constant: 20),
            stackViewTop.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 23),
            stackViewTop.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -23)
        ])
        
        let viewLogo = UIView()
        stackViewTop.addArrangedSubview(viewLogo)

        let iconLogo = UIImageView(image: UIImage(named: "icon-logo"))
        viewLogo.addSubview(iconLogo)

        iconLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconLogo.topAnchor.constraint(equalTo: viewLogo.topAnchor),
            iconLogo.centerXAnchor.constraint(equalTo: viewLogo.centerXAnchor),

            iconLogo.widthAnchor.constraint(equalToConstant: 26.48),
            iconLogo.heightAnchor.constraint(equalToConstant: 30.8)
        ])
        
        stackViewTop.addArrangedSubview(viewLocation)

        viewLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewLocation.topAnchor.constraint(equalTo: iconLogo.bottomAnchor, constant: 7.6),
            viewLocation.centerXAnchor.constraint(equalTo: stackViewTop.centerXAnchor),

            viewLocation.heightAnchor.constraint(equalToConstant: 22.69)
        ])
        
        viewLocation.isHidden = true

        let iconLocation = UIImageView(image: UIImage(named: "icon-location"))
        viewLocation.addSubview(iconLocation)

        iconLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconLocation.topAnchor.constraint(equalTo: viewLocation.topAnchor),
            iconLocation.leadingAnchor.constraint(equalTo: viewLocation.leadingAnchor),

            iconLocation.widthAnchor.constraint(equalToConstant: 15.13),
            iconLocation.heightAnchor.constraint(equalToConstant: 18.17)
        ])

        labelLocation.text = ""
        labelLocation.font = UIFont(name: "Gilroy-Semibold", size: 18)
        labelLocation.textColor = UIColor(hex: "#4C4F4D")
        viewLocation.addSubview(labelLocation)

        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelLocation.topAnchor.constraint(equalTo: viewLocation.topAnchor),
            labelLocation.bottomAnchor.constraint(equalTo: viewLocation.bottomAnchor),
            labelLocation.leadingAnchor.constraint(equalTo: iconLocation.trailingAnchor, constant: 7.44),
            labelLocation.trailingAnchor.constraint(equalTo: viewLocation.trailingAnchor)
        ])

        inputSearch.backgroundColor = UIColor(hex: "#F2F3F2")
        inputSearch.textColor = UIColor(hex: "#181B19")
        inputSearch.font = UIFont(name: "Gilroy-Semibold", size: 14)
        inputSearch.layer.cornerRadius = 15
        inputSearch.attributedPlaceholder = NSAttributedString(string: "Search Store", attributes: [
            .foregroundColor: UIColor(hex: "#7C7C7C"),
            .font: UIFont(name: "Gilroy-Semibold", size: 14)!
        ])
        stackViewTop.addArrangedSubview(inputSearch)

        inputSearch.leftPadding = 15
        inputSearch.rightPadding = 15
        inputSearch.leftViewPadding = 9.81

        let iconSearch = UIImageView(image: UIImage(named: "icon-search"))
        iconSearch.tintColor = UIColor(hex: "#181B19")
        iconSearch.contentMode = .scaleAspectFit

        inputSearch.leftView = iconSearch
        inputSearch.leftViewMode = .always
        
        iconClear.isUserInteractionEnabled = true
        iconClear.contentMode = .scaleAspectFit
        inputSearch.rightViewMode = .always
        iconClear.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClearTextInputSearch(_:))))

        inputSearch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputSearch.heightAnchor.constraint(equalToConstant: 51.57),
            
            inputSearch.leadingAnchor.constraint(equalTo: stackViewTop.leadingAnchor),
            inputSearch.trailingAnchor.constraint(equalTo: stackViewTop.trailingAnchor)
        ])
        
        inputSearch.addTarget(self, action: #selector(handleSearch(_:)), for: .editingChanged)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        subView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: stackViewTop.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: subView.trailingAnchor)
        ])
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshProductClassificaions(_:)), for: .valueChanged)
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        stackView.addArrangedSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
        
        stackViewContent.axis = .vertical
        stackViewContent.spacing = 30
        stackViewContent.distribution = .fill
        stackViewContent.alignment = .fill
        scrollView.addSubview(stackViewContent)

        stackViewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewContent.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackViewContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackViewContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackViewContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            stackViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        stackViewContent.addArrangedSubview(viewSlideShow)

        slideShow.setImageInputs(imageSources)
        slideShow.slideshowInterval = Const.TIME_INTERVAL_SLIDESHOW
        slideShow.layer.cornerRadius = 8
        slideShow.contentScaleMode = .scaleAspectFill
        viewSlideShow.addSubview(slideShow)

        slideShow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slideShow.topAnchor.constraint(equalTo: viewSlideShow.topAnchor, constant: 15),
            slideShow.bottomAnchor.constraint(equalTo: viewSlideShow.bottomAnchor),
            slideShow.leadingAnchor.constraint(equalTo: viewSlideShow.leadingAnchor, constant: 23),
            slideShow.trailingAnchor.constraint(equalTo: viewSlideShow.trailingAnchor, constant: -23),
            
            slideShow.heightAnchor.constraint(greaterThanOrEqualToConstant: 114.99)
        ])
        
        viewSlideShow.isHidden = true

        self.homeScreenViewModel.productClassifications.forEach { productClassification in
            let labelTitleType = UILabel()
            labelTitleType.text = productClassification.name
            labelTitleType.font = UIFont(name: "Gilroy-Semibold", size: 24)
            labelTitleType.textColor = UIColor(hex: "#181725")

            var viewsProduct: [ProductView] = []
            productClassification.products.forEach { product in
                let imageProduct = UIImage(named: product.thumbnail.imageUrl)

                let nameProduct = UILabel()
                nameProduct.text = product.name
                nameProduct.font = UIFont(name: "Gilroy-Bold", size: 16)
                nameProduct.textColor = UIColor(hex: "#181725")

                let piecePriceProduct = UILabel()
                piecePriceProduct.text = product.unitOfMeasure
                piecePriceProduct.font = UIFont(name: "Gilroy-Medium", size: 14)
                piecePriceProduct.textColor = UIColor(hex: "#7C7C7C")

                let priceProduct = UILabel()
                priceProduct.text = "$\(product.price)"
                priceProduct.font = UIFont(name: "Gilroy-Semibold", size: 18)
                priceProduct.textColor = UIColor(hex: "#181725")

                let viewProduct = ProductView(idProduct: product.id,imageProduct: imageProduct!, nameProduct: nameProduct, piecePriceProduct: piecePriceProduct, priceProduct: priceProduct)
                
                viewProduct.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    viewProduct.widthAnchor.constraint(equalToConstant: 173.32),
                    viewProduct.heightAnchor.constraint(equalToConstant: 248.51)
                ])
                
                viewProduct.closureAddToCart = { idProduct in
                    // Nếu người dùng chưa đăng nhập sẽ hiển thị thông báo đăng nhập để sử dụng tính năng này
                    if !AppConfig.isLogin {
                        
                        SessionManager.shared.indexTabbarView = 0
                        
                        // Tạo view controller của thông báo đăng nhập
                        let notifyRequireLoginViewController = NotifyRequireLoginViewController(content: "Login required before using this feature!")
                        
                        notifyRequireLoginViewController.closureHandleConfirm = { [weak self] in
                            guard let self = self else { return }
                            
                            HomeScreenViewController.redirectToSignin(for: self)
                        }
                        
                        // Bọc nó trong UINavigationController
                        let navController = UINavigationController(rootViewController: notifyRequireLoginViewController)
                        
                        // Tùy chọn hiển thị modally
                        navController.modalPresentationStyle = .overFullScreen
                        navController.modalTransitionStyle = .crossDissolve
                        
                        // Trình bày modally để nó chồng lên tabBar
                        self.present(navController, animated: true, completion: nil)
                    } else {
                        // Thêm sản phẩm vào giỏ hàng
                        // Gửi API kèm token và danh sách sản phẩm để thêm và giỏ hàng, nếu 401 thì hiển thị phiên đăng nhập đã hết hạn (yêu cầu đăng nhập để sử dụng, nếu không thì sẽ không thêm vào giỏ), nếu lỗi khác thì sẽ hiển thị thông báo có lỗi, vui lòng thử lại sau
                        
                        let data: [[String: Any]] = [
                            [
                                "product_id": idProduct,
                                "quantity": 1
                            ]
                        ]
                        
                        self.homeScreenViewModel.addProductToCart(data: data)
                    }
                }
                
                viewProduct.closureTapProduct = { _ in
                    // Xem chi tiết sản phẩm
                    let productDetailtViewController = ProductDetailViewController(product: product)
                    productDetailtViewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(productDetailtViewController, animated: true)
                }

                viewsProduct.append(viewProduct)
            }

            let productClassficationView = ProductClassificationView(labelTitle: labelTitleType, viewsProduct: viewsProduct)
            stackViewContent.addArrangedSubview(productClassficationView)
        }
        
        let viewPaddingBottom = UIView()
        stackViewContent.addArrangedSubview(viewPaddingBottom)
        
        stackView.addArrangedSubview(gridCollectionProductSearch)
        
//        gridCollectionProductSearch.isHidden = true
        
        gridCollectionProductSearch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridCollectionProductSearch.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 25),
            gridCollectionProductSearch.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -25)
        ])
        
        let viewEmpty = UIView()
        subView.addSubview(viewEmpty)
        
        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            viewEmpty.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
            viewEmpty.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewEmpty.trailingAnchor.constraint(equalTo: subView.trailingAnchor)
        ])
    }
    
    static func redirectToSignin(for self: UIViewController) {
        let signInViewController = SignInViewController()
        signInViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
    
    @objc private func refreshProductClassificaions(_ sender: AnyObject) {
        self.homeScreenViewModel.fetchProductClassifications(reload: true)
    }
    
    // Hàm xử lý khi nhập nội dung vào tìm kiếm
    @objc private func handleSearch(_ sender: PaddedTextField) {
        // Hủy công việc đang chờ nếu có
        debounceWorkItem?.cancel()
        
        if let value = sender.text, !value.isEmpty {
            // Hiển thị icon clear
            self.inputSearch.rightView = iconClear
            self.homeScreenViewModel.searchProduct(keyword: value)
            
            // Tạo một công việc mới và đặt thời gian chờ
            let workItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.stackView.insertArrangedSubview(self.gridCollectionProductSearch, at: 0)
            }
            
            // Lưu công việc và chạy nó sau khoảng debounceInterval
            debounceWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + HomeScreenViewModel.debounceInterval, execute: workItem)
            
            return
        }
        
        // Khi chuỗi tìm kiếm rỗng, hủy các sản phẩm tìm kiếm
        self.homeScreenViewModel.listProductSearch = []
        inputSearch.rightView = nil
        
        // Hủy công việc đang chờ nếu có
        debounceWorkItem?.cancel()
        
        // Hiển thị scrollView trở lại
        stackView.insertArrangedSubview(scrollView, at: 0)
    }
    
    // Hàm xử lý khi bấm vào nút clear text input search
    @objc private func handleClearTextInputSearch(_ sender: AnyObject) {
        inputSearch.text = ""
        inputSearch.rightView = nil
        stackView.insertArrangedSubview(scrollView, at: 0)
        self.homeScreenViewModel.listProductSearch = []
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
    
    deinit {
        // Hủy đăng ký thông báo khi không còn sử dụng
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension HomeScreenViewController: UICollectionViewDataSource {
    // Đặt số lượng mục trong chế độ xem bộ sưu tập. Không thêm số lượng phần nên nó sẽ gán giá trị mặc định là 1
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeScreenViewModel.listProductSearch.count
    }
    
    // dequeueReusableCell với mã định danh ô được cung cấp từ phương thức setupCollectionView.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCellView
            
        let product = self.homeScreenViewModel.listProductSearch[indexPath.item]

        // Thiết lập id
        cell.product = product

        // Thiết lập màu nền
        cell.backgroundColor = UIColor(hex: "#FFFFFF")
        cell.layer.borderColor = UIColor(hex: "#E2E2E2").cgColor

        // Thiết lập hình ảnh
        cell.imageProduct.image = UIImage(named: product.thumbnail.imageUrl)
        
        // Thiết lập tiêu đề
        cell.nameProduct.text = product.name
        cell.nameProduct.font = UIFont(name: "Gilroy-Bold", size: 16)
        cell.nameProduct.textColor = UIColor(hex: "#181725")
        
        cell.piecePriceProduct.text = product.unitOfMeasure
        cell.piecePriceProduct.font = UIFont(name: "Gilroy-Medium", size: 14)
        cell.piecePriceProduct.textColor = UIColor(hex: "#7C7C7C")
        
        cell.priceProduct.text = "$\(product.price)"
        cell.priceProduct.font = UIFont(name: "Gilroy-Bold", size: 18)
        cell.priceProduct.textColor = UIColor(hex: "#181725")
        
        cell.closureAddToCart = { [weak self] _ in
            guard let _ = self else { return }
        }

        cell.closureTapProduct = { [weak self] product in
            // Xem chi tiết sản phẩm
            let productDetailtViewController = ProductDetailViewController(product: product)
            productDetailtViewController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(productDetailtViewController, animated: true)
        }
        
        return cell
    }
}

extension HomeScreenViewController: UICollectionViewDelegateFlowLayout {
    // Đầu tiên thêm insetForSectionAt từ UICollectionViewDelegateFlowLayout.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Thêm phần chèn cho các phần chế độ xem bộ sưu tập.
        return UIEdgeInsets(top: 15, left: 0, bottom: 25, right: 0)
    }
    
    // Thêm để chỉ định kích thước cho ô nên đã thêm phương thức từ UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Nhận bố cục được chỉ định từ chế độ xem bộ sưu tập.
        let lay =   collectionViewLayout as! UICollectionViewFlowLayout
        
        // Phân bổ chiều rộng của ô.
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing / 2
        
        // Trả về kích thước của mỗi ô nhưng đảm bảo khoảng cách giữa các dòng phải nhỏ hơn.
        return CGSize(width: widthPerItem, height: 248.51)
    }
}
