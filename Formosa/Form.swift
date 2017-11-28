//
//  Form.swift
//  Formosa
//
//  Created by Jordan Kay on 5/22/17.
//  Copyright © 2017 Cultivr. All rights reserved.
//

public protocol Form: DataSource {
    associatedtype Resource
    associatedtype SubmitProgress
    associatedtype CheckValidityProgress
    associatedtype FormFieldType: FormField, Hashable
    associatedtype SubmissionError: Error

    typealias SubmitTask = Task<SubmitProgress, Resource, SubmissionError>
    typealias CheckValidityTask = Task<CheckValidityProgress, Void, FormValidityError<Self>>
    
    var input: [FormFieldType: String] { get set }
    var representedResource: Resource? { get }
    
    static var initiallyFocusedFormField: FormFieldType? { get }
    static var isErrorReported: Bool { get }
    
    func submit() -> SubmitTask
    func checkValidity() -> CheckValidityTask
}

public extension Form {
    static var initiallyFocusedFormField: FormFieldType? {
        return nil
    }
    
    static var isErrorReported: Bool {
        return true
    }
    
    func hasMatchingInput(across formFields: [FormFieldType]) -> Bool {
        var string: String? = nil
        for formField in formFields {
            if string != nil && string != self[formField] {
                return false
            }
            string = self[formField]
        }
        return true
    }
    
    subscript(formField: FormFieldType) -> String? {
        get {
            return input[formField] ?? formField.existingInput
        }
        set {
            input[formField] = newValue
        }
    }
}
