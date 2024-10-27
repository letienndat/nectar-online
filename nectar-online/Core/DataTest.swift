//
//  DataTest.swift
//  nectar-online
//
//  Created by Macbook on 27/10/2024.
//

import Foundation
import Collections

class DataTest {
    public static let zone: [String: [String]] = [
        "Banasree": ["Block A", "Block B", "Block C", "Banasree Main Road", "Banasree Lake Side", "South Banasree", "Banasree Sector 1", "Banasree Sector 2"],
        "Gulshan": ["Gulshan 1", "Gulshan 2", "Gulshan Circle", "Banani", "Navana Tower", "Gulshan South Avenue", "Gulshan North Avenue"],
        "Dhanmondi": ["Road 1", "Road 2", "Satmasjid Road", "Dhanmondi 32", "Rabindra Sarobar", "Lalmatia", "Road 27", "Shankar"],
        "Uttara": ["Sector 1", "Sector 3", "Sector 5", "Sector 9", "Sector 13", "Sector 14", "Uttara North", "Uttara South"],
        "Mirpur": ["Mirpur 1", "Mirpur 2", "Pallabi", "Kazipara", "Shewrapara", "Mirpur DOHS", "Shyamoli", "Mirpur Cantonment"],
        "Mohammadpur": ["Adabor", "Town Hall", "Mohammadia Housing Society", "Shyamoli", "Babar Road", "Mohammadpur Bus Stand", "Shankar"],
        "Bashundhara": ["Block A", "Block B", "Block C", "Bashundhara Main", "Apollo Hospital Area", "Bashundhara R/A", "Block G"],
        "Tejgaon": ["Industrial Area", "Farmgate", "Bijoy Sarani", "Nakhalpara", "West Tejturi Bazar", "Tejkunipara"],
        "Old Dhaka": ["Lalbagh", "Chawk Bazar", "Ahsan Manzil", "Islampur", "Sutrapur", "Nawabpur", "Shakharibazar"]
    ]
    
    public static let imageBanner: [String] = [
        "slideshow-banner",
        "slideshow-banner",
        "slideshow-banner",
    ]
    
    public static let productClassifications: OrderedDictionary<String, [Product]> = [
        "Exclusive Offer": [
            Product(pathImage: "product-image-organic-bananas", name: "Organic Bananas", pieceAndPrice: "7pcs, Priceg", price: 4.99),
            Product(pathImage: "product-image-red-apple", name: "Red Apple", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(pathImage: "product-image-organic-bananas", name: "Organic Bananas", pieceAndPrice: "7pcs, Priceg", price: 4.99),
            Product(pathImage: "product-image-red-apple", name: "Red Apple", pieceAndPrice: "1kg, Priceg", price: 4.99),
        ],
        "Best Selling": [
            Product(pathImage: "product-image-bell-pepper-red", name: "Bell Pepper Red", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(pathImage: "product-image-ginger", name: "Ginger", pieceAndPrice: "250gm, Priceg", price: 4.99),
            Product(pathImage: "product-image-bell-pepper-red", name: "Bell Pepper Red", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(pathImage: "product-image-ginger", name: "Ginger", pieceAndPrice: "250gm, Priceg", price: 4.99),
        ],
        "Groceries": [
            Product(pathImage: "product-image-beef-bone", name: "Beef Bone", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(pathImage: "product-image-broiler-chicken", name: "Broiler Chicken", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(pathImage: "product-image-beef-bone", name: "Beef Bone", pieceAndPrice: "1kg, Priceg", price: 4.99),
            Product(pathImage: "product-image-broiler-chicken", name: "Broiler Chicken", pieceAndPrice: "1kg, Priceg", price: 4.99),
        ],
    ]
}

class Product {
    var pathImage: String
    var name: String
    var pieceAndPrice: String
    var price: Float
    
    init(pathImage: String, name: String, pieceAndPrice: String, price: Float) {
        self.pathImage = pathImage
        self.name = name
        self.pieceAndPrice = pieceAndPrice
        self.price = price
    }
}
