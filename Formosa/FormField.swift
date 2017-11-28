//
//  FormField.swift
//  Formosa
//
//  Created by Jordan Kay on 5/22/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

public protocol FormField: FormElement {
    var name: String? { get }
    var existingInput: String? { get }
    var validInputRegex: String? { get }
    var validPartialInputRegex: String? { get }
    var placeholderText: String { get }
    var keyboardType: UIKeyboardType { get }
    var autocorrectsInput: Bool { get }
    var autocapitalizationType: UITextAutocapitalizationType { get }
    var securityLevel: FormFieldSecurityLevel { get }

    func isValid(forInput input: String) -> Bool
}

public extension FormField {
    var name: String? {
        return nil
    }
    
    var existingInput: String? {
        return nil
    }
    
    var validInputRegex: String? {
        return nil
    }
    
    var validPartialInputRegex: String? {
        return nil
    }
    
    var keyboardType: UIKeyboardType {
        return .default
    }
    
    var autocorrectsInput: Bool {
        return false
    }

    var autocapitalizationType: UITextAutocapitalizationType {
        return .sentences
    }
    
    var securityLevel: FormFieldSecurityLevel {
        return .insecure
    }
    
    func isValid(forInput input: String) -> Bool {
        if let regex = validInputRegex {
            return input.range(of: regex, options: .regularExpression) != nil
        }
        return true
    }
}
