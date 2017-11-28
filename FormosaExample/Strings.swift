//
//  Strings.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Foundation

enum Strings: String {
    case emailLabel
    case failedToLogInTitle
    case failedToLogInDescription
    case fullNameLabel
    case logInLabel
    case logInPrompt
    case logOutLabel
    case loggedInLabel
    case loggedOutLabel
    case passwordLabel
    case signUpLabel
    case signUpPrompt
    case usernameLabel
    
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }
    
    func localized(_ args: CVarArg...) -> String {
        return String(format: localized, locale: Locale.current, arguments: args)
    }
}
