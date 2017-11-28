//
//  AuthenticationForm.swift
//  Formosa
//
//  Created by Jordan Kay on 5/23/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

import Formosa
import SwiftTask

protocol AuthenticationForm: Form {
    static var name: String { get }
    static var prompt: String { get }
    static var submitAction: AuthenticationFormAction { get }
    static var formFields: [AuthenticationFormField] { get }
}

extension AuthenticationForm {
    var sections: [[FormElement]] {
        let formFields: [FormElement] = Self.formFields
        return [[Self.prompt] + formFields + [Self.submitAction]]
    }
}

extension AuthenticationForm where FormFieldType == AuthenticationFormField {
    var credentials: [ExampleCredential: String] {
        var credentials: [ExampleCredential: String] = [:]
        for (key, value) in input {
            credentials[ExampleCredential(key)] = value
        }
        return credentials
    }
    
    // TODO: Support incremental checking
    func checkValidity() -> CheckValidityTask {
        return Task { _, fulfill, reject, _ in
            for formField in Self.formFields {
                let input = self[formField]
                if input.characters.count == 0 {
                    let error = FormValidityError<Self>.formFieldInvalid(formField, .blank)
                    reject(error)
                    return
                }
            }
            fulfill(())
        }
    }
}
