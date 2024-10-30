//
//  ProductDetailViewController.swift
//  nectar-online
//
//  Created by Macbook on 29/10/2024.
//

import UIKit
import ImageSlideshow

class ProductDetailViewController: UIViewController {
    
    private let labelProductDetail = UILabel()
    private let iconArrowProductDetail = UIButton(type: .system)
    private let iconArrowNutritions = UIButton(type: .system)
    private let iconArrowReview = UIButton(type: .system)
    private var isShowProductDetail = false
    private var isShowNutritions = false
    private var isShowReview = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNav()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        let scrollView = UIScrollView()
        scrollView.bounces = false
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
        
        var imageSources: [ImageSource] = []
        DataTest.imageProductDetail.forEach { image in
            imageSources.append(ImageSource(image: UIImage(named: image)!))
        }

        let slideShow = ImageSlideshow()
        slideShow.setImageInputs(imageSources)
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
        
        let labelNameProduct = UILabel()
        labelNameProduct.text = "Naturel Red Apple"
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
        
        let labelPieceAndPrice = UILabel()
        labelPieceAndPrice.text = "1kg, Price"
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
        
        let buttonHeart = UIButton(type: .system)
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
        
        let iconSubtract = UIButton(type: .system)
        iconSubtract.setImage(UIImage(named: "icon-subtract"), for: .normal)
        iconSubtract.tintColor = UIColor(hex: "#B3B3B3")
        viewQuantity.addSubview(iconSubtract)
        
        iconSubtract.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconSubtract.leadingAnchor.constraint(equalTo: viewQuantity.leadingAnchor),
            iconSubtract.centerYAnchor.constraint(equalTo: viewQuantity.centerYAnchor),
            
