//
//  AuthenticationFormAction.swift
//  Formosa
//
//  Created by Jordan Kay on 5/25/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Formosa

enum AuthenticationFormAction {
    case logIn
    case signUp
}

extension AuthenticationFormAction: FormAction {
    var name: String {
        let value: Strings
        switch self {
        case .logIn:
            value = .logInLabel
        case .signUp:
            value = .signUpLabel
        }
        return value.localized
    }
}
