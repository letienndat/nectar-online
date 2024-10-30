//
//  DataTest.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import Foundation
import Collections

class DataTest {
    public static let zones: [Zone] = [
        Zone(id: 1, name: "Banasree", areas: [
            Area(id: 1, name: "Block A"),
            Area(id: 2, name: "Block B"),
            Area(id: 3, name: "Block C"),
            Area(id: 4, name: "Banasree Main Road"),
            Area(id: 5, name: "Banasree Lake Side"),
            Area(id: 6, name: "South Banasree"),
            Area(id: 7, name: "Banasree Sector 1"),
            Area(id: 8, name: "Banasree Sector 2")
        ]),
        Zone(id: 2, name: "Gulshan", areas: [
            Area(id: 9, name: "Gulshan 1"),
            Area(id: 10, name: "Gulshan 2"),
            Area(id: 11, name: "Gulshan Circle"),
            Area(id: 12, name: "Banani"),
            Area(id: 13, name: "Navana Tower"),
            Area(id: 14, name: "Gulshan South Avenue"),
            Area(id: 15, name: "Gulshan North Avenue")
        ]),
        Zone(id: 3, name: "Dhanmondi", areas: [
            Area(id: 16, name: "Road 1"),
            Area(id: 17, name: "Road 2"),
            Area(id: 18, name: "Satmasjid Road"),
            Area(id: 19, name: "Dhanmondi 32"),
            Area(id: 20, name: "Rabindra Sarobar"),
            Area(id: 21, name: "Lalmatia"),
            Area(id: 22, name: "Road 27"),
            Area(id: 23, name: "Shankar")
        ]),
        Zone(id: 4, name: "Uttara", areas: [
            Area(id: 24, name: "Sector 1"),
            Area(id: 25, name: "Sector 3"),
            Area(id: 26, name: "Sector 5"),
            Area(id: 27, name: "Sector 9"),
            Area(id: 28, name: "Sector 13"),
            Area(id: 29, name: "Sector 14"),
            Area(id: 30, name: "Uttara North"),
            Area(id: 31, name: "Uttara South")
        ]),
        Zone(id: 5, name: "Mirpur", areas: [
            Area(id: 32, name: "Mirpur 1"),
            Area(id: 33, name: "Mirpur 2"),
            Area(id: 34, name: "Pallabi"),
            Area(id: 35, name: "Kazipara"),
            Area(id: 36, name: "Shewrapara"),
            Area(id: 37, name: "Mirpur DOHS"),
            Area(id: 38, name: "Shyamoli"),
            Area(id: 39, name: "Mirpur Cantonment")
        ]),
        Zone(id: 6, name: "Mohammadpur", areas: [
            Area(id: 40, name: "Adabor"),
            Area(id: 41, name: "Town Hall"),
            Area(id: 42, name: "Mohammadia Housing Society"),
            Area(id: 43, name: "Shyamoli"),
            Area(id: 44, name: "Babar Road"),
            Area(id: 45, name: "Mohammadpur Bus Stand"),
            Area(id: 46, name: "Shankar")
        ]),
        Zone(id: 7, name: "Bashundhara", areas: [
            Area(id: 47, name: "Block A"),
            Area(id: 48, name: "Block B"),
            Area(id: 49, name: "Block C"),
            Area(id: 50, name: "Bashundhara Main"),
            Area(id: 51, name: "Apollo Hospital Area"),
            Area(id: 52, name: "Bashundhara R/A"),
            Area(id: 53, name: "Block G")
        ]),
        Zone(id: 8, name: "Tejgaon", areas: [
            Area(id: 54, name: "Industrial Area"),
            Area(id: 55, name: "Farmgate"),
            Area(id: 56, name: "Bijoy Sarani"),
            Area(id: 57, name: "Nakhalpara"),
            Area(id: 58, name: "West Tejturi Bazar"),
            Area(id: 59, name: "Tejkunipara")
        ]),
        Zone(id: 9, name: "Old Dhaka", areas: [
            Area(id: 60, name: "Lalbagh"),
            Area(id: 61, name: "Chawk Bazar"),
            Area(id: 62, name: "Ahsan Manzil"),
            Area(id: 63, name: "Islampur"),
            Area(id: 64, name: "Sutrapur"),
            Area(id: 65, name: "Nawabpur"),
            Area(id: 66, name: "Shakharibazar")
        ])
    ]
    
