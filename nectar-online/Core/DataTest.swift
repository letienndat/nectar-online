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
    
    public static let location: Zone = Zone(id: 1, name: "Banassre", areas: [Area(id: 1, name: "Dhaka")])
    
    public static let imageBanner: [Image] = [
        Image(id: 1, title: "Banner 1", imageUrl: "slideshow-banner"),
        Image(id: 2, title: "Banner 2", imageUrl: "slideshow-banner"),
        Image(id: 3, title: "Banner 3", imageUrl: "slideshow-banner"),
    ]
    
    public static let imageProductDetail: [String] = [
        "product-detail-image",
        "product-detail-image",
        "product-detail-image",
    ]
    
    public static let productClassifications: [ProductClassification] = [
        ProductClassification(id: 1, name: "Exclusive Offer", products: [
            Product(
                id: 1,
                name: "Organic Bananas",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 0,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-organic-bananas"),
                images: [
                    Image(id: 1, title: "Title Image 1", imageUrl: "product-image-organic-bananas"),
                    Image(id: 2, title: "Title Image 2", imageUrl: "product-image-organic-bananas"),
                    Image(id: 3, title: "Title Image 3", imageUrl: "product-image-organic-bananas")
                ]
            ),
            Product(
                id: 2,
                name: "Red Apple",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 3,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 2, title: "Title Image 2", imageUrl: "product-image-red-apple"),
                images: [
                    Image(id: 4, title: "Title Image 4", imageUrl: "product-image-red-apple"),
                    Image(id: 5, title: "Title Image 5", imageUrl: "product-image-red-apple"),
                    Image(id: 6, title: "Title Image 6", imageUrl: "product-image-red-apple")
                ]
            ),
            Product(
                id: 3,
                name: "Organic Bananas",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 3, title: "Title Image 3", imageUrl: "product-image-organic-bananas"),
                images: [
                    Image(id: 7, title: "Title Image 7", imageUrl: "product-image-organic-bananas"),
                    Image(id: 8, title: "Title Image 8", imageUrl: "product-image-organic-bananas"),
                    Image(id: 9, title: "Title Image 9", imageUrl: "product-image-organic-bananas")
                ]
            ),
            Product(
                id: 4,
                name: "Red Apple",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 4, title: "Title Image 4", imageUrl: "product-image-red-apple"),
                images: [
                    Image(id: 10, title: "Title Image 10", imageUrl: "product-image-red-apple"),
                    Image(id: 11, title: "Title Image 11", imageUrl: "product-image-red-apple"),
                    Image(id: 12, title: "Title Image 12", imageUrl: "product-image-red-apple")
                ]
            ),
            Product(
                id: 5,
                name: "Organic Bananas",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 5, title: "Title Image 5", imageUrl: "product-image-organic-bananas"),
                images: [
                    Image(id: 13, title: "Title Image 13", imageUrl: "product-image-organic-bananas"),
                    Image(id: 14, title: "Title Image 14", imageUrl: "product-image-organic-bananas"),
                    Image(id: 15, title: "Title Image 15", imageUrl: "product-image-organic-bananas")
                ]
            ),
            Product(
                id: 6,
                name: "Red Apple",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 6, title: "Title Image 6", imageUrl: "product-image-red-apple"),
                images: [
                    Image(id: 16, title: "Title Image 16", imageUrl: "product-image-red-apple"),
                    Image(id: 17, title: "Title Image 17", imageUrl: "product-image-red-apple"),
                    Image(id: 18, title: "Title Image 18", imageUrl: "product-image-red-apple")
                ]
            ),
        ]),
        ProductClassification(id: 2, name: "Best Selling", products: [
            Product(
                id: 7,
                name: "Bell Pepper Red",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 7, title: "Title Image 7", imageUrl: "product-image-bell-pepper-red"),
                images: [
                    Image(id: 19, title: "Title Image 19", imageUrl: "product-image-bell-pepper-red"),
                    Image(id: 20, title: "Title Image 20", imageUrl: "product-image-bell-pepper-red"),
                    Image(id: 21, title: "Title Image 21", imageUrl: "product-image-bell-pepper-red")
                ]
            ),
            Product(
                id: 8,
                name: "Ginger",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 8, title: "Title Image 8", imageUrl: "product-image-ginger"),
                images: [
                    Image(id: 22, title: "Title Image 22", imageUrl: "product-image-ginger"),
                    Image(id: 23, title: "Title Image 23", imageUrl: "product-image-ginger"),
                    Image(id: 24, title: "Title Image 24", imageUrl: "product-image-ginger")
                ]
            ),
            Product(
                id: 9,
                name: "Bell Pepper Red",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 9, title: "Title Image 9", imageUrl: "product-image-bell-pepper-red"),
                images: [
                    Image(id: 22, title: "Title Image 22", imageUrl: "product-image-bell-pepper-red"),
                    Image(id: 23, title: "Title Image 23", imageUrl: "product-image-bell-pepper-red"),
                    Image(id: 24, title: "Title Image 24", imageUrl: "product-image-bell-pepper-red")
                ]
            ),
            Product(
                id: 10,
                name: "Ginger",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 10, title: "Title Image 10", imageUrl: "product-image-ginger"),
                images: [
                    Image(id: 25, title: "Title Image 25", imageUrl: "product-image-ginger"),
                    Image(id: 26, title: "Title Image 26", imageUrl: "product-image-ginger"),
                    Image(id: 27, title: "Title Image 27", imageUrl: "product-image-ginger")
                ]
            ),
            Product(
                id: 11,
                name: "Bell Pepper Red",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 11, title: "Title Image 11", imageUrl: "product-image-bell-pepper-red"),
                images: [
                    Image(id: 28, title: "Title Image 28", imageUrl: "product-image-bell-pepper-red"),
                    Image(id: 29, title: "Title Image 29", imageUrl: "product-image-bell-pepper-red"),
                    Image(id: 30, title: "Title Image 30", imageUrl: "product-image-bell-pepper-red")
                ]
            ),
            Product(
                id: 12,
                name: "Ginger",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 12, title: "Title Image 12", imageUrl: "product-image-ginger"),
                images: [
                    Image(id: 31, title: "Title Image 31", imageUrl: "product-image-ginger"),
                    Image(id: 32, title: "Title Image 32", imageUrl: "product-image-ginger"),
                    Image(id: 33, title: "Title Image 33", imageUrl: "product-image-ginger")
                ]
            ),
        ]),
        ProductClassification(id: 3, name: "Groceries", products: [
            Product(
                id: 13,
                name: "Beef Bone",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 13, title: "Title Image 13", imageUrl: "product-image-beef-bone"),
                images: [
                    Image(id: 34, title: "Title Image 34", imageUrl: "product-image-beef-bone"),
                    Image(id: 35, title: "Title Image 35", imageUrl: "product-image-beef-bone"),
                    Image(id: 36, title: "Title Image 36", imageUrl: "product-image-beef-bone")
                ]
            ),
            Product(
                id: 14,
                name: "Broiler Chicken",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 14, title: "Title Image 14", imageUrl: "product-image-broiler-chicken"),
                images: [
                    Image(id: 37, title: "Title Image 37", imageUrl: "product-image-broiler-chicken"),
                    Image(id: 38, title: "Title Image 38", imageUrl: "product-image-broiler-chicken"),
                    Image(id: 39, title: "Title Image 39", imageUrl: "product-image-broiler-chicken")
                ]
            ),
            Product(
                id: 15,
                name: "Beef Bone",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 15, title: "Title Image 15", imageUrl: "product-image-beef-bone"),
                images: [
                    Image(id: 40, title: "Title Image 40", imageUrl: "product-image-beef-bone"),
                    Image(id: 41, title: "Title Image 41", imageUrl: "product-image-beef-bone"),
                    Image(id: 42, title: "Title Image 42", imageUrl: "product-image-beef-bone")
                ]
            ),
            Product(
                id: 16,
                name: "Broiler Chicken",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 16, title: "Title Image 16", imageUrl: "product-image-broiler-chicken"),
                images: [
                    Image(id: 43, title: "Title Image 43", imageUrl: "product-image-broiler-chicken"),
                    Image(id: 44, title: "Title Image 44", imageUrl: "product-image-broiler-chicken"),
                    Image(id: 45, title: "Title Image 45", imageUrl: "product-image-broiler-chicken")
                ]
            ),
            Product(
                id: 17,
                name: "Beef Bone",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 17, title: "Title Image 17", imageUrl: "product-image-beef-bone"),
                images: [
                    Image(id: 46, title: "Title Image 46", imageUrl: "product-image-beef-bone"),
                    Image(id: 47, title: "Title Image 47", imageUrl: "product-image-beef-bone"),
                    Image(id: 48, title: "Title Image 48", imageUrl: "product-image-beef-bone")
                ]
            ),
            Product(
                id: 18,
                name: "Broiler Chicken",
                description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
                unitOfMeasure: "1kg, Price",
                price: 4.99,
                nutrients: "100gr",
                rating: 5,
                sold: 100,
                stock: 1000,
                categoryId: 1,
                thumbnail: Image(id: 18, title: "Title Image 18", imageUrl: "product-image-broiler-chicken"),
                images: [
                    Image(id: 49, title: "Title Image 49", imageUrl: "product-image-broiler-chicken"),
                    Image(id: 50, title: "Title Image 50", imageUrl: "product-image-broiler-chicken"),
                    Image(id: 51, title: "Title Image 51", imageUrl: "product-image-broiler-chicken")
                ]
            ),
        ])
    ]
    
    public static let listProductSearch: [Product] = [
        Product(
            id: 1,
            name: "Diet Coke Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "355ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-diet-coke"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-diet-coke"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-diet-coke"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-diet-coke")
            ]
        ),
        Product(
            id: 2,
            name: "Sprite Can Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "325ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-sprite-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-sprite-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-sprite-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-sprite-can")
            ]
        ),
        Product(
            id: 3,
            name: "Apple & Grape Juice Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "2L, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-apple-and-grape-juice"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-apple-and-grape-juice"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-apple-and-grape-juice"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-apple-and-grape-juice")
            ]
        ),
        Product(
            id: 4,
            name: "Orenge Juice Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "2L, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-orenge-juice"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-orenge-juice"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-orenge-juice"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-orenge-juice")
            ]
        ),
        Product(
            id: 5,
            name: "Coca Cola Can Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "325ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-coca-cola-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-coca-cola-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-coca-cola-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-coca-cola-can")
            ]
        ),
        Product(
            id: 6,
            name: "Pepsi Can Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "330ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-pepsi-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-pepsi-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-pepsi-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-pepsi-can")
            ]
        ),
        Product(
            id: 7,
            name: "Diet Coke Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "355ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-diet-coke"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-diet-coke"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-diet-coke"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-diet-coke")
            ]
        ),
        Product(
            id: 8,
            name: "Sprite Can Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "325ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-sprite-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-sprite-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-sprite-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-sprite-can")
            ]
        ),
        Product(
            id: 9,
            name: "Apple & Grape Juice Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "2L, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-apple-and-grape-juice"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-apple-and-grape-juice"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-apple-and-grape-juice"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-apple-and-grape-juice")
            ]
        ),
        Product(
            id: 10,
            name: "Orenge Juice Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "2L, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-orenge-juice"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-orenge-juice"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-orenge-juice"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-orenge-juice")
            ]
        ),
        Product(
            id: 11,
            name: "Coca Cola Can Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "325ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-coca-cola-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-coca-cola-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-coca-cola-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-coca-cola-can")
            ]
        ),
        Product(
            id: 12,
            name: "Pepsi Can Search",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "330ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-pepsi-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-pepsi-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-pepsi-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-pepsi-can")
            ]
        ),
    ]
    
    public static let listCategoryProduct: [CategoryProduct] = [
        CategoryProduct(
            id: 1,
            name: "Frash Fruits & Vegetable",
            color: "#53B175",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-frash-fruits-and-vegetable")
        ),
        CategoryProduct(
            id: 2,
            name: "Cooking Oil & Ghee",
            color: "#F8A44C",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-cooking-oil-and-ghee")
        ),
        CategoryProduct(
            id: 3,
            name: "Meat & Fish",
            color: "#F7A593",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-meat-and-fish")
        ),
        CategoryProduct(
            id: 4,
            name: "Bakery & Snacks",
            color: "#D3B0E0",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-bakery-and-snacks")
        ),
        CategoryProduct(
            id: 5,
            name: "Dairy & Eggs",
            color: "#FDE598",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-dairy-and-eggs")
        ),
        CategoryProduct(
            id: 6,
            name: "Beverages",
            color: "#B7DFF5",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-beverages")
        ),
        CategoryProduct(
            id: 7,
            name: "Frash Fruits & Vegetable",
            color: "#53B175",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-frash-fruits-and-vegetable")
        ),
        CategoryProduct(
            id: 8,
            name: "Cooking Oil & Ghee",
            color: "#F8A44C",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-cooking-oil-and-ghee")
        ),
        CategoryProduct(
            id: 9,
            name: "Meat & Fish",
            color: "#F7A593",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-meat-and-fish")
        ),
        CategoryProduct(
            id: 10,
            name: "Bakery & Snacks",
            color: "#D3B0E0",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-bakery-and-snacks")
        ),
        CategoryProduct(
            id: 11,
            name: "Dairy & Eggs",
            color: "#FDE598",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-dairy-and-eggs")
        ),
        CategoryProduct(
            id: 12,
            name: "Beverages",
            color: "#B7DFF5",
            image: Image(id: 1, title: "Title Image", imageUrl: "group-product-image-beverages")
        ),
    ]
    
    public static let listProductCategory: [Product] = [
        Product(
            id: 1,
            name: "Diet Coke",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "355ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-diet-coke"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-diet-coke"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-diet-coke"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-diet-coke")
            ]
        ),
        Product(
            id: 2,
            name: "Sprite Can",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "325ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-sprite-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-sprite-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-sprite-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-sprite-can")
            ]
        ),
        Product(
            id: 3,
            name: "Apple & Grape Juice",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "2L, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-apple-and-grape-juice"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-apple-and-grape-juice"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-apple-and-grape-juice"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-apple-and-grape-juice")
            ]
        ),
        Product(
            id: 4,
            name: "Orenge Juice",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "2L, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-orenge-juice"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-orenge-juice"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-orenge-juice"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-orenge-juice")
            ]
        ),
        Product(
            id: 5,
            name: "Coca Cola Can",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "325ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-coca-cola-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-coca-cola-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-coca-cola-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-coca-cola-can")
            ]
        ),
        Product(
            id: 6,
            name: "Pepsi Can",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "330ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-pepsi-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-pepsi-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-pepsi-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-pepsi-can")
            ]
        ),
        Product(
            id: 7,
            name: "Diet Coke",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "355ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-diet-coke"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-diet-coke"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-diet-coke"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-diet-coke")
            ]
        ),
        Product(
            id: 8,
            name: "Sprite Can",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "325ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-sprite-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-sprite-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-sprite-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-sprite-can")
            ]
        ),
        Product(
            id: 9,
            name: "Apple & Grape Juice",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "2L, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-apple-and-grape-juice"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-apple-and-grape-juice"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-apple-and-grape-juice"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-apple-and-grape-juice")
            ]
        ),
        Product(
            id: 10,
            name: "Orenge Juice",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "2L, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-orenge-juice"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-orenge-juice"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-orenge-juice"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-orenge-juice")
            ]
        ),
        Product(
            id: 11,
            name: "Coca Cola Can",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "325ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-coca-cola-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-coca-cola-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-coca-cola-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-coca-cola-can")
            ]
        ),
        Product(
            id: 12,
            name: "Pepsi Can",
            description: "Apples are nutritious. Apples may be good for weight loss. apples may be good for your heart. As part of a healtful and varied diet.",
            unitOfMeasure: "330ml, Price",
            price: 4.99,
            nutrients: "100gr",
            rating: 5,
            sold: 100,
            stock: 1000,
            categoryId: 1,
            thumbnail: Image(id: 1, title: "Title Image 1", imageUrl: "product-image-pepsi-can"),
            images: [
                Image(id: 1, title: "Title Image 1", imageUrl: "product-image-pepsi-can"),
                Image(id: 2, title: "Title Image 2", imageUrl: "product-image-pepsi-can"),
                Image(id: 3, title: "Title Image 3", imageUrl: "product-image-pepsi-can")
            ]
        ),
    ]
}
