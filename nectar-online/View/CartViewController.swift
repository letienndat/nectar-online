//
//  CartViewController.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import UIKit

class CartViewController: UIViewController {
    
    private let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E2E2E2")
        return view
    }()
    
    private let bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E2E2E2")
        return view
    }()
    private let viewNoLogin = UIView()
    private let viewLogin = UIView()
    let buttonConfirmNoLogin = ButtonView.createSystemButton(
        title: "Redirect To Signin",
        titleColor: UIColor(hex: "#FFF9FF"),
        titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
        backgroundColor: UIColor(hex: "#53B175"),
        borderRadius: 19
    )
    let buttonGoToCheckout = ButtonView.createSystemButton(
        title: "Go to Checkout",
        titleColor: UIColor(hex: "#FFF9FF"),
        titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
        backgroundColor: UIColor(hex: "#53B175"),
        borderRadius: 19
    )
    let priceLabel = PaddedLabel(padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
    private let loading = AnimationLoadingView()
    private let refreshControl = UIRefreshControl()
    private lazy var gridCollectionProduct: UICollectionView = {
        // Khởi tạo UICollectionView với layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 15
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCartViewCell.self, forCellWithReuseIdentifier: "ProductCartCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.addSubview(topBorder)
        collectionView.addSubview(bottomBorder)
        
        return collectionView
    }()
    private lazy var cartViewModel: CartViewModel = CartViewModel()
    
    // Hàm được gọi khi view được thêm vào bộ nhớ
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
        setupLoadingOverlay()
        
        self.cartViewModel.hideRefreshing = { [weak self] in
            guard let self = self else { return }
            
            self.refreshControl.endRefreshing()
        }
        
        self.cartViewModel.hideLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = true
            self.loading.stopAnimation()
        }
        
        self.cartViewModel.showLoading = { [weak self] in
            guard let self = self else { return }
            
            self.view.isUserInteractionEnabled = false
            self.loading.startAnimation()
        }
        
        self.cartViewModel.showError = { [weak self] error in
            guard let self = self else { return }
            
            self.showErrorAlert(message: error, isReload: true, handleReload: { self.fetchData() })
        }
        
        self.cartViewModel.closureNoAccess = { [weak self] in
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
        
        self.cartViewModel.updateCart = { [weak self] in
            guard let self = self else { return }
            
            self.gridCollectionProduct.reloadData()
        }
        
        self.cartViewModel.updateTotalPrice = { [weak self] totalPrice in
            guard let self = self else { return }
            
            self.priceLabel.text = "$" + String(format: "%.2f", totalPrice)
            self.buttonGoToCheckout.rightView?.isHidden = false
        }
        
        self.cartViewModel.closureChangeQuantity = { [weak self] productId, method, quantity, price in
            guard let self = self else { return }
            
            if method != -1 {
                // Tìm indexPath của sản phẩm theo id
                if let index = self.cartViewModel.cart?.products.firstIndex(where: { $0.id == productId }) {
                    let indexPath = IndexPath(item: index, section: 0)
                    
                    // Cập nhật lại cell ở vị trí indexPath
                    if let cell = self.gridCollectionProduct.cellForItem(at: indexPath) as? ProductCartViewCell {
                        cell.quantityProduct.text = String(quantity)
                        cell.canBeSubtracted(quantity > 1)
                        cell.priceProduct.text = "$" + String(format: "%.2f", Double(quantity) * price)
                    }
                }
            }
        }
        
        self.cartViewModel.closureRemoveProuct = { [weak self] index in
            guard let self = self else { return }
            
            let indexPath = IndexPath(item: index, section: 0)
            
            self.gridCollectionProduct.performBatchUpdates({
                self.gridCollectionProduct.deleteItems(at: [indexPath])
            }, completion: nil)
            
            if let tabItems = self.tabBarController?.tabBar.items {
                let cartTabItem = tabItems[2]
                
                guard let totalProduct = self.cartViewModel.cart?.products.count else { return }
                
                let resShow: String = totalProduct > 99 ? "99+" : String(totalProduct)
                cartTabItem.badgeValue = resShow
                
                cartTabItem.setBadgeTextAttributes([
                    .font: UIFont(name: "Gilroy-Semibold", size: 12) ?? .systemFont(ofSize: 12),
                    .foregroundColor: UIColor(hex: "#FFFFFF")
                ], for: .normal)
            }
            
            let banner = NotificationBanner(message: "Product has been removed from cart", duration: 3.0)
            banner.show()
        }
    }
    
    private func fetchData() {
        self.cartViewModel.cart?.updateCart(totalPrice: DataTest.cart.totalPrice, products: DataTest.cart.products)
        self.cartViewModel.fetchCart()
    }
    
    // Hàm được gọi trước khi view xuất hiện trên màn hình
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "My Cart"
        
        if AppConfig.isLogin {
            self.fetchData()
            
            self.viewLogin.isHidden = false
            self.viewNoLogin.isHidden = true
        } else {
            self.viewLogin.isHidden = true
            self.viewNoLogin.isHidden = false
        }
    }
    
    // Hàm được gọi khi view xuất hiện trên màn hình
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "My Cart"
    }
    
    // Hàm được gọi trước khi view biến mất khỏi màn hình
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // Hàm được gọi khi view biến mất khỏi màn hình
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Cập nhật frame của topBorder và bottomBorder sau khi layout
        topBorder.frame = CGRect(x: 0, y: 0, width: gridCollectionProduct.frame.width, height: 1)
    }

    private func setupNav() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.navigationItem.title = "My Cart"
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        setupViewLogin()
        setupViewNoLigin()
    }
    
    private func setupViewLogin() {
        self.view.addSubview(viewLogin)
        
        viewLogin.isHidden = true
        
        viewLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewLogin.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            viewLogin.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(self.tabBarController?.tabBar.frame.height ?? 0) ),
            viewLogin.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            viewLogin.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        gridCollectionProduct.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        viewLogin.addSubview(gridCollectionProduct)
        
        gridCollectionProduct.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridCollectionProduct.topAnchor.constraint(equalTo: viewLogin.topAnchor, constant: 10),
            gridCollectionProduct.leadingAnchor.constraint(equalTo: viewLogin.leadingAnchor),
            gridCollectionProduct.trailingAnchor.constraint(equalTo: viewLogin.trailingAnchor),
        ])
        
        let viewEmpty = UIView()
        viewLogin.addSubview(viewEmpty)
        
        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.topAnchor.constraint(equalTo: gridCollectionProduct.bottomAnchor),
            viewEmpty.bottomAnchor.constraint(equalTo: viewLogin.bottomAnchor),
            viewEmpty.leadingAnchor.constraint(equalTo: viewLogin.leadingAnchor),
            viewEmpty.trailingAnchor.constraint(equalTo: viewLogin.trailingAnchor),
        ])
        
        viewLogin.addSubview(buttonGoToCheckout)
        
        buttonGoToCheckout.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonGoToCheckout.bottomAnchor.constraint(equalTo: viewLogin.bottomAnchor, constant: -24.45),
            buttonGoToCheckout.leadingAnchor.constraint(equalTo: viewLogin.leadingAnchor, constant: 25),
            buttonGoToCheckout.trailingAnchor.constraint(equalTo: viewLogin.trailingAnchor, constant: -25)
        ])
    }
    
    private func setupViewNoLigin() {
        self.view.addSubview(viewNoLogin)
        
        viewNoLogin.isHidden = true
        
        viewNoLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewNoLogin.topAnchor.constraint(equalTo: self.view.topAnchor),
            viewNoLogin.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            viewNoLogin.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            viewNoLogin.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        let viewContent = UIView()
        viewNoLogin.addSubview(viewContent)
        
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContent.topAnchor.constraint(equalTo: viewNoLogin.topAnchor),
            viewContent.leadingAnchor.constraint(equalTo: viewNoLogin.leadingAnchor, constant: 25),
            viewContent.trailingAnchor.constraint(equalTo: viewNoLogin.trailingAnchor, constant: -25),
        ])
        
        let labelContent = UILabel()
        labelContent.text = "Please login to use this feature!"
        labelContent.font = UIFont(name: "Gilroy-Medium", size: 16)
        labelContent.textColor = UIColor(hex: "#181725")
        labelContent.textAlignment = .center
        labelContent.numberOfLines = 0
        viewContent.addSubview(labelContent)
        
        labelContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelContent.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor),
            labelContent.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor),
            
            labelContent.leadingAnchor.constraint(greaterThanOrEqualTo: viewContent.leadingAnchor, constant: 30),
            labelContent.trailingAnchor.constraint(lessThanOrEqualTo: viewContent.trailingAnchor, constant: -30),
        ])
        
        viewNoLogin.addSubview(buttonConfirmNoLogin)
        
        buttonConfirmNoLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonConfirmNoLogin.leadingAnchor.constraint(equalTo: viewNoLogin.leadingAnchor, constant: 25),
            buttonConfirmNoLogin.trailingAnchor.constraint(equalTo: viewNoLogin.trailingAnchor, constant: -25),
            buttonConfirmNoLogin.topAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 20),
            buttonConfirmNoLogin.bottomAnchor.constraint(equalTo: viewNoLogin.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        buttonConfirmNoLogin.addTarget(self, action: #selector(handleConfirm(_:)), for: .touchUpInside)
        
        // Tạo rightView
        priceLabel.text = ""
        priceLabel.font = UIFont(name: "Gilroy-Semibold", size: 12)
        priceLabel.textColor = UIColor(hex: "#FCFCFC")
        priceLabel.backgroundColor = UIColor(hex: "#489E67")
        priceLabel.layer.cornerRadius = 4
        priceLabel.clipsToBounds = true
        priceLabel.textAlignment = .center
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22)
        ])
        buttonGoToCheckout.rightView = priceLabel
        
        buttonGoToCheckout.rightView?.isHidden = true
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
    
    // Hàm load lại dữ liệu
    @objc private func handleRefresh(_ sender: AnyObject) {
        self.cartViewModel.fetchCart(isRefresh: true)
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
    
    
    private func showQuestionAlert(message: String, handleOk: (() -> Void)?) {
        let alert = UIAlertController(title: "Question", message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            handleOk?()
        })
        alert.addAction(confirmAction)
        
        let cencelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(cencelAction)
        
        alert.preferredAction = confirmAction
        
        present(alert, animated: true)
    }
    
    @objc private func handleConfirm(_ sender: AnyObject) {
        HomeScreenViewController.redirectToSignin(for: self)
    }
}

