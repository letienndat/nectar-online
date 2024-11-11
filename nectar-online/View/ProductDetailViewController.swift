//
//  ProductDetailViewController.swift
//  nectar-online
//
//  Created by Macbook on 29/10/2024.
//

import UIKit
import ImageSlideshow

class ProductDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let refreshControl = UIRefreshControl()
    private let loading = AnimationLoadingView()
    private let buttonHeart = UIButton(type: .system)
    private let labelProductDetail = CopyableLabel()
    private let iconArrowProductDetail = UIButton(type: .system)
    private let iconArrowNutritions = UIButton(type: .system)
    private let iconArrowReview = UIButton(type: .system)
    private var isShowProductDetail = false
    private var isShowNutritions = false
    private var isShowReview = false
    private var productDetailViewModel = ProductDetailViewModel()
    private let labelNumberQuantity = UILabel()
    private let labelPrice = UILabel()
    private let iconSubtract = UIButton(type: .system)
    private let labelContentReview = UILabel()
    private var arrayIconStars: [UIButton] = []
    private let maxStars = 5
    private var imageSources: [ImageSource] = []
    private let slideShow = ImageSlideshow()
    private let labelNameProduct = UILabel()
    private let labelPieceAndPrice = UILabel()
    private let labelNutritionalContent = UILabel()
    
    init(product: Product) {
        self.productDetailViewModel.product = product
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
        setupLoadingOverlay()
        
        productDetailViewModel.updateFavoriteIcon = { [weak self] in
            self?.updateIconFavoriteColor()
        }
        
        productDetailViewModel.updateQuantityView = { [weak self] in
            self?.updateNumberQuantiyAndPrice()
        }
        
        productDetailViewModel.updateIconSubtract = { [weak self] in
            self?.updateIconSubtract()
        }
        
        productDetailViewModel.product?.updateReview = { [weak self] in
            self?.showReview()
        }
        
        productDetailViewModel.product?.updateRating = { [weak self] in
            self?.showStars()
        }
        
        productDetailViewModel.loadProduct = { [weak self] in
            self?.updateUI()
        }
        
        productDetailViewModel.hideLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = true
            self.loading.stopAnimation()
        }
        
        productDetailViewModel.showLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = false
            self.loading.startAnimation()
        }
        
        productDetailViewModel.hideRefreshing = { [weak self] in
            self?.refreshControl.endRefreshing()
        }
        
        self.productDetailViewModel.closureFavoriteProductSuccess = { [weak self] isFavorite in
            guard let _ = self else { return }
            
            // Xử lý khi hiển thị yêu thích sản phẩm hay không
            self?.productDetailViewModel.isFavorite = isFavorite
        }
        
        self.productDetailViewModel.closureFavoriteProductFail = { [weak self] _ in
            guard let self = self else { return }
            
            self.showErrorAlert(message: "Sorry, there was an error liking/unliking the product. Please try again later!", handleReload: nil)
        }
        
        self.productDetailViewModel.closureNoAccess = { [weak self] in
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
        
        self.productDetailViewModel.closureAddProductToCartSuccess = { [weak self] totalProduct in
            guard let self = self else { return }
            
            // Cập nhật lại số sản phẩm hiện có trong giỏ ở icon tabbar cart
            if let tabItems = self.tabBarController?.tabBar.items {
                let cartTabItem = tabItems[2]
                
                let resShow: String = totalProduct > 99 ? "99+" : String(totalProduct)
                cartTabItem.badgeValue = resShow
                
                cartTabItem.setBadgeTextAttributes([
                    .font: UIFont(name: "Gilroy-Semibold", size: 12) ?? .systemFont(ofSize: 12),
                    .foregroundColor: UIColor(hex: "#FFFFFF")
                ], for: .normal)
            }
            
            let banner = NotificationBanner(message: "Product has been added to cart")
            banner.show()
        }
        
        self.productDetailViewModel.closureAddProductToCartFail = { [weak self] _ in
            guard let self = self else { return }
            
            self.showErrorAlert(message: "Sorry, there was an error adding the product to the cart. Please try again later!", handleReload: nil)
        }
        
        self.productDetailViewModel.closureRatingProductSuccess = { [weak self] review, rating in
            guard let self = self else { return }
            
            // Cập nhật số sao được đánh giá
            self.productDetailViewModel.product?.review = review
            self.productDetailViewModel.product?.rating = rating
        }
        
        self.productDetailViewModel.closureRatingProductFail = { [weak self] _ in
            guard let self = self else { return }
            
            self.showErrorAlert(message: "Sorry, there was an error while rating the product. Please try again later!", handleReload: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.productDetailViewModel.product?.quantity = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupNav() {
        // Tùy chỉnh màu sắc cho icon
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "#181725")
        
        // Đặt tiêu đề nút quay lại là trống
        self.navigationController?.navigationBar.topItem?.title = ""
        
        self.navigationItem.title = ""
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-share"), style: .plain, target: self, action: #selector(handleShareProduct(_:)))
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        // Thiết lập scrollView và refreshControl
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshProductDetail), for: .valueChanged)
        
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
            
            subView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            subView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        let viewImageProductDetail = UIView()
        viewImageProductDetail.backgroundColor = UIColor(hex: "#F2F3F2")
        viewImageProductDetail.layer.cornerRadius = 25
        subView.addSubview(viewImageProductDetail)
        
        viewImageProductDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewImageProductDetail.topAnchor.constraint(equalTo: subView.topAnchor),
            viewImageProductDetail.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewImageProductDetail.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            
            viewImageProductDetail.heightAnchor.constraint(equalToConstant: 371.44)
        ])
        
        let dispatchGroup = DispatchGroup() // Tạo DispatchGroup
        
        // Bắt đầu một task mới trong DispatchGroup
        dispatchGroup.enter()
        loadImage(from: productDetailViewModel.product?.thumbnail.imageUrl ?? "") { img in
            if let downloadedImage = img {
                self.imageSources.append(ImageSource(image: downloadedImage))
            } else {
                //
            }
            // Thông báo rằng task đã hoàn thành
            dispatchGroup.leave()
        }
        
        self.productDetailViewModel.product?.images.forEach { image in
            // Bắt đầu một task mới trong DispatchGroup
            dispatchGroup.enter()
            loadImage(from: image.imageUrl) { img in
                if let downloadedImage = img {
                    self.imageSources.append(ImageSource(image: downloadedImage))
                } else {
                    //
                }
                // Thông báo rằng task đã hoàn thành
                dispatchGroup.leave()
            }
        }
        
        // Khi tất cả các task đã hoàn thành
        dispatchGroup.notify(queue: .main) {
            self.slideShow.setImageInputs(self.imageSources)
        }

        slideShow.slideshowInterval = Const.TIME_INTERVAL_SLIDESHOW
        viewImageProductDetail.addSubview(slideShow)

        slideShow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slideShow.topAnchor.constraint(equalTo: viewImageProductDetail.topAnchor, constant: 102.8),
            slideShow.bottomAnchor.constraint(equalTo: viewImageProductDetail.bottomAnchor, constant: -31.62),
            slideShow.leadingAnchor.constraint(equalTo: viewImageProductDetail.leadingAnchor),
            slideShow.trailingAnchor.constraint(equalTo: viewImageProductDetail.trailingAnchor),
        ])
        
        let viewContent = UIView()
        subView.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: viewImageProductDetail.bottomAnchor, constant: 30.5),
            viewContent.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25),
            viewContent.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25),
        ])
        
        let stackViewContent = UIStackView()
        stackViewContent.axis = .vertical
        stackViewContent.distribution = .fill
        stackViewContent.alignment = .fill
        stackViewContent.spacing = 1
        stackViewContent.backgroundColor = UIColor(hex: "#E2E2E2", alpha: 0.7)
        viewContent.addSubview(stackViewContent)
        
        stackViewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewContent.topAnchor.constraint(equalTo: viewContent.topAnchor),
            stackViewContent.leadingAnchor.constraint(equalTo: viewContent.leadingAnchor),
            stackViewContent.trailingAnchor.constraint(equalTo: viewContent.trailingAnchor),
            stackViewContent.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor)
        ])
        
        let viewInfoMain = UIView()
        viewInfoMain.backgroundColor = UIColor(hex: "#FFFFFF")
        stackViewContent.addArrangedSubview(viewInfoMain)
        
        let viewInfoMainTop = UIView()
        viewInfoMain.addSubview(viewInfoMainTop)
        
        viewInfoMainTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewInfoMainTop.topAnchor.constraint(equalTo: viewInfoMain.topAnchor),
            viewInfoMainTop.leadingAnchor.constraint(equalTo: viewInfoMain.leadingAnchor),
            viewInfoMainTop.trailingAnchor.constraint(equalTo: viewInfoMain.trailingAnchor)
        ])
        
        labelNameProduct.text = productDetailViewModel.product?.name
        labelNameProduct.font = UIFont(name: "Gilroy-Bold", size: 24)
        labelNameProduct.textColor = UIColor(hex: "#181725")
        labelNameProduct.textAlignment = .left
        labelNameProduct.numberOfLines = 0
        viewInfoMainTop.addSubview(labelNameProduct)
        
        labelNameProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelNameProduct.topAnchor.constraint(equalTo: viewInfoMainTop.topAnchor),
            labelNameProduct.leadingAnchor.constraint(equalTo: viewInfoMainTop.leadingAnchor),
            labelNameProduct.trailingAnchor.constraint(equalTo: viewInfoMainTop.trailingAnchor, constant: -(22.8 + 10)) // Tối đa phải cách icon yêu thích 10,
        ])
        
        labelPieceAndPrice.text = productDetailViewModel.product?.unitOfMeasure
        labelPieceAndPrice.font = UIFont(name: "Gilroy-Semibold", size: 16)
        labelPieceAndPrice.textColor = UIColor(hex: "#7C7C7C")
        viewInfoMainTop.addSubview(labelPieceAndPrice)
        
        labelPieceAndPrice.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelPieceAndPrice.topAnchor.constraint(equalTo: labelNameProduct.bottomAnchor, constant: 10.5),
            labelPieceAndPrice.bottomAnchor.constraint(equalTo: viewInfoMainTop.bottomAnchor),
            labelPieceAndPrice.leadingAnchor.constraint(equalTo: viewInfoMainTop.leadingAnchor),
            
            labelPieceAndPrice.heightAnchor.constraint(equalToConstant: 14.89)
        ])
        
        buttonHeart.setImage(UIImage(named: "icon-heart"), for: .normal)
        buttonHeart.tintColor = UIColor(hex: "#7C7C7C")
        viewInfoMainTop.addSubview(buttonHeart)
        
        buttonHeart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonHeart.topAnchor.constraint(equalTo: viewInfoMainTop.topAnchor),
            buttonHeart.trailingAnchor.constraint(equalTo: viewInfoMainTop.trailingAnchor),
            
            buttonHeart.widthAnchor.constraint(equalToConstant: 22.8),
            buttonHeart.heightAnchor.constraint(equalToConstant: 19.6)
        ])
        buttonHeart.addTarget(self, action: #selector(handleTapFavorite(_:)), for: .touchUpInside)
        
        let viewInfoMainBottom = UIView()
        viewInfoMain.addSubview(viewInfoMainBottom)
        
        viewInfoMainBottom.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewInfoMainBottom.topAnchor.constraint(equalTo: viewInfoMainTop.bottomAnchor, constant: 30.14),
            viewInfoMainBottom.bottomAnchor.constraint(equalTo: viewInfoMain.bottomAnchor, constant: -30.4),
            viewInfoMainBottom.leadingAnchor.constraint(equalTo: viewInfoMain.leadingAnchor),
            viewInfoMainBottom.trailingAnchor.constraint(equalTo: viewInfoMain.trailingAnchor),
        ])
        
        let viewQuantity = UIView()
        viewInfoMainBottom.addSubview(viewQuantity)
        
        viewQuantity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewQuantity.topAnchor.constraint(equalTo: viewInfoMainBottom.topAnchor),
            viewQuantity.bottomAnchor.constraint(equalTo: viewInfoMainBottom.bottomAnchor),
            viewQuantity.leadingAnchor.constraint(equalTo: viewInfoMainBottom.leadingAnchor),
            
            viewQuantity.heightAnchor.constraint(equalToConstant: 45.67)
        ])
        
        iconSubtract.setImage(UIImage(named: "icon-subtract"), for: .normal)
        iconSubtract.tintColor = UIColor(hex: "#B3B3B3")
        viewQuantity.addSubview(iconSubtract)
        
        iconSubtract.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconSubtract.topAnchor.constraint(equalTo: viewQuantity.topAnchor),
            iconSubtract.bottomAnchor.constraint(equalTo: viewQuantity.bottomAnchor),
            iconSubtract.leadingAnchor.constraint(equalTo: viewQuantity.leadingAnchor)
        ])
        
        iconSubtract.addTarget(self, action: #selector(subtractOneQuantity(_:)), for: .touchUpInside)
        
        let viewNumberQuantity = UIView()
        viewNumberQuantity.layer.cornerRadius = 17
        viewNumberQuantity.layer.borderWidth = 1
        viewNumberQuantity.layer.borderColor = UIColor(hex: "#E2E2E2").cgColor
        viewQuantity.addSubview(viewNumberQuantity)
        
        viewNumberQuantity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewNumberQuantity.topAnchor.constraint(equalTo: viewQuantity.topAnchor),
            viewNumberQuantity.bottomAnchor.constraint(equalTo: viewQuantity.bottomAnchor),
            viewNumberQuantity.leadingAnchor.constraint(equalTo: iconSubtract.trailingAnchor, constant: 20),
            
            viewNumberQuantity.widthAnchor.constraint(greaterThanOrEqualToConstant: 45.67)
        ])
        
        labelNumberQuantity.text = "\(productDetailViewModel.product?.quantity ?? 1)"
        labelNumberQuantity.font = UIFont(name: "Gilroy-Semibold", size: 18)
        labelNumberQuantity.textColor = UIColor(hex: "#181725")
        viewNumberQuantity.addSubview(labelNumberQuantity)
        
        labelNumberQuantity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelNumberQuantity.centerYAnchor.constraint(equalTo: viewNumberQuantity.centerYAnchor),
            
            labelNumberQuantity.leadingAnchor.constraint(equalTo: viewNumberQuantity.leadingAnchor, constant: 19.33),
            labelNumberQuantity.trailingAnchor.constraint(equalTo: viewNumberQuantity.trailingAnchor, constant: -19.34)
        ])
        
        let iconAdd = UIButton(type: .system)
        iconAdd.setImage(UIImage(named: "icon-add"), for: .normal)
        iconAdd.tintColor = UIColor(hex: "#53B175")
        viewQuantity.addSubview(iconAdd)
        
        iconAdd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconAdd.topAnchor.constraint(equalTo: viewQuantity.topAnchor),
            iconAdd.bottomAnchor.constraint(equalTo: viewQuantity.bottomAnchor),
            iconAdd.trailingAnchor.constraint(equalTo: viewQuantity.trailingAnchor),
            iconAdd.leadingAnchor.constraint(equalTo: viewNumberQuantity.trailingAnchor, constant: 20)
        ])
        
        iconAdd.addTarget(self, action: #selector(addOneQuantity(_:)), for: .touchUpInside)
        
        labelPrice.text = "$\(productDetailViewModel.product?.price ?? 0.00)"
        labelPrice.font = UIFont(name: "Gilroy-Bold", size: 24)
        labelPrice.textColor = UIColor(hex: "#181725")
        viewInfoMainBottom.addSubview(labelPrice)
        
        labelPrice.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelPrice.trailingAnchor.constraint(equalTo: viewInfoMainBottom.trailingAnchor),
            labelPrice.centerYAnchor.constraint(equalTo: viewInfoMainBottom.centerYAnchor),
            labelPrice.leadingAnchor.constraint(greaterThanOrEqualTo: viewQuantity.trailingAnchor, constant: 20)
        ])
        
        let viewProductDetail = UIView()
        viewProductDetail.backgroundColor = UIColor(hex: "#FFFFFF")
        stackViewContent.addArrangedSubview(viewProductDetail)
        
        let stackViewProductDetail = UIStackView()
        stackViewProductDetail.axis = .vertical
        stackViewProductDetail.distribution = .fill
        stackViewProductDetail.alignment = .fill
        stackViewProductDetail.spacing = 9.45
        viewProductDetail.addSubview(stackViewProductDetail)
        
        stackViewProductDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewProductDetail.topAnchor.constraint(equalTo: viewProductDetail.topAnchor, constant: 18.05),
            stackViewProductDetail.bottomAnchor.constraint(equalTo: viewProductDetail.bottomAnchor, constant: -19.1),
            stackViewProductDetail.leadingAnchor.constraint(equalTo: viewProductDetail.leadingAnchor),
            stackViewProductDetail.trailingAnchor.constraint(equalTo: viewProductDetail.trailingAnchor)
        ])
        
        let viewTopProductDetail = UIView()
        stackViewProductDetail.addArrangedSubview(viewTopProductDetail)
        
        viewTopProductDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewTopProductDetail.topAnchor.constraint(equalTo: stackViewProductDetail.topAnchor),
            viewTopProductDetail.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        viewTopProductDetail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapArrowProductDetail(_:))))
        
        let labelTitleProductDetail = UILabel()
        labelTitleProductDetail.text = "Product Detail"
        labelTitleProductDetail.font = UIFont(name: "Gilroy-Semibold", size: 16)
        labelTitleProductDetail.textColor = UIColor(hex: "#181725")
        viewTopProductDetail.addSubview(labelTitleProductDetail)
        
        labelTitleProductDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitleProductDetail.topAnchor.constraint(equalTo: viewTopProductDetail.topAnchor),
            labelTitleProductDetail.leadingAnchor.constraint(equalTo: viewTopProductDetail.leadingAnchor),
            
            labelTitleProductDetail.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        iconArrowProductDetail.setImage(UIImage(named: "icon-arrow-right"), for: .normal)
        iconArrowProductDetail.tintColor = UIColor(hex: "#181725")
        viewTopProductDetail.addSubview(iconArrowProductDetail)
        
        iconArrowProductDetail.addTarget(self, action: #selector(handleTapArrowProductDetail(_:)), for: .touchUpInside)
        
        iconArrowProductDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconArrowProductDetail.trailingAnchor.constraint(equalTo: viewTopProductDetail.trailingAnchor),
            iconArrowProductDetail.centerYAnchor.constraint(equalTo: viewTopProductDetail.centerYAnchor),
            
            iconArrowProductDetail.widthAnchor.constraint(equalToConstant: 8.4),
            iconArrowProductDetail.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        labelProductDetail.text = productDetailViewModel.product?.description
        labelProductDetail.font = UIFont(name: "Gilroy-Medium", size: 13)
        labelProductDetail.textColor = UIColor(hex: "#7C7C7C")
        labelProductDetail.numberOfLines = 0
        labelProductDetail.isHidden = true
        
        // Tạo NSMutableParagraphStyle để cài đặt line height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5 // Khoảng cách giữa các dòng (line height)

        // Tạo NSAttributedString với đoạn text và paragraphStyle
        let attributedString = NSMutableAttributedString(string: labelProductDetail.text!)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        // Gán NSAttributedString vào UILabel
        labelProductDetail.attributedText = attributedString
        
        stackViewProductDetail.addArrangedSubview(labelProductDetail)
        
        let viewNutritions = UIView()
        viewNutritions.backgroundColor = UIColor(hex: "#FFFFFF")
        stackViewContent.addArrangedSubview(viewNutritions)
        
        let stackViewNutritions = UIStackView()
        stackViewNutritions.axis = .vertical
        stackViewNutritions.distribution = .fill
        stackViewNutritions.alignment = .fill
        stackViewNutritions.spacing = 9.45
        viewNutritions.addSubview(stackViewNutritions)
        
        stackViewNutritions.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewNutritions.topAnchor.constraint(equalTo: viewNutritions.topAnchor, constant: 18.05),
            stackViewNutritions.bottomAnchor.constraint(equalTo: viewNutritions.bottomAnchor, constant: -19.1),
            stackViewNutritions.leadingAnchor.constraint(equalTo: viewNutritions.leadingAnchor),
            stackViewNutritions.trailingAnchor.constraint(equalTo: viewNutritions.trailingAnchor)
        ])
        
        let viewTopNutritions = UIView()
        stackViewNutritions.addArrangedSubview(viewTopNutritions)
        
        viewTopNutritions.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewTopNutritions.topAnchor.constraint(equalTo: stackViewNutritions.topAnchor),
            viewTopNutritions.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        viewTopNutritions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapArrowNutritions(_:))))
        
        let labelTitleNutritions = UILabel()
        labelTitleNutritions.text = "Nutritions"
        labelTitleNutritions.font = UIFont(name: "Gilroy-Semibold", size: 16)
        labelTitleNutritions.textColor = UIColor(hex: "#181725")
        viewTopNutritions.addSubview(labelTitleNutritions)
        
        labelTitleNutritions.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitleNutritions.leadingAnchor.constraint(equalTo: viewTopNutritions.leadingAnchor),
            labelTitleNutritions.centerYAnchor.constraint(equalTo: viewTopNutritions.centerYAnchor),
        ])
        
        iconArrowNutritions.setImage(UIImage(named: "icon-arrow-right"), for: .normal)
        iconArrowNutritions.tintColor = UIColor(hex: "#181725")
        viewTopNutritions.addSubview(iconArrowNutritions)
        
        iconArrowNutritions.addTarget(self, action: #selector(handleTapArrowNutritions(_:)), for: .touchUpInside)
        
        iconArrowNutritions.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconArrowNutritions.trailingAnchor.constraint(equalTo: viewTopNutritions.trailingAnchor),
            iconArrowNutritions.centerYAnchor.constraint(equalTo: viewTopNutritions.centerYAnchor),
            
            iconArrowNutritions.widthAnchor.constraint(equalToConstant: 8.4),
            iconArrowNutritions.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        let viewNutritionalContent = UIView()
        viewNutritionalContent.backgroundColor = UIColor(hex: "#EBEBEB")
        viewNutritionalContent.layer.cornerRadius = 5
        viewTopNutritions.addSubview(viewNutritionalContent)
        
        viewNutritionalContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewNutritionalContent.leadingAnchor.constraint(greaterThanOrEqualTo: labelTitleNutritions.trailingAnchor, constant: 20),
            viewNutritionalContent.trailingAnchor.constraint(equalTo: iconArrowNutritions.leadingAnchor, constant: -20.6),
            viewNutritionalContent.centerYAnchor.constraint(equalTo: viewTopNutritions.centerYAnchor),
            
            viewNutritionalContent.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        labelNutritionalContent.text = productDetailViewModel.product?.nutrients
        labelNutritionalContent.font = UIFont(name: "Gilroy-Semibold", size: 9)
        labelNutritionalContent.textColor = UIColor(hex: "#7C7C7C")
        viewNutritionalContent.addSubview(labelNutritionalContent)
        
        labelNutritionalContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelNutritionalContent.centerXAnchor.constraint(equalTo: viewNutritionalContent.centerXAnchor),
            labelNutritionalContent.centerYAnchor.constraint(equalTo: viewNutritionalContent.centerYAnchor),
            
            labelNutritionalContent.leadingAnchor.constraint(equalTo: viewNutritionalContent.leadingAnchor, constant: 5),
            labelNutritionalContent.trailingAnchor.constraint(equalTo: viewNutritionalContent.trailingAnchor, constant: -5)
        ])
        
        let viewReview = UIView()
        viewReview.backgroundColor = UIColor(hex: "#FFFFFF")
        stackViewContent.addArrangedSubview(viewReview)
        
        let stackViewReview = UIStackView()
        stackViewReview.axis = .vertical
        stackViewReview.distribution = .fill
        stackViewReview.alignment = .fill
        stackViewReview.spacing = 9.45
        viewReview.addSubview(stackViewReview)
        
        stackViewReview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewReview.topAnchor.constraint(equalTo: viewReview.topAnchor, constant: 18.05),
            stackViewReview.bottomAnchor.constraint(equalTo: viewReview.bottomAnchor, constant: -19.1),
            stackViewReview.leadingAnchor.constraint(equalTo: viewReview.leadingAnchor),
            stackViewReview.trailingAnchor.constraint(equalTo: viewReview.trailingAnchor)
        ])
        
        let viewTopReview = UIView()
        stackViewReview.addArrangedSubview(viewTopReview)
        
        viewTopReview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewTopReview.topAnchor.constraint(equalTo: stackViewReview.topAnchor),
            viewTopReview.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        viewTopReview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapArrowReview(_:))))
        
        let labelTitleReview = UILabel()
        labelTitleReview.text = "Review"
        labelTitleReview.font = UIFont(name: "Gilroy-Semibold", size: 16)
        labelTitleReview.textColor = UIColor(hex: "#181725")
        viewTopReview.addSubview(labelTitleReview)
        
        labelTitleReview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitleReview.leadingAnchor.constraint(equalTo: viewTopReview.leadingAnchor),
            labelTitleReview.centerYAnchor.constraint(equalTo: viewTopReview.centerYAnchor),
        ])
        
        labelContentReview.text = "(" + String(format: "%.1f", self.productDetailViewModel.product?.review ?? 0.0) + " star)"
        labelContentReview.font = UIFont(name: "Gilroy-Semibold", size: 16)
        labelContentReview.textColor = UIColor(hex: "#7C7C7C")
        viewTopReview.addSubview(labelContentReview)
        
        labelContentReview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelContentReview.leadingAnchor.constraint(equalTo: labelTitleReview.trailingAnchor, constant: 5),
            labelContentReview.centerYAnchor.constraint(equalTo: viewTopReview.centerYAnchor),
        ])
        
        iconArrowReview.setImage(UIImage(named: "icon-arrow-right"), for: .normal)
        iconArrowReview.tintColor = UIColor(hex: "#181725")
        viewTopReview.addSubview(iconArrowReview)
        
        iconArrowReview.addTarget(self, action: #selector(handleTapArrowReview(_:)), for: .touchUpInside)
        
        iconArrowReview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconArrowReview.trailingAnchor.constraint(equalTo: viewTopReview.trailingAnchor),
            iconArrowReview.centerYAnchor.constraint(equalTo: viewTopReview.centerYAnchor),
            
            iconArrowReview.widthAnchor.constraint(equalToConstant: 8.4),
            iconArrowReview.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        let stackViewReviewStars = UIStackView()
        stackViewReviewStars.axis = .horizontal
        stackViewReviewStars.alignment = .center
        stackViewReviewStars.distribution = .fill
        stackViewReviewStars.spacing = 4.72
        viewTopReview.addSubview(stackViewReviewStars)
        
        stackViewReviewStars.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewReviewStars.leadingAnchor.constraint(greaterThanOrEqualTo: labelContentReview.trailingAnchor, constant: 20),
            stackViewReviewStars.trailingAnchor.constraint(equalTo: iconArrowReview.leadingAnchor, constant: -20.6),
            stackViewReviewStars.centerYAnchor.constraint(equalTo: viewTopReview.centerYAnchor),
            
            stackViewReviewStars.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        for index in 0..<maxStars {
            let iconStar = UIButton(type: .system)
            iconStar.setImage(UIImage(named: "icon-star"), for: .normal)
            iconStar.tintColor = index < self.productDetailViewModel.product?.rating ?? 5 ? UIColor(hex: "#F3603F") : UIColor(hex: "#DADADA")
            iconStar.tag = index
            iconStar.addTarget(self, action: #selector(handleTapIconStar(_:)), for: .touchUpInside)
            
            arrayIconStars.append(iconStar)
            stackViewReviewStars.addArrangedSubview(iconStar)
        }
        
        let viewEmpty = UIView()
        subView.addSubview(viewEmpty)
        
        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.topAnchor.constraint(equalTo: viewContent.bottomAnchor),
            viewEmpty.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewEmpty.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
        ])
        
        let buttonAddToBasket = ButtonView.createSystemButton(
            title: "Add To Basket",
            titleColor: UIColor(hex: "#FFF9FF"),
            titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
            backgroundColor: UIColor(hex: "#53B175"),
            borderRadius: 19
        )
        subView.addSubview(buttonAddToBasket)
        
        buttonAddToBasket.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonAddToBasket.topAnchor.constraint(equalTo: viewEmpty.bottomAnchor),
            buttonAddToBasket.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -38.67),
            buttonAddToBasket.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25),
            buttonAddToBasket.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25),
            
            buttonAddToBasket.heightAnchor.constraint(equalToConstant: 67)
        ])
        
        buttonAddToBasket.addTarget(self, action: #selector(handleAddToBasket(_:)), for: .touchUpInside)
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
    
    // Hàm xử lý sự kiện kéo màn hình xuống để load lại thông tin chi tiết sản phẩm
    @objc private func refreshProductDetail() {
        self.productDetailViewModel.fetchProduct(id: self.productDetailViewModel.product!.id, isRefresh: true)
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
    
    private func updateUI() {
        let dispatchGroup = DispatchGroup() // Tạo DispatchGroup
        
        // Bắt đầu một task mới trong DispatchGroup
        dispatchGroup.enter()
        loadImage(from: productDetailViewModel.product?.thumbnail.imageUrl ?? "") { img in
            if let downloadedImage = img {
                self.imageSources.append(ImageSource(image: downloadedImage))
            } else {
                //
            }
            // Thông báo rằng task đã hoàn thành
            dispatchGroup.leave()
        }
        
        self.productDetailViewModel.product?.images.forEach { image in
            // Bắt đầu một task mới trong DispatchGroup
            dispatchGroup.enter()
            loadImage(from: image.imageUrl) { img in
                if let downloadedImage = img {
                    self.imageSources.append(ImageSource(image: downloadedImage))
                } else {
                    //
                }
                // Thông báo rằng task đã hoàn thành
                dispatchGroup.leave()
            }
        }
        
        // Khi tất cả các task đã hoàn thành
        dispatchGroup.notify(queue: .main) {
            self.slideShow.setImageInputs(self.imageSources)
        }
        
        labelNameProduct.text = self.productDetailViewModel.product?.name
        labelPieceAndPrice.text = self.productDetailViewModel.product?.unitOfMeasure
        labelNumberQuantity.text = "$\(self.productDetailViewModel.product?.quantity ?? 1)"
        labelPrice.text = "$\(self.productDetailViewModel.product?.price ?? 0.00)"
        labelProductDetail.text = self.productDetailViewModel.product?.description
        labelNutritionalContent.text = self.productDetailViewModel.product?.nutrients
        showReview()
        showStars()
    }
    
    // Hàm xử lý khi bấm vào share product
    @objc private func handleShareProduct(_ sender: UIButton) {
        //
    }
    
    // Hàm xử lý khi bấm vào icon yêu thích
    @objc private func handleTapFavorite(_ sender: UIButton) {
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
            // Thêm sản phẩm vào danh sách yêu thích
            
            guard let id = self.productDetailViewModel.product?.id else {
                return
            }
            
            self.productDetailViewModel.favoriteProduct(productId: id)
        }
    }
    
    // Cập nhật màu cho icon yêu thích
    private func updateIconFavoriteColor() {
        buttonHeart.tintColor = UIColor(hex: productDetailViewModel.isFavorite ? "#FF0000" : "#7C7C7C")
    }
    
    // Xử lý sự kiện bấm nút giảm số lượng
    @objc func subtractOneQuantity(_ sender: UIButton) {
        productDetailViewModel.subtractOneQuantity()
    }
    
    // Xử lý sự kiện bấm nút tăng số lượng
    @objc func addOneQuantity(_ sender: UIButton) {
        productDetailViewModel.addOneQuantity()
    }
    
    // Cập nhật số lượng và giá
    private func updateNumberQuantiyAndPrice() {
        labelNumberQuantity.text = "\(productDetailViewModel.product?.quantity ?? 1)"
        labelPrice.text = "$\(String(format: "%.2f", Double(productDetailViewModel.product?.quantity ?? 1) * (productDetailViewModel.product?.price ?? 0.00)))"
    }
    
    // Cập nhật icon giảm sản phẩm
    private func updateIconSubtract() {
        self.iconSubtract.tintColor = UIColor(hex: self.productDetailViewModel.canSubtractQuantity ? "#53B175" : "#B3B3B3")
    }
    
    // Hàm ẩn hiện chi tiết sản phẩm
    @objc private func handleTapArrowProductDetail(_ sender: UIView) {
        labelProductDetail.isHidden.toggle()
        isShowProductDetail.toggle()
        
        if isShowProductDetail {
            iconArrowProductDetail.transform = CGAffineTransform(rotationAngle: .pi / 2)
        } else {
            iconArrowProductDetail.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    // Hàm ẩn hiện thông tin Nutritions
    @objc private func handleTapArrowNutritions(_ sender: UIView) {
        isShowNutritions.toggle()
        
        if isShowNutritions {
            iconArrowNutritions.transform = CGAffineTransform(rotationAngle: .pi / 2)
        } else {
            iconArrowNutritions.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    // Hàm ẩn/hiện đánh giá
    @objc private func handleTapArrowReview(_ sender: UIView) {
        isShowReview.toggle()
        
        if isShowReview {
            iconArrowReview.transform = CGAffineTransform(rotationAngle: .pi / 2)
        } else {
            iconArrowReview.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    // Hàm tính toán số sao đánh giá
    @objc private func handleTapIconStar(_ sender: UIButton) {
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
            // Thêm sản phẩm vào danh sách yêu thích
            
            guard let id = self.productDetailViewModel.product?.id else {
                return
            }
            let starIndex = sender.tag + 1
            
            let data: [String: Int] = [
                "product_id": id,
                "rating": starIndex
            ]
            
            self.productDetailViewModel.ratingProduct(data: data)
            self.productDetailViewModel.ratingTemp = starIndex
        }
    }
    
    // Hàm hiển thị số sao trung bình của sản phẩm
    private func showReview() {
        self.labelContentReview.text = "(" + String(format: "%.1f", self.productDetailViewModel.product?.review ?? 0.0) + " star)"
    }
    
    // Hàm hiển thị số sao mình đánh giá
    private func showStars() {
        // Cập nhật các nút sao dựa trên sao được bấm
        for (index, button) in arrayIconStars.enumerated() {
            if index < self.productDetailViewModel.product?.rating ?? 0 {
                button.tintColor = UIColor(hex: "#F3603F")
            } else {
                button.tintColor = UIColor(hex: "#DADADA")
            }
        }
    }
    
    // Hàm xử lý khi bấm vào Add To Basket
    @objc private func handleAddToBasket(_ sender: UIButton) {
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
            
            guard let id = self.productDetailViewModel.product?.id else {
                return
            }
            
            let data: [[String: Any]] = [
                [
                    "product_id": id,
                    "quantity": 1
                ]
            ]
            
            self.productDetailViewModel.addProductToCart(data: data)
        }
    }
}
