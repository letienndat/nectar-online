//
//  TypeExploreViewController.swift
//  nectar-online
//
//  Created by Macbook on 01/11/2024.
//

import UIKit

class ProductsCategoryViewController: UIViewController {
    private let categoryProduct: CategoryProduct
    private let loading = AnimationLoadingView()
    private let refreshControl = UIRefreshControl()
    private lazy var gridCollectionProduct: UICollectionView = {
        // Khởi tạo UICollectionView với layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductViewCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private let productsCategoryViewModel: ProductsCategoryViewModel = ProductsCategoryViewModel()
    private var productsFilter: [Product] = [] {
        didSet {
            self.gridCollectionProduct.reloadData()
        }
    }
    private let filterViewModel: FilterViewModel
    
    init(categoryProduct: CategoryProduct) {
        self.categoryProduct = categoryProduct
        self.productsFilter = productsCategoryViewModel.listProductCategory.products
        self.filterViewModel = FilterViewModel(sourcesFilter: [])
        
        super.init(nibName: nil, bundle: nil)
        
        self.addSourceFilter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Đẩy các tiêu chí lọc vào sourceFilter
    private func addSourceFilter() {
        var sourcesFilter: [SourceFilter] = []
        
        // Category
        let sourceFilterCategory = SourceFilter(filterCriteria: .category, title: EnumFilterCriteria.category.rawValue)
        var inputsCheckboxCategory: [InputCheckbox] = sourceFilterCategory.inputsCheckbox
        self.productsCategoryViewModel.listProductCategory.products.forEach {
            let category = $0.category
            if !inputsCheckboxCategory.contains(where: { $0.id == category.id }) {
                inputsCheckboxCategory.append(InputCheckbox(id: category.id, name: category.name, checked: false, tempChecked: false))
            }
        }
        sourceFilterCategory.inputsCheckbox = inputsCheckboxCategory
        sourcesFilter.append(sourceFilterCategory)
        
        // Price
        let sourceFilterPrice = SourceFilter(
            filterCriteria: .price,
            title: EnumFilterCriteria.price.rawValue,
            minRange: Const.MIN_RANGE_PRICE,
            maxRange: Const.MAX_RANGE_PRICE,
            startRange: Const.MIN_RANGE_PRICE,
            endRange: Const.MAX_RANGE_PRICE,
            tempStartRange: Const.MIN_RANGE_PRICE,
            tempEndRange: Const.MAX_RANGE_PRICE,
            rating: 0,
            tempRating: 0
        )
        sourcesFilter.append(sourceFilterPrice)
        
        // Rating
        let sourceFilterRating = SourceFilter(filterCriteria: .review, title: EnumFilterCriteria.review.rawValue)
        sourcesFilter.append(sourceFilterRating)
        
        self.filterViewModel.sourcesFilter = sourcesFilter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tạo UITapGestureRecognizer để phát hiện người dùng bấm ra ngoài view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeybroad))
        
        // Thêm gesture vào view cha
        self.view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
        setupLoadingOverlay()
        
        self.productsCategoryViewModel.hideRefreshing = { [weak self] in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
        }
        
        self.productsCategoryViewModel.hideLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = true
            self.loading.stopAnimation()
        }
        
