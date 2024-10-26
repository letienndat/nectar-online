//
//  Validate.swift
//  nectar-online
//
//  Created by Macbook on 26/10/2024.
//

import Foundation

enum TypeCheck {
    case text
    case username
    case email
    case password
}

class Validate {
    static func validate(type: TypeCheck, string: String) -> Bool {
        switch type {
        case .text:
            return NSPredicate(format: Const.TYPE_FORMAT, Const.REGEX_TEXT).evaluate(with: string)
        case .username:
            return NSPredicate(format: Const.TYPE_FORMAT, Const.REGEX_USERNAME).evaluate(with: string)
        case .email:
            return NSPredicate(format: Const.TYPE_FORMAT, Const.REGEX_EMAIL).evaluate(with: string)
        case .password:
            return NSPredicate(format: Const.TYPE_FORMAT, Const.REGEX_PASSWORD).evaluate(with: string)
        }
    }
}
