//
//  FormValidityError.swift
//  Formosa
//
//  Created by Jordan Kay on 5/25/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

public enum FormValidityError<FormType: Form>: Error {
    case invalid
    case formFieldInvalid(FormType.FormFieldType, FormFieldValidityError)
    case formFieldsInvalid([FormType.FormFieldType: FormFieldValidityError])
}
