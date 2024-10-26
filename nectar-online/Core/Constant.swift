//
//  Constant.swift
//  nectar-online
//
//  Created by Macbook on 26/10/2024.
//

import Foundation

class Const {
    public static let TYPE_FORMAT: String = "SELF MATCHES %@"
    public static let REGEX_TEXT: String = "^[A-Za-zÀ-ÖØ-öø-ÿ\\s]+$"
    public static let REGEX_USERNAME: String = "^[A-Za-z0-9._]{3,15}$"
    public static let REGEX_EMAIL: String = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    public static let REGEX_PASSWORD: String = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[A-Za-z\\d@$!%*?&#]{8,}$"
    public static let ZONE: [String: [String]] = [
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
}
