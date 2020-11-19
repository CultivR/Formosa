//
//  ExampleFormField.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Formosa

enum AuthenticationFormField: FormField {
    case fullName
    case username
    case password
    case email
    
    var placeholderText: String {
        let value: Strings
        switch self {
        case .fullName:
            value = .fullNameLabel
        case .username:
            value = .usernameLabel
        case .password:
            value = .passwordLabel
        case .email:
            value = .emailLabel
        }
        return value.localized
    }
    
    var keyboardType: UIKeyboardType {
        return self == .email ? .emailAddress : .default
    }
    
    var autocorrectsInput: Bool {
        return false
    }
    
    var autocapitalizationType: UITextAutocapitalizationType {
        return self == .fullName ? .words : .none
    }
    
    var securityLevel: FormFieldSecurityLevel {
        return self == .password ? .secured : .insecure
    }
}

extension ExampleCredential {
    init(_ formField: AuthenticationFormField) {
        switch formField {
        case .fullName:
            self = .fullName
        case .username:
            self = .username
        case .password:
            self = .password
        case .email:
            self = .email
        }
    }
}
