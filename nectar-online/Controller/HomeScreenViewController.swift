//
//  HomeScreenViewController.swift
//  nectar-online
//  
//  Created by Macbook on 26/10/2024.
//

import UIKit
import ImageSlideshow

class HomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tạo UITapGestureRecognizer để phát hiện người dùng bấm ra ngoài view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeybroad))
        
        // Thêm gesture vào view cha
        self.view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
        
        self.tabBarController?.tabBar.layer.zPosition = 1
    }
    
    // Hàm được gọi khi ViewController sắp được thêm vào màn hình
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // Hàm được gọi khi ViewController chuẩn bị xoá khỏi màn hình
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)  // Hiển thị lại ở màn hình kế tiếp
    }
    
    @objc func hideKeybroad() {
        self.view.endEditing(true)
    }

    private func setupNav() {
        //
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
            
            subView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            subView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        let stackViewTop = UIStackView()
        stackViewTop.axis = .vertical
        stackViewTop.distribution = .fill
        stackViewTop.alignment = .fill
        stackViewTop.spacing = 20
        subView.addSubview(stackViewTop)

        stackViewTop.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewTop.topAnchor.constraint(equalTo: subView.topAnchor, constant: 20),
            stackViewTop.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 23),
            stackViewTop.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -23)
        ])

        let viewLogoAndLocation = UIView()
        stackViewTop.addArrangedSubview(viewLogoAndLocation)

        let iconLogo = UIImageView(image: UIImage(named: "icon-logo"))
        viewLogoAndLocation.addSubview(iconLogo)

        iconLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconLogo.topAnchor.constraint(equalTo: viewLogoAndLocation.topAnchor),
            iconLogo.centerXAnchor.constraint(equalTo: viewLogoAndLocation.centerXAnchor),

            iconLogo.widthAnchor.constraint(equalToConstant: 26.48),
            iconLogo.heightAnchor.constraint(equalToConstant: 30.8)
        ])

        let viewLocation = UIView()
        viewLogoAndLocation.addSubview(viewLocation)

        viewLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewLocation.topAnchor.constraint(equalTo: iconLogo.bottomAnchor, constant: 7.6),
            viewLocation.bottomAnchor.constraint(equalTo: viewLogoAndLocation.bottomAnchor),
            viewLocation.centerXAnchor.constraint(equalTo: viewLogoAndLocation.centerXAnchor),

            viewLocation.heightAnchor.constraint(equalToConstant: 22.69)
        ])

        let iconLocation = UIImageView(image: UIImage(named: "icon-location"))
        viewLocation.addSubview(iconLocation)

        iconLocation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconLocation.topAnchor.constraint(equalTo: viewLocation.topAnchor),
            iconLocation.leadingAnchor.constraint(equalTo: viewLocation.leadingAnchor),

            iconLocation.widthAnchor.constraint(equalToConstant: 15.13),
            iconLocation.heightAnchor.constraint(equalToConstant: 18.17)
        ])

        let labelLocation = UILabel()
        labelLocation.text = "Dhaka, Banassre"
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

        let inputSearch = PaddedTextField()
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
        iconSearch.tintColor = UIColor.gray
        iconSearch.contentMode = .scaleAspectFit

        inputSearch.leftView = iconSearch
        inputSearch.leftViewMode = .always

        inputSearch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputSearch.heightAnchor.constraint(equalToConstant: 51.57)
        ])

        var imageSources: [ImageSource] = []
        DataTest.imageBanner.forEach { image in
            imageSources.append(ImageSource(image: UIImage(named: image)!))
        }

        let slideShow = ImageSlideshow()
        slideShow.setImageInputs(imageSources)
        slideShow.slideshowInterval = Const.TIME_INTERVAL_SLIDESHOW
        slideShow.layer.cornerRadius = 8
        slideShow.contentScaleMode = .scaleAspectFill
        stackViewTop.addArrangedSubview(slideShow)

        slideShow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slideShow.heightAnchor.constraint(greaterThanOrEqualToConstant: 114.99)
        ])

        let stackViewContent = UIStackView()
        stackViewContent.axis = .vertical
        stackViewContent.spacing = 30
        stackViewContent.distribution = .fill
        stackViewContent.alignment = .fill
        subView.addSubview(stackViewContent)

        stackViewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewContent.topAnchor.constraint(equalTo: stackViewTop.bottomAnchor, constant: 30),
            stackViewContent.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -50),
            stackViewContent.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            stackViewContent.trailingAnchor.constraint(equalTo: subView.trailingAnchor),

            stackViewContent.widthAnchor.constraint(equalTo: subView.widthAnchor)
        ])

        Array(DataTest.productClassifications.keys).forEach { title in
            let labelTitleType = UILabel()
            labelTitleType.text = title
            labelTitleType.font = UIFont(name: "Gilroy-Semibold", size: 24)
            labelTitleType.textColor = UIColor(hex: "#181725")

            var viewsProduct: [ProductView] = []
            if let products = DataTest.productClassifications[title] {
                products.forEach { product in
                    let imageProduct = UIImage(named: product.pathImage)

                    let nameProduct = UILabel()
                    nameProduct.text = product.name
                    nameProduct.font = UIFont(name: "Gilroy-Bold", size: 16)
                    nameProduct.textColor = UIColor(hex: "#181725")

                    let piecePriceProduct = UILabel()
                    piecePriceProduct.text = product.pieceAndPrice
                    piecePriceProduct.font = UIFont(name: "Gilroy-Medium", size: 14)
                    piecePriceProduct.textColor = UIColor(hex: "#7C7C7C")

                    let priceProduct = UILabel()
                    priceProduct.text = "$\(product.price)"
                    priceProduct.font = UIFont(name: "Gilroy-Semibold", size: 18)
                    priceProduct.textColor = UIColor(hex: "#181725")

                    let viewProduct = ProductView(idProduct: String(product.id),imageProduct: imageProduct!, nameProduct: nameProduct, piecePriceProduct: piecePriceProduct, priceProduct: priceProduct)
                    
                    viewProduct.closureAddToCard = { _ in
                        // Thêm sản phẩm vào giỏ hàng
                    }
                    
                    viewProduct.closureTapProduct = { _ in
                        // Xem chi tiết sản phẩm
                        let productDetailtViewController = ProductDetailViewController()
                        productDetailtViewController.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(productDetailtViewController, animated: true)
                    }

                    viewsProduct.append(viewProduct)
                }

                let productClassficationView = ProductClassificationView(labelTitle: labelTitleType, viewsProduct: viewsProduct)
                stackViewContent.addArrangedSubview(productClassficationView)
            } else {
                // Products trống
            }
        }
    }
}
