//
//  TypeExploreViewController.swift
//  nectar-online
//
//  Created by Macbook on 01/11/2024.
//

import UIKit

class ProductsCategoryViewController: UIViewController {
    private let categoryProduct: CategoryProduct
    private let loadingOverlay = LoadingOverlayView()
    private let refreshControl = UIRefreshControl()
    private lazy var gridCollectionProduct: UICollectionView = {
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
    private let productsCategoryViewModel: ProductsCategoryViewModel = ProductsCategoryViewModel()
    
    init(categoryProduct: CategoryProduct) {
        self.categoryProduct = categoryProduct
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            self.loadingOverlay.hideLoadingOverlay()
        }
        
        self.productsCategoryViewModel.showLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = false
            self.loadingOverlay.showLoadingOverlay()
        }
        
        self.productsCategoryViewModel.showError = { [weak self] error in
            guard let self = self else { return }
            
            self.showErrorAlert(message: error, isReload: true, handleReload: { self.fetchData() })
        }
        
        self.productsCategoryViewModel.updateListProductCategory = {
            self.gridCollectionProduct.reloadData()
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
        view.addSubview(loadingOverlay)
        
        // Cài đặt Auto Layout cho lớp phủ mờ để nó bao phủ toàn bộ view
        NSLayoutConstraint.activate([
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // Hàm xử lý khi kéo danh sách sản phẩm để load lại danh sách sản phẩm mới
    @objc private func refreshProductsCategory(_ sender: AnyObject) {
        self.productsCategoryViewModel.fetchListProductCategory(id: self.categoryProduct.id, isRefresh: true)
    }
    
    // Hàm xử lý khi bấm vào filter
    @objc private func handleFilter(_ sender: UIButton) {
        //
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
        return self.productsCategoryViewModel.listProductCategory.count
    }
    
    // dequeueReusableCell với mã định danh ô được cung cấp từ phương thức setupCollectionView.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCellView
            
        let product = self.productsCategoryViewModel.listProductCategory[indexPath.item]

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
        
        cell.closureAddToCard = { [weak self] product in
            guard let _ = self else { return }
            let _ = product
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
