//
//  FilterViewController.swift
//  nectar-online
//
//  Created by Macbook on 05/11/2024.
//

import UIKit
import RangeSeekSlider

class FilterViewController: UIViewController {
    private let filterViewModel: FilterViewModel!
    let buttonApply = ButtonView.createSystemButton(
        title: "Apply Filter",
        titleColor: UIColor(hex: "#FFF9FF"),
        titleFont: UIFont(name: "Gilroy-Semibold", size: 18),
        backgroundColor: UIColor(hex: "#53B175"),
        borderRadius: 19
    )
    private var arrayFilterCriteria: [FilterCriteria] = []
    var closureApplyFilter: (() -> Void)?
    
    init(filterViewModel: FilterViewModel!) {
        self.filterViewModel = filterViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNav()
        self.setupView()
    }
    
    private func setupNav() {
        self.title = "Filters"
        self.view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        // Thêm nút đóng
        let closeButton = UIBarButtonItem(image: UIImage(named: "icon-close"), style: .plain, target: self, action: #selector(closeFilter))
        closeButton.tintColor = UIColor(hex: "#181725")
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    private func setupView() {
        let subView = UIView()
        subView.backgroundColor = UIColor(hex: "#F2F3F2")
        subView.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 30)
        self.view.addSubview(subView)

        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            subView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let buttonClearFilters = UIButton(type: .system)
        buttonClearFilters.setTitle("Clear filters", for: .normal)
        buttonClearFilters.setTitleColor(UIColor(hex: "#53B175"), for: .normal)
        buttonClearFilters.titleLabel?.font = UIFont(name: "Gilroy-Medium", size: 16)
        subView.addSubview(buttonClearFilters)
        
        buttonClearFilters.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonClearFilters.topAnchor.constraint(equalTo: subView.topAnchor, constant: 20),
            buttonClearFilters.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25),
        ])
        
        buttonClearFilters.addTarget(self, action: #selector(handleClearFilters(_:)), for: .touchUpInside)

        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delaysContentTouches = false
        scrollView.bounces = false
        subView.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: buttonClearFilters.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25),
            scrollView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25),
            scrollView.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -(67 + 20 + 20))
        ])

        let subViewScroll = UIView()
        scrollView.addSubview(subViewScroll)

        subViewScroll.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subViewScroll.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            subViewScroll.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            subViewScroll.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            subViewScroll.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            subViewScroll.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor), // Đảm bảo chiều rộng cố định
            subViewScroll.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor, constant: -30)
        ])
        
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 30
        subViewScroll.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: subViewScroll.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: subViewScroll.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: subViewScroll.trailingAnchor)
        ])
        
        let viewEmptyAfterStackView = UIView()
        subViewScroll.addSubview(viewEmptyAfterStackView)
        
        viewEmptyAfterStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmptyAfterStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            viewEmptyAfterStackView.leadingAnchor.constraint(equalTo: subViewScroll.leadingAnchor),
            viewEmptyAfterStackView.trailingAnchor.constraint(equalTo: subViewScroll.trailingAnchor),
            viewEmptyAfterStackView.bottomAnchor.constraint(equalTo: subViewScroll.bottomAnchor)
        ])
        
        filterViewModel.sourcesFilter.forEach { source in
            let title = UILabel()
            title.text = source.title
            title.textColor = UIColor(hex: "#181725")
            title.font = UIFont(name: "Gilroy-Semibold", size: 24)

            let filterCriteria = FilterCriteria(
                filterCriteria: source.typeFilterCriteria,
                title: title,
                inputsCheckbox: source.inputsCheckbox,
                minRange: source.minRange,
                maxRange: source.maxRange,
                startRange: source.startRange,
                endRange: source.endRange,
                rating: source.rating
            ) { id, checked in
                if let index = source.inputsCheckbox.firstIndex(where: { $0.id == id }) {
                    source.inputsCheckbox[index].tempChecked = checked
                }
            }
            
            if source.typeFilterCriteria == .price {
                filterCriteria.handleChangRange = { [weak self] minValue, maxValue in
                    guard let _ = self else { return }
                    
                    source.tempStartRange = minValue
                    source.tempEndRange = maxValue
                }
            }
            
            if source.typeFilterCriteria == .rating {
                filterCriteria.handleTapRating = { [weak self] star, state in
                    guard let _ = self else { return }
                    
                    source.tempRating = state ? star : 0
                }
            }
            
            arrayFilterCriteria.append(filterCriteria)
            
            stackView.addArrangedSubview(filterCriteria)
        }
        
        let viewEmpty = UIView()
        viewEmpty.backgroundColor = .clear
        subView.addSubview(viewEmpty)

        viewEmpty.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewEmpty.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            viewEmpty.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            viewEmpty.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            viewEmpty.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])

        subView.addSubview(buttonApply)

        buttonApply.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonApply.topAnchor.constraint(equalTo: viewEmpty.bottomAnchor),
            buttonApply.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -20),
            buttonApply.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 25),
            buttonApply.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: -25)
        ])
        
        buttonApply.addTarget(self, action: #selector(applyFilter(_:)), for: .touchUpInside)
    }
    
    @objc func closeFilter() {
        for (i, j) in self.filterViewModel.sourcesFilter.enumerated() {
            if j.typeFilterCriteria == .category {
                for (x, y) in self.filterViewModel.sourcesFilter[i].inputsCheckbox.enumerated() {
                    self.filterViewModel.sourcesFilter[i].inputsCheckbox[x].tempChecked = y.checked
                }
            } else if j.typeFilterCriteria == .price {
                self.filterViewModel.sourcesFilter[i].tempStartRange = j.startRange
                self.filterViewModel.sourcesFilter[i].tempEndRange = j.endRange
            } else if j.typeFilterCriteria == .rating {
                self.filterViewModel.sourcesFilter[i].tempRating = 0
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func applyFilter(_ sender: UIButton) {
        for (i, j) in self.filterViewModel.sourcesFilter.enumerated() {
            if j.typeFilterCriteria == .category {
                for (x, y) in self.filterViewModel.sourcesFilter[i].inputsCheckbox.enumerated() {
                    self.filterViewModel.sourcesFilter[i].inputsCheckbox[x].checked = y.tempChecked
                }
            } else if j.typeFilterCriteria == .price {
                self.filterViewModel.sourcesFilter[i].startRange = j.tempStartRange
                self.filterViewModel.sourcesFilter[i].endRange = j.tempEndRange
            } else if j.typeFilterCriteria == .rating {
                self.filterViewModel.sourcesFilter[i].rating = j.tempRating
            }
        }
        
        self.closureApplyFilter?()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleClearFilters(_ sender: AnyObject) {
        for (i, j) in self.filterViewModel.sourcesFilter.enumerated() {
            if j.typeFilterCriteria == .category {
                for (x, _) in self.filterViewModel.sourcesFilter[i].inputsCheckbox.enumerated() {
                    self.filterViewModel.sourcesFilter[i].inputsCheckbox[x].checked = false
                    self.filterViewModel.sourcesFilter[i].inputsCheckbox[x].tempChecked = false
                }
            } else if j.typeFilterCriteria == .price {
                self.filterViewModel.sourcesFilter[i].startRange = Const.MIN_RANGE_PRICE
                self.filterViewModel.sourcesFilter[i].endRange = Const.MAX_RANGE_PRICE
                self.filterViewModel.sourcesFilter[i].tempStartRange = Const.MIN_RANGE_PRICE
                self.filterViewModel.sourcesFilter[i].tempEndRange = Const.MAX_RANGE_PRICE
            } else if j.typeFilterCriteria == .rating {
                self.filterViewModel.sourcesFilter[i].rating = 0
                self.filterViewModel.sourcesFilter[i].tempRating = 0
            }
        }
        
        self.arrayFilterCriteria.forEach { element in
            if element.typeFilterCriteria == .category {
                for i in element.listCheckbox {
                    i.checkbox.isSelected = false
                    i.title.textColor = UIColor(hex: "#181725")
                }
            } else if element.typeFilterCriteria == .price {
                element.rangeSlider.selectedMinValue = Const.MIN_RANGE_PRICE
                element.rangeSlider.selectedMaxValue = Const.MAX_RANGE_PRICE
                element.rangeSlider.layoutSubviews()
            } else if element.typeFilterCriteria == .rating {
                for i in element.listRating {
                    i.backgroundColor = .clear
                }
            }
        }
    }
}

class FilterCriteria: UIView {
    let typeFilterCriteria: EnumFilterCriteria
    var title: UILabel
    lazy var listCheckbox: [LineCheckBoxView] = []
    lazy var rangeSlider: RangeSeekSlider = RangeSeekSlider()
    lazy var listRating: [LineRating] = []
    
    var handleChangRange: ((CGFloat, CGFloat) -> Void)?
    var handleTapRating: ((Int, Bool) -> Void)?
    
    init(
        filterCriteria: EnumFilterCriteria,
        title: UILabel,
        inputsCheckbox: [InputCheckbox] = [],
        minRange: CGFloat = Const.MIN_RANGE_PRICE,
        maxRange: CGFloat = Const.MAX_RANGE_PRICE,
        startRange: CGFloat = Const.MIN_RANGE_PRICE,
        endRange: CGFloat = Const.MAX_RANGE_PRICE,
        rating: Int = 0,
        updateCheckboxState: @escaping (Int, Bool) -> Void
    ) {
        self.typeFilterCriteria = filterCriteria
        self.title = title
        
        super.init(frame: .zero)
        
        switch filterCriteria {
        case .category:
            
            inputsCheckbox.forEach { input in
                // Checkbox
                let checkboxButton = CheckboxButton()
                checkboxButton.isSelected = input.checked
                
                // Title
                let title = UILabel()
                title.text = input.name
                title.font = UIFont(name: "Gilgoy-Medium", size: 16)
                title.textColor = UIColor(hex: "#181725")
                
                let lineCheckboxView = LineCheckBoxView(id: input.id, checkbox: checkboxButton, title: title, type: .category, name: input.name)
                
                lineCheckboxView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    lineCheckboxView.heightAnchor.constraint(equalToConstant: 24.07)
                ])
                
                // Gọi callback khi có thay đổi
                lineCheckboxView.handleTapCheck = { [weak self] id, checked in
                    guard let _ = self else { return }
                    updateCheckboxState(id, checked)
                }
                
                self.listCheckbox.append(lineCheckboxView)
            }
            
        case .price:
            rangeSlider.delegate = self
            
            rangeSlider.minValue = minRange // Giá trị nhỏ nhất của slider
            rangeSlider.maxValue = maxRange // Giá trị lớn nhất của slider
            rangeSlider.selectedMinValue = startRange // Giá trị bắt đầu của khoảng chọn
            rangeSlider.selectedMaxValue = endRange // Giá trị kết thúc của khoảng chọn
            
        case .rating:
            stride(from: 5, through: 1, by: -1).forEach { i in
                let title = UILabel()
                title.text = i == 5 ? "" : "and above"
                title.textColor = UIColor(hex: "#181725")
                title.font = UIFont(name: "Gilroy-Medium", size: 16)
                
                self.listRating.append(LineRating(id: i, title: title, key: .price, numberRating: i, selected: i==rating))
            }
            
            break
        }
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        
        title.numberOfLines = 1
        title.textAlignment = .left
        self.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 25),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        switch typeFilterCriteria {
        case .category:
            self.listCheckbox.forEach { checkbox in
                stackView.addArrangedSubview(checkbox)
            }
        case .price:
            // Đặt màu cho slider
            rangeSlider.numberFormatter.positivePrefix = "$"
            rangeSlider.labelsFixed = true
            rangeSlider.tintColor = UIColor(hex: "#9F9D9D")
            rangeSlider.lineHeight = 10
            rangeSlider.handleColor = UIColor(hex: "#FFFFFF")
            rangeSlider.minLabelFont = UIFont(name: "Gilroy-Medium", size: 16)!
            rangeSlider.minLabelColor = UIColor(hex: "#181725")
            rangeSlider.maxLabelFont = UIFont(name: "Gilroy-Medium", size: 16)!
            rangeSlider.maxLabelColor = UIColor(hex: "#181725")
            rangeSlider.colorBetweenHandles = UIColor(hex: "#53B175")
            rangeSlider.handleBorderWidth = 2
            rangeSlider.handleBorderColor = UIColor(hex: "#53B175")
            stackView.addArrangedSubview(rangeSlider)
            
            rangeSlider.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                rangeSlider.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
            ])
        case .rating:
            stackView.spacing = 0
            self.listRating.forEach { ratingView in
                stackView.addArrangedSubview(ratingView)
                
                ratingView.closureTapRating = { [weak self] star, state in
                    guard let self = self else { return }
                    
                    for i in self.listRating {
                        if i.id != star && state {
                            i.backgroundColor = .clear
                        }
                    }
                    
                    self.handleTapRating?(star, state)
                }
            }
            
            break
        }
    }
}

