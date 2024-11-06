//
//  ExploreViewController.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private var keybroadShow: Bool = false
    private let loadingOverlay = LoadingOverlayView()
    private let refreshControl = UIRefreshControl()
    private lazy var gridCollectionCategory: UICollectionView = {
        // Khởi tạo UICollectionView với layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryProductView.self, forCellWithReuseIdentifier: "CategoryProductCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private lazy var gridCollectionProductSearch: UICollectionView = {
        // Khởi tạo UICollectionView với layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCellView.self, forCellWithReuseIdentifier: "ProductSearchCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private let stackViewInput = UIStackView()
    private let iconFilter = UIButton(type: .system)
    private let inputSearch = PaddedTextField()
    private let iconClear = UIImageView(image: UIImage(named: "icon-clear-input"))
    private let exploreViewModel: ExploreViewModel = ExploreViewModel()
    private var productsFilter: [Product] = [] {
        didSet {
            self.gridCollectionProductSearch.reloadData()
        }
    }
    private let filterViewModel: FilterViewModel
    
    init() {
        self.productsFilter = self.exploreViewModel.listProductSearch
        self.filterViewModel = FilterViewModel(sourcesFilter: [])
        
        super.init(nibName: nil, bundle: nil)
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
        self.exploreViewModel.listProductSearch.forEach {
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
        let sourceFilterRating = SourceFilter(filterCriteria: .rating, title: EnumFilterCriteria.rating.rawValue)
        sourcesFilter.append(sourceFilterRating)
        
        self.filterViewModel.sourcesFilter = sourcesFilter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Tạo UITapGestureRecognizer để phát hiện người dùng bấm ra ngoài view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeybroad))
        
        // Thêm gesture vào view cha
        self.view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
        setupLoadingOverlay()
        
        self.exploreViewModel.hideRefreshing = { [weak self] in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
        }
        
        self.exploreViewModel.hideLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = true
            self.loadingOverlay.hideLoadingOverlay()
        }
        
        self.exploreViewModel.showLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = false
            self.loadingOverlay.showLoadingOverlay()
        }
        
        self.exploreViewModel.showError = { [weak self] error in
            guard let self = self else { return }
            
            self.showErrorAlert(message: error, isReload: true, handleReload: { self.fetchData() })
        }
        
        self.exploreViewModel.updateListCategoryProduct = { [weak self] in
            guard let self = self else { return }
            
            self.gridCollectionCategory.reloadData()
        }
        
        self.exploreViewModel.updateListProductSearch = { [weak self] in
            guard let self = self else { return }
            
            self.productsFilter = self.exploreViewModel.listProductSearch
            self.addSourceFilter()
            self.gridCollectionProductSearch.reloadData()
        }
        
        self.exploreViewModel.showErrorSearch = { [weak self] error in
            guard let _ = self else { return }
            
//            self.showErrorAlert(message: error, handleReload: nil)
        }
        