            iconSubtract.widthAnchor.constraint(equalToConstant: 17),
            iconSubtract.heightAnchor.constraint(equalToConstant: 2.84)
        ])
        
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
        
        let labelNumberQuantity = UILabel()
        labelNumberQuantity.text = "100"
        labelNumberQuantity.font = UIFont(name: "Gilroy-Semibold", size: 18)
        labelNumberQuantity.textColor = UIColor(hex: "#181725")
        viewNumberQuantity.addSubview(labelNumberQuantity)
        
        labelNumberQuantity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelNumberQuantity.centerXAnchor.constraint(equalTo: viewNumberQuantity.centerXAnchor),
            labelNumberQuantity.centerYAnchor.constraint(equalTo: viewNumberQuantity.centerYAnchor),
            
            labelNumberQuantity.leadingAnchor.constraint(equalTo: viewNumberQuantity.leadingAnchor, constant: 13.83),
            labelNumberQuantity.trailingAnchor.constraint(equalTo: viewNumberQuantity.trailingAnchor, constant: -13.83)
        ])
        
        let iconAdd = UIButton(type: .system)
        iconAdd.setImage(UIImage(named: "icon-add"), for: .normal)
        iconAdd.tintColor = UIColor(hex: "#53B175")
        viewQuantity.addSubview(iconAdd)
        
        iconAdd.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconAdd.leadingAnchor.constraint(equalTo: viewNumberQuantity.trailingAnchor, constant: 20),
            iconAdd.trailingAnchor.constraint(equalTo: viewQuantity.trailingAnchor),
            iconAdd.centerYAnchor.constraint(equalTo: viewQuantity.centerYAnchor),
            
            iconAdd.widthAnchor.constraint(equalToConstant: 17),
            iconAdd.heightAnchor.constraint(equalToConstant: 17)
        ])
        
        let labelPrice = UILabel()
        labelPrice.text = "$4.99"
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
        
        labelProductDetail.text = "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet."
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
        
        viewNutritions.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewNutritions.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        let labelTitleNutritions = UILabel()
        labelTitleNutritions.text = "Nutritions"
        labelTitleNutritions.font = UIFont(name: "Gilroy-Semibold", size: 16)
        labelTitleNutritions.textColor = UIColor(hex: "#181725")
        viewNutritions.addSubview(labelTitleNutritions)
        
        labelTitleNutritions.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitleNutritions.leadingAnchor.constraint(equalTo: viewNutritions.leadingAnchor),
            labelTitleNutritions.centerYAnchor.constraint(equalTo: viewNutritions.centerYAnchor),
        ])
        
        iconArrowNutritions.setImage(UIImage(named: "icon-arrow-right"), for: .normal)
        iconArrowNutritions.tintColor = UIColor(hex: "#181725")
        viewNutritions.addSubview(iconArrowNutritions)
        
        iconArrowNutritions.addTarget(self, action: #selector(handleTapArrowNutritions(_:)), for: .touchUpInside)
        
        iconArrowNutritions.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconArrowNutritions.trailingAnchor.constraint(equalTo: viewNutritions.trailingAnchor),
            iconArrowNutritions.centerYAnchor.constraint(equalTo: viewNutritions.centerYAnchor),
            
            iconArrowNutritions.widthAnchor.constraint(equalToConstant: 8.4),
            iconArrowNutritions.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        let viewNutritionalContent = UIView()
        viewNutritionalContent.backgroundColor = UIColor(hex: "#EBEBEB")
        viewNutritionalContent.layer.cornerRadius = 5
        viewNutritions.addSubview(viewNutritionalContent)
        
        viewNutritionalContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewNutritionalContent.leadingAnchor.constraint(greaterThanOrEqualTo: labelTitleNutritions.trailingAnchor, constant: 20),
            viewNutritionalContent.trailingAnchor.constraint(equalTo: iconArrowNutritions.leadingAnchor, constant: -20.6),
            viewNutritionalContent.centerYAnchor.constraint(equalTo: viewNutritions.centerYAnchor),
            
            viewNutritionalContent.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        let labelNutritionalContent = UILabel()
        labelNutritionalContent.text = "100gr"
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
        
        viewReview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewReview.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        let labelTitleReview = UILabel()
        labelTitleReview.text = "Review "
        labelTitleReview.font = UIFont(name: "Gilroy-Semibold", size: 16)
        labelTitleReview.textColor = UIColor(hex: "#181725")
        viewReview.addSubview(labelTitleReview)
        
        labelTitleReview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitleReview.leadingAnchor.constraint(equalTo: viewReview.leadingAnchor),
            labelTitleReview.centerYAnchor.constraint(equalTo: viewReview.centerYAnchor),
        ])
        
        iconArrowReview.setImage(UIImage(named: "icon-arrow-right"), for: .normal)
        iconArrowReview.tintColor = UIColor(hex: "#181725")
        viewReview.addSubview(iconArrowReview)
        
        iconArrowReview.addTarget(self, action: #selector(handleTapArrowReview(_:)), for: .touchUpInside)
        
        iconArrowReview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconArrowReview.trailingAnchor.constraint(equalTo: viewReview.trailingAnchor),
            iconArrowReview.centerYAnchor.constraint(equalTo: viewReview.centerYAnchor),
            
            iconArrowReview.widthAnchor.constraint(equalToConstant: 8.4),
            iconArrowReview.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        let stackViewReviewStars = UIStackView()
        stackViewReviewStars.axis = .horizontal
        stackViewReviewStars.alignment = .center
        stackViewReviewStars.distribution = .fill
        stackViewReviewStars.spacing = 4.72
        viewReview.addSubview(stackViewReviewStars)
        
        stackViewReviewStars.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewReviewStars.leadingAnchor.constraint(greaterThanOrEqualTo: labelTitleReview.trailingAnchor, constant: 20),
            stackViewReviewStars.trailingAnchor.constraint(equalTo: iconArrowReview.leadingAnchor, constant: -20.6),
            stackViewReviewStars.centerYAnchor.constraint(equalTo: viewReview.centerYAnchor),
            
            stackViewReviewStars.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        (1...5).forEach { _ in
            let iconStar = UIImageView(image: UIImage(named: "icon-star"))
            stackViewReviewStars.addArrangedSubview(iconStar)
            
            iconStar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iconStar.widthAnchor.constraint(equalToConstant: 14.72),
                iconStar.heightAnchor.constraint(equalToConstant: 14)
            ])
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
    
    // Hàm xử lý khi bấm vào share product
    @objc private func handleShareProduct(_ sender: UIButton) {
        //
    }
    
    // Hàm ẩn hiện chi tiết sản phẩm
    @objc private func handleTapArrowProductDetail(_ sender: UIButton) {
        labelProductDetail.isHidden.toggle()
        isShowProductDetail.toggle()
        
        if isShowProductDetail {
            iconArrowProductDetail.transform = CGAffineTransform(rotationAngle: .pi / 2)
        } else {
            iconArrowProductDetail.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    // Hàm ẩn hiện thông tin Nutritions
    @objc private func handleTapArrowNutritions(_ sender: UIButton) {
        isShowNutritions.toggle()
        
        if isShowNutritions {
            iconArrowNutritions.transform = CGAffineTransform(rotationAngle: .pi / 2)
        } else {
            iconArrowNutritions.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    // Hàm ẩn/hiện đánh giá
    @objc private func handleTapArrowReview(_ sender: UIButton) {
        isShowReview.toggle()
        
        if isShowReview {
            iconArrowReview.transform = CGAffineTransform(rotationAngle: .pi / 2)
        } else {
            iconArrowReview.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    // Hàm xử lý khi bấm vào Add To Basket
    @objc private func handleAddToBasket(_ sender: UIButton) {
        //
    }
}