extension FilterCriteria: RangeSeekSliderDelegate {
    // Hàm delegate sẽ được gọi khi giá trị thay đổi
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
//        print("Giá trị min: \(minValue), max: \(maxValue)")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        self.handleChangRange?(slider.selectedMinValue, slider.selectedMaxValue)
//        print("Giá trị min: \(slider.selectedMinValue), max: \(slider.selectedMaxValue)")
    }
}

enum EnumFilterCriteria: String {
    case category = "Categories"
    case price = "Price"
    case rating = "Rating"
}

class LineCheckBoxView: UIView {
    let id: Int
    var checkbox: CheckboxButton
    var title: UILabel
    let key: EnumFilterCriteria
    let name: String
    
    var handleTapCheck: ((Int, Bool) -> Void)?
    
    init(id:Int, checkbox: CheckboxButton, title: UILabel, type: EnumFilterCriteria, name: String) {
        self.id = id
        self.checkbox = checkbox
        self.title = title
        self.key = type
        self.name = name
        
        super.init(frame: .zero)
        
        self.setupView()
        
        self.checkbox.handleTapCheck = { [weak self] checked in
            guard let self = self else { return }
            
            self.title.textColor = checked ? UIColor(hex: "#53B175") : UIColor(hex: "#181725")
            self.handleTapCheck?(self.id, checked)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapLineCheckbox(_:))))
        
        self.addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkbox.topAnchor.constraint(equalTo: self.topAnchor),
            checkbox.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            checkbox.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            checkbox.widthAnchor.constraint(equalToConstant: 24.07),
            checkbox.heightAnchor.constraint(equalToConstant: 24.07)
        ])
        
        title.numberOfLines = 1
        title.textAlignment = .left
        title.textColor = checkbox.isSelected ? UIColor(hex: "#53B175") : UIColor(hex: "#181725")
        self.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 11.94),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    @objc private func handleTapLineCheckbox(_ sender: AnyObject) {
        self.checkbox.isSelected.toggle()
        self.title.textColor = self.checkbox.isSelected ? UIColor(hex: "#53B175") : UIColor(hex: "#181725")
        self.handleTapCheck?(self.id, self.checkbox.isSelected)
    }
}