extension CartViewController: UICollectionViewDelegateFlowLayout {
    // Đầu tiên thêm insetForSectionAt từ UICollectionViewDelegateFlowLayout.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Thêm phần chèn cho các phần chế độ xem bộ sưu tập.
        return UIEdgeInsets(top: 0, left: 0, bottom: 24.45 + buttonGoToCheckout.frame.height + 20, right: 0)
    }
    
    // Thêm để chỉ định kích thước cho ô nên đã thêm phương thức từ UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 157.01)
    }
}

extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cartViewModel.cart?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCartCell", for: indexPath) as! ProductCartViewCell
            
        let product = self.cartViewModel.cart?.products[indexPath.item]
        
        // Hiển thị đường viền dưới cho tất cả cell trừ cell cuối
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            // Cell cuối cùng không cách 2 bên
            cell.bottomBorder.frame = CGRect(x: 0, y: cell.frame.height - 1, width: cell.frame.width, height: 1)
        } else {
            // Các cell khác cách 2 bên 25
            cell.bottomBorder.frame = CGRect(x: 25, y: cell.frame.height - 1, width: cell.frame.width - 50, height: 1)
        }

        // Thiết lập id
        cell.product = product

        // Thiết lập hình ảnh
        loadImage(from: product?.thumbnail.imageUrl ?? "") { image in
            if let downloadedImage = image {
                cell.imageProduct.image = downloadedImage
            } else {
                //
            }
        }
        
        // Thiết lập tiêu đề
        cell.nameProduct.text = product?.name
        cell.nameProduct.font = UIFont(name: "Gilroy-Bold", size: 16)
        cell.nameProduct.textColor = UIColor(hex: "#181725")
        
        cell.piecePriceProduct.text = product?.unitOfMeasure
        cell.piecePriceProduct.font = UIFont(name: "Gilroy-Medium", size: 14)
        cell.piecePriceProduct.textColor = UIColor(hex: "#7C7C7C")
        
        cell.quantityProduct.text = String(product?.quantity ?? 1)
        cell.quantityProduct.font = UIFont(name: "Gilroy-Semibold", size: 16)
        cell.quantityProduct.textColor = UIColor(hex: "#181725")
        cell.canBeSubtracted(product?.quantity ?? 1 > 1)
        
        cell.priceProduct.text = "$" + String(format: "%.2f", (product?.price ?? 0) * Double(product?.quantity ?? 0))
        cell.priceProduct.font = UIFont(name: "Gilroy-Bold", size: 18)
        cell.priceProduct.textColor = UIColor(hex: "#181725")

        cell.closureTapProduct = { [weak self] product in
            // Xem chi tiết sản phẩm
            let productDetailtViewController = ProductDetailViewController(product: product)
            productDetailtViewController.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(productDetailtViewController, animated: true)
        }
        
        cell.closureSubtractOneQuantity = { [weak self] in
            guard let self = self else { return }
            
            let data: [String: Int] = [
                "method": 0
            ]
            
            self.cartViewModel.changeQuantity(productId: product!.id, data: data)
        }
        
        cell.closureAddOneQuantity = { [weak self] in
            guard let self = self else { return }
            
            let data: [String: Int] = [
                "method": 1
            ]
            
            self.cartViewModel.changeQuantity(productId: product!.id, data: data)
        }
        
        cell.closureRemoveProduct = { [weak self] in
            guard let self = self else { return }
            
            self.showQuestionAlert(message: "Are you sure you want to remove product \(product?.name ?? "{}") from your cart?") { [weak self] in
                guard let self = self else { return }
                
                self.cartViewModel.removeProduct(productId: product!.id)
            }
        }
        
        return cell
    }
}