        self.productsCategoryViewModel.showLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = false
            self.loading.startAnimation()
        }
        
        self.productsCategoryViewModel.showError = { [weak self] error in
            guard let self = self else { return }
            
            self.showErrorAlert(message: error, isReload: true, handleReload: { self.fetchData() })
        }
        
        self.productsCategoryViewModel.updateListProductCategory = {
            
            self.navigationItem.title = self.productsCategoryViewModel.listProductCategory.name
            self.gridCollectionProduct.reloadData()
            
            self.productsFilter = self.productsCategoryViewModel.listProductCategory.products
            self.addSourceFilter()
        }
        
        self.productsCategoryViewModel.closureAddProductToCartSuccess = { [weak self] totalProduct in
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
        
        self.productsCategoryViewModel.closureAddProductToCartFail = { [weak self] _ in
            guard let self = self else { return }
            
            self.showErrorAlert(message: "Sorry, there was an error adding the product to the cart. Please try again later!", handleReload: nil)
        }
        
        self.productsCategoryViewModel.closureNoAccess = { [weak self] in
            guard let self = self else { return }
            
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
        self.productsCategoryViewModel.fetchListProductCategory(id: categoryProduct.id)
    }
    
    // Hàm được gọi khi ViewController sắp được thêm vào màn hình
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
        
        if loading.isAnimating {
            loading.startAnimation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func hideKeybroad() {
        self.view.endEditing(true)
    }

    private func setupNav() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Tùy chỉnh màu sắc cho icon
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "#181725")
        
        // Đặt tiêu đề nút quay lại là trống
        self.navigationController?.navigationBar.topItem?.title = ""
        
        self.navigationItem.title = categoryProduct.name
        
        // Đặt font cho title trong navigation bar
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Gilroy-Bold", size: 20)!, // Thay đổi kiểu font, kích cỡ và trọng lượng theo ý muốn
            .foregroundColor: UIColor(hex: "#181725") // Màu chữ cho title
        ]

        // Áp dụng thuộc tính cho toàn bộ navigation bar
        UINavigationBar.appearance().titleTextAttributes = attributes

        // Hoặc áp dụng cho một navigation bar cụ thể trong view controller hiện tại
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-filter"), style: .plain, target: self, action: #selector(handleFilter(_:)))
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
        
        // Thêm collection view vào subView
        subView.addSubview(gridCollectionProduct)
        
        gridCollectionProduct.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshProductsCategory(_:)), for: .valueChanged)
        
        gridCollectionProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridCollectionProduct.topAnchor.constraint(equalTo: subView.topAnchor, constant: 10),
            gridCollectionProduct.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            gridCollectionProduct.trailingAnchor.constraint(equalTo: subView.trailingAnchor)
        ])
        
        let viewEmpty = UIView()
        subView.addSubview(viewEmpty)
        
        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.topAnchor.constraint(equalTo: gridCollectionProduct.bottomAnchor),
            viewEmpty.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
            viewEmpty.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewEmpty.trailingAnchor.constraint(equalTo: subView.trailingAnchor)
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
    
    // Hàm xử lý khi kéo danh sách sản phẩm để load lại danh sách sản phẩm mới
    @objc private func refreshProductsCategory(_ sender: AnyObject) {
        self.productsCategoryViewModel.fetchListProductCategory(id: self.categoryProduct.id, isRefresh: true)
    }
    
    // Hàm xử lý khi bấm vào filter
    @objc private func handleFilter(_ sender: UIButton) {
        
        // Tạo view controller của view bộ lọc
        let filterViewController = FilterViewController(filterViewModel: filterViewModel)
        
        // Bọc nó trong UINavigationController
        let navController = UINavigationController(rootViewController: filterViewController)
        
        // Tùy chọn hiển thị modally
        navController.modalPresentationStyle = .overFullScreen
        navController.modalTransitionStyle = .crossDissolve
        
        // Trình bày modally để nó chồng lên tabBar
        self.present(navController, animated: true, completion: nil)
        
        filterViewController.closureApplyFilter = { [weak self] in
            guard let self = self else { return }
            
            self.productsFilter = self.productsCategoryViewModel.listProductCategory.products.filter { product in
                var res: Bool = true
                
                // Category
                let sourceFilterCategory = self.filterViewModel.sourcesFilter.first(where: { $0.typeFilterCriteria == .category })
                // Nếu tất cả checkbox không tick thì bỏ qua, còn nếu có ít nhất 1 tick thì kiểm tra
                if let check = sourceFilterCategory?.inputsCheckbox.allSatisfy({ $0.checked == false }), check == true {
                    res = true
                } else {
                    res = sourceFilterCategory?.inputsCheckbox.contains(where: { $0.id == product.category.id && $0.checked }) ?? false
                }
                if !res {
                    return false
                }
                
                // Price
                let sourceFilterPrice = self.filterViewModel.sourcesFilter.first(where: { $0.typeFilterCriteria == .price })
                // Nếu price nằm trong khoảng
                if let startRange = sourceFilterPrice?.startRange, let endRange = sourceFilterPrice?.endRange,
                   (startRange...endRange).contains(product.price) {
                    res = true
                } else {
                    res = false
                }
                if !res {
                    return false
                }
                
                // Rating
                let sourceFilterRating = self.filterViewModel.sourcesFilter.first(where: { $0.typeFilterCriteria == .review })
                res = Int(product.review) >= sourceFilterRating?.rating ?? 0
                
                return res
            }
        }
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { context in
            self.gridCollectionProduct.collectionViewLayout.invalidateLayout()
        })
    }
}

extension ProductsCategoryViewController: UICollectionViewDataSource {
    // Đặt số lượng mục trong chế độ xem bộ sưu tập. Không thêm số lượng phần nên nó sẽ gán giá trị mặc định là 1
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productsFilter.count
    }
    
    // dequeueReusableCell với mã định danh ô được cung cấp từ phương thức setupCollectionView.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductViewCell
            
        let product = self.productsFilter[indexPath.item]

        // Thiết lập id
        cell.product = product

        // Thiết lập màu nền
        cell.backgroundColor = UIColor(hex: "#FFFFFF")
        cell.layer.borderColor = UIColor(hex: "#E2E2E2").cgColor

        // Thiết lập hình ảnh
        loadImage(from: product.thumbnail.imageUrl) { image in
            if let downloadedImage = image {
                cell.imageProduct.image = downloadedImage
            } else {
                //
            }
        }
        
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
        
        cell.closureAddToCart = { [weak self] product in
            guard let _ = self else { return }
            let _ = product
        }

        cell.closureTapProduct = { [weak self] product in
            // Xem chi tiết sản phẩm
            let productDetailtViewController = ProductDetailViewController(product: product)
            productDetailtViewController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(productDetailtViewController, animated: true)
        }
        
        cell.closureAddToCart = { [weak self] product in
            
            guard let self = self else { return }
            
            // Nếu người dùng chưa đăng nhập sẽ hiển thị thông báo đăng nhập để sử dụng tính năng này
            if !AppConfig.isLogin {
                
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
                        "product_id": product.id,
                        "quantity": 1
                    ]
                ]
                
                self.productsCategoryViewModel.addProductToCart(data: data)
            }
        }
        
        return cell
    }
}

extension ProductsCategoryViewController: UICollectionViewDelegateFlowLayout {
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
