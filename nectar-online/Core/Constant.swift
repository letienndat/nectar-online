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
    public static let TIME_INTERVAL_SLIDESHOW: Double = 3
    public static let BASE_URL = "http://192.168.0.103:8000/api"
    public static let KEYCHAIN_TOKEN = "JjadA#$J!uhayQ27Ah2"
}