    public static let imageBanner: [String] = [
        "slideshow-banner",
        "slideshow-banner",
        "slideshow-banner",
    ]
    
    public static let imageProductDetail: [String] = [
        "product-detail-image",
        "product-detail-image",
        "product-detail-image",
    ]
    
    public static let productClassifications: OrderedDictionary<String, [Product]> = [
        "Exclusive Offer": [
            Product(id: 1, pathImage: "product-image-organic-bananas", name: "Organic Bananas", pieceAndPrice: "7pcs, Priceg", price: 4.99),
            Product(id: 2, pathImage: "product-image-red-apple", name: "Red Apple", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 3, pathImage: "product-image-organic-bananas", name: "Organic Bananas", pieceAndPrice: "7pcs, Priceg", price: 4.99),
            Product(id: 4, pathImage: "product-image-red-apple", name: "Red Apple", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 5, pathImage: "product-image-organic-bananas", name: "Organic Bananas", pieceAndPrice: "7pcs, Priceg", price: 4.99),
            Product(id: 6, pathImage: "product-image-red-apple", name: "Red Apple", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 7, pathImage: "product-image-organic-bananas", name: "Organic Bananas", pieceAndPrice: "7pcs, Priceg", price: 4.99),
            Product(id: 8, pathImage: "product-image-red-apple", name: "Red Apple", pieceAndPrice: "1kg, Priceg", price: 4.99),
        ],
        "Best Selling": [
            Product(id: 5, pathImage: "product-image-bell-pepper-red", name: "Bell Pepper Red", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 6, pathImage: "product-image-ginger", name: "Ginger", pieceAndPrice: "250gm, Priceg", price: 4.99),
            Product(id: 7, pathImage: "product-image-bell-pepper-red", name: "Bell Pepper Red", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 8, pathImage: "product-image-ginger", name: "Ginger", pieceAndPrice: "250gm, Priceg", price: 4.99),
            Product(id: 9, pathImage: "product-image-bell-pepper-red", name: "Bell Pepper Red", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 10, pathImage: "product-image-ginger", name: "Ginger", pieceAndPrice: "250gm, Priceg", price: 4.99),
            Product(id: 11, pathImage: "product-image-bell-pepper-red", name: "Bell Pepper Red", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 12, pathImage: "product-image-ginger", name: "Ginger", pieceAndPrice: "250gm, Priceg", price: 4.99),
        ],
        "Groceries": [
            Product(id: 13, pathImage: "product-image-beef-bone", name: "Beef Bone", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 14, pathImage: "product-image-broiler-chicken", name: "Broiler Chicken", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 15, pathImage: "product-image-beef-bone", name: "Beef Bone", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 16, pathImage: "product-image-broiler-chicken", name: "Broiler Chicken", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 17, pathImage: "product-image-beef-bone", name: "Beef Bone", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 18, pathImage: "product-image-broiler-chicken", name: "Broiler Chicken", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 19, pathImage: "product-image-beef-bone", name: "Beef Bone", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(id: 20, pathImage: "product-image-broiler-chicken", name: "Broiler Chicken", pieceAndPrice: "1kg, Priceg", price: 4.99),
        ],
    ]
}

class Product {
    let id: Int
    let pathImage: String
    let name: String
    let pieceAndPrice: String
    let price: Float
    
    init(id: Int, pathImage: String, name: String, pieceAndPrice: String, price: Float) {
        self.id = id
        self.pathImage = pathImage
        self.name = name
        self.pieceAndPrice = pieceAndPrice
        self.price = price
    }
}