class LineRating: UIView {
    var id: Int
    var title: UILabel
    let key: EnumFilterCriteria
    let numberRating: Int
    var selected: Bool
    private let maxStars = 5
    
    var closureTapRating: ((Int, Bool) -> Void)?
    
    init(id: Int, title: UILabel, key: EnumFilterCriteria, numberRating: Int, selected: Bool) {
        self.id = id
        self.title = title
        self.key = key
        self.numberRating = numberRating
        self.selected = selected
        
        super.init(frame: .zero)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = self.selected ? UIColor(hex: "#E2E2E2") : .clear
        self.addBorder(edges: [.bottom], color: UIColor(hex: "#E2E2E2"), borderLineSize: 1)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapRating(_:))))
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        let stackViewReviewStars = UIStackView()
        stackViewReviewStars.axis = .horizontal
        stackViewReviewStars.alignment = .center
        stackViewReviewStars.distribution = .fill
        stackViewReviewStars.spacing = 4.72
        self.addSubview(stackViewReviewStars)
        
        stackViewReviewStars.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewReviewStars.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackViewReviewStars.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            stackViewReviewStars.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        for index in 0..<maxStars {
            let iconStar = UIImageView(image: index < self.numberRating ? UIImage(named: "icon-star") : UIImage(named: "icon-star-unactive"))
            
            stackViewReviewStars.addArrangedSubview(iconStar)
        }
        
        self.title.textAlignment = .left
        self.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: stackViewReviewStars.trailingAnchor, constant: 6),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func handleTapRating(_ sender: AnyObject) {
        self.selected.toggle()
        self.backgroundColor = self.selected ? UIColor(hex: "#E2E2E2") : .clear
        self.closureTapRating?(id, selected)
    }
}

struct InputCheckbox {
    let id: Int
    let name: String
    var checked: Bool
    var tempChecked: Bool
}