//        self.fetchData()
    }
    
    private func fetchData() {
        self.exploreViewModel.fetchCategoryProduct()
    }
    
    // Hàm được gọi khi ViewController sắp được thêm vào màn hình
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let text = inputSearch.text, text.isEmpty {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        self.navigationItem.title = "Find Products"
        
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
    
    // Hàm được gọi sau khi ViewController bị xoá khỏi màn hình
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Hàm ẩn bàn phím khi ấn ra ngoài vùng input
    @objc private func hideKeybroad() {
        if let text = inputSearch.text, text.isEmpty {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.iconFilter.isHidden = true
            self.gridCollectionProductSearch.isHidden = true
            self.gridCollectionCategory.isHidden = false
            self.exploreViewModel.listProductSearch = []
        }
        self.keybroadShow = false
        self.view.endEditing(true)
    }

    private func setupNav() {
        // BUG: Nếu select index mặc định = 0 thì sẽ không select vào icon tab bar Shop nên để tạm sang 1 (ExploreView), viewDidLoad của ExploreViewController sẽ select lại index = 0
//        self.tabBarController?.selectedIndex = 0
        
        self.navigationItem.title = "Find Products"
        
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
        
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.delaysContentTouches = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.height ?? 0) ),
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
        
        stackViewInput.axis = .horizontal
        stackViewInput.distribution = .fill
        stackViewInput.alignment = .center
        stackViewInput.spacing = 19.83
        subView.addSubview(stackViewInput)
        
        stackViewInput.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewInput.topAnchor.constraint(equalTo: subView.topAnchor, constant: 25),
            stackViewInput.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            stackViewInput.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
        ])
        
        inputSearch.backgroundColor = UIColor(hex: "#F2F3F2")
        inputSearch.textColor = UIColor(hex: "#181B19")
        inputSearch.font = UIFont(name: "Gilroy-Semibold", size: 14)
        inputSearch.layer.cornerRadius = 15
        inputSearch.attributedPlaceholder = NSAttributedString(string: "Search Store", attributes: [
            .foregroundColor: UIColor(hex: "#7C7C7C"),
            .font: UIFont(name: "Gilroy-Semibold", size: 14)!
        ])
        stackViewInput.addArrangedSubview(inputSearch)

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
            inputSearch.heightAnchor.constraint(equalToConstant: 51.57)
        ])
        
        inputSearch.addTarget(self, action: #selector(handleTapInputSearch(_:)), for: .editingDidBegin)
        inputSearch.addTarget(self, action: #selector(handleChangValueInputSearch(_:)), for: .editingChanged)
        
        iconFilter.setImage(UIImage(named: "icon-filter"), for: .normal)
        iconFilter.tintColor = UIColor(hex: "#181725")
        stackViewInput.addArrangedSubview(iconFilter)
        
        iconFilter.isHidden = true
        
        iconFilter.addTarget(self, action: #selector(handleFilter(_:)), for: .touchUpInside)
        
        iconFilter.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconFilter.widthAnchor.constraint(equalToConstant: 16.8),
            iconFilter.heightAnchor.constraint(equalToConstant: 17.85)
        ])
        
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 30
        subView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: inputSearch.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: subView.trailingAnchor)
        ])
        
        // Thêm collection category view vào stackView
        stackView.addArrangedSubview(gridCollectionCategory)
        
        gridCollectionCategory.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCategoriesProduct(_:)), for: .valueChanged)
        
        // Thêm collection product search view vào stackView
        stackView.addArrangedSubview(gridCollectionProductSearch)
        
        gridCollectionProductSearch.isHidden = true
        
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
    
    // Hàm xử lý khi bấm vào nút clear text input search
    @objc private func handleClearTextInputSearch(_ sender: AnyObject) {
        inputSearch.text = ""
        inputSearch.rightView = nil
        self.exploreViewModel.listProductSearch = []
        
        if !keybroadShow {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.iconFilter.isHidden = true
            self.gridCollectionProductSearch.isHidden = true
            self.gridCollectionCategory.isHidden = false
        }
    }
    
    // Hàm xử lý khi người dùng bấm vào icon filter
    @objc private func handleFilter(_ sender: AnyObject) {
        if self.exploreViewModel.listProductSearch.isEmpty {
            return
        }
        
        print("pass")
        
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
            
            self.productsFilter = self.exploreViewModel.listProductSearch.filter { product in
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
                let sourceFilterRating = self.filterViewModel.sourcesFilter.first(where: { $0.typeFilterCriteria == .rating })
                res = product.rating >= sourceFilterRating?.rating ?? 0
                
                return res
            }
        }
    }
    
    // Hàm xử lý khi người dùng bấm vào input
    @objc private func handleTapInputSearch(_ sender: AnyObject) {
        self.iconFilter.isHidden = false
        self.keybroadShow = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.gridCollectionCategory.isHidden = true
        self.gridCollectionProductSearch.isHidden = false
    }
    
    // Hàm xử lý khi người dùng nhập ký tự vào input
    @objc private func handleChangValueInputSearch(_ sender: AnyObject) {
        if let text = inputSearch.text, !text.isEmpty {
            inputSearch.rightView = iconClear
            exploreViewModel.searchProduct(keyword: text)
        } else {
            self.exploreViewModel.listProductSearch = []
        }
    }
    
    // Hàm xử lý sự kiện khi kéo danh sách danh mục sản phẩm để load lại
    @objc private func refreshCategoriesProduct(_ sender: AnyObject) {
        self.exploreViewModel.fetchCategoryProduct(isRefresh: true)
    }
    
    // Hàm xử lý khi bấm vào ô nhóm sản phẩm
    @objc private func handleTapGroupProduct(_ sender: UITapGestureRecognizer) {
        if let tappedView = sender.view as? CategoryProductView {
            let id = tappedView.id
            let categoryProduct = self.exploreViewModel.listCategoryProduct.first(where: { $0.id == id })
            // Xem các sản phẩm của loại được bấm chọn
            let productsCategoryViewController = ProductsCategoryViewController(categoryProduct: categoryProduct!)
            productsCategoryViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(productsCategoryViewController, animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { context in
            self.gridCollectionCategory.collectionViewLayout.invalidateLayout()
        })
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
}

extension ExploreViewController: UICollectionViewDataSource {
    // Đặt số lượng mục trong chế độ xem bộ sưu tập. Không thêm số lượng phần nên nó sẽ gán giá trị mặc định là 1
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == gridCollectionCategory {
            return self.exploreViewModel.listCategoryProduct.count
        } else if collectionView == gridCollectionProductSearch {
            return self.productsFilter.count
        }
        
        return 0
    }
    
    // dequeueReusableCell với mã định danh ô được cung cấp từ phương thức setupCollectionView.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gridCollectionCategory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryProductCell", for: indexPath) as! CategoryProductView
                
            let categoryProduct = self.exploreViewModel.listCategoryProduct[indexPath.item]
            
            // Thiết lập id
            cell.id = categoryProduct.id
            
            // Thiết lập màu nền
            cell.backgroundColor = UIColor(hex: categoryProduct.color).withAlphaComponent(0.1)
            cell.layer.borderColor = cell.backgroundColor?.withAlphaComponent(0.7).cgColor
            
            // Thiết lập hình ảnh và tiêu đề
            loadImage(from: categoryProduct.image.imageUrl) { image in
                if let downloadedImage = image {
                    cell.imageView.image = downloadedImage
                } else {
                    //
                }
            }
            cell.title.text = categoryProduct.name
            cell.title.font = UIFont(name: "Gilroy-Bold", size: 16)
            cell.title.textColor = UIColor(hex: "#181725")
            
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGroupProduct(_:))))
            
            return cell
        } else if collectionView == gridCollectionProductSearch {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductSearchCell", for: indexPath) as! ProductCellView
                
            let product = self.productsFilter[indexPath.item]

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
            
            cell.closureAddToCard = { [weak self] _ in
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
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    // Đầu tiên thêm insetForSectionAt từ UICollectionViewDelegateFlowLayout.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Thêm phần chèn cho các phần chế độ xem bộ sưu tập.
        return UIEdgeInsets(top: 15, left: 0, bottom: 30, right: 0)
    }
    
    // Thêm để chỉ định kích thước cho ô nên đã thêm phương thức từ UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Nhận bố cục được chỉ định từ chế độ xem bộ sưu tập.
        let lay =   collectionViewLayout as! UICollectionViewFlowLayout
        
        // Phân bổ chiều rộng của ô.
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing / 2
        
        // Trả về kích thước của mỗi ô nhưng đảm bảo khoảng cách giữa các dòng phải nhỏ hơn.
        if collectionView == gridCollectionCategory {
            return CGSize(width: widthPerItem, height: 189.11)
        } else if collectionView == gridCollectionProductSearch {
            return CGSize(width: widthPerItem, height: 248.51)
        }
        
        return CGSize()
    }
}
